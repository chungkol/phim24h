//
//  OverView.swift
//  Phim24h
//
//  Created by Chung on 9/30/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
class OverView: UIViewController {
    
    
    @IBOutlet weak var contentDetail: UILabel!
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    
    
    @IBOutlet weak var movie_release: UILabel!
    
    @IBOutlet weak var movie_runtime: UILabel!
    
    @IBOutlet weak var movie_budget: UILabel!
    
    @IBOutlet weak var movie_revenue: UILabel!
    
    var movie: MovieDetail!
    var movie_content : String!
    var datas: [Trailer] = []
    var imageDatas: [Backdrop] = []
    var heightScroll: CGFloat!
    var movie_id: Int! {
        didSet {
            ManagerData.instance.getAllVideoWithID(movie_id, completetion: { [unowned self] (trailers) in
                self.datas = trailers
                ManagerData.instance.getAllImageWithID(self.movie_id, completetion: { [unowned self] (backdrops) in
                    self.imageDatas = backdrops
                    self.myCollection.reloadData()
                    })
                
                })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentDetail.text = movie_content
        myCollection.dataSource = self
        myCollection.delegate = self
        myCollection.register(UINib(nibName: "CellForTrailer", bundle: nil), forCellWithReuseIdentifier: "CelTrailer")
        ManagerData.instance.getAllMovieDetail(movie_id, completetion: { [unowned self] (results) in
            self.movie = results
            self.movie_budget.text = "$ \(self.movie.budget!)"
            self.movie_release.text = "\(self.movie.release_date!)"
            self.movie_runtime.text = "\(self.movie.runtime!) minutes"
            self.movie_revenue.text = "\(self.movie.revenue!)"
            })
        
        
    }
    
    
}
extension OverView: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        //
    //        delegate.setData(film: datas[indexPath.row])
    //
    //    }
}

extension OverView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CelTrailer", for: indexPath) as! CellForTrailer
        
        cell.loading.startAnimating()
        
        if let path = imageDatas[indexPath.row].file_path {
            let pathImage = "https://image.tmdb.org/t/p/original\(path)"
            cell.imageCell.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
                cell.loading.isHidden = true
                cell.loading.stopAnimating()
            })
            
        }
        
        
        cell.labelCell.text = datas[indexPath.row].name
        
        
        
        return cell
        
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(datas[indexPath.row].key as AnyObject)
        let moviePlay = MoviePlayer(nibName: "MoviePlayer", bundle: nil)
        moviePlay.trailer = datas[indexPath.row]
        moviePlay.img_path = imageDatas[indexPath.row].file_path
        print("trailer \(datas[indexPath.row])")
        print("path \(imageDatas[indexPath.row].file_path)")
        self.navigationController?.pushViewController(moviePlay, animated: true)
        
    }
    
    
    
}
