//
//  CollectAssetCell.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/2/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import Photos
import ReactiveSwift

class CollectAssetCell: UITableViewCell {

    @IBOutlet weak var thumnailImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var assetCount: UILabel!
    
    var collection: MPAssetCollectionProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillData(collect: MPAssetCollectionProtocol, size: Int) {
        collection = collect
        
        collectionName.text = collect.collectionName
        assetCount.text = String(collect.numberOfAssets)
        
        let asset = collect.assetAt(index: 0)
        let thumbnailSize = CGSize(width: size, height: size)
        MPPhotoLib.sharedInstance
            .requestImageForAsset(asset: asset, size: thumbnailSize)
            .start(Signal<(UIImage?, PHImageRequestID?), Never>.Observer(value: { (image, requestId) in

                if let img = image {
                    self.thumnailImage.image = img
                }
            }))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
