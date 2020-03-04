//
//  ImageViewController.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/3/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import Photos
import ReactiveSwift

class ImageViewController: UIViewController {
    
    var asset: PHAsset!
    
    var cropRotationView: MPCropRotationView!
    
    var cropAreaView: MPCropAreaView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        //temp
        actionButton()
    }
    
    func setUpUI() {
        let imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .scaleAspectFit
        
        view.backgroundColor = .black
        
        MPPhotoLib.sharedInstance
            .fullResolutionImageDataFor(asset: asset)
            .observe(on: UIScheduler())
            .start(Signal<UIImage?, Never>.Observer(value: { (image) in
                imageView.image = image
            }, completed: {
                print("complete")
            }))
        view.addSubview(imageView)
        
        cropRotationView = MPCropRotationView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 200))
        cropRotationView.angleChanged = { angle in
            print("receive angle did change: \(angle)")
        }
        view.addSubview(cropRotationView)
        
        cropAreaView = MPCropAreaView(frame: CGRect(x:30, y: 300, width: view.frame.width - 60, height: 200))
        view.addSubview(cropAreaView)
    }

    func actionButton() {
        let resetButton = UIButton()
        resetButton.backgroundColor = .blue
        resetButton.frame = CGRect(x: view.frame.width/2 - 40, y: view.frame.height - 100, width: 80, height: 30)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        
        resetButton.addTarget(self, action: #selector(resetButtonDidClick), for: .touchUpInside)
        view.addSubview(resetButton)
    }
    
    @objc func resetButtonDidClick() {
        cropRotationView.setAngle(angle: 0, isAnimate: true)
    }
}
