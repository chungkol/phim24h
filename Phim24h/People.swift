//
//  People.swift
//  Phim24h
//
//  Created by Chung on 9/30/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
class People: UIViewController {
    
    @IBOutlet weak var btnMoreCrew: UIButton!
    @IBOutlet weak var btnMoreCast: UIButton!
    @IBOutlet weak var collectionCast: UICollectionView!
    
    @IBOutlet weak var collectionCrew: UICollectionView!
    
    var list_Cast: [Cast] = []
    var list_Crew: [Crew] = []
    var movie_id: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCast.delegate = self
        collectionCast.dataSource = self
        collectionCrew.delegate = self
        collectionCrew.dataSource = self
        collectionCrew.register(UINib(nibName: "CollectionViewPeople", bundle: nil), forCellWithReuseIdentifier: "CellForPeople")
        collectionCast.register(UINib(nibName: "CollectionViewPeople", bundle: nil), forCellWithReuseIdentifier: "CellForPeople")
        ManagerData.instance.getAllCast(movie_id: movie_id, completetion: { [unowned self] (results) in
            self.list_Cast = results
            self.collectionCast.reloadData()
            ManagerData.instance.getAllCrew(movie_id: self.movie_id, completetion: { [unowned self] (results) in
                self.list_Crew = results
                self.collectionCrew.reloadData()
                })
            })
        
        
    }
    
    
}

extension People: UICollectionViewDelegate {
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 230
        }
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        print(self.view.bounds.size.width)
    //    }
    
    
}



extension People: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForPeople", for: indexPath) as! CollectionViewPeople
        
        //        if collectionView.tag == 100 {
        //            if let item: Cast = list_Cast[indexPath.row] {
        //                cell.loading.startAnimating()
        //                if let path = item.profile_path {
        //                    let pathImage = "https://image.tmdb.org/t/p/original\(path)"
        //                    cell.imageCell.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
        //                        cell.loading.isHidden = true
        //                        cell.loading.stopAnimating()
        //                    })
        //                }
        //                cell.lbChar.text = item.character
        //                cell.lbName.text = item.name
        //            }
        //
        //        }
        //
        //        if collectionView.tag == 101 {
        //            if let item: Crew = list_Crew[indexPath.row] {
        //                cell.loading.startAnimating()
        //                if let path = item.profile_path {
        //                    let pathImage = "https://image.tmdb.org/t/p/original\(path)"
        //                    cell.imageCell.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
        //                        cell.loading.isHidden = true
        //                        cell.loading.stopAnimating()
        //                    })
        //                }
        //                cell.lbChar.text = item.department
        //                cell.lbName.text = item.name
        //            }
        //            
        //        }
        return cell
    }
}
