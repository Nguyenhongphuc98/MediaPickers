//
//  MPCropView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/11/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

let MPCropViewOverScreenSize = 1000
let MPCropRotationHeight: CGFloat = 100

class MPCropView: UIControl {
    
    var originSize: CGSize = CGSize(width: 0, height: 0)
    
    var maximumCanvasSize: CGSize = .zero

    var rotation: CGFloat = 0
    
    var cropRect: CGRect = .zero
    
    var zoomed: Bool = false
    
    var mirrored: Bool = false
    
    var isLookedAspectRatio: Bool = false
    
    var aspectRatio: CGFloat = .zero
    
    //overlay view
    var overlayWrapperView: UIView!
    
    var topOverlayView: UIView!
    
    var leftOverlayView: UIView!
    
    var bottomOverlayView: UIView!
    
    var rightOverlayView: UIView!
    
    //main area
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
        canvasInsets.bottom = canvasInsets.bottom + MPCropRotationHeight
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
        backgroundColor = .white
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
        
        overlayWrapperView = UIView(frame: scrollView.frame)
        overlayWrapperView.isUserInteractionEnabled = false
        //overlayWrapperView.alpha = 0.45
        overlayWrapperView.addSubview(topOverlayView)
        overlayWrapperView.addSubview(leftOverlayView)
        overlayWrapperView.addSubview(rightOverlayView)
        overlayWrapperView.addSubview(bottomOverlayView)
        addSubview(overlayWrapperView)
        
        areaView = MPCropAreaView(frame: scrollView.frame)
        addSubview(areaView)
        layoutOverlayView()
        
        //rotation
        rotationView = MPCropRotationView(frame: CGRect(x: frame.width / 2 - originSize.width / 2, y: scrollView.frame.origin.y + scrollView.frame.size.height, width: originSize.width, height: MPCropRotationHeight))
        addSubview(rotationView)
    }
    
    private func setUpAction() {
        
        areaView.areaDidBeginEditing = {
            self.handleAreaDidBeginEditting()
        }
        
        areaView.areaDidChange = {
            self.handleAreaDidchange()
        }
        
        areaView.areaDidEndEditing = {
            self.handleCropAreaDidEndEditting()
        }
        
        rotationView.angleDidBeginChanging = {
           // self.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), view: self.scrollView)
            UIView.animate(withDuration: 0.1) {
                self.overlayWrapperView.alpha = 0.45
                self.areaView.setGridMode(gridMode: .Minor, isAnimate: false)
            }
        }
        
        rotationView.angleDidChange = { angle in
            self.setRotation(rotation: angle)
        }
        
        rotationView.angleDidEndChanging = {
            
            self.areaView.setGridMode(gridMode: .None, isAnimate: false)
            UIView.animate(withDuration: 0.2) {
                self.overlayWrapperView.alpha = 1
            }
        }
        
        scrollView.contentWillBeZooming = {
            UIView.animate(withDuration: 0.2) {
                self.overlayWrapperView.alpha = 0.45
            }
        }
        
        scrollView.contentDidEndZooming = {
            self.zoomed = true
            UIView.animate(withDuration: 0.2) {
                self.overlayWrapperView.alpha = 1
            }
        }
    }
    
    private func layoutOverlayView() {
        
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
    
    //MARK: handel area
    private func handleAreaDidBeginEditting() {
        overlayWrapperView.alpha = 0.45
        rotationView.alpha = 0
    }
    
    private func handleAreaDidchange() {
        //areaview khong the vuot qua canvas area
        let cropFrame = self.areaView.frame
        
        let topInset = cropFrame.origin.y <  canvasInsets.top ? canvasInsets.top - cropFrame.origin.y : 0

        let leftInset = cropFrame.origin.x < canvasInsets.left ? canvasInsets.left - cropFrame.origin.x : 0

        let bottomOfCropRect = cropFrame.origin.y + cropFrame.size.height
        let bottomOfCanvansRect = self.canvasCenter.y + self.maximumCanvasSize.height / 2
        let bottomInset = bottomOfCropRect > bottomOfCanvansRect ? bottomOfCropRect - bottomOfCanvansRect : 0

        let rightOfCropRect = cropFrame.origin.x + cropFrame.size.width
        let rightOfCanvasRect = canvasCenter.x + maximumCanvasSize.width / 2
        let rightInset = rightOfCropRect > rightOfCanvasRect ? rightOfCropRect - rightOfCanvasRect : 0
        
        self.areaView.frame = cropFrame.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
        
        //zoom view content de fill areaview neu can thiet
//        scrollView.bounds = self.makeNewSizeScrollView(for: rotation)
//        scrollView.scaleToBounds()
        
        self.layoutOverlayView()
    }
    
    private func handleCropAreaDidEndEditting() {
        
        zoomed = true
        
        //tinh do scale ma cropview da scale
        let scaleX = maximumCanvasSize.width / areaView.bounds.size.width
        let scaleY = maximumCanvasSize.height / areaView.bounds.size.height
        let scale = min(scaleX, scaleY)
        
        let newWidth = scale * areaView.bounds.size.width
        let newHeight = scale * areaView.bounds.size.height
        
        let newAreaBounds = CGRect(x: .zero, y: .zero, width: newWidth, height: newHeight)
        
        //tinh bound moi cua scrollview - vi no co the dang xoay r-radians
        let positiveAgle = abs(rotation)
        let newScrollViewBoundWidth = sin(positiveAgle) * newHeight + cos(positiveAgle) * newWidth
        let newScrollViewBoundHeight = cos(positiveAgle) * newHeight + sin(positiveAgle) * newWidth
        
        let scrollViewBound = CGRect(x: .zero, y: .zero, width: newScrollViewBoundWidth, height: newScrollViewBoundHeight)
        
        
        //tinh content offset cua scrollview
        
        
        let zoomRect = self.convert(self.areaView.frame, to: self.scrollView.contentView)

        //update UI
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.bounds = scrollViewBound
            self.areaView.bounds = newAreaBounds
            self.areaView.center = self.canvasCenter
            self.rotationView.frame = CGRect(x: self.frame.width / 2 - self.originSize.width / 2, y: self.areaView.frame.origin.y + self.areaView.frame.size.height, width: self.originSize.width, height: MPCropRotationHeight)
            self.layoutOverlayView()

            //zoom scrollview to ..
            self.scrollView.zoom(to: zoomRect, isAnimate: false)
        }) { (finished) in
            
            if finished {
                UIView.animate(withDuration: 0.5) {
                    self.overlayWrapperView.alpha = 1
                    self.rotationView.alpha = 1
                }
            }
        }
        
    }
    
    func setRotation(rotation: CGFloat) {
        //setAnchorPoint(anchorPoint: .zero, view: areaView)
        //self.areaView.transform = CGAffineTransform(rotationAngle: rotation)
        self.rotation = rotation
        self.scrollView.transform = CGAffineTransform(rotationAngle: rotation)
        
        
        //update scrollview bounds
        let positiveAgle = abs(rotation)
        let newScrollViewBoundWidth = sin(positiveAgle) * areaView.frame.size.height + cos(positiveAgle) * areaView.frame.size.width
        let newScrollViewBoundHeight = cos(positiveAgle) * areaView.frame.size.height + sin(positiveAgle) * areaView.frame.size.width
        self.scrollView.bounds = CGRect(x: .zero, y: .zero, width: newScrollViewBoundWidth, height: newScrollViewBoundHeight)
        
        //calculate offset
        self.scrollView.center = canvasCenter
        
        //scale if needed
        let isContentNotFit = self.scrollView.contentSize.width / self.scrollView.bounds.size.width <= 1 || self.scrollView.contentSize.height / self.scrollView.bounds.size.height <= 1
        
        if isContentNotFit || !zoomed {
            self.scrollView.scaleToBounds()
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)

        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)

        var position : CGPoint = view.layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x;

        position.y -= oldPoint.y;
        position.y += newPoint.y;

        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    
    
    //MARK: layout area
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:remote cropView method
    public func resetToOrigin() {
        print("reset")
    }
    
    public func mirrorContent() {
        mirrored = !mirrored
        print("mirror")
    }
    
    public func reotate90Degrees(withAnimate animate: Bool) {
        print("rotate")
    }
    
    public func lockCropArea(with aspectRatio: CGFloat) {
        isLookedAspectRatio = true
        print("lock aspect ratio")
    }
    
    public func unlockCropArea() {
        isLookedAspectRatio = false
    }
}
