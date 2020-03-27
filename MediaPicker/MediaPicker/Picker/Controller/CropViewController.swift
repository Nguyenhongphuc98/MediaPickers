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
    
    var cropView: MPCropView!
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        let canvasInset = UIEdgeInsets(top: 100, left: 30, bottom: 100, right: 30)
        self.cropView = MPCropView(frame: self.view.bounds, insets: canvasInset, image: image)
        self.view.addSubview(self.cropView)

        actionButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cropView.isHidden = true
    }

    func actionButton() {
        
        let frameActionbar = view.frame.inset(by: UIEdgeInsets(top: view.frame.height - 100 , left: 30, bottom: 70, right: 30))
        let actionBar = UIStackView(frame: frameActionbar)
        actionBar.axis = .horizontal
        actionBar.distribution = .equalSpacing
        view.addSubview(actionBar)
        
        let resetButton = UIButton()
        resetButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        resetButton.addTarget(self, action: #selector(resetButtonDidClick), for: .touchUpInside)
        
        let mirrorButton = UIButton()
        mirrorButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        mirrorButton.setTitle("Mirror", for: .normal)
        mirrorButton.layer.cornerRadius = 5
        mirrorButton.clipsToBounds = true
        mirrorButton.addTarget(self, action: #selector(mirrorButtonDidClick), for: .touchUpInside)
        
        let rLeftButton = UIButton()
        rLeftButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        rLeftButton.setTitle("R-Left", for: .normal)
        rLeftButton.layer.cornerRadius = 5
        rLeftButton.clipsToBounds = true
        rLeftButton.addTarget(self, action: #selector(rLeftButtonDidClick), for: .touchUpInside)
        
        let aspectButton = UIButton()
        aspectButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        aspectButton.setTitle("Aspect", for: .normal)
        aspectButton.layer.cornerRadius = 5
        aspectButton.clipsToBounds = true
        aspectButton.addTarget(self, action: #selector(aspectButtonDidClick), for: .touchUpInside)
        
        let cropButton = UIButton()
        cropButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cropButton.setTitle("Crop", for: .normal)
        cropButton.layer.cornerRadius = 5
        cropButton.clipsToBounds = true
        cropButton.addTarget(self, action: #selector(cropButtonDidClick), for: .touchUpInside)
        
        actionBar.addArrangedSubview(resetButton)
        actionBar.addArrangedSubview(mirrorButton)
        actionBar.addArrangedSubview(rLeftButton)
        actionBar.addArrangedSubview(aspectButton)
        actionBar.addArrangedSubview(cropButton)
        
        
        vc.view.backgroundColor = .green
        uiView.frame = vc.view.frame.insetBy(dx: 30, dy: 30)
        uiView.contentMode = .scaleAspectFit
        uiView.center = vc.view.center
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: vc.view.frame.width, height: 40))
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .systemPink
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        vc.view.addSubview(uiView)
        vc.view.addSubview(closeButton)
    }
    
    @objc func resetButtonDidClick() {
        cropView.resetToOrigin()
    }
    
    @objc func mirrorButtonDidClick() {
        cropView.mirrorContent()
    }
    
    @objc func aspectButtonDidClick() {
        let alert = UIAlertController(title: "Aspect ratio", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "1:1", style: .default , handler:{ (UIAlertAction)in
            self.cropView.lockCropArea(with: 1)
        }))

        alert.addAction(UIAlertAction(title: "3:2", style: .default , handler:{ (UIAlertAction)in
            self.cropView.lockCropArea(with: 3 / 2)
        }))

        alert.addAction(UIAlertAction(title: "5:3", style: .default , handler:{ (UIAlertAction)in
            self.cropView.lockCropArea(with: 5 / 3)
        }))
        
        alert.addAction(UIAlertAction(title: "unlock ratio", style: .destructive , handler:{ (UIAlertAction)in
            self.cropView.unlockCropArea()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    @objc func rLeftButtonDidClick() {
        cropView.reotateLeft90Degrees(withAnimate: true)
    }
    
    let vc = UIViewController()
    let uiView = UIImageView()
    @objc func cropButtonDidClick() {
        
        let image = cropView.cropImageForCurentState()
        uiView.image = image
        
        present(vc, animated: true) {
        }
        
    }
    
    @objc func dismissVC() {
        vc.dismiss(animated: true) {  }
    }
}
