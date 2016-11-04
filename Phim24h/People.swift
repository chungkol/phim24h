//
//  People.swift
//  Phim24h
//
//  Created by Chung on 9/30/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
class People: BaseDetailViewController {
    
    @IBOutlet weak var btnMoreCrew: UIButton!
    @IBOutlet weak var btnMoreCast: UIButton!
    @IBOutlet weak var collectionCast: UICollectionView!
    
    @IBOutlet weak var collectionCrew: UICollectionView!
    
    var list_Cast: [Cast] = []
    var list_Crew: [Crew] = []
    var movie_id: Int! {
        didSet {
            ManagerData.instance.getAllCast(movie_id, completetion: { [unowned self] (results) in
                self.list_Cast = results
                DispatchQueue.main.async {
                     self.collectionCast.reloadData()
                }
               
                })
            ManagerData.instance.getAllCrew(self.movie_id, completetion: { [unowned self] (results) in
                self.list_Crew = results
                DispatchQueue.main.async {
                    self.collectionCrew.reloadData()
                }
                })

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCast.delegate = self
        collectionCast.dataSource = self
        collectionCrew.delegate = self
        collectionCrew.dataSource = self
        collectionCrew.register(UINib(nibName: "CollectionViewPeople", bundle: nil), forCellWithReuseIdentifier: "CellForPeople")
        collectionCast.register(UINib(nibName: "CollectionViewPeople", bundle: nil), forCellWithReuseIdentifier: "CellForPeople")
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
}

extension People: UICollectionViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}



extension People: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if list_Cast.count >= 10 && collectionView.tag == 102 {
            return 10
        } else if list_Crew.count >= 10 && collectionView.tag == 101  {
            return 10
        }else {
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForPeople", for: indexPath) as! CollectionViewPeople
        
        if collectionView.tag == 102 {
            if let item: Cast = list_Cast[indexPath.row] {
                
                if let path = item.profile_path {
                    let pathImage = "https://image.tmdb.org/t/p/original\(path)"
                    super.loadImage(url_image: URL(string: pathImage), imageView: cell.imageCell, key: "\(item.id!)")
                }
                cell.lbChar.text = item.character
                cell.lbName.text = item.name
            }
            
        }
        else if collectionView.tag == 101 {
            if let item: Crew = list_Crew[indexPath.row] {
                if let path = item.profile_path {
                    let pathImage = "https://image.tmdb.org/t/p/original\(path)"
                   super.loadImage(url_image: URL(string: pathImage), imageView: cell.imageCell, key: "\(item.id!)")
                }
                cell.lbChar.text = item.department
                cell.lbName.text = item.name
            }
            
        }
        return cell
    }
}
