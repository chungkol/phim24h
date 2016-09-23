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
    
    
    
    @IBOutlet weak var scrollviewSlide: UIScrollView!
    
    @IBOutlet weak var pageSilde: UIPageControl!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    var first = false
    var currentPage = 0
    
    var datas = NSMutableDictionary()
    var dataKey : [String] = []
    var dataForSlide: [Film] = []
    var photo: [UIImageView] = []
    
    var frontScrollViews: [UIScrollView] = []
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSilde.currentPage = currentPage
        pageSilde.numberOfPages = 5
        
        
        
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        initData()
    }
    func initData(){
        ManagerData.instance.getUpComing(page: 1 , type: ManagerData.UPCOMING) {[unowned self] (films) in
            self.dataForSlide = films
            self.datas.setObject(films as! [Film], forKey: "Up coming" as NSCopying)
            
            
            
            ManagerData.instance.getTopRated(page: 1 , type: ManagerData.TOP_RATED) {[unowned self] (films) in
                self.datas.setObject(films as! [Film], forKey: "Top rated" as NSCopying)
                
                
                ManagerData.instance.getPopular(page: 1 , type: ManagerData.POPULAR) {[unowned self] (films) in
                    self.datas.setObject(films as! [Film], forKey: "Popular" as NSCopying)
                    
                    
                    ManagerData.instance.getNowPlaying(page: 1 , type: ManagerData.NOW_PLAYING) {[unowned self] (films) in
                        self.datas.setObject(films as! [Film], forKey: "Now Playing" as NSCopying)
                        print(self.datas.count)
                        
                        self.addImgaeForSlide()
                        self.scrollviewSlide.delegate = self
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.updateSlide(_:)), userInfo: nil, repeats: true)
                        RunLoop.main.add(self.timer, forMode: .commonModes)
                        
                        self.dataKey = self.datas.allKeys as! [String]
                        self.myTable.reloadData()
                        
                        
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
                self.scrollviewSlide.backgroundColor =  UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
                
                self.scrollviewSlide.addSubview(frontScrollView)
                pageSilde.currentPage = 0
                
                
                
            }
            
            
        }
        
        
    }
    func tapImg(_ gesture: UITapGestureRecognizer){
        print("tap image")
        
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
    @IBAction func pageChange(_ sender: UIPageControl) {
        scrollviewSlide.contentOffset = CGPoint(x: CGFloat(pageSilde.currentPage) * scrollviewSlide.frame.size.width, y: 0)
        
        
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageSilde.currentPage = Int(pageNumber)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        if let nameCell: String = dataKey[indexPath.row]
        {
            cell.title = nameCell
            if let datas = datas.value(forKey: nameCell) as? [Film]
            {
                cell.datas = datas
            }
            
        }
        
        return cell
        
    }
}


