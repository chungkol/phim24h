//
//  TableViewCell.swift
//  Phim24h
//
//  Created by Chung on 9/23/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleCell: UIButton!
    
    @IBOutlet weak var collectionCell: UICollectionView!
    
    var datas: [Film] = []
    var title: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionCell.delegate = self
        collectionCell.dataSource = self
        collectionCell.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionCell.reloadData()
        
        
        collectionCell.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension TableViewCell: UICollectionViewDelegate {
    
}

extension TableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        titleCell.setTitle(title, for: .normal)
        
        let item: Film = datas[(indexPath as NSIndexPath).row]
        
        let pathImage = "https://image.tmdb.org/t/p/original\(item.poster_path!)"
        
        cell.imageCell.kf.setImage(with: URL(string: pathImage))
        cell.nameCell.text = item.title
        return cell
        
    }
    
}
