//
//  HomeViewController.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class HomeViewController: BaseViewController, pushViewDelegate  {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    var headerView: UIView!
    
    var pageSilde: UIPageControl!
    
    var first = false
    var currentPage = 0
    
    var datas: [DataModel] = []
    
    var dataForSlide: [Film] = []
    var photo: [UIImageView] = []
    
    
    var frontScrollViews: [UIScrollView] = []
    
    var timer = Timer()
    
    var iCa: iCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addIcarousel()
        myTable.contentInset = UIEdgeInsetsMake(-33, 0, 0, 0)
        
        myTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        initData()
        
    }
    override func viewWillLayoutSubviews() {
        
        
    }
    
    
    
    
    func addIcarousel(){
        if headerView == nil {
            headerView = UIView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height:(self.view.bounds.size.width * 0.6) + 25))
            headerView.backgroundColor = UIColor.gray
        }
        if iCa == nil {
            iCa = iCarousel(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height: (self.view.bounds.size.width * 0.6)))
            iCa.type = .coverFlow2
            iCa.dataSource = self
            iCa.delegate = self
            headerView.addSubview(iCa)
            
            iCa.translatesAutoresizingMaskIntoConstraints = false
            
            let layouTop = NSLayoutConstraint(item: iCa, attribute: .top, relatedBy: .equal, toItem: self.headerView, attribute: .top, multiplier: 1.0, constant: 0)
            
            let layoutBot = NSLayoutConstraint(item: iCa, attribute: .bottom, relatedBy: .equal, toItem: self.headerView, attribute: .bottom, multiplier: 1.0, constant: -25)
            
            
            let layoutRight = NSLayoutConstraint(item: iCa, attribute: .trailing, relatedBy: .equal, toItem: self.headerView, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            
            let layoutLeft = NSLayoutConstraint(item: iCa, attribute: .leading, relatedBy: .equal, toItem: self.headerView, attribute: .leading, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layouTop, layoutBot, layoutLeft, layoutRight])
            
        }
        if pageSilde == nil {
            
            pageSilde = UIPageControl(frame: CGRect(x:0, y: 0, width: 100, height: 25))
            pageSilde.currentPage = currentPage
            pageSilde.numberOfPages = 10
            pageSilde.backgroundColor = UIColor.red
            let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.pageChange(_:)))
            
            tap.numberOfTapsRequired = 1
            self.pageSilde.backgroundColor = UIColor.clear
            
            pageSilde.addGestureRecognizer(tap)
            headerView.addSubview(pageSilde)
            
            pageSilde.currentPageIndicatorTintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            
            self.pageSilde.translatesAutoresizingMaskIntoConstraints = false
            
            let layouTop = NSLayoutConstraint(item: pageSilde, attribute: .top, relatedBy: .equal, toItem: self.iCa, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            
            let horizontalConstraint = NSLayoutConstraint(item: pageSilde, attribute: .centerX, relatedBy: .equal, toItem: self.headerView, attribute: .centerX, multiplier: 1, constant: 0)
            
            let heightContraint = NSLayoutConstraint(item: pageSilde, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
            
            let widthContraint = NSLayoutConstraint(item: pageSilde, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
            
            NSLayoutConstraint.activate([layouTop, horizontalConstraint, widthContraint, heightContraint])
        }
        
    }
    
    
    
    
    func initData(){
        ManagerData.instance.getUpComing(page: 1 , type: ManagerData.UPCOMING) {[unowned self] (films) in
            self.datas.append(DataModel(title: "Up Coming", key: ManagerData.UPCOMING, datas: films as [Film]))
            
            ManagerData.instance.getTopRated(page: 1 , type: ManagerData.TOP_RATED) {[unowned self] (films) in
                self.datas.append(DataModel(title: "Top Rated", key: ManagerData.TOP_RATED, datas: films as [Film]))
                
                
                ManagerData.instance.getPopular(page: 1 , type: ManagerData.POPULAR) {[unowned self] (films) in
                    self.datas.append(DataModel(title: "Popular", key: ManagerData.POPULAR, datas: films as [Film]))
                    
                    ManagerData.instance.getNowPlaying(page: 1 , type: ManagerData.NOW_PLAYING) {[unowned self] (films) in
                        
                        self.dataForSlide = films
                        
                        self.datas.append(DataModel(title: "Now Playing", key: ManagerData.NOW_PLAYING, datas: films as [Film]))
                        
                        self.iCa.reloadData()
                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.updateSlide(_:)), userInfo: nil, repeats: true)
                        RunLoop.main.add(self.timer, forMode: .commonModes)
                        self.myTable.delegate = self
                        self.myTable.dataSource = self
                        self.myTable.reloadData()
                        ManagerData.instance.getAllGenre(completetion: { [unowned self] (genres) in
                            })
                        
                    }
                    
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setTitForView("Phim24h")
    }
    
    
    
    func updateSlide(_ sender: AnyObject){
        var current = iCa.currentItemIndex
        current = current + 1
        if current < 10 {
            iCa.scrollToItem(at: current, animated: true)
            
        }
        else{
            current = 0
            iCa.scrollToItem(at: current, animated: true)
        }
        pageSilde.currentPage = current
        
    }
    func pageChange(_ sender: AnyObject) {
        var current = iCa.currentItemIndex
        current = current + 1
        if current < 10 {
            iCa.scrollToItem(at: current, animated: true)
            
        }
        else{
            current = 0
            iCa.scrollToItem(at: current, animated: true)
        }
        pageSilde.currentPage = current
    }
    func seeMore(_ sender: UIButton!) {
        switch sender.tag {
        case 100:
            print("Up Coming")
            goToTableWithPage(key: ManagerData.UPCOMING, titleCell: "Up Coming")
        case 101:
            print("Top Rated")
            goToTableWithPage(key: ManagerData.TOP_RATED, titleCell: "Top Rated")
            
        case 102:
            print("Popular")
            goToTableWithPage(key: ManagerData.POPULAR, titleCell: "Popular")
            
        case 103:
            print("Now Playing")
            goToTableWithPage(key: ManagerData.NOW_PLAYING, titleCell: "Now Playing")
            
        default: break
        }
    }
    
    func  goToTableWithPage(key: String, titleCell: String) {
        let tableWithpage = TableWithPage(nibName: "TableWithPage", bundle: nil)
        tableWithpage.data_key = key
        tableWithpage.data_title = titleCell
        self.navigationController?.pushViewController(tableWithpage, animated: true)
        
    }
    
}



extension HomeViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(self.view.bounds.size.width)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print(self.view.bounds.size.width)
        return (self.view.bounds.size.width * 0.6) + 25
    }
    
}



extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        let dataModel: DataModel = datas[indexPath.row]
        
        
        if let myData = dataModel.datas
        {
            cell.btnMore.addTarget(self, action: #selector(HomeViewController.seeMore(_:)), for: .touchUpInside)
            cell.btnMore.tag = 100 + indexPath.row
            cell.datas = myData
            cell.title = dataModel.title
            cell.selectionStyle = .none
        }
        
        return cell
        
    }
    
    func setData(film: Film) {
        let detaiMovie = DetailMovieViewController(nibName: "DetailMovieViewController", bundle: nil) as DetailMovieViewController
        detaiMovie.film = film
        self.navigationController?.pushViewController(detaiMovie, animated: true)
    }
}
extension HomeViewController: iCarouselDelegate{
    
}

extension HomeViewController: iCarouselDataSource{
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        pageSilde.currentPage = carousel.currentItemIndex
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 10
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var subView: FXImageView!
        var loading: UIActivityIndicatorView!
        
        
        subView = FXImageView(frame: CGRect(x: 0, y: 0, width: self.headerView.bounds.width - 50, height: self.headerView.bounds.height - 50))
        subView.contentMode = .scaleAspectFill
        subView.isAsynchronous = true
        subView.reflectionScale = 0.5
        //        subView.reflectionAlpha = 0.25
        subView.reflectionGap = 10.0
        subView.shadowOffset = CGSize(width: 0.0, height: 2.0)
        subView.shadowBlur = 5.0;
        subView.cornerRadius = 10.0;
        
        
        loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        loading.color = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
        
        subView.addSubview(loading)
        loading.startAnimating()
        
        
        //add constraints
        
        let verticalConstraint = NSLayoutConstraint(item: loading, attribute: .centerY, relatedBy: .equal, toItem: subView, attribute: .centerY, multiplier: 1, constant: 0)
        
        let horizontalConstraint = NSLayoutConstraint(item: loading, attribute: .centerX, relatedBy: .equal, toItem: subView, attribute: .centerX, multiplier: 1, constant: 0)
        
        let heightContraint = NSLayoutConstraint(item: loading, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        
        let widthContraint = NSLayoutConstraint(item: loading, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        
        NSLayoutConstraint.activate([verticalConstraint, horizontalConstraint, widthContraint, heightContraint])
        
        
        if let item: Film = dataForSlide[index]  {
            
            if let path = item.backdrop_path {
                let pathImage = "https://image.tmdb.org/t/p/original\(path)"
                subView.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
                    loading.isHidden = true
                    loading.stopAnimating()
                })
            }
            
            
        }
        
        
        
        
        return subView!
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    @objc(carousel:didSelectItemAtIndex:) func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let detaiMovie = DetailMovieViewController(nibName: "DetailMovieViewController", bundle: nil) as DetailMovieViewController
        
        detaiMovie.film = dataForSlide[index]
        self.navigationController?.pushViewController(detaiMovie, animated: true)
    }
    
}



