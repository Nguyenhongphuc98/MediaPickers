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
    
    var collectionName: String { get }
    
    var numberOfAssets: Int { get }
    
    func assetAt(index: Int) -> PHAsset
}

//chứa asetcollection và fetch result của collection nay
class MPAssetCollection: NSObject {

    var assetCollection: PHAssetCollection? = nil
    
    var fetchResult: PHFetchResult<PHAsset>? = nil
    
    init(assetCollection: PHAssetCollection) {
        self.assetCollection = assetCollection
        fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
    }
    
    func isEqual(_ object: MPAssetCollection) -> Bool {
        return  collectionName == object.collectionName
    }
}

extension MPAssetCollection: MPAssetCollectionProtocol {
    
    var collectionName: String {
        if let title = assetCollection?.localizedTitle {
            return title
        }
        
        return "Other"
    }
    
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
