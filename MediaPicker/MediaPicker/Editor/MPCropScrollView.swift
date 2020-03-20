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
    
    var contentOffset: CGPoint {
        get {
            return scrollview.contentOffset
        }
        set {
            scrollview.setContentOffset(newValue, animated: true)
        }
    }
    
    var contentSize: CGSize {
        scrollview.contentSize
    }
    
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
        backgroundColor = .clear
        clipsToBounds = false
        contentView = MPCropContentView(frame: bounds)
        //addSubview(contentView)
        
        scrollview = UIScrollView(frame: bounds)
        scrollview.delegate = self
        scrollview.bounces = true
        scrollview.alwaysBounceVertical = true
        scrollview.alwaysBounceHorizontal = true
        scrollview.clipsToBounds = false
        scrollview.minimumZoomScale = MPCropScrollViewMinimumSoomScale
        scrollview.maximumZoomScale = MPCropScrollViewMaximumSoomScale
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.contentSize = CGSize(width: bounds.width, height: bounds.height)
        scrollview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollview.addSubview(contentView)
        addSubview(scrollview)
    }
    
    func setImage(image: UIImage) {
        contentView.image = image
    }
    
    func zoom(to rect: CGRect, isAnimate: Bool) {
        scrollview.zoom(to: rect, animated: isAnimate)
    }
    
    func scaleToBounds() {
        scrollview.setZoomScale(makeScaleToBounds(), animated: false)
    }
    
    func makeScaleToBounds() -> CGFloat {
        let scaleWidth = bounds.size.width / contentView.bounds.size.width
        let scaleHeight = bounds.size.height / contentView.bounds.size.height
        
        return max(scaleWidth, scaleHeight)
    }
    
    func resetScale() {
        scrollview.setZoomScale(1, animated: false)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        let lineColor = UIColor.red
//        lineColor.setFill()
//        
//        //scrollview.isHidden = true
//        
//        UIRectFill(CGRect(x: 0, y: 0, width: rect.width, height: 3))
//        UIRectFill(CGRect(x: 0, y: 0, width: 3, height: rect.height))
//        UIRectFill(CGRect(x: 0, y: rect.height, width: rect.width, height: 3))
//        UIRectFill(CGRect(x: rect.width / 2 - 2, y: rect.height / 2 - 2, width: 4, height: 4))
        
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
