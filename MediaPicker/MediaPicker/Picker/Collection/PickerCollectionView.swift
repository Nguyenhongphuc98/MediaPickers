//
//  PickerCollectionView.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/25/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import Photos
import ReactiveSwift

protocol PickerCollectionViewDelegate {
    
}

protocol PickerCollectionViewDataSource {
    func assetCollectionFor(collectionView: PickerCollectionView) -> MPAssetCollectionProtocol?
}

class PickerCollectionView: UIView {
    
    var collectionview: UICollectionView?
    
    var assetCollection: MPAssetCollectionProtocol?
    
    let numberOfCollumn: Int = 3
    
    let collumMargin: CGFloat = 5
    
    var thumbnailSize = CGSize.zero
    
    //quản lý các request image để có thể huỷ bỏ khi chuyển qua collection khác
    var requestIDDictionary = Dictionary<Int, PHImageRequestID>()
    
    var dataSource: PickerCollectionViewDataSource?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        setUpUI()
    }
    
    func setUpUI() {
        
        let cellWidth = (Int(frame.size.width) - Int(self.collumMargin) * (self.numberOfCollumn - 1) - 20)/self.numberOfCollumn
        self.thumbnailSize = CGSize(width: cellWidth, height: cellWidth)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.thumbnailSize
        layout.minimumInteritemSpacing = collumMargin
        layout.minimumLineSpacing = collumMargin
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        let cv = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.prefetchDataSource = self
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        
        addSubview(cv)
        self.collectionview = cv
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: ["cv":cv]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cv]|", options: [], metrics: nil, views: ["cv":cv]))
        
        cv.register(UINib(nibName: "ThumbnailCell", bundle: nil), forCellWithReuseIdentifier: "ThumbnailCell")
    }
    
    
    func reloadCollectionView() {
        guard let assetCollection = dataSource?.assetCollectionFor(collectionView: self) else {
            return
        }
        
        //huy tat ca request chua load tai day
        
        
        self.assetCollection = assetCollection
        collectionview?.reloadData()
    }
}

//=======================================================================
extension PickerCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard assetCollection != nil else {
            return 0
        }
        return assetCollection!.numberOfAssets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ThumbnailCell", for: indexPath) as! ThumbnailCell
        
        if let asset = assetCollection?.assetAt(index: indexPath.row) {
            //load image
            MPPhotoLib.sharedInstance
                .requestImageForAsset(asset: asset, size: self.thumbnailSize)
                .start(Signal<(UIImage?, PHImageRequestID?), Never>.Observer(value: { (image, requestId) in
                    
                    //first times
                    if let requestID = requestId {
                        self.requestIDDictionary[indexPath.row] = requestID
                    }
                    
                    //second times
                    if let img = image {
                        //fill image to cell
                        cell.fill(image: img)
                    }
                }, failed: { (never) in
                    print("fail")
                }, completed: {
                    self.requestIDDictionary.removeValue(forKey: indexPath.row)
                }, interrupted: {
                    print("interup")
                }))
        }
    
        return cell;
    }
}

extension PickerCollectionView: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("prefetch: \(indexPaths)")
        guard let collection = self.assetCollection else {
            return
        }
        
        var assets = [PHAsset]()
        for indexPath in indexPaths {
            let asset = collection.assetAt(index: indexPath.row)
            assets.append(asset)
            
        }
        
        //tao thumbnail image o background thread
        MPPhotoLib.sharedInstance
            .imageCachingManager.startCachingImages(for: assets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
       
         print("cancel prefetch: \(indexPaths)")
            for indexPath in indexPaths {
                guard let requestID = requestIDDictionary[indexPath.row] else { continue }
                print("cancel reques: \(requestID)")
                MPPhotoLib.sharedInstance
                .imageCachingManager
                .cancelImageRequest(requestID)
                self.requestIDDictionary.removeValue(forKey: indexPath.row)
            }
//            queue.async { [weak self] in
//                guard let `self` = self, let collection = self.focusedCollection else { return }
//                var assets = [PHAsset]()
//                for indexPath in indexPaths {
//                    if let asset = collection.getAsset(at: indexPath.row) {
//                        assets.append(asset)
//                    }
//                }
//                let scale = max(UIScreen.main.scale,2)
//                let targetSize = CGSize(width: self.thumbnailSize.width*scale, height: self.thumbnailSize.height*scale)
//                self.photoLibrary.imageManager.stopCachingImages(for: assets, targetSize: targetSize, contentMode: .aspectFill, options: nil)
//            }
        }
    
}
