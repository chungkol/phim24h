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

class HomeViewController: BaseViewController  {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    var testView: UIView!
    var scrollviewSlide: UIScrollView!
    var pageSilde: UIPageControl!
    
    var first = false
    var currentPage = 0
    
    var datas: [DataModel] = []
    
    var dataForSlide: [Film] = []
    var photo: [UIImageView] = []
    
    
    var frontScrollViews: [UIScrollView] = []
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlide()
        myTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        myTable.contentInset = UIEdgeInsetsMake(-32, 0, 0, 0)
        self.automaticallyAdjustsScrollViewInsets = false
        initData()
    }
    
    //add Subview for slide
    func addSlide(){
        print(self.view.bounds.size.width)
        testView = UIView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height:(self.view.bounds.size.width * 0.6) + 25))
        testView.backgroundColor = UIColor.gray
        
        scrollviewSlide = UIScrollView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height:(self.view.bounds.size.width * 0.6)))
        
        
        pageSilde = UIPageControl(frame: CGRect(x:0, y:(scrollviewSlide.bounds.origin.x + scrollviewSlide.bounds.size.height), width: 100, height: 25))
        pageSilde.currentPage = currentPage
        pageSilde.numberOfPages = 5
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.pageChange(_:)))
        tap.numberOfTapsRequired = 1
        pageSilde.addGestureRecognizer(tap)
        testView.addSubview(scrollviewSlide)
        testView.addSubview(pageSilde)
        scrollviewSlide.translatesAutoresizingMaskIntoConstraints = false
        
        //        constraint scroll
        
        var layouTop = NSLayoutConstraint(item: scrollviewSlide, attribute: .top, relatedBy: .equal, toItem: self.testView, attribute: .top, multiplier: 1.0, constant: 0)
        
        let layoutBot = NSLayoutConstraint(item: scrollviewSlide, attribute: .bottom, relatedBy: .equal, toItem: self.testView, attribute: .bottom, multiplier: 1.0, constant: -25)
        
        
        let layoutRight = NSLayoutConstraint(item: scrollviewSlide, attribute: .trailing, relatedBy: .equal, toItem: self.testView, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        
        let layoutLeft = NSLayoutConstraint(item: scrollviewSlide, attribute: .leading, relatedBy: .equal, toItem: self.testView, attribute: .leading, multiplier: 1.0, constant: 0)
        

        
        testView.backgroundColor = UIColor.red
        NSLayoutConstraint.activate([layoutRight,layouTop,layoutLeft,layoutBot])

        
        //        constraint page
        self.pageSilde.translatesAutoresizingMaskIntoConstraints = false
        self.pageSilde.backgroundColor = UIColor.darkGray
        
        layouTop = NSLayoutConstraint(item: pageSilde, attribute: .top, relatedBy: .equal, toItem: self.scrollviewSlide, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        
        let horizontalConstraint = NSLayoutConstraint(item: pageSilde, attribute: .centerX, relatedBy: .equal, toItem: self.testView, attribute: .centerX, multiplier: 1, constant: 0)
        let heightContraint = NSLayoutConstraint(item: pageSilde, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
        
        let widthContraint = NSLayoutConstraint(item: pageSilde, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        NSLayoutConstraint.activate([layouTop, horizontalConstraint, widthContraint, heightContraint])
    }
    
    
    
    
    func initData(){
        //        loading.startAnimating()
        ManagerData.instance.getUpComing(page: 1 , type: ManagerData.UPCOMING) {[unowned self] (films) in
            self.datas.append(DataModel(title: "Up Coming", key: ManagerData.UPCOMING, datas: films as [Film]))
            
            ManagerData.instance.getTopRated(page: 1 , type: ManagerData.TOP_RATED) {[unowned self] (films) in
                self.datas.append(DataModel(title: "Top Rated", key: ManagerData.TOP_RATED, datas: films as [Film]))
                
                
                ManagerData.instance.getPopular(page: 1 , type: ManagerData.POPULAR) {[unowned self] (films) in
                    self.datas.append(DataModel(title: "Popular", key: ManagerData.POPULAR, datas: films as [Film]))
                    
                    ManagerData.instance.getNowPlaying(page: 1 , type: ManagerData.NOW_PLAYING) {[unowned self] (films) in
                        
                        self.dataForSlide = films
                        
                        self.datas.append(DataModel(title: "Now Playing", key: ManagerData.NOW_PLAYING, datas: films as [Film]))
                        
                        
                        self.addImgaeForSlide()
                        self.scrollviewSlide.delegate = self
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.updateSlide(_:)), userInfo: nil, repeats: true)
                        RunLoop.main.add(self.timer, forMode: .commonModes)
                        
                        self.myTable.delegate = self
                        self.myTable.dataSource = self
                        self.myTable.reloadData()
                        //                        self.loading.isHidden = true
                        //                        self.loading.stopAnimating()
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
    
    
    func addImgaeForSlide(){
        if (!first) {
            first = true
            let pagesScrollViewSize = scrollviewSlide.frame.size
            
            scrollviewSlide.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(5), height: 0)
            scrollviewSlide.contentOffset = CGPoint(x: CGFloat(currentPage) * scrollviewSlide.frame.size.width, y: 0)
            
            
            for i in 0..<5
            {
                let imgView = UIImageView()
                let pathImage = "https://image.tmdb.org/t/p/original\(dataForSlide[i].backdrop_path!)"
                imgView.kf.setImage(with: URL(string: pathImage))
                imgView.frame = CGRect(x: 0, y: 0, width: scrollviewSlide.frame.size.width, height: scrollviewSlide.frame.size.height)
                imgView.contentMode = .scaleAspectFill
                
                photo.append(imgView)
                
                imgView.isUserInteractionEnabled = true
                imgView.isMultipleTouchEnabled = true
                
                //su kien tap
                let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapImg(_:)))
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                
                
                let frontScrollView = UIScrollView(frame: CGRect( x: CGFloat(i) * scrollviewSlide.frame.size.width, y: 0, width: scrollviewSlide.frame.size.width, height: scrollviewSlide.frame.size.height))
                frontScrollView.minimumZoomScale = 1
                frontScrollView.maximumZoomScale = 2
                frontScrollView.delegate = self
                frontScrollView.addSubview(imgView)
                frontScrollViews.append(frontScrollView)
//                self.scrollviewSlide.backgroundColor =  UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
                
                self.scrollviewSlide.addSubview(frontScrollView)
                pageSilde.currentPage = 0
                
                
                
            }
            
            
        }
        
        
    }
    func tapImg(_ gesture: UITapGestureRecognizer){
        
        
    }
    func updateSlide(_ sender: AnyObject){
        var current = pageSilde.currentPage
        current = current + 1
        if current < 5 {
            
            scrollviewSlide.contentOffset = CGPoint(x: CGFloat(current) * scrollviewSlide.frame.size.width,y: 0)
            
        }
        else{
            current = 0
            scrollviewSlide.contentOffset = CGPoint(x: CGFloat(current) * scrollviewSlide.frame.size.width,y: 0)
            
        }
        pageSilde.currentPage = current
        
    }
    func pageChange(_ sender: AnyObject) {
        scrollviewSlide.contentOffset = CGPoint(x: CGFloat(pageSilde.currentPage) * scrollviewSlide.frame.size.width, y: 0)
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageSilde.currentPage = Int(pageNumber)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return testView
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
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let tableWithpage = TableWithPage(nibName: "TableWithPage", bundle: nil)
    //        tableWithpage.data_key = datas[indexPath.row].key
    //        tableWithpage.data_title = datas[indexPath.row].title
    //        self.navigationController?.pushViewController(tableWithpage, animated: true)
    //
    //    }
    
    
    
}



extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        
        let dataModel: DataModel = datas[indexPath.row]
        
        
        if let myData = dataModel.datas
        {
            cell.titleCell.addTarget(self, action: #selector(HomeViewController.seeMore(_:)), for: .touchUpInside)
            cell.titleCell.tag = 100 + indexPath.row
            cell.datas = myData
            cell.title = dataModel.title
        }
        
        return cell
        
    }
}


