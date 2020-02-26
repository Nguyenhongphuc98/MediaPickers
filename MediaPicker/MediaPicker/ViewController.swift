//
//  ViewController.swift
//  MediaPicker
//
//  Created by CPU11716 on 2/24/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import ReactiveSwift
import AsyncDisplayKit

class ViewController: UIViewController {
    
    var openButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpUI()
    }
    
    func setUpUI() {
        self.view.backgroundColor = .white
        
        openButton.setTitle("Open Media", for: UIControl.State.normal)
        openButton.backgroundColor = .gray
        openButton.frame = CGRect.init(origin: self.view.frame.origin, size: CGSize(width: 200, height: 50))
        openButton.layer.cornerRadius = 5
        openButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(openButton)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[openButton]-30-|", options: [], metrics: nil, views: ["openButton":openButton]))
        
        NSLayoutConstraint(	item: openButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true

        openButton.addTarget(self, action: #selector(openMediaButtonDidClick(sender:)), for: UIControl.Event.touchUpInside)

    }
    
    @objc func openMediaButtonDidClick(sender: UITapGestureRecognizer) {
        let pickerVC = PickerViewController()
        self.navigationController?.present(pickerVC, animated: true, completion: nil)
    } 
}

