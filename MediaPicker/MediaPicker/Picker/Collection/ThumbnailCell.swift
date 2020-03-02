//
//  ThumbnailCell.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/25/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import Photos

protocol ThumbnailCellProtocol {
    
    var image: UIImage {get set}
}

class ThumbnailCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!

    var asset: PHAsset?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(image: UIImage) {
        thumbnailImage.image = image
    }
}
