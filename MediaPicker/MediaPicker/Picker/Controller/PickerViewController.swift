//
//  PickerViewController.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/25/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import ReactiveSwift
import Photos

class PickerViewController: UIViewController {
    
    var collectionView: PickerCollectionView!
    
    var mpCollections: [MPAssetCollection]!
    
    var focusedCollection: MPAssetCollection?
    
    var albumsButton: UIButton!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        testPhotoLib()
    }
    
    func testPhotoLib() {
        MPPhotoLib.sharedInstance
            .checkAuthorization()
            .observe(on: UIScheduler())
            .start(Signal<AuthorizationResult, Never>.Observer(value: { [unowned self] (status) in
                
                switch status {
                case .authorized:
                    MPPhotoLib.sharedInstance
                        .fetchCollection(type: .smartAlbum, subtype: .smartAlbumUserLibrary)
                        .observe(on: UIScheduler())
                        .start(Signal<MPAssetCollection, Never>.Observer(value: { [unowned self] (collection) in
                            
                            self.focus(collection: collection)
                            
                            MPPhotoLib.sharedInstance
                                .fetchSmartAlbums()
                                .observe(on: UIScheduler())
                                .start(Signal<[MPAssetCollection], Never>.Observer(value: { [unowned self] (albums) in
                                    self.mpCollections = albums
                                    if let _ = self.focusedCollection {
                                    } else {
                                        self.focus(collection: albums[0])
                                    }
                                }))
                        }))
                    
                    
                default:
                    print("don't have permission")
                    self.albumsButton.isEnabled = false
                }
                
            }, completed: {
                print("authorization complete")
            }))
    }

    func setUpUI() {
        self.view.backgroundColor = .gray
        
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        actInd.center = view.center
        actInd.hidesWhenStopped = true
        actInd.style = .gray
        
        albumsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        albumsButton.setTitle("Albums", for: .normal)
        albumsButton.setTitleColor(.blue, for: .normal)
        albumsButton.setTitleColor(.green, for: .highlighted)
        albumsButton.setTitleColor(.gray, for: .disabled)
        albumsButton.addTarget(self, action: #selector(albumsButtonDidClick), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = albumsButton
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        collectionView = PickerCollectionView(frame: self.view.frame)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(albumsButton)
        self.view.addSubview(collectionView)
        view.addSubview(actInd)
    }
    
    func focus(collection: MPAssetCollection) {
        self.focusedCollection = collection
        navigationItem.title = collection.collectionName
        collectionView?.reloadCollectionView()
        
    }
    
    @objc func albumsButtonDidClick() {
        
        //cancel image all requets
        collectionView.cancelAllImageRequest()
        
        let albumVC = AlbumsViewController()
        albumVC.albums = mpCollections
        if let focused = focusedCollection {
            albumVC.focusIndex.value = mpCollections.firstIndex(where: { (collect) -> Bool in
                collect.isEqual(focused)
            })!
        }
        print(albumVC.focusIndex.value)
        albumVC.focusIndex
            .signal
            .observe(Signal<Int, Never>.Observer(value: { [unowned self] (index) in
                self.focus(collection: self.mpCollections![index])
                print("change index to: \(index)")
            }))
        
        modalPresentationStyle = UIModalPresentationStyle.popover
        //present(albumVC, animated: true, completion: {print("present complete")})
        navigationController?.pushViewController(albumVC, animated: true)
    }
}

extension PickerViewController: PickerCollectionViewDataSource {
    
    func assetCollectionFor(collectionView: PickerCollectionView) -> MPAssetCollectionProtocol? {
        guard let coll = self.focusedCollection else {
            return nil
        }
        return coll
    }
}

extension PickerViewController: PickerCollectionViewDelegate {
    
    func pickerCollectionView(collectionview: PickerCollectionView, didSelectImageAt index: Int) {
        actInd.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var count = 0
        MPPhotoLib.sharedInstance
        .requestImageForAsset(asset: focusedCollection!.assetAt(index: index),size: CGSize(width: 1238, height: 822))
        .observe(on: UIScheduler())
            .start(Signal<(UIImage?, PHImageRequestID?), Never>.Observer(value: { (img, id) in
                guard img != nil && id == nil else {
                    return
                }
                count += 1
                guard count == 2 else {
                    return
                }
                let imageVC = CropViewController(image: img!)
                self.actInd.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationController?.pushViewController(imageVC, animated: true)
            }))
        
//        MPPhotoLib.sharedInstance
//            .fullResolutionImageDataFor(asset: focusedCollection!.assetAt(index: index))
//            .observe(on: UIScheduler())
//            .start(Signal<UIImage?, Never>.Observer(value: { [unowned self] (image) in
//
//                let imageVC = CropViewController(image: image!)
//                self.actInd.stopAnimating()
//                UIApplication.shared.endIgnoringInteractionEvents()
//                self.navigationController?.pushViewController(imageVC, animated: true)
//            }))
//        let imageVC = CropViewController()
//        imageVC.asset = focusedCollection!.assetAt(index: index)
//        navigationController?.pushViewController(imageVC, animated: true)
    }
}
