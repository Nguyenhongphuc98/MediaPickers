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
    
    let numberOfCollumn: Int = 5
    
    let collumMargin: Int = 5
    
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
        
        let cellWidth = (Int(frame.size.width) - self.collumMargin * (self.numberOfCollumn - 1))/self.numberOfCollumn
        self.thumbnailSize = CGSize(width: cellWidth, height: cellWidth)
        
        setUpUI()
    }
    
    func setUpUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.thumbnailSize
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let cv = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        
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
