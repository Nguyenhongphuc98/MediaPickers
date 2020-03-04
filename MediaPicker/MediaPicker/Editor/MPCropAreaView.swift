//
//  MPCropAreaView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/4/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

let MPCropCornerControlSize: CGFloat = 44

class MPCropAreaView: UIControl {

    public var areaDidChanged: (()->())?
    
    //control============================================
    var topEdgeControl: MPCropControl!
    
    var leftEdgeControl: MPCropControl!
    
    var bottomEdgeControl: MPCropControl!
    
    var rightEdgeControl: MPCropControl!
    
    var topLeftCornerControl: MPCropControl!
    
    var topRightCornerControl: MPCropControl!
    
    var bottomLeftCornerControl: MPCropControl!
    
    var bottomRightCornerControl: MPCropControl!
    
    //view highlight control============================================
    var cornersView: UIImageView?
    
    var topEdgeHighLight: UIView!
    
    var leftEdgeHighLight: UIView!
    
    var bottomEdgeHighLight: UIView!
    
    var rightEdgeHighLight: UIView!
    
    override init(frame: CGRect) {
        
        topEdgeHighLight = UIView(frame: CGRect(x: 0, y: -1, width: frame.size.width, height: 2))
        topEdgeHighLight.autoresizingMask = .flexibleWidth
        topEdgeHighLight.backgroundColor = .white
        topEdgeHighLight.isHidden = true
        
        leftEdgeHighLight = UIView(frame: CGRect(x: -1, y: 0, width: 2, height: frame.size.height))
        leftEdgeHighLight.autoresizingMask = .flexibleHeight
        leftEdgeHighLight.backgroundColor = .white
        leftEdgeHighLight.isHidden = true
        
        rightEdgeHighLight = UIView(frame: CGRect(x: frame.size.width - 1, y: 0, width: 2, height: frame.size.height))
        rightEdgeHighLight.autoresizingMask = .flexibleHeight
        rightEdgeHighLight.backgroundColor = .white
        rightEdgeHighLight.isHidden = true
        
        bottomEdgeHighLight = UIView(frame: CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 2))
        bottomEdgeHighLight.autoresizingMask = .flexibleWidth
        bottomEdgeHighLight.backgroundColor = .white
        bottomEdgeHighLight.isHidden = true
        
        
        topEdgeControl = MPCropControl(frame: CGRect(x: MPCropCornerControlSize / 2, y: -MPCropCornerControlSize / 2, width: frame.size.width - MPCropCornerControlSize, height: MPCropCornerControlSize))
        topEdgeControl.autoresizingMask = .flexibleWidth
        
        leftEdgeControl = MPCropControl(frame: CGRect(x: -MPCropCornerControlSize / 2, y: MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: frame.size.height - MPCropCornerControlSize))
        leftEdgeControl.autoresizingMask = .flexibleHeight
        
        bottomEdgeControl = MPCropControl(frame: CGRect(x: MPCropCornerControlSize / 2, y: frame.size.height - MPCropCornerControlSize / 2, width: frame.size.width - MPCropCornerControlSize, height: MPCropCornerControlSize))
        bottomEdgeControl.autoresizingMask = .flexibleWidth
        
        rightEdgeControl = MPCropControl(frame: CGRect(x: frame.size.width - MPCropCornerControlSize / 2, y: MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: frame.size.height - MPCropCornerControlSize))
        rightEdgeControl.autoresizingMask = .flexibleWidth
        
        
        topLeftCornerControl = MPCropControl(frame: CGRect(x: -MPCropCornerControlSize / 2, y: -MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        
        topRightCornerControl = MPCropControl(frame: CGRect(x: frame.size.width - MPCropCornerControlSize / 2, y: -MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        topRightCornerControl.autoresizingMask = .flexibleLeftMargin
        
        bottomLeftCornerControl = MPCropControl(frame: CGRect(x: -MPCropCornerControlSize / 2, y: frame.size.height - MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        bottomLeftCornerControl.autoresizingMask = .flexibleTopMargin
        
        bottomRightCornerControl = MPCropControl(frame: CGRect(x: frame.size.width - MPCropCornerControlSize / 2, y: frame.size.height - MPCropCornerControlSize / 2, width: MPCropCornerControlSize, height: MPCropCornerControlSize))
        bottomLeftCornerControl.autoresizingMask = .flexibleTopMargin
        
        super.init(frame: frame)
        setUpUI()
        setUpAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assert(false, "chua implement init with coder")
    }
 
    func setUpUI() {
        cornersView = UIImageView(frame: bounds.insetBy(dx: -2, dy: -2))
        cornersView?.image = #imageLiteral(resourceName: "PhotoEditorCropCorners")
        cornersView?.image = cornersView?.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
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
    }
    
    func setUpAction() {
        
    }
}
