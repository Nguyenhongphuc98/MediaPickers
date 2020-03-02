//
//  CollectAssetTableview.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/2/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

protocol AlbumsTableViewDatasource {
    
    func albumsFor(tableView: AlbumsTableview) -> [MPAssetCollectionProtocol]?
    
    func focusIndexFor(tableview: AlbumsTableview) -> Int
}

protocol AlbumsTableViewDelegate {
    
    func didSelectRow(row: Int)
}

class AlbumsTableview: UIView {
    
    var dataSource: AlbumsTableViewDatasource!
    
    var delegate: AlbumsTableViewDelegate!
    
    var tableView: UITableView!
    
    var albums: [MPAssetCollectionProtocol]!
    
    var focusAlbumIndex = 0
    
    let itemHeight = 70

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    
    func setUpUI() {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        table.rowHeight = CGFloat(itemHeight)
        table.separatorStyle = .none
        
        table.dataSource = self
        table.delegate = self
        
        table.register(UINib(nibName: "CollectAssetCell", bundle: nil), forCellReuseIdentifier: "CollectCell")
        tableView = table
        addSubview(table)
    }
    
    func reloadData() {
        guard let dataSource = self.dataSource else {
            return
        }
        albums = dataSource.albumsFor(tableView: self)
        focusAlbumIndex = dataSource.focusIndexFor(tableview: self)
        tableView.reloadData()
    }
}

extension AlbumsTableview: UITableViewDelegate, UITableViewDataSource {
    
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectCell", for: indexPath) as! CollectAssetCell
        
        if focusAlbumIndex == indexPath.row {
            cell.accessoryType = .checkmark
        }
        cell.fillData(collect: albums[indexPath.row], size: itemHeight)
        return cell;
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //xu ly cai gi do o day neu can thiet
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let delegate = self.delegate else {
             return
        }
        delegate.didSelectRow(row: indexPath.row)
    }
}
