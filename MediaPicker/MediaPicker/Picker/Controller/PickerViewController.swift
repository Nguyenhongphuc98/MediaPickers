//
//  PickerViewController.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/25/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import ReactiveSwift

class PickerViewController: UIViewController {
    
    var collectionView: PickerCollectionView!
    
    var mpCollections: [MPAssetCollection]!
    
    var focusedCollection: MPAssetCollection?
    
    var albumsButton: UIButton!

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
            .start(Signal<AuthorizationResult, Never>.Observer(value: { (status) in
                
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
                                }))
                        }))
                    
                    
                default:
                    print("don't have permission")
                }
                
            }, completed: {
                print("authorization complete")
            }))
    }

    func setUpUI() {
        self.view.backgroundColor = .gray
        
        albumsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        albumsButton.setTitle("Albums", for: .normal)
        albumsButton.setTitleColor(.blue, for: .normal)
        albumsButton.setTitleColor(.green, for: .highlighted)
        albumsButton.addTarget(self, action: #selector(albumsButtonDidClick), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = albumsButton
        navigationItem.leftBarButtonItem = leftBarButtonItem
        view.addSubview(albumsButton)
        
        collectionView = PickerCollectionView(frame: self.view.frame)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.view.addSubview(collectionView)
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
        let imageVC = CropViewController()
        imageVC.asset = focusedCollection!.assetAt(index: index)
        navigationController?.pushViewController(imageVC, animated: true)
    }
}
