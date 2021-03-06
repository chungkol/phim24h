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
class TableWithPage: BaseDetailViewController {
    
    var data_key: String = ""
    var data_title: String!
    var list_Genre: [Genre]!
    var genre_id: Int = 0
    var datas: [Film] = []
    var temp: [Film] = []
    var type: Int = 0
    var page: Int = 1
    var position: SVPullToRefreshPosition!
    var checkPull = false
    var movie_id: Int! {
        didSet {
            getData(page)
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
        OEANotification.setDefaultViewController(self)
        myTable.register(UINib(nibName: "TableViewCellWithPage", bundle: nil), forCellReuseIdentifier: "TableCellWithPage")
        if type == 1 || type == 5 {
            addPullToRefresh()
        }
        self.title = data_title
        getData(page)
        
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
                if let uid = UserData.instance.user?.uid {
                    datas = try ManagerSQLite.shareInstance.getAllData(table_name: uid)
                }else {
                    OEANotification.notify("Notification", subTitle: "Haven't any film in your favorite", type: NotificationType.warning, isDismissable: true)
                }
                
            }
            catch
            {
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
            self.page = ManagerData.instance.page
            if self.page > 1 {
                self.pullToRefreshData(page: self.page - 1, position: .top)
            }else {
                return
            }
            }, position: .top)
        
        myTable.addPullToRefresh(actionHandler: {
            self.page = ManagerData.instance.page
            
            self.pullToRefreshData(page: self.page + 1, position: .bottom)
            }, position: .bottom)
    }
    func pullToRefreshData(page: Int, position: SVPullToRefreshPosition) {
        self.position = position
        self.page = page
        self.checkPull = true
        let popTime: DispatchTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
            self.myTable.beginUpdates()
            if self.datas.count >= 20 {
                if position == .bottom {
                    self.myTable.setContentOffset(CGPoint.zero, animated: true)
                }else {
                    self.myTable.scrollToRow(at: NSIndexPath(row: 19, section: 0) as IndexPath, at: .bottom, animated: true)
                }
            }
        })
    }
}
extension TableWithPage: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! TableViewCellWithPage).imageCell.kf.cancelDownloadTask()
//    }
    
    //bug o day
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (position == nil || checkPull == false)
        {
            return
        }
        if self.type == 1 {
            ManagerData.instance.getListMovieForPullToRefresh(page, type: self.data_key, completetion: { [unowned self] (films) in
                self.datas = films
                
                ManagerData.instance.page = self.page
                DispatchQueue.main.async {
                    self.myTable.endUpdates()
                    self.myTable.reloadData()
                }
                self.myTable.pullToRefreshView(at: self.position).stopAnimating()
                
                })
            return
        } else {
            ManagerData.instance.getAllMovieSimilar(page, movie_ID: self.movie_id, completetion: { [unowned self] (films) in
                self.datas = films
                
                ManagerData.instance.page = self.page
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                    self.myTable.endUpdates()
                }
                self.myTable.pullToRefreshView(at: self.position).stopAnimating()
                })
            
            
        }
        
        checkPull = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
}

extension TableWithPage: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellWithPage", for: indexPath) as! TableViewCellWithPage
        cell.selectionStyle = .none
        if let item: Film = datas[indexPath.row] {
            
            if let path = item.poster_path {
                let pathImage = "https://image.tmdb.org/t/p/original\(path)"
                super.loadImage(url_image: URL(string: pathImage), imageView: cell.imageCell, key: "\(item.id!)")
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

