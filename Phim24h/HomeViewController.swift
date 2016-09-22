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
    
    @IBOutlet weak var collectionTopRated: UICollectionView!
    
    @IBOutlet weak var imageInSlide: UIImageView!
    
    @IBOutlet weak var scrollviewSlide: UIScrollView!
    
    @IBOutlet weak var pageSilde: UIPageControl!
    var first = false
    var currentPage = 0
    
    var topRated: [Film] = []
    
    var photo: [UIImageView] = []
    
    var frontScrollViews: [UIScrollView] = []
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSilde.currentPage = currentPage
        pageSilde.numberOfPages = 5
        scrollviewSlide.delegate = self
        collectionTopRated.delegate = self
        collectionTopRated.dataSource = self
        collectionTopRated.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        ManagerData.instance.getListFilm(page: 1 , type: ManagerData.TOP_RATED) {[unowned self] (films) in
            self.topRated = films
            self.addImgaeForSlide()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setTitForView("Phim24h")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
                let pathImage = "https://image.tmdb.org/t/p/original\(topRated[i].backdrop_path!)"
                print(pathImage)
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
                currentPage = 0
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.updateSlide(_:)), userInfo: nil, repeats: true)
                
                
            }
            
        }
        
        
    }
    func tapImg(_ gesture: UITapGestureRecognizer){
        print("tap image")
        print("aaa \(topRated.count)")
    }
    func updateSlide(_ sender: AnyObject){
        var current = pageSilde.currentPage
         print("trước \(current)")
        current = current + 1
        if current < 4 {
            
            scrollviewSlide.contentOffset = CGPoint(x: CGFloat(current) * scrollviewSlide.frame.size.width,y: 0)
            
        }else{
            current = 0
            scrollviewSlide.contentOffset = CGPoint(x: CGFloat(current) * scrollviewSlide.frame.size.width,y: 0)

        }
        pageSilde.currentPage = current
        
        
        print("sau \(current)")

        
        
    }
    @IBAction func pageChange(_ sender: UIPageControl) {
        print( pageSilde.currentPage)
        scrollviewSlide.contentOffset = CGPoint(x: CGFloat(pageSilde.currentPage) * scrollviewSlide.frame.size.width, y: 0)
        
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageSilde.currentPage = Int(pageNumber)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count \(topRated.count)")
        return topRated.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let item: Film = topRated[(indexPath as NSIndexPath).row]
        
        let pathImage = "https://image.tmdb.org/t/p/original\(item.backdrop_path!)"
        
        cell.imageCell.kf.setImage(with: URL(string: pathImage))
        cell.nameCell.text = item.title
        return cell
        
    }
}
