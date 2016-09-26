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
    
    func seeMore(sender: AnyObject!) {
        switch titleCell.tag {
        case 100:
            print("Up Coming")
        case 101:
            print("Top Rated")
        case 102:
            print("Popular")
        case 103:
            print("Now Playing")
        default: break
        }
    }
}
extension TableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(datas[indexPath.row].title)
    }
}

extension TableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.loading.startAnimating()
        titleCell.setTitle(title, for: .normal)
        
        let item: Film = datas[(indexPath as NSIndexPath).row]
        
        let pathImage = "https://image.tmdb.org/t/p/original\(item.poster_path!)"
        
        cell.imageCell.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
            cell.loading.isHidden = true
            cell.loading.stopAnimating()
        })
        cell.nameCell.text = item.title
        return cell
        
    }
    
    
}
