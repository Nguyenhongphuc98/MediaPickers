//
//  MPAuthorize.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/24/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import Photos
import ReactiveSwift

struct MPPhotoConfig {
    
    var albumName: String?
    
    var mediaType: PHAssetMediaType? = nil
}

public enum AuthorizationResult : Int {

    case denied // User has Restricted or denied this application access to photos data.

    case authorized // User has authorized this application to access photos data.
}

private let sharePhotoLib = MPPhotoLib()

class MPPhotoLib: NSObject {
    
    var imageCachingManager = PHCachingImageManager()
    
    var fetchResult: PHFetchResult<PHAsset>? = nil
    
    class var sharedInstance: MPPhotoLib {
        return sharePhotoLib
    }
    
    public func checkAuthorization() -> SignalProducer<AuthorizationResult, Never> {
        return SignalProducer { (observer, lifetime) in
            
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    
                    switch status {
                    case .authorized:
                        observer.send(value: .authorized)
                    default:
                        observer.send(value: .denied)
                        break;
                    }
                    observer.sendCompleted()
                }
            case .authorized:
                observer.send(value: .authorized)
                observer.sendCompleted()
            default:
                observer.send(value: .denied)
                observer.sendCompleted()
            }
            
        }
    }
    

    //fetch vơi 1 loai cu the cua album
    public func fetchCollection(type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype) -> SignalProducer<MPAssetCollection, Never> {
        
        return SignalProducer { (observer, lifetime) in
            DispatchQueue.global(qos: .background)
                .async {
                    let config = MPPhotoConfig()
                    let options = self.generateCollectionOption(config: config)
                    
                    let collections = PHAssetCollection.fetchAssetCollections(with: type, subtype: subtype, options: options)
                    
                    let collectionResult = MPAssetCollection(assetCollection: collections.firstObject!)
                    observer.send(value: collectionResult)
                    observer.sendCompleted()
            }
        }
    }
    

    //fetch smart albums theo subtype
    public func fetchSmartAlbums(subtypes: [PHAssetCollectionSubtype] = [.any]) -> SignalProducer<[MPAssetCollection], Never> {
        
        return SignalProducer { (observer, lifetime) in
            DispatchQueue.global(qos: .background)
                .async {
                    
                    var assetCollection: [PHAssetCollection] = []
                    var assetCollectionResult: [MPAssetCollection] = []
                    
                    let config = MPPhotoConfig()
                    let options = self.generateCollectionOption(config: config)
                    
                    for subtype in subtypes {
                        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtype, options: options)
                        
                        assetCollection.removeAll()
                        collections.enumerateObjects { (collection, index, _) in
                            assetCollection.append(collection)
                        }
                        
                        //neu subtype = .any thi se co nhieu collection
                        for collect in assetCollection {
                            let collectionResult = MPAssetCollection(assetCollection: collect)
                            if collectionResult.numberOfAssets != 0 && !assetCollectionResult.contains(collectionResult) {
                                assetCollectionResult.append(collectionResult)
                            }
                        }
                        
                    }
                    
                    observer.send(value: assetCollectionResult)
                    observer.sendCompleted()
            }
        }
    }
    
    // lay image cho 1 asset cu the, ket qua co the tra ve nhieu lan
    func requestImageForAsset(asset: PHAsset, size: CGSize = CGSize(width: 150, height: 150)) -> SignalProducer<(UIImage?, PHImageRequestID?), Never> {
        
        return SignalProducer { (observer, lifetime) in

            let options = PHImageRequestOptions()
            
            //lấy chính xác size, nếu để fast thì ảnh nhận được cótheer lớn hơn.
            options.resizeMode = .exact
            
            //có thể nhận nhiều result nếu asyn và 1 nếu syn: tức là handle được gọi có thể nhiều lần. (gọi ảnh chất lượng thấp trước, sau đó trả ảnh chất lượng khi ready)
            options.deliveryMode = .opportunistic
            options.isNetworkAccessAllowed = true
            
            let requestID = self.imageCachingManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, info in
                
                //hoàn thành nếu ảnh != ảnh chất lượng thấp
                let complete = (info?["PHImageResultIsDegradedKey"] as? Bool) == false
                print("request \(String(describing: info?["PHImageResultRequestIDKey"])) is low quality \(!complete)")
                if let image = image {
                    observer.send(value: (image, nil))
                }
                
                if complete {
                    observer.sendCompleted()
                }
            }
            
            observer.send(value: (nil,requestID))
        }
    }
    
    func fullResolutionImageDataFor(asset: PHAsset) -> SignalProducer<UIImage?, Never> {
        
        return SignalProducer { (observer, lifetime) in
            let options = PHImageRequestOptions()
            //chi lay 1 anh ket qua
            options.isSynchronous = true
            options.resizeMode = .none
            options.isNetworkAccessAllowed = false
            options.version = .current
            
            //load anh lon nhat co the
            let _ = PHCachingImageManager().requestImageData(for: asset, options: options) { (imageData, dataUTI, orientation, info) in
                if let data = imageData {
                    observer.send(value: UIImage(data: data))
                }
                observer.sendCompleted()
            }
        }
    }
    
    //huy bo anh dang duoc request nhung khong can den nua
    func cancelImageRequest(requestID: PHImageRequestID) {
        imageCachingManager.cancelImageRequest(requestID)
    }
    
    //tao thumbnail image o background thread
    func startCatchingImages(assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil) {
        imageCachingManager.startCachingImages(for: assets, targetSize: targetSize, contentMode: contentMode, options: options)
    }
    
    //huy bo catching image, vd khi dao chieu collectionview
    func stopCatchingImages(assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil) {
        imageCachingManager.stopCachingImages(for: assets, targetSize: targetSize, contentMode: contentMode, options: options)
    }
}

//untils function=====================================
extension MPPhotoLib {
    
    private func generateCollectionOption(config: MPPhotoConfig) -> PHFetchOptions {
        
        let fetchOptions = PHFetchOptions()
        
        if let albumName = config.albumName {
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        }
        return fetchOptions;
    }
    
    private func generateAssetOption(config: MPPhotoConfig) -> PHFetchOptions {
        
        let options = PHFetchOptions()
        
        if let mediaType = config.mediaType {
            let mediaPredicate = NSPredicate(format: "mediaType = %i", mediaType.rawValue)
            options.merge(predicate: mediaPredicate)
        }
        return options;
    }
}
