//
//  DetailMovieViewController.swift
//  Phim24h
//
//  Created by Chung on 9/28/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
protocol pushView {
    func setData(film:Film)
}
class DetailMovieViewController: BaseDetailViewController {
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var imageDetail: UIImageView!
    
    @IBOutlet weak var titleDetail: UILabel!
    
    @IBOutlet weak var dateDetail: UILabel!
    
    @IBOutlet weak var typeDetail: UILabel!
    
    @IBOutlet weak var imageVote: UIImageView!
    
    @IBOutlet weak var totalVote: UILabel!
    
    @IBOutlet weak var mySegment: UISegmentedControl!
    var film: Film!
    
    var list_Genre: [Genre] = []
    
    var bottomView: UIView!
    var overView: OverView!
    var people: People!
    var similar: Similar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySegment.setFontSize(fontSize: 14)
        addSubviewForSegment()
        let leftButton = UIBarButtonItem(image: UIImage(named: "vote"), style: .plain, target: self
            , action: #selector(actionVote))
        let leftButton2 = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self
            , action: #selector(actionShare))
        
        navigationItem.rightBarButtonItems = [leftButton,leftButton2]
        
        ManagerData.instance.getAllGenre(completetion: { [unowned self] (genres) in
            self.list_Genre = genres
            self.typeDetail.text = self.getNameOfGenre(genres: self.film.genre_ids as! [Int])
            })
        setData()
    }
    
    func actionVote() {
        print("vote")
    }
    func actionShare() {
        print("share")
    }
    
    
    func setData(){
        let pathImage = "https://image.tmdb.org/t/p/original\(film.poster_path!)"
        imageDetail.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
            self.loading.isHidden = true
            self.loading.stopAnimating()
        })
        titleDetail.text = film.title
        dateDetail.text = film.release_date
        //        typeDetail.text = name_genre
        let ceilVote = ceil(film.vote_average!)
        totalVote.text = "(\(ceilVote))"
        imageVote.image = UIImage(named: "stars\(Int(ceilVote))")
        //        contentDetail.text = film.overview
        
        
    }
    func getNameOfGenre(genres: [Int]) -> String {
        var result: String = ""
        for item in self.list_Genre {
            for index in 0..<genres.count {
                if let id = item.id {
                    if id == genres[index] {
                        
                        result.append("\(item.name!), ")
                    }
                }
                
            }
        }
        return result
    }
    
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        
        switch mySegment.selectedSegmentIndex
        {
        case 0:
            print("overview")
            overView.view.isHidden = false
            people.view.isHidden = true
            similar.view.isHidden = true
            
        case 1:
            print("people")
            people.view.isHidden = false
            similar.view.isHidden = true
            overView.view.isHidden = true
        case 2:
            print("similar")
            similar.view.isHidden = false
            
            people.view.isHidden = true
            overView.view.isHidden = true
        default:
            break;
        }
        
    }
    
    func addSubviewForSegment () {
        
        if bottomView == nil {
            bottomView = UIView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height:(self.view.bounds.size.width * 0.6) + 25))
            
            self.view.addSubview(bottomView)
            
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            
            let layouTop = NSLayoutConstraint(item: bottomView, attribute: .top, relatedBy: .equal, toItem: self.headerView, attribute: .bottom, multiplier: 1.0, constant: 8)
            
            let layoutBot = NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -8)
            
            
            let layoutRight = NSLayoutConstraint(item: bottomView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -8)
            
            
            let layoutLeft = NSLayoutConstraint(item: bottomView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8)
            
            NSLayoutConstraint.activate([layouTop, layoutBot, layoutLeft, layoutRight])
        }
        
        overView = OverView(nibName: "OverView", bundle: nil)
        //        controller.ANYPROPERTY=THEVALUE // If you want to pass value
        overView.view.frame = self.view.bounds;
        overView.willMove(toParentViewController: self)
        bottomView.addSubview(overView.view)
        self.addChildViewController(overView)
        overView.didMove(toParentViewController: self)
        
        
        
        people = People(nibName: "People", bundle: nil)
        //        controller.ANYPROPERTY=THEVALUE // If you want to pass value
        people.view.frame = self.view.bounds;
        people.willMove(toParentViewController: self)
        bottomView.addSubview(people.view)
        self.addChildViewController(people)
        people.didMove(toParentViewController: self)
        
        
        
        similar = Similar(nibName: "Similar", bundle: nil)
        //        controller.ANYPROPERTY=THEVALUE // If you want to pass value
        similar.view.frame = self.view.bounds;
        similar.willMove(toParentViewController: self)
        bottomView.addSubview(similar.view)
        self.addChildViewController(similar)
        similar.didMove(toParentViewController: self)
        
        people.view.isHidden = true
        similar.view.isHidden = true
        
        
        
    }
}

extension UISegmentedControl {
    
    func setFontSize(fontSize: CGFloat) {
        
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject: UIColor.white,
            NSFontAttributeName as NSObject: UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightRegular)
        ]
        
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : UIColor.black
            ,
            NSFontAttributeName as NSObject : UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightMedium),
            ]
        
        self.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
}

