//
//  Similar.swift
//  Phim24h
//
//  Created by Chung on 9/30/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
class Similar: UIViewController {
    
    
    @IBOutlet weak var myTable: UITableView!
    var datas: [Film] = []
    var movie_id: Int!
    var list_Genre: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName: "TableViewCellWithPage", bundle: nil), forCellReuseIdentifier: "TableCellWithPage")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if movie_id != nil {
            ManagerData.instance.getAllMovieSimilar(page: 1, movie_ID: movie_id, completetion: {            [unowned self] (films) in
                self.datas = films
                self.myTable.reloadData()
                
                })
            ManagerData.instance.getAllGenre(completetion: { [unowned self] (genres) in
                self.list_Genre = genres
                self.myTable.reloadData()
                
                })
            

        }
    }
    func getNameOfGenre(genres: [Int]) -> String {
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
extension Similar: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
}

extension Similar: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datas.count >= 10 {
            return 10
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellWithPage", for: indexPath) as! TableViewCellWithPage
        cell.backgroundColor = UIColor.black
        cell.bgCell.backgroundColor = UIColor.black
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
            
            cell.titleCell.textColor = UIColor.white
            cell.totalViewCell.textColor = UIColor.white
            cell.contentCell.textColor = UIColor.white
            cell.typeCell.textColor = UIColor.white
            cell.imPlay.image = UIImage(named: "play_w")
            cell.imType.image = UIImage(named: "type_film_w")
            if list_Genre.count > 0 {
                if let type: String = self.getNameOfGenre(genres: item.genre_ids as! [Int]) {
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
