//
//  MPCropAreaView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/4/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

let MPCropCornerControlSize: CGFloat = 44
let MPCropRectMinimumSize: CGFloat = 44

class MPCropAreaView: UIControl {

    public var areaDidBeginEditing: (()->())?
    
    public var areaDidChange: (()->())?
    
    public var areaDidEndEditing: (()->())?
    
    var currentGridMode: GridMode = .None
    
    //property==========================================
    var isLockAspectRatio: Bool = false
    //a = W:H
    var aspectRatio: CGFloat = 0
    
    //control===========================================
    var topEdgeControl: MPCropControl!
    
    var leftEdgeControl: MPCropControl!
    
    var bottomEdgeControl: MPCropControl!
    
    var rightEdgeControl: MPCropControl!
    
    var topLeftCornerControl: MPCropControl!
    
    var topRightCornerControl: MPCropControl!
    
    var bottomLeftCornerControl: MPCropControl!
    
    var bottomRightCornerControl: MPCropControl!
    
    //view highlight control============================
    var cornersView: UIImageView?
    
    var topEdgeHighLight: UIView!
    
    var leftEdgeHighLight: UIView!
    
    var bottomEdgeHighLight: UIView!
    
    var rightEdgeHighLight: UIView!
    
    //grid view=========================================
    var majorGridView: MPCropGridView!
    
    var minorGridView: MPCropGridView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        setUpAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpUI()
        setUpAction()
    }
 
    func setUpUI() {
        topEdgeHighLight = UIView(frame: CGRect(x: 0, y: -1, width: frame.size.width, height: 2))
        topEdgeHighLight.autoresizingMask = .flexibleWidth
        topEdgeHighLight.backgroundColor = .white
        topEdgeHighLight.isHidden = true
        
        leftEdgeHighLight = UIView(frame: CGRect(x: -1, y: 0, width: 2, height: frame.size.height))
        leftEdgeHighLight.autoresizingMask = .flexibleHeight
        leftEdgeHighLight.backgroundColor = .white
        leftEdgeHighLight.isHidden = true
        
        rightEdgeHighLight = UIView(frame: CGRect(x: frame.size.width - 1, y: 0, width: 2, height: frame.size.height))
        rightEdgeHighLight.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        rightEdgeHighLight.backgroundColor = .white
        rightEdgeHighLight.isHidden = true
        
        bottomEdgeHighLight = UIView(frame: CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 2))
        bottomEdgeHighLight.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        bottomEdgeHighLight.backgroundColor = .white
        bottomEdgeHighLight.isHidden = true
        
        
        topEdgeControl = MPCropControl(frame: CGRect(x: MPCropCornerControlSize / 2, y: -MPCropCornerControlSize / 2, width: frame.size.width - MPCropCornerControlSize, height: MPCropCornerControlSize))
        topEdgeControl.autoresizingMask = .flexibleWidth
        
        leftEdgeControl = MPCropControl(frame: CGRect(x: -MPCropCornerControlSize / 2, y: MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: frame.size.height - MPCropCornerControlSize))
        leftEdgeControl.autoresizingMask = .flexibleHeight
        
        bottomEdgeControl = MPCropControl(frame: CGRect(x: MPCropCornerControlSize / 2, y: frame.size.height - MPCropCornerControlSize / 2, width: frame.size.width - MPCropCornerControlSize, height: MPCropCornerControlSize))
        bottomEdgeControl.autoresizingMask = [.flexibleWidth, . flexibleTopMargin]
        
        rightEdgeControl = MPCropControl(frame: CGRect(x: frame.size.width - MPCropCornerControlSize / 2, y: MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: frame.size.height - MPCropCornerControlSize))
        rightEdgeControl.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        
        
        topLeftCornerControl = MPCropControl(frame: CGRect(x: -MPCropCornerControlSize / 2, y: -MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        
        topRightCornerControl = MPCropControl(frame: CGRect(x: frame.size.width - MPCropCornerControlSize / 2, y: -MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        topRightCornerControl.autoresizingMask = .flexibleLeftMargin
        
        bottomLeftCornerControl = MPCropControl(frame: CGRect(x: -MPCropCornerControlSize / 2, y: frame.size.height - MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        bottomLeftCornerControl.autoresizingMask = .flexibleTopMargin
        
        bottomRightCornerControl = MPCropControl(frame: CGRect(x: frame.size.width - MPCropCornerControlSize / 2, y: frame.size.height - MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        bottomRightCornerControl.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        
        //let bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        majorGridView = MPCropGridView(mode: .Major, frame: bounds)
        majorGridView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        majorGridView.isHidden = true
        
        minorGridView = MPCropGridView(mode: .Minor, frame: bounds)
        minorGridView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        minorGridView.isHidden = true
        
        cornersView = UIImageView(frame: bounds.insetBy(dx: -2, dy: -2))
        cornersView?.image = #imageLiteral(resourceName: "PhotoEditorCropCorners")
        cornersView?.image = cornersView?.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        cornersView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(cornersView!)
        
        addSubview(topEdgeHighLight)
        addSubview(leftEdgeHighLight)
        addSubview(bottomEdgeHighLight)
        addSubview(rightEdgeHighLight)
        
        addSubview(topEdgeControl)
        addSubview(leftEdgeControl)
        addSubview(bottomEdgeControl)
        addSubview(rightEdgeControl)
        
        addSubview(topLeftCornerControl)
        addSubview(topRightCornerControl)
        addSubview(bottomLeftCornerControl)
        addSubview(bottomRightCornerControl)
        
        addSubview(majorGridView)
        addSubview(minorGridView)
        
    }
    
    func setUpAction() {
        
        let didBegin: (MPCropControl)->Void = { [unowned self] (sender) in
            
            self.setGridMode(gridMode: .Major, isAnimate: true)
            
            if let didBegin = self.areaDidBeginEditing {
                didBegin()
            }
            
            //neu dang khoa ti le thi mac dinh cac highlight view da sang, khong can set nua
            if self.isLockAspectRatio {
                return
            }
            
            switch sender {
                
            case self.topEdgeControl:
                self.topEdgeHighLight.isHidden = false
                
            case self.leftEdgeControl:
                self.leftEdgeHighLight.isHidden = false
                
            case self.bottomEdgeControl:
                self.bottomEdgeHighLight.isHidden = false
                
            case self.rightEdgeControl:
                self.rightEdgeHighLight.isHidden = false
                
            default:
                break
            }
        }
        
        let didEnd: (MPCropControl)->Void = { [unowned self] (sender) in
            
            self.setGridMode(gridMode: .None, isAnimate: true)
            
            if let areaEndEditting = self.areaDidEndEditing {
                areaEndEditting()
            }
            
            //neu dang khoa ti le thi mac dinh cac highlight view da sang,khog duoc an
            if self.isLockAspectRatio {
                return
            }
            
            switch sender {
                
            case self.topEdgeControl:
                self.topEdgeHighLight.isHidden = true
                
            case self.leftEdgeControl:
                self.leftEdgeHighLight.isHidden = true
                
            case self.bottomEdgeControl:
                self.bottomEdgeHighLight.isHidden = true
                
            case self.rightEdgeControl:
                self.rightEdgeHighLight.isHidden = true
                
            default:
                break
            }
        }
        
        let didResize: (MPCropControl, CGPoint)->Void = { [unowned self] (cropControl, translation) in
            self.handleResizeWithSender(sender: cropControl, translation: translation)

            if let areaDidChange = self.areaDidChange {
                areaDidChange()
            }
        }
        
        for view in subviews {
            if let controlView = view as? MPCropControl {
                controlView.didBeginResize = didBegin
                controlView.didResize = didResize
                controlView.didEndResize = didEnd
            }
        }
    }
    
    func handleResizeWithSender(sender: MPCropControl, translation: CGPoint) {
        var newFrame = self.frame

        switch sender {
            //corners============================================================
        case topLeftCornerControl:
            newFrame = CGRect(x: newFrame.origin.x + translation.x,
                              y: newFrame.origin.y + translation.y,
                              width: frame.size.width - translation.x,
                              height: frame.size.height - translation.y)
            
            if self.isLockAspectRatio {
                //ti le duoc tinh theo chieu co delta lon hon
                var constrainFrame = (abs(translation.y) > abs(translation.x)) ? makeConstrainFrameFromHeightOf(rect: newFrame) : makeConstrainFrameFromWidthOf(rect: newFrame)
                
                //dieu chinh lai top-left cua frame
                constrainFrame.origin.x += newFrame.size.width - constrainFrame.size.width
                constrainFrame.origin.y += newFrame.size.height - constrainFrame.size.height
                
                newFrame = constrainFrame
            }
            
        case topRightCornerControl:
            newFrame = CGRect(x: newFrame.origin.x,
                              y: newFrame.origin.y + translation.y,
                              width: newFrame.size.width + translation.x,
                              height: newFrame.size.height - translation.y)
            
            if self.isLockAspectRatio {
                //ti le duoc tinh theo chieu co delta lon hon
                var constrainFrame = (abs(translation.y) > abs(translation.x)) ? makeConstrainFrameFromHeightOf(rect: newFrame) : makeConstrainFrameFromWidthOf(rect: newFrame)
                
                //dieu chinh lai top-origin cua frame
                constrainFrame.origin.y += newFrame.size.height - constrainFrame.size.height
                
                newFrame = constrainFrame
            }
            
        case bottomLeftCornerControl:
            newFrame = CGRect(x: newFrame.origin.x + translation.x,
                              y: newFrame.origin.y,
                              width: newFrame.size.width - translation.x,
                              height: newFrame.size.height + translation.y)
            
            if self.isLockAspectRatio {
                //ti le duoc tinh theo chieu co delta lon hon
                var constrainFrame = (abs(translation.y) > abs(translation.x)) ? makeConstrainFrameFromHeightOf(rect: newFrame) : makeConstrainFrameFromWidthOf(rect: newFrame)
                
                //dieu chinh lai left-origin cua frame
                constrainFrame.origin.x += newFrame.size.height - constrainFrame.size.height
                
                newFrame = constrainFrame
            }
            
        case bottomRightCornerControl:
            newFrame = CGRect(x: newFrame.origin.x,
                              y: newFrame.origin.y,
                              width: newFrame.size.width + translation.x,
                              height: newFrame.size.height + translation.y)
            
            if self.isLockAspectRatio {
                //ti le duoc tinh theo chieu co delta lon hon
                let constrainFrame = (abs(translation.y) > abs(translation.x)) ? makeConstrainFrameFromHeightOf(rect: newFrame) : makeConstrainFrameFromWidthOf(rect: newFrame)
                
                //khong can dieu chinh lai origin cua frame
                
                newFrame = constrainFrame
            }
            
            //edges============================================================
            case topEdgeControl:
            newFrame = CGRect(x: newFrame.origin.x,
                              y: newFrame.origin.y + translation.y,
                              width: newFrame.size.width,
                              height: newFrame.size.height - translation.y)
            
            if self.isLockAspectRatio {
                newFrame = makeConstrainFrameFromHeightOf(rect: newFrame)
            }
            
            case leftEdgeControl:
                newFrame = CGRect(x: newFrame.origin.x + translation.x,
                              y: newFrame.origin.y,
                              width: newFrame.size.width - translation.x,
                              height: newFrame.size.height)
            
            if self.isLockAspectRatio {
                newFrame = makeConstrainFrameFromWidthOf(rect: newFrame)
            }
            
            case bottomEdgeControl:
            newFrame = CGRect(x: newFrame.origin.x,
                              y: newFrame.origin.y,
                              width: newFrame.size.width,
                              height: newFrame.size.height + translation.y)
            
            if self.isLockAspectRatio {
                newFrame = makeConstrainFrameFromHeightOf(rect: newFrame)
            }
            
            case rightEdgeControl:
            newFrame = CGRect(x: newFrame.origin.x,
                              y: newFrame.origin.y,
                              width: newFrame.size.width + translation.x,
                              height: newFrame.size.height)
            
            if self.isLockAspectRatio {
                newFrame = makeConstrainFrameFromWidthOf(rect: newFrame)
            }
        default:
            break
        }
        
        //khong cho frame nho hon quy dinh
        if newFrame.width < MPCropRectMinimumSize {
            newFrame.size.width = MPCropRectMinimumSize
        }
        
        if newFrame.height < MPCropRectMinimumSize {
            newFrame.size.height = MPCropRectMinimumSize
        }
        
        //trong truong hop co dinh ti le w:h thi phai set lai tuy vao w, h hien tai
        if isLockAspectRatio {
            //xu ly o day
        }
        
        self.frame = newFrame
    }
    
    public func setGridMode(gridMode: GridMode, isAnimate: Bool) {
        guard currentGridMode != gridMode else {
            return
        }

        currentGridMode = gridMode
        
        switch gridMode {
        case .Major:
            majorGridView.setHidden(isHidden: false, isAnimate: isAnimate)
            minorGridView.setHidden(isHidden: true, isAnimate: isAnimate)
            
        case .Minor:
            majorGridView.setHidden(isHidden: true, isAnimate: isAnimate)
            minorGridView.setHidden(isHidden: false, isAnimate: isAnimate)
            
        default:
            majorGridView.setHidden(isHidden: true, isAnimate: isAnimate)
            minorGridView.setHidden(isHidden: true, isAnimate: isAnimate)
        }
    }
    
    public func lockAspectRatio(ratio: CGFloat) {
        isLockAspectRatio = true
        aspectRatio = ratio
        
        setHighLightEdge(toHidden: false)
    }
    
    public func unlockAspectRatio() {
        isLockAspectRatio = false
        setHighLightEdge(toHidden: true)
    }
    
    private func setHighLightEdge(toHidden isHidden:Bool) {
        self.topEdgeHighLight.isHidden = isHidden
        self.leftEdgeHighLight.isHidden = isHidden
        self.bottomEdgeHighLight.isHidden = isHidden
        self.rightEdgeHighLight.isHidden = isHidden
    }
    
    // MARK: overide method
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        if view is MPCropControl {
            return view
        }
        return nil
    }
    
    // MARK: internal utilities
    private func makeConstrainFrameFromWidthOf(rect: CGRect) -> CGRect {
        
        let width = rect.size.width
        let height = width / aspectRatio
        
        let origin = CGPoint(x: rect.origin.x, y: rect.origin.y)
        let size = CGSize(width: width, height: height)
        
        return CGRect(origin: origin, size: size)
    }
    
    private func makeConstrainFrameFromHeightOf(rect: CGRect) -> CGRect {
        
        let height = rect.size.height
        let width = height * aspectRatio
        
        let origin = CGPoint(x: rect.origin.x, y: rect.origin.y)
        let size = CGSize(width: width, height: height)
        
        return CGRect(origin: origin, size: size)
    }
}
