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

class CropViewController: UIViewController {
    
    var asset: PHAsset!
    
    var cropRotationView: MPCropRotationView!
    
    var cropAreaView: MPCropAreaView!
    
    var cropView: MPCropView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        //temp
        actionButton()
    }
    
    func setUpUI() {
        
        view.backgroundColor = .black
 
        MPPhotoLib.sharedInstance
            .fullResolutionImageDataFor(asset: asset)
            .observe(on: UIScheduler())
            .start(Signal<UIImage?, Never>.Observer(value: { (image) in
                //imageView.image = image
                if let i = image {
                    let canvasInset = UIEdgeInsets(top: 100, left: 30, bottom: 100, right: 30)
                    self.cropView = MPCropView(frame: self.view.bounds, insets: canvasInset, image: i)
                    self.view.addSubview(self.cropView)
                }
                
            }, completed: {
                print("complete")
            }))
        
    }

    func actionButton() {
        
        let frameActionbar = view.frame.inset(by: UIEdgeInsets(top: view.frame.height - 100 , left: 30, bottom: 70, right: 30))
        let actionBar = UIStackView(frame: frameActionbar)
        actionBar.backgroundColor = .green
        actionBar.axis = .horizontal
        actionBar.distribution = .equalSpacing
        view.addSubview(actionBar)
        
        let resetButton = UIButton()
        resetButton.backgroundColor = .blue
      //  resetButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        resetButton.addTarget(self, action: #selector(resetButtonDidClick), for: .touchUpInside)
        
        let mirrorButton = UIButton()
        mirrorButton.backgroundColor = .blue
       // mirrorButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        mirrorButton.setTitle("Mirror", for: .normal)
        mirrorButton.layer.cornerRadius = 5
        mirrorButton.clipsToBounds = true
        mirrorButton.addTarget(self, action: #selector(mirrorButtonDidClick), for: .touchUpInside)
        
        let aspectButton = UIButton()
        aspectButton.backgroundColor = .blue
       // aspectButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        aspectButton.setTitle("Aspect", for: .normal)
        aspectButton.layer.cornerRadius = 5
        aspectButton.clipsToBounds = true
        aspectButton.addTarget(self, action: #selector(aspectButtonDidClick), for: .touchUpInside)
        
        actionBar.addArrangedSubview(resetButton)
        actionBar.addArrangedSubview(mirrorButton)
        actionBar.addArrangedSubview(aspectButton)
    }
    
    @objc func resetButtonDidClick() {
        cropView.resetToOrigin()
    }
    
    @objc func mirrorButtonDidClick() {
        cropView.mirrorContent()
    }
    
    @objc func aspectButtonDidClick() {
        cropView.lockCropArea(with: 1.0)
    }
}
