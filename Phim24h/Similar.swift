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
    var tableDetail: TableWithPage!
    var movie_id: Int! {
        didSet {
            tableDetail.type = 5
            tableDetail.movie_id = movie_id
            tableDetail.addPullToRefresh()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addTable()
        
    }
    func addTable() {
        if tableDetail == nil {
            tableDetail = TableWithPage(nibName: "TableWithPage", bundle: nil)
            
            tableDetail.willMove(toParentViewController: self)
            
            self.view.addSubview(tableDetail.view)
            self.addChildViewController(tableDetail)
            tableDetail.didMove(toParentViewController: self)
            
            tableDetail.view.translatesAutoresizingMaskIntoConstraints = false
            
            let layoutTop = NSLayoutConstraint(item: tableDetail.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
            
            let layoutBot = NSLayoutConstraint(item: tableDetail.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            let layoutRight = NSLayoutConstraint(item: tableDetail.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            
            let layoutLeft = NSLayoutConstraint(item: tableDetail.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutBot, layoutRight])
        }
        
        
    }
    
    
    
    //    @IBOutlet weak var myTable: UITableView!
    //    var datas: [Film] = []
    //
    //    var list_Genre: [Genre] = []
    //
    //    var movie_id: Int! {
    //        didSet {
    //            ManagerData.instance.getAllMovieSimilar(1, movie_ID: movie_id, completetion: {            [unowned self] (films) in
    //                self.datas = films
    //                self.myTable.reloadData()
    //
    //                })
    //            ManagerData.instance.getAllGenre({ [unowned self] (genres) in
    //                self.list_Genre = genres
    //                self.myTable.reloadData()
    //
    //                })
    //
    //        }
    //    }
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        myTable.delegate = self
    //        myTable.dataSource = self
    //        myTable.register(UINib(nibName: "TableViewCellWithPage", bundle: nil), forCellReuseIdentifier: "TableCellWithPage")
    //
    //    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //    }
    //    func getNameOfGenre(_ genres: [Int]) -> String {
    //        var result: String = ""
    //        for item in self.list_Genre {
    //            for index in 0..<genres.count {
    //                if item.id == genres[index] {
    //
    //                    result.append("\(item.name!), ")
    //                }
    //            }
    //        }
    //        return result
    //    }
    //
    
}
//extension Similar: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
//
//
//}
//
//extension Similar: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if datas.count >= 10 {
//            return 10
//        }
//        return 0
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellWithPage", for: indexPath) as! TableViewCellWithPage
//
//        if let item: Film = datas[indexPath.row] {
//            cell.loading.startAnimating()
//            cell.titleCell.text = item.title
//            cell.totalViewCell.text = String(item.popularity!)
//            cell.contentCell.text = item.overview
//            if let path = item.poster_path {
//                let pathImage = "https://image.tmdb.org/t/p/original\(path)"
//                cell.imageCell.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
//                    cell.loading.isHidden = true
//                    cell.loading.stopAnimating()
//                })
//            }
//
//
//            if list_Genre.count > 0 {
//                if let type: String = self.getNameOfGenre(item.genre_ids as! [Int]) {
//                    cell.typeCell.text = type
//                }
//            }
//
//        }
//        return cell
//
//    }
//    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let detaiMovie = DetailMovieVC(nibName: "DetailMovieVC", bundle: nil) as DetailMovieVC
//
//        detaiMovie.film = datas[indexPath.row]
//        self.navigationController?.pushViewController(detaiMovie, animated: true)
//
//    }
//
//}
