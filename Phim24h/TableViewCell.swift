//
//  TableViewCell.swift
//  Phim24h
//
//  Created by Chung on 9/23/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
protocol pushViewDelegate {
    func setData(_ film: Film)
}
class TableViewCell: UITableViewCell {
    
    var delegate: pushViewDelegate!
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var titleCell: UILabel!
    
    @IBOutlet weak var collectionCell: UICollectionView!
    
    var datas: [Film] = []
    var title: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        collectionCell.delegate = self
        collectionCell.dataSource = self
        collectionCell.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        KingfisherManager.shared.downloader.downloadTimeout = 30
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func loadImage(url_image: URL?, imageView: UIImageView, key: String?) {
         imageView.image = UIImage(named: "haha")
        if KingfisherManager.shared.cache.isImageCached(forKey: key!).cached {
            KingfisherManager.shared.cache.retrieveImage(forKey: key!, options: nil) { (Image, CacheType) -> () in
                if Image != nil {
                    imageView.image = Image
                }else {
                    imageView.image = UIImage(named: "haha")
                }
            }
        }else {
            imageView.kf.indicatorType = .activity
            imageView.kf.indicator?.startAnimatingView()
                        self.downloadImage(url_image: url_image!, imageView: imageView, key: key! )
        }
        
    }
    
    func downloadImage(url_image: URL, imageView: UIImageView, key: String?) {
        imageView.image = UIImage()
        KingfisherManager.shared.downloader.downloadImage(with: url_image, options: [KingfisherOptionsInfoItem.cacheMemoryOnly], progressBlock: nil, completionHandler: { (image, error, url, data) -> () in
            
            if image != nil {
                if let resizeImage = (image?.kf.resize(to: CGSize(width: imageView.frame.size.width + 50, height: imageView.frame.size.height + 50)))
                {
                    print(key!)
                    KingfisherManager.shared.cache.store(resizeImage, forKey: key!)
                    imageView.image = resizeImage
                    imageView.kf.indicator?.stopAnimatingView()

                                    }
            }else {
                imageView.image = UIImage(named: "haha")
                imageView.kf.indicator?.stopAnimatingView()

            }
        })
    }
    
    
    
}
extension TableViewCell: UICollectionViewDelegate {
    
    //    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        (cell as! CollectionViewCell).imageCell.kf.cancelDownloadTask()
    //        DispatchQueue.main.async {
    //            //                        collectionView.reloadData()
    //        }
    //
    //
    //    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        delegate.setData(datas[indexPath.row])
        
    }
}

extension TableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        titleCell.text = title
        let item: Film = datas[indexPath.item]
        if let path = item.poster_path {
            let pathImage = "https://image.tmdb.org/t/p/original\(path)"
            loadImage(url_image: URL(string: pathImage), imageView: cell.imageCell, key: "\(item.id!)")
        }
        cell.nameCell.text = item.title
        return cell
        
    }
    
    
    
}
