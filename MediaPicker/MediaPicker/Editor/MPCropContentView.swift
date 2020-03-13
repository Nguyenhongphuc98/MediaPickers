//
//  MPCropContentView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/13/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

class MPCropContentView: UIView {

    var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            imageView.image = self.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        imageView = UIImageView(frame: bounds)
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
}
