//
//  MPCropView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/11/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

let MPCropViewOverScreenSize = 1000

class MPCropView: UIControl {
    
    var originSize: CGSize = CGSize(width: 0, height: 0)
    
    var maximumCanvasSize: CGSize = .zero

    var rotation: CGFloat = 0
    
    var cropRect:CGRect = CGRect.zero
    
    var mirrored: Bool = false
    
    var isLookedAspectRatio: Bool = false
    
    //overlay view
    var overlayWrapperView: UIView!
    
    var topOverlayView: UIView!
    
    var leftOverlayView: UIView!
    
    var bottomOverlayView: UIView!
    
    var rightOverlayView: UIView!
    
    //main area
    var mainAreaWrapperView: UIControl!
    
    var areaView: MPCropAreaView!
    
    var image: UIImage!
    
    var imageView: UIImageView!
    
    var scrollView: MPCropScrollView!
    
    //rotation view
    var rotationView: MPCropRotationView!
    
    var canvasInsets: UIEdgeInsets = .zero
    
    var canvasCenter: CGPoint = .zero
    
    //MARK: init area
    init(frame: CGRect, insets: UIEdgeInsets, image: UIImage) {

        canvasInsets = insets
        self.image = image
        
        super.init(frame: frame)
        
        setUpUI()
        setUpAction()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
        setUpAction()
    }
    
    //MARK: setup area
    private func setUpUI() {
        
        cropRect = CGRect(x: 0, y: 0, width: originSize.width, height: originSize.height)
        let overlayColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        
        //tinh toan vung bounds cho crop area
        maximumCanvasSize = frame.inset(by: canvasInsets).size
        canvasCenter = CGPoint(x: maximumCanvasSize.width / 2 + canvasInsets.left, y: maximumCanvasSize.height / 2 + canvasInsets.top)
        let scaleX = image.size.width / maximumCanvasSize.width
        let scaleY = image.size.height / maximumCanvasSize.height
        let scale = max(scaleX, scaleY)
        let cropBounds = CGRect(x: .zero, y: .zero, width: image.size.width / scale, height: image.size.height / scale)
        
        originSize = cropBounds.size
        
        scrollView = MPCropScrollView(frame: cropBounds)
        scrollView.center = canvasCenter
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.setImage(image: image)
        addSubview(scrollView)
        
        topOverlayView = UIView(frame: CGRect.zero)
        topOverlayView.backgroundColor = overlayColor
        
        leftOverlayView = UIView(frame: CGRect.zero)
        leftOverlayView.backgroundColor = overlayColor
        
        bottomOverlayView = UIView(frame: CGRect.zero)
        bottomOverlayView.backgroundColor = overlayColor
        
        rightOverlayView = UIView(frame: CGRect.zero)
        rightOverlayView.backgroundColor = overlayColor
        
        overlayWrapperView = UIView(frame: CGRect.zero)
        overlayWrapperView.isUserInteractionEnabled = false
        overlayWrapperView.alpha = 0.45
        overlayWrapperView.addSubview(topOverlayView)
        overlayWrapperView.addSubview(leftOverlayView)
        overlayWrapperView.addSubview(rightOverlayView)
        overlayWrapperView.addSubview(bottomOverlayView)
        
        areaView = MPCropAreaView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        areaView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mainAreaWrapperView = UIControl(frame: scrollView.frame)
        mainAreaWrapperView.addSubview(overlayWrapperView)
        mainAreaWrapperView.addSubview(areaView)
        addSubview(mainAreaWrapperView)
        
        //rotation
        rotationView = MPCropRotationView(frame: CGRect(x: 0, y: 530, width: originSize.width, height: 200))
        addSubview(rotationView)
    }
    
    private func setUpAction() {
        
        areaView.areaDidBeginEditing = {
            self.handelAreaDidBeginEditting()
        }
        
        areaView.areaDidChange = {
            self.handleCropAreaChanged()
        }
        
        areaView.areaDidEndEditing = {
            self.handleCropAreaDidEndEditting()
        }
        
        rotationView.angleDidChange = { angle in
            self.setRotation(rotation: angle)
        }
        
        scrollView.contentWillBeZooming = {
            print("content zooming...")
        }
        
        scrollView.contentDidEndZooming = {
            print("content did end zooming ...")
        }
    }
    
    //MARK: handel area
    private func handelAreaDidBeginEditting() {
        overlayWrapperView.alpha = 0.45
    }
    
    private func handleCropAreaChanged() {
        
        //layout overlayviews
        let wrapperAreaBounds = CGRect(x: 0, y: 0, width: areaView.frame.width, height: areaView.frame.height)
        let topOverlayFrame = CGRect(x: 0, y: -MPCropViewOverScreenSize, width: Int(wrapperAreaBounds.width), height: MPCropViewOverScreenSize)
        let leftOverlayFrame = CGRect(x: -MPCropViewOverScreenSize, y: -MPCropViewOverScreenSize, width: MPCropViewOverScreenSize, height: Int(wrapperAreaBounds.height) + 2 * MPCropViewOverScreenSize)
        let bottomOverlayFrame = CGRect(x: .zero, y: wrapperAreaBounds.height, width: wrapperAreaBounds.size.width, height: CGFloat(MPCropViewOverScreenSize))
        let rightOverlayFrame = CGRect(x: Int(wrapperAreaBounds.width), y: -MPCropViewOverScreenSize, width: MPCropViewOverScreenSize, height: Int(wrapperAreaBounds.height) + 2 * MPCropViewOverScreenSize)
        
        overlayWrapperView.frame = areaView.frame
        topOverlayView.frame = topOverlayFrame
        leftOverlayView.frame = leftOverlayFrame
        bottomOverlayView.frame = bottomOverlayFrame
        rightOverlayView.frame = rightOverlayFrame
    }
    
    private func handleCropAreaDidEndEditting() {
        //tinh do scale ma cropview da scale
        let scaleX = originSize.width / areaView.bounds.size.width
        let scaleY = originSize.height / areaView.bounds.size.height
        let scale = min(scaleX, scaleY)
        
        let newWidth = scale * areaView.bounds.size.width
        let newHeight = scale * areaView.bounds.size.height
        
        let newAreaBounds = CGRect(x: .zero, y: .zero, width: newWidth, height: newHeight)
        
        //tinh bound moi cua scrollview - vi no co the dang xoay r-radians
        
        //tinh content offset cua scrollview
        
        
        let zoomRect = self.convert(self.areaView.frame, to: self.scrollView.contentView)
        //update UI
        UIView.animate(withDuration: 0.3, animations: {
            
            
            self.areaView.frame = newAreaBounds
            self.handleCropAreaChanged()
            //self.areaView.center = self.canvasCenter

            //zoom scrollview to ..
            self.scrollView.zoom(to: zoomRect, isAnimate: false)
        }) { (finished) in
            if finished {
                self.overlayWrapperView.alpha = 1
            }
        }
        
    }
    
    func setRotation(rotation: CGFloat) {
        self.scrollView.transform = CGAffineTransform(rotationAngle: rotation)
    }
    
    //MARK: layout area
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
