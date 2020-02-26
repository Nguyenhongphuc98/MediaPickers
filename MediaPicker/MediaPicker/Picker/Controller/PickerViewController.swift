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
    
    var collectionView: PickerCollectionView?
    var focusedCollection: MPAssetCollection?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        testPhotoLib()
    }
    
    func testPhotoLib() {
        MPPhotoLib.sharedInstance
            .checkAuthorization()
            .start(Signal<AuthorizationResult, Never>.Observer(value: { (status) in
                switch status {
                case .authorized:
                    MPPhotoLib.sharedInstance
                        .fetchCollection(type: .smartAlbum, subtype: .smartAlbumUserLibrary)
                        .start(Signal<MPAssetCollection, Never>.Observer(value: { (collection) in
                            self.focus(collection: collection)
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
        collectionView = PickerCollectionView(frame: self.view.frame)
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
    }
    
    func focus(collection: MPAssetCollection) {
        self.focusedCollection = collection
        collectionView?.reloadCollectionView()
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
