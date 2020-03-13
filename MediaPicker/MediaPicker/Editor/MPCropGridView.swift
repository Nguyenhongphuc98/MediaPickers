//
//  MPCropGridView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/11/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

//raw value cung bang so cot/dong duoc chia
enum GridMode: Int {
    case None = 0
    case Major = 3
    case Minor = 9
}

class MPCropGridView: UIView {

    var mode: GridMode = .None
    
    var lineColor: UIColor = .white
    
    let thickness: CGFloat = 1.0
    
    var isHiding: Bool = false
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    init(mode: GridMode, frame: CGRect) {
        self.mode = mode
        
        if mode == .Minor {
            lineColor = UIColor(displayP3Red: 238, green: 238, blue: 238, alpha: 0.8)
        }
        
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = false
    }
    
    public func setFrame(frame: CGRect) {
        super.frame = frame
        
        if !isHidden {
            //notify to system can ve lai content trong drawing cycle tiep theo
            setNeedsDisplay()
        }
    }

    public func setHidden(isHidden: Bool, isAnimate: Bool) {
        //neu dang animate thi thoi
        guard !isHiding else {
            return
        }
        
        if isAnimate{
            isHiding = true
            super.isHidden = false
            
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.alpha = isHidden ? 0 : 1
            }) { (finished) in
                if finished {
                    super.isHidden = isHidden
                    self.isHiding = false
                }
            }
        } else {
            super.isHidden = isHidden
            self.alpha = isHidden ? 0 : 1
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        lineColor.setFill()
        
        let width = rect.size.width
        let height = rect.size.height
        
        let horizontalSpace = Int(width) / mode.rawValue
        let verticalSpace = Int(height) / mode.rawValue
        
        for index in 1..<mode.rawValue {
            //ve thanh ke doc
            UIRectFill(CGRect(x: CGFloat(horizontalSpace * index), y: 0.0, width: thickness, height: height))
            //ve thanh ke ngang
            UIRectFill(CGRect(x: 0.0, y: CGFloat(verticalSpace * index), width: width, height: thickness))
        }
    }
}
