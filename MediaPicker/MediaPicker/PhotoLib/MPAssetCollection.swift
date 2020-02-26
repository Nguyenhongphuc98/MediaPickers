//
//  MPAssetCollection.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/26/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import Photos

protocol MPAssetCollectionProtocol {
    
    var numberOfAssets: Int { get }
    
    func assetAt(index: Int) -> PHAsset
}

//chứa asetcollection và fetch result của collection nay
class MPAssetCollection: NSObject {

    var assetCollection: PHAssetCollection? = nil
    
    var fetchResult: PHFetchResult<PHAsset>? = nil
    
    init(assetCollection: PHAssetCollection) {
        fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
    }
}

extension MPAssetCollection: MPAssetCollectionProtocol {
    
    var numberOfAssets: Int {
           guard let count = self.fetchResult?.count else {
               return 0;
           }
           
           return count;
       }
    
    func assetAt(index: Int) -> PHAsset {
        guard let result = self.fetchResult else {
            return PHAsset()
        }
        
        assert(index >= 0 && index <= result.count, "[assetAt]: index out of bound")
        
        return result.object(at: index)
    }
}
