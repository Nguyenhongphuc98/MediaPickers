//
//  FetchOption.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/25/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import Photos

extension PHFetchOptions {
    func merge(predicate: NSPredicate) {
        if let storePredicate = self.predicate {
            self.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [storePredicate, predicate])
        }else {
            self.predicate = predicate
        }
    }
}
