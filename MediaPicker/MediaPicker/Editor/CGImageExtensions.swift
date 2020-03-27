//
//  CGImageExtensions.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/26/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

extension CGImage {
    
    func transformedImage(_ transform: CGAffineTransform, imageOriginSize: CGSize, cropSize: CGSize, imageAdjustedSize: CGSize, zoomScale: CGFloat, translation: CGPoint, angle: CGFloat) -> CGImage? {
        
        guard var colorSpace = self.colorSpace else {
            return nil
        }
        
        if !colorSpace.supportsOutput {
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }
        
        //kich thuoc thuc su tren anh goc ma can crop
        let width = imageOriginSize.width / imageAdjustedSize.width * cropSize.width
        let height = imageOriginSize.height / imageAdjustedSize.height * cropSize.height
        let imageResultSize = CGSize(width: width, height: height)
        
        //so bits su dung cho moi kenh. vd RGB (32bit) se la 8 bits moi kenh
        let bitsPerComponent = self.bitsPerComponent
        //so bytes cho moi row bitmap, de 0 va de no tu dong tinh
        let bytesPerRow = 0
        
        //tao bitmap fraphic context
        var graphicContext = CGContext(data: nil,
                                       width: Int(imageResultSize.width),
                                       height: Int(imageResultSize.height),
                                       bitsPerComponent: bitsPerComponent,
                                       bytesPerRow: bytesPerRow,
                                       space: colorSpace,
                                       bitmapInfo: self.bitmapInfo.rawValue)
        
        if graphicContext == nil {
            graphicContext = CGContext(data: nil,
                                       width: Int(imageResultSize.width),
                                       height: Int(imageResultSize.height),
                                       bitsPerComponent: bitsPerComponent,
                                       bytesPerRow: bytesPerRow,
                                       space: colorSpace,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        }
        
        graphicContext?.setFillColor(UIColor.systemPink.cgColor)
        graphicContext?.fill(CGRect(x: 0, y: 0, width: imageResultSize.width, height: imageResultSize.height))
        
//        var combineTransform = CGAffineTransform(scaleX: imageResultSize.width / cropSize.width,
//                                                 y: imageResultSize.width / cropSize.width)
//        combineTransform = combineTransform.translatedBy(x: cropSize.width / 2, y: cropSize.height / 2)
//        combineTransform = combineTransform.scaledBy(x: 1, y: -1)
        
        var combineTransform = CGAffineTransform.identity
        let ratio = imageOriginSize.width / imageAdjustedSize.width
        let startCropRect = CGPoint(x: translation.x * ratio, y: translation.y * ratio)
        let y = imageResultSize.height - startCropRect.y - imageOriginSize.height
        combineTransform = combineTransform.translatedBy(x: startCropRect.x, y: y)
        combineTransform = combineTransform.scaledBy(x: 1, y: -1)
        
        let dx = (abs(translation.x) + imageResultSize.width / 2 - imageOriginSize.width / 2) * ratio
        let dy = (abs(translation.y) + imageResultSize.height / 2 - imageOriginSize.height / 2) * ratio
        
        //combineTransform = combineTransform.translatedBy(x: dx, y: dy)
        
        
        
        graphicContext?.concatenate(combineTransform)
        //graphicContext?.concatenate(transform)
        graphicContext?.translateBy(x: -imageResultSize.width / 2, y: -imageResultSize.height / 2)
        graphicContext?.rotate(by: angle)
        graphicContext?.translateBy(x: imageResultSize.width / 2, y: imageResultSize.height / 2)
        graphicContext?.scaleBy(x: 1, y: -1)
//        graphicContext?.draw(self, in: CGRect(x: -imageAdjustedSize.width / 2,
//                                              y: -imageAdjustedSize.height / 2,
//                                              width: imageAdjustedSize.width,
//                                              height: imageAdjustedSize.height))
        
        
//        let ratio = cropSize.width / imageAdjustedSize.width
//        let startCropRect = CGPoint(x: translation.x * ratio, y: translation.y * ratio)
//        let y = startCropRect.y + imageResultSize.height - imageOriginSize.height
//        graphicContext?.draw(self, in: CGRect(x: -startCropRect.x,
//                                              y: y,
//                                              width: imageOriginSize.width,
//                                              height: imageOriginSize.height))
        

        graphicContext?.draw(self, in: CGRect(x: 0,
                                              y: 0,
                                              width: imageOriginSize.width,
                                              height: imageOriginSize.height))
        return graphicContext?.makeImage()
    }
}
