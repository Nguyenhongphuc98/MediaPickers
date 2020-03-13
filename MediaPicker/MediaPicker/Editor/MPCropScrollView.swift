//
//  MPCropScrollView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/12/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

let MPCropScrollViewMinimumSoomScale: CGFloat = 1.0
let MPCropScrollViewMaximumSoomScale: CGFloat = 10.0

class MPCropScrollView: UIView {

    var contentView: MPCropContentView!
    
    var scrollview: UIScrollView!
    
    var contentWillBeZooming: (()->Void)?
    
    var contentDidEndZooming: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView = MPCropContentView(frame: bounds)
        addSubview(contentView)
        
        scrollview = UIScrollView(frame: bounds)
        scrollview.delegate = self
        scrollview.bounces = true
        scrollview.alwaysBounceVertical = true
        scrollview.alwaysBounceHorizontal = true
        scrollview.minimumZoomScale = MPCropScrollViewMinimumSoomScale
        scrollview.maximumZoomScale = MPCropScrollViewMaximumSoomScale
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.contentSize = CGSize(width: bounds.width, height: bounds.height)
        addSubview(scrollview)
    }
    
    func setImage(image: UIImage) {
        contentView.image = image
    }
    
    func zoom(to rect: CGRect, isAnimate: Bool) {
        scrollview.zoom(to: rect, animated: isAnimate)
    }
}

// MARK: scrollview delegate
extension MPCropScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if let contentWillBeZooming = self.contentWillBeZooming {
            contentWillBeZooming()
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let contentDidEndZooming = self.contentDidEndZooming {
            contentDidEndZooming()
        }
    }
}