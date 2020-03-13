//
//  AlbumsViewController.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/2/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit
import ReactiveSwift

class AlbumsViewController: UIViewController {
    
    var albums = [MPAssetCollectionProtocol]()
    
    var albumsTableView: AlbumsTableview!
    
    var focusIndex: MutableProperty<Int> = MutableProperty(0)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    func setUpUI() {
        view.backgroundColor = .yellow
        let tableView = AlbumsTableview(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        
        albumsTableView = tableView
        view.addSubview(tableView)
        tableView.reloadData()
    }
}

extension AlbumsViewController: AlbumsTableViewDatasource {
    
    func albumsFor(tableView: AlbumsTableview) -> [MPAssetCollectionProtocol]? {
        return albums
    }
    
    func focusIndexFor(tableview: AlbumsTableview) -> Int {
        return focusIndex.value
    }
}

extension AlbumsViewController: AlbumsTableViewDelegate {
    
    func didSelectRow(row: Int) {
        focusIndex.value = row
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
