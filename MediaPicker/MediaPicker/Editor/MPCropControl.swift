//
//  MPCropControl.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/4/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

class MPCropControl: UIControl {
    
    public var didBeginResize: ((_ sender: MPCropControl) -> ())?

    public var didResize: ((_ sender: MPCropControl, _ translation: CGPoint)->())?
    
    public var didEndResize: ((_ sender: MPCropControl) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    func setUpUI() {
        backgroundColor = .clear
        isExclusiveTouch = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPan(gesture:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(userDidPress(gesture:)))
        pressGesture.minimumPressDuration = 0.1
        pressGesture.delegate = self
        addGestureRecognizer(pressGesture)
    }
    
    @objc func userDidPan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            if let didBegin = self.didBeginResize {
                didBegin(self)
            }
            
        case .changed:
            let translation = gesture.translation(in: superview)
            
            if let didResize = self.didResize {
                didResize(self, translation)
            }
            
            gesture.setTranslation(CGPoint.zero, in: superview)
            print("change pan")
            
        case .ended, .cancelled:
            if let didEnd = self.didEndResize {
                didEnd(self)
            }
            
        default:
            break;
        }
    }
    
    @objc func userDidPress(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("began press")
            if let didBegin = self.didBeginResize {
                didBegin(self)
            }
            
        case .ended, .cancelled:
            print("ended press")
            if let didEnd = self.didEndResize {
                didEnd(self)
            }
            
        default:
            break;
        }
    }
}

// MARK: recognize delegate
extension MPCropControl: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
