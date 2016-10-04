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
    
    
    var parentView: UIView!
    var myScrollView: UIScrollView!
    
    var header: UIView!
    var headerLeft: UIView!
    var headerRight: UIView!
    var imageDetail: UIImageView!
    var loading: UIActivityIndicatorView!
    var saperator: UIView!
    
    var titleDetail: UILabel!
    var dateDetail: UILabel!
    var typeDetail: UILabel!
    var imageVote: UIImageView!
    var totalVote: UILabel!
    var mySegment: UISegmentedControl!
    var bottom: UIView!
    
    var layoutTop : NSLayoutConstraint!
    var layoutBot : NSLayoutConstraint!
    var layoutLeft : NSLayoutConstraint!
    var layoutRight : NSLayoutConstraint!
    var layoutHeight : NSLayoutConstraint!
    var layoutWidth : NSLayoutConstraint!
    var layoutCenterX : NSLayoutConstraint!
    var layoutCenterY : NSLayoutConstraint!
    
    var film: Film!
    var list_Genre: [Genre] = []
    var overView: OverView!
    var people: People!
    var similar: Similar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if myScrollView == nil {
            addScrollView()
        }
        if header == nil {
            addHeaderView()
        }
        if bottom == nil {
            addSubviewForSegment()
        }
        mySegment.setFontSize(fontSize: 14)
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
        loading.startAnimating()
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
    
    
    func changeView(_ sender: UISegmentedControl) {
        
        switch mySegment.selectedSegmentIndex
        {
        case 0:
            print("overviwe")
            showView(type: "overview")
        case 1:
            print("people")
           
            showView(type: "people")
        case 2:
            print("similar")
            
            showView(type: "similar")
        default:
            break;
        }
        
    }
    func showView (type: String) {
        switch type {
        case "overview":
            overView.view.isHidden = false
            people.view.isHidden = true
            similar.view.isHidden = true
        case "people":
            people.view.isHidden = false
            similar.view.isHidden = true
            overView.view.isHidden = true
        case "similar":
            similar.view.isHidden = false
            people.view.isHidden = true
            overView.view.isHidden = true
            
        default:
            break
        }
    }
    func addScrollView() {
        if (myScrollView == nil) {
            myScrollView = UIScrollView(frame: CGRect(x:0, y:0, width: 5, height:5))
            myScrollView.backgroundColor = UIColor.red
            myScrollView.contentSize = self.view.bounds.size
            self.view.addSubview(myScrollView)
            
            myScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            
            layoutTop = NSLayoutConstraint(item: myScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
            
            layoutLeft = NSLayoutConstraint(item: myScrollView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: myScrollView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            layoutBot = NSLayoutConstraint(item: myScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        }
        if (parentView == nil) {
            parentView = UIView(frame: CGRect(x:0, y:0, width: 5, height:5))
            parentView.backgroundColor = UIColor.red
            self.myScrollView.addSubview(parentView)
            
            parentView.translatesAutoresizingMaskIntoConstraints = false
            
            
            layoutTop = NSLayoutConstraint(item: parentView, attribute: .top, relatedBy: .equal, toItem: self.myScrollView, attribute: .top, multiplier: 1.0, constant: 0)
            
            layoutLeft = NSLayoutConstraint(item: parentView, attribute: .leading, relatedBy: .equal, toItem: self.myScrollView, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: parentView, attribute: .trailing, relatedBy: .equal, toItem: self.myScrollView, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            layoutBot = NSLayoutConstraint(item: parentView, attribute: .bottom, relatedBy: .equal, toItem: self.myScrollView, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            layoutHeight = NSLayoutConstraint(item: parentView
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.bounds.height)
            layoutWidth = NSLayoutConstraint(item: parentView
                , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.bounds.width)
            
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot , layoutHeight , layoutWidth])
        }
        
    }
    func addHeaderView() {
        
        
        // add Header
        if (header == nil) {
            header = UIView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height:(self.view.bounds.size.width * 0.5)))
            header.backgroundColor = UIColor.black
            self.parentView.addSubview(header)
            
            header.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: header, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
            
            layoutHeight = NSLayoutConstraint(item: header
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (self.view.bounds.size.width * 0.5))
            
            layoutRight = NSLayoutConstraint(item: header, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            
            layoutLeft = NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        //add header left---------------------------
        if headerLeft == nil {
            headerLeft = UIView(frame: CGRect(x:0, y:0, width: 100, height: 130))
            headerLeft.backgroundColor = UIColor.black
            self.header.addSubview(headerLeft)
            
            headerLeft.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: headerLeft, attribute: .top, relatedBy: .equal, toItem: self.header, attribute: .top, multiplier: 1.0, constant: 8)
            
            layoutHeight = NSLayoutConstraint(item: headerLeft
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130)
            layoutWidth = NSLayoutConstraint(item: headerLeft
                , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
            layoutLeft = NSLayoutConstraint(item: headerLeft, attribute: .leading, relatedBy: .equal, toItem: self.header, attribute: .leading, multiplier: 1.0, constant: 8)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutWidth, layoutHeight])
        }
        if  imageDetail == nil {
            imageDetail = UIImageView(frame: CGRect(x:0, y:0, width: 100, height: 130))
            
            self.headerLeft.addSubview(imageDetail)
            
            imageDetail.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: imageDetail, attribute: .top, relatedBy: .equal, toItem: self.headerLeft, attribute: .top, multiplier: 1.0, constant: 0)
            
            layoutLeft = NSLayoutConstraint(item: imageDetail, attribute: .leading, relatedBy: .equal, toItem: self.headerLeft, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: imageDetail, attribute: .trailing, relatedBy: .equal, toItem: self.headerLeft, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            layoutBot = NSLayoutConstraint(item: imageDetail, attribute: .bottom, relatedBy: .equal, toItem: self.headerLeft, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        }
        if  loading == nil {
            loading = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width: 30, height: 30))
            
            loading.color = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            
            self.headerLeft.addSubview(loading)
            
            loading.translatesAutoresizingMaskIntoConstraints = false
            
            layoutHeight = NSLayoutConstraint(item: loading
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
            layoutWidth = NSLayoutConstraint(item: loading
                , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
            
            layoutCenterX = NSLayoutConstraint(item: loading, attribute: .centerX, relatedBy: .equal, toItem: self.headerLeft, attribute: .centerX, multiplier: 1, constant: 0)
            
            layoutCenterY = NSLayoutConstraint(item: loading, attribute: .centerY, relatedBy: .equal, toItem: self.headerLeft, attribute: .centerY, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([layoutHeight, layoutWidth, layoutCenterX, layoutCenterY])
        }
        
        //---------------------------------------
        
        //add header right
        if headerRight == nil {
            headerRight = UIView(frame: CGRect(x:0, y:0, width: 100, height: 130))
            headerRight.backgroundColor = UIColor.black
            self.header.addSubview(headerRight)
            
            headerRight.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: headerRight, attribute: .top, relatedBy: .equal, toItem: self.header, attribute: .top, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: headerRight, attribute: .leading, relatedBy: .equal, toItem: self.headerLeft, attribute: .trailing, multiplier: 1.0, constant: 8)
            
            layoutRight = NSLayoutConstraint(item: headerRight, attribute: .trailing, relatedBy: .equal, toItem: self.header, attribute: .trailing, multiplier: 1.0, constant: -8)
            
            layoutBot = NSLayoutConstraint(item: headerRight, attribute: .bottom, relatedBy: .equal, toItem: self.header, attribute: .bottom, multiplier: 1.0, constant: -8)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        }
        if titleDetail == nil {
            titleDetail = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 130))
            titleDetail.textColor = UIColor.white
            titleDetail.font = UIFont.systemFont(ofSize: 17)
            self.headerRight.addSubview(titleDetail)
            
            titleDetail.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: titleDetail, attribute: .top, relatedBy: .equal, toItem: self.headerRight, attribute: .top, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: titleDetail, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: titleDetail, attribute: .trailing, relatedBy: .equal, toItem: self.headerRight, attribute: .trailing, multiplier: 1.0, constant: -8)
            
            layoutHeight = NSLayoutConstraint(item: titleDetail
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        if dateDetail == nil {
            dateDetail = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 130))
            dateDetail.textColor = UIColor.gray
            dateDetail.font = UIFont.systemFont(ofSize: 15)
            self.headerRight.addSubview(dateDetail)
            
            dateDetail.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: dateDetail, attribute: .top, relatedBy: .equal, toItem: self.titleDetail, attribute: .bottom, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: dateDetail, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: dateDetail, attribute: .trailing, relatedBy: .equal, toItem: self.headerRight, attribute: .trailing, multiplier: 1.0, constant: -8)
            
            layoutHeight = NSLayoutConstraint(item: dateDetail
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        if typeDetail == nil {
            typeDetail = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 130))
            typeDetail.textColor = UIColor.gray
            typeDetail.font = UIFont.systemFont(ofSize: 15)
            
            self.headerRight.addSubview(typeDetail)
            
            typeDetail.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: typeDetail, attribute: .top, relatedBy: .equal, toItem: self.dateDetail, attribute: .bottom, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: typeDetail, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: typeDetail, attribute: .trailing, relatedBy: .equal, toItem: self.headerRight, attribute: .trailing, multiplier: 1.0, constant: -8)
            
            layoutHeight = NSLayoutConstraint(item: typeDetail
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        if imageVote == nil {
            imageVote = UIImageView(frame: CGRect(x:0, y:0, width: 100, height: 130))
            
            self.headerRight.addSubview(imageVote)
            
            imageVote.translatesAutoresizingMaskIntoConstraints = false
            
            layoutHeight = NSLayoutConstraint(item: imageVote
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 12)
            
            layoutWidth = NSLayoutConstraint(item: imageVote
                , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130)
            
            layoutTop = NSLayoutConstraint(item: imageVote, attribute: .top, relatedBy: .equal, toItem: self.typeDetail, attribute: .bottom, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: imageVote, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutWidth, layoutHeight])
        }
        
        if totalVote == nil {
            totalVote = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 130))
            totalVote.textColor = UIColor.gray
            totalVote.font = UIFont.systemFont(ofSize: 15)
            
            self.headerRight.addSubview(totalVote)
            
            totalVote.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: totalVote, attribute: .top, relatedBy: .equal, toItem: self.typeDetail, attribute: .bottom, multiplier: 1.0, constant: 4)
            
            layoutLeft = NSLayoutConstraint(item: totalVote, attribute: .leading, relatedBy: .equal, toItem: self.imageVote, attribute: .trailing, multiplier: 1.0, constant: 8)
            
            layoutRight = NSLayoutConstraint(item: totalVote, attribute: .trailing, relatedBy: .equal, toItem: self.headerRight, attribute: .trailing, multiplier: 1.0, constant: -8)
            
            layoutHeight = NSLayoutConstraint(item: totalVote
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        
        if mySegment == nil {
            mySegment = UISegmentedControl(frame: CGRect(x:0, y:0, width: 100, height: 130))
            mySegment.insertSegment(withTitle: "Overview", at: 0, animated: true)
            mySegment.insertSegment(withTitle: "People", at: 1, animated: true)
            mySegment.insertSegment(withTitle: "Similar", at: 2, animated: true)
            mySegment.selectedSegmentIndex = 0
            mySegment.addTarget(self, action: #selector(DetailMovieViewController.changeView(_:)), for: .valueChanged)
            (mySegment.subviews[0] as UIView).tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            (mySegment.subviews[1] as UIView).tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            (mySegment.subviews[2] as UIView).tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            
            self.headerRight.addSubview(mySegment)
            
            mySegment.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: mySegment, attribute: .top, relatedBy: .equal, toItem: self.imageVote, attribute: .bottom, multiplier: 1.0, constant: 20)
            
            layoutLeft = NSLayoutConstraint(item: mySegment, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: mySegment, attribute: .trailing, relatedBy: .equal, toItem: self.headerRight, attribute: .trailing, multiplier: 1.0, constant: -40)
            
            layoutHeight = NSLayoutConstraint(item: mySegment
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        if saperator == nil {
            saperator = UIView(frame: CGRect(x:0, y:0, width: 100, height: 1))
            saperator.backgroundColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            self.header.addSubview(saperator)
            
            saperator.translatesAutoresizingMaskIntoConstraints = false
            
            layoutHeight = NSLayoutConstraint(item: saperator
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)
            
            layoutLeft = NSLayoutConstraint(item: saperator, attribute: .leading, relatedBy: .equal, toItem: self.header, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: saperator, attribute: .trailing, relatedBy: .equal, toItem: self.header, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            layoutBot = NSLayoutConstraint(item: saperator, attribute: .bottom, relatedBy: .equal, toItem: self.header, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutHeight, layoutLeft, layoutRight, layoutBot])
        }
        
        
        
        
        
        
        
    }
    func addSubviewForSegment () {
        
        if bottom == nil {
            bottom = UIView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height:(self.view.bounds.size.width * 0.6) + 25))
            bottom.backgroundColor = UIColor.red
            
            self.parentView.addSubview(bottom)
            bottom.translatesAutoresizingMaskIntoConstraints = false
            
            let layoutTop = NSLayoutConstraint(item: bottom, attribute: .top, relatedBy: .equal, toItem: self.header, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            let layoutBot = NSLayoutConstraint(item: bottom, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            let layoutRight = NSLayoutConstraint(item: bottom, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            
            let layoutLeft = NSLayoutConstraint(item: bottom, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        }
        //add overView------------
        overView = OverView(nibName: "OverView", bundle: nil)
        overView.movie_id = film.id
        overView.movie_content = film.overview
        overView.willMove(toParentViewController: self)
        bottom.addSubview(overView.view)
        self.addChildViewController(overView)
        overView.didMove(toParentViewController: self)
        
        overView.view.translatesAutoresizingMaskIntoConstraints = false
        
        layoutTop = NSLayoutConstraint(item: overView.view, attribute: .top, relatedBy: .equal, toItem: self.bottom, attribute: .top, multiplier: 1.0, constant: 0)
        
        layoutBot = NSLayoutConstraint(item: overView.view, attribute: .bottom, relatedBy: .equal, toItem: self.bottom, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        layoutRight = NSLayoutConstraint(item: overView.view, attribute: .trailing, relatedBy: .equal, toItem: self.bottom, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        
        layoutLeft = NSLayoutConstraint(item: overView.view, attribute: .leading, relatedBy: .equal, toItem: self.bottom, attribute: .leading, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutBot, layoutRight])
        
        // add people view--------------
        people = People(nibName: "People", bundle: nil)
         people.movie_id = film.id
        people.view.frame = self.view.bounds;
        people.willMove(toParentViewController: self)
        bottom.addSubview(people.view)
        self.addChildViewController(people)
        people.didMove(toParentViewController: self)
        
        people.view.translatesAutoresizingMaskIntoConstraints = false
        
        layoutTop = NSLayoutConstraint(item: people.view, attribute: .top, relatedBy: .equal, toItem: self.bottom, attribute: .top, multiplier: 1.0, constant: 0)
        
        layoutBot = NSLayoutConstraint(item: people.view, attribute: .bottom, relatedBy: .equal, toItem: self.bottom, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        layoutRight = NSLayoutConstraint(item: people.view, attribute: .trailing, relatedBy: .equal, toItem: self.bottom, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        
        layoutLeft = NSLayoutConstraint(item: people.view, attribute: .leading, relatedBy: .equal, toItem: self.bottom, attribute: .leading, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutBot, layoutRight])
        
        // add similar view -----------
        similar = Similar(nibName: "Similar", bundle: nil)
         similar.movie_id = film.id
        similar.view.frame = self.view.bounds;
        similar.willMove(toParentViewController: self)
        bottom.addSubview(similar.view)
        self.addChildViewController(similar)
        similar.didMove(toParentViewController: self)
        
        similar.view.translatesAutoresizingMaskIntoConstraints = false
        
        layoutTop = NSLayoutConstraint(item: similar.view, attribute: .top, relatedBy: .equal, toItem: self.bottom, attribute: .top, multiplier: 1.0, constant: 0)
        
        layoutBot = NSLayoutConstraint(item: similar.view, attribute: .bottom, relatedBy: .equal, toItem: self.bottom, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        layoutRight = NSLayoutConstraint(item: similar.view, attribute: .trailing, relatedBy: .equal, toItem: self.bottom, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        
        layoutLeft = NSLayoutConstraint(item: similar.view, attribute: .leading, relatedBy: .equal, toItem: self.bottom, attribute: .leading, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutBot, layoutRight])
        
        
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

