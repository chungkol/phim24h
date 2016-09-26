//
//  TableWithPage.swift
//  Phim24h
//
//  Created by Chung on 9/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher

class TableWithPage: UIViewController {
    
    var data_key: String!
    var data_title: String!
    var list_Genre: [Genre]!
    
    var datas: [Film] = []
    
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName: "TableViewCellWithPage", bundle: nil), forCellReuseIdentifier: "TableCellWithPage")
        self.title = data_title
        getData(page: 1)

        ManagerData.instance.getAllGenre(completetion: { [unowned self] (genres) in
            self.list_Genre = genres
            self.myTable.reloadData()

            })

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let myTable = self.myTable
//        {
//            myTable.delegate = self
//            myTable.dataSource = self
//            myTable.register(UINib(nibName: "TableViewCellWithPage", bundle: nil), forCellReuseIdentifier: "TableCellWithPage")
//            self.title = data_title
//            ManagerData.instance.getAllGenre(completetion: { [unowned self] (genres) in
//                self.list_Genre = genres
//                self.myTable.reloadData()
//                print(self.list_Genre)
//                })
//            getData(page: 1)
//        }
    }
    func getData(page: Int) {
        
        switch data_key {
        case ManagerData.POPULAR:
            ManagerData.instance.getPopular(page: page , type: ManagerData.POPULAR) {[unowned self] (films) in
                self.datas = films
            }
        case ManagerData.TOP_RATED:
            ManagerData.instance.getTopRated(page: page , type: ManagerData.POPULAR) {[unowned self] (films) in
                self.datas = films
            }
        case ManagerData.NOW_PLAYING:
            ManagerData.instance.getNowPlaying(page: page , type: ManagerData.POPULAR) {[unowned self] (films) in
                self.datas = films
            }
        case ManagerData.UPCOMING:
            ManagerData.instance.getUpComing(page: page , type: ManagerData.POPULAR) {[unowned self] (films) in
                self.datas = films
            }
            
        default: break
        }
        myTable.reloadData()
        print(datas.count)
        
    }
    
    func getNameOfGenre(genres: [Int]) -> String {
        var result: String!
        for item in self.list_Genre {
            for index in 0..<genres.count {
                if item.id == genres[index] {
                    result.append("\(item.name), ")
                    if( index == genres.count) {
                        result.append("\(item.name).")
                    }
                }
            }
        }
        return result
    }
    
    
    
    
}

extension TableWithPage: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
}

extension TableWithPage: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellWithPage", for: indexPath) as! TableViewCellWithPage
        
        cell.loading.startAnimating()
        let item: Film = datas[indexPath.row]
        let pathImage = "https://image.tmdb.org/t/p/original\(item.poster_path!)"
        
        cell.imageCell.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
            cell.loading.isHidden = true
            cell.loading.stopAnimating()
        })
        cell.titleCell.text = item.title
        cell.totalViewCell.text = String(item.popularity)
        cell.contentCell.text = item.overview
        
        
//        if let _ = list_Genre {
            print(" item \(indexPath.row) : \(item.genre_ids)")
//            if let type: String = self.getNameOfGenre(genres: item.genre_ids as! [Int]) {
//                cell.typeCell.text = type
//                print(type)
//            }
//        }
        
        
        
        
        return cell
        
    }
    
}
