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
    var genre_id: Int = 0
    
    var datas: [Film] = []
    
    @IBOutlet weak var myTable: UITableView!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "TableWithPage", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName: "TableViewCellWithPage", bundle: nil), forCellReuseIdentifier: "TableCellWithPage")
        self.title = data_title
        getData(1)
        
        ManagerData.instance.getAllGenre({ [unowned self] (genres) in
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
    func getData(_ page: Int ) {
        if genre_id == 0 {
            switch self.data_key {
            case ManagerData.POPULAR:
                ManagerData.instance.getPopular(page , type: ManagerData.POPULAR) {[unowned self] (films) in
                    self.datas = films
                    
                }
            case ManagerData.TOP_RATED:
                ManagerData.instance.getTopRated(page , type: ManagerData.POPULAR) {[unowned self] (films) in
                    self.datas = films
                }
            case ManagerData.NOW_PLAYING:
                ManagerData.instance.getNowPlaying(page , type: ManagerData.POPULAR) {[unowned self] (films) in
                    self.datas = films
                }
            case ManagerData.UPCOMING:
                ManagerData.instance.getUpComing(page , type: ManagerData.POPULAR) {[unowned self] (films) in
                    self.datas = films
                }
                
            default: break
            }
            myTable.reloadData()
        }else{
            ManagerData.instance.getAllFilmWithGenre(genre_id) {[unowned self] (films) in
                self.datas = films
                self.myTable.reloadData()
            }
        }
        
        
        
        
        
    }
    
    func getNameOfGenre(_ genres: [Int]) -> String {
        var result: String = ""
        for item in self.list_Genre {
            for index in 0..<genres.count {
                if item.id == genres[index] {
                    
                    result.append("\(item.name!), ")
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
        return datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellWithPage", for: indexPath) as! TableViewCellWithPage
        
        if let item: Film = datas[indexPath.row] {
            cell.loading.startAnimating()
            
            if let path = item.poster_path {
                let pathImage = "https://image.tmdb.org/t/p/original\(path)"
                cell.imageCell.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
                    cell.loading.isHidden = true
                    cell.loading.stopAnimating()
                })
            }
           
            cell.titleCell.text = item.title
            cell.totalViewCell.text = String(item.popularity!)
            cell.contentCell.text = item.overview
            
            
            if let _ = list_Genre {
                if let type: String = self.getNameOfGenre(item.genre_ids as! [Int]) {
                    cell.typeCell.text = type
                }
            }
        }
        return cell
        
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detaiMovie = DetailMovieViewController(nibName: "DetailMovieViewController", bundle: nil) as DetailMovieViewController
        
        detaiMovie.film = datas[indexPath.row]
        self.navigationController?.pushViewController(detaiMovie, animated: true)
        
    }
    
}
