//
//  TableWithPage.swift
//  Phim24h
//
//  Created by Chung on 9/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
import OEANotification
import HTPullToRefresh
class TableWithPage: UIViewController {
    
    var data_key: String!
    var data_title: String!
    var list_Genre: [Genre]!
    var genre_id: Int = 0
    var datas: [Film] = []
    var temp: [Film] = []
    var type: Int = 0
    var movie_id: Int! {
        didSet {
            getData(1)
        }
    }
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
        if type == 1 || type == 5 {
            addPullToRefresh()
        }
        self.title = data_title
        getData(1)
        
        ManagerData.instance.getAllGenre({ [unowned self] (genres) in
            self.list_Genre = genres
            DispatchQueue.main.async {
                self.myTable.reloadData()
            }
            })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func getData(_ page: Int ) {
        switch type {
        case 1:
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
        case 2:
            ManagerData.instance.getAllFilmWithGenre(genre_id) {[unowned self] (films) in
                self.datas = films
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
            }
        case 3:
            do
            {
                try ManagerSQLite.shareInstance.connectDatabase()
                datas = try ManagerSQLite.shareInstance.getAllFavorite(table_name: (UserData.instance.user?.uid)!)
            }
            catch
            {
                OEANotification.setDefaultViewController(self)
                OEANotification.notify("Notification", subTitle: "Haven't any film in your favorite", type: NotificationType.warning, isDismissable: true)            }
        case 4:
            datas = temp
            DispatchQueue.main.async {
                self.myTable.reloadData()
            }
        case 5:
            ManagerData.instance.getAllMovieSimilar(page, movie_ID: movie_id, completetion: {            [unowned self] (films) in
                self.datas = films
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
                
                })
            
        default:
            break
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
    func addPullToRefresh() {
        
        myTable.addPullToRefresh(actionHandler: {
            var page = ManagerData.instance.page
            if page! > 1 {
                self.pullToRefreshData(page: page! - 1, position: .top)
            }
            }, position: .top)
        
        myTable.addPullToRefresh(actionHandler: {
            var page = ManagerData.instance.page
            print(page)
            self.pullToRefreshData(page: page! + 1, position: .bottom)
            
            }, position: .bottom)
        
        
    }
    
    
    func pullToRefreshData(page: Int, position: SVPullToRefreshPosition) {
        
        
        let popTime: DispatchTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
            self.myTable.beginUpdates()
            if self.type == 1 {
                ManagerData.instance.getListMovieForPullToRefresh(page, type: self.data_key, completetion: { [unowned self] (films) in
                    self.datas = films
                    self.myTable.reloadData()
                    self.myTable.endUpdates()
                    self.myTable.pullToRefreshView(at: position).stopAnimating()
                    if position == .bottom {
                        self.myTable.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .top, animated: true)
                    }else {
                        self.myTable.scrollToRow(at: NSIndexPath(row: 19, section: 0) as IndexPath, at: .bottom, animated: true)
                    }
                    ManagerData.instance.page = page
                    print(page)
                    })
            } else {
                ManagerData.instance.getAllMovieSimilar(page, movie_ID: self.movie_id, completetion: { [unowned self] (films) in
                    self.datas = films
                    self.myTable.reloadData()
                    self.myTable.endUpdates()
                    self.myTable.pullToRefreshView(at: position).stopAnimating()
                    if position == .bottom {
                        self.myTable.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .top, animated: true)
                    }else {
                        self.myTable.scrollToRow(at: NSIndexPath(row: 19, section: 0) as IndexPath, at: .bottom, animated: true)
                    }
                    ManagerData.instance.page = page
                    print(page)
                    
                    
                    })
                
            }
            
            
        })
        
        
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
        let detaiMovie = DetailMovieVC(nibName: "DetailMovieVC", bundle: nil) as DetailMovieVC
        
        detaiMovie.film = datas[indexPath.row]
        self.navigationController?.pushViewController(detaiMovie, animated: true)
        
    }
    
}

