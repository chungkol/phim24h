//
//  DetailMovieVC.swift
//  Phim24h
//
//  Created by Chung on 10/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//


import UIKit
import OEANotification
import HCSStarRatingView
import Firebase
protocol pushView {
    func setData(_ film:Film)
}
class DetailMovieVC: BaseDetailViewController {
    
    var myScrollView: UIScrollView!
    
    var header: UIView!
    var headerLeft: UIView!
    var headerRight: UIView!
    var imageDetail: UIImageView!
    var saperator: UIView!
    
    var titleDetail: UILabel!
    var dateDetail: UILabel!
    var typeDetail: UILabel!
    var imageVote: HCSStarRatingView!
    var imageForRate: HCSStarRatingView!
    
    var totalVote: UILabel!
    var mySegment: UISegmentedControl!
    var bottom: UIView!
    
    var guest_id: String?
    var time_save: String?
    
    var alertController: UIAlertController!
    var alertVote: UIAlertController!
    var ref: FIRDatabaseReference!
    var layoutTop : NSLayoutConstraint!
    var layoutBot : NSLayoutConstraint!
    var layoutLeft : NSLayoutConstraint!
    var layoutRight : NSLayoutConstraint!
    var layoutHeight : NSLayoutConstraint!
    var layoutWidth : NSLayoutConstraint!
    var layoutCenterX : NSLayoutConstraint!
    var layoutCenterY : NSLayoutConstraint!
    var value: Int = 0
    var isCheck = false
    var film: Film!
    var list_Genre: [Genre] = []
    var overView: OverView!
    var people: People!
    var similar: Similar!
    var userDefault: UserDefaults!
    static let KEY_GUEST: String = "key_guest"
    static let KEY_TIME_NOW: String = "key_time"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault = UserDefaults.standard
        ref = FIRDatabase.database().reference()
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
                myScrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + 200 )
        
        mySegment.setFontSize(12)
        let leftButton = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self
            , action: #selector(actionAdd))
        let leftButton2 = UIBarButtonItem(image: UIImage(named: "vote"), style: .plain, target: self
            , action: #selector(actionVote))
        let leftButton3 = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target:self, action: #selector(actionShare))
        
        navigationItem.rightBarButtonItems = [leftButton,leftButton2, leftButton3]
        
        ManagerData.instance.getAllGenre({ [unowned self] (genres) in
            self.list_Genre = genres
            self.typeDetail.text = self.getNameOfGenre(self.film.genre_ids as! [Int])
            })
        setData()
        
    }
    func actionShare() {
        
    }
    func actionAdd() {
        self.addAlertViewAdd()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func actionVote() {
        self.addAlertViewVote()
        
    }
    func showMess(title: String, content: String , type: NotificationType) {
        OEANotification.setDefaultViewController(self)
        OEANotification.notify(title, subTitle: content, type: type, isDismissable: true)
    }
    
    func addAlertViewAdd() {
        if alertController == nil {
            alertController = UIAlertController(title: "Notification", message: "Would you like to add favorite?", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "Cancel", style: .default){ (action) -> Void in
            }
            let actionAdd = UIAlertAction(title: "Add", style: .default){ (action) -> Void in
                if let user = UserData.instance.user {
                    let mess = ManagerSQLite.shareInstance.insertData(table_name: (user.uid)!, film: self.film)
                    self.showMess(title: "Notification", content: mess, type: .success)
                }

            }
            
            alertController?.addAction(actionCancel)
            alertController.addAction(actionAdd)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func addAlertViewVote() {
        
        if let guest_Id = userDefault.object(forKey: DetailMovieVC.KEY_GUEST) as? String , let date_save = userDefault.object(forKey: DetailMovieVC.KEY_TIME_NOW) as?
            String{
            if !getAmountBeetweenTwoDateTime(date_save: date_save , current_date: getDateAndTimeNow()) {
                self.guest_id = guest_Id
                self.time_save = date_save
            }else {
                createGuestID()
            }
            
        }else{
            createGuestID()
        }
        
        if alertVote == nil {
            alertVote = UIAlertController(title: "Notification", message: "Would you like to vote for film?", preferredStyle: .alert)
            if imageForRate == nil {
                imageForRate = HCSStarRatingView(frame: CGRect(x:20, y:50, width: 130, height: 30))
                imageForRate.maximumValue = 10
                imageForRate.minimumValue = 0
                imageForRate.tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
                
                imageForRate.backgroundColor = UIColor.clear
                imageForRate.addTarget(self, action: #selector(voteChange(_:)), for: .valueChanged)
                alertVote.view.addSubview(imageForRate)
                
                imageForRate.translatesAutoresizingMaskIntoConstraints = false
                
                let layoutWidth = NSLayoutConstraint(item: imageForRate, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 130)
                let layoutHeight = NSLayoutConstraint(item: imageForRate, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
                
                let layoutTop = NSLayoutConstraint(item: imageForRate, attribute: .top, relatedBy: .equal, toItem: alertVote.view, attribute: .top, multiplier: 1, constant: 55)
                let layoutCenterX = NSLayoutConstraint(item: imageForRate, attribute: .centerX, relatedBy: .equal, toItem: alertVote.view, attribute: .centerX, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([layoutWidth, layoutHeight, layoutCenterX, layoutTop])
            }
            
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default){ (action) -> Void in
                print("Cancel")
            }
            let actionVote = UIAlertAction(title: "Vote", style: .default){ (action) -> Void in
                
                self.rateForMovie(movie_ID: self.film.id!, guest_session_id: self.guest_id!, value: self.value)
                self.value = 0
                self.imageForRate.value = 0
            }
            
            alertVote?.addAction(actionCancel)
            alertVote.addAction(actionVote)
        }
        self.present(alertVote, animated: true, completion: nil)
    }
    func createGuestID() {
        ManagerData.instance.createAccountGuest(completetion: { [unowned self] (result) in
            
            self.guest_id = result.guest_session_id
            self.time_save = self.getDateAndTimeNow()
            
            print(self.guest_id!)
            print(self.time_save!)
            self.userDefault.set(self.guest_id, forKey: DetailMovieVC.KEY_GUEST)
            self.userDefault.set(self.time_save, forKey: DetailMovieVC.KEY_TIME_NOW)
            self.userDefault.synchronize()
            })
        
    }
    func rateForMovie(movie_ID: Int, guest_session_id: String, value: Int) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            checkForRate(uid: uid, film_Id: self.film.id!)
            if value > 0 {
                if !isCheck {
                    ManagerData.instance.rateForMovie(movie_ID: movie_ID, guest_session_id: guest_session_id,value: value, completetion: { [unowned self] (result) in
                        self.showMess(title: "Notification", content: result.status_message!, type: .info)
                        
                        self.ref.child("user").child("\(uid)").child("vote").child("\(self.film.id!)").setValue(["vote" : value])
                        
                        })
                }else{
                    showMess(title: "Notification", content: "you were vote for film", type: .info)
                }
            }else {
                showMess(title: "Notification", content: "Value must be greater than 0", type: .warning)
            }
        }
        
        
    }
    func checkForRate(uid: String , film_Id: Int) {
        self.ref.child("user").child("\(uid)").child("vote").child("\(film_Id)").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                self.isCheck = true
            }else{
                self.isCheck = false
            }
        })
    }
    
    func getDateAndTimeNow() -> String
    {
        let currentDate = NSDate()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss dd/MM/yyyy"
        return dateFormat.string(from: currentDate as Date)
    }
    
    func getAmountBeetweenTwoDateTime(date_save: String, current_date: String) -> Bool {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss dd/MM/yyyy"
        let date1 = dateFormat.date(from: date_save)
        let date2 = dateFormat.date(from: current_date)
        let amount: Double = (date2?.timeIntervalSince(date1!))!
        if amount / 3600 >= 24.0 {
            return true
        }else {
            return false
        }
    }
    
    func voteChange(_ sender: HCSStarRatingView!) {
        value = Int(sender.value)
    }
    
    
    
    
    func setData(){
        if let path = film.poster_path {
            let pathImage = "https://image.tmdb.org/t/p/original\(path)"
            super.loadImage(url_image: URL(string: pathImage), imageView: imageDetail, key: "\(film.id!)")
        }
        
        titleDetail.text = film.title
        dateDetail.text = film.release_date
        let ceilVote = ceil(film.vote_average!)
        totalVote.text = "(\(ceilVote))"
        imageVote.value = CGFloat(Int(ceilVote))
        
        
    }
    func getNameOfGenre(_ genres: [Int]) -> String {
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
            showView("overview")
        case 1:
            print("people")
            
            showView("people")
        case 2:
            print("similar")
            
            showView("similar")
        default:
            break;
        }
        
    }
    func showView (_ type: String) {
        switch type {
        case "overview":
            overView.view.isHidden = false
            people.view.isHidden = true
            similar.view.isHidden = true
            myScrollView.isScrollEnabled = true
        case "people":
            people.view.isHidden = false
            similar.view.isHidden = true
            overView.view.isHidden = true
            people.movie_id = film.id
            myScrollView.isScrollEnabled = true
        case "similar":
            similar.view.isHidden = false
            people.view.isHidden = true
            overView.view.isHidden = true
            similar.movie_id = film.id
            myScrollView.isScrollEnabled = false
            
            
        default:
            break
        }
    }
    func addScrollView() {
        if (myScrollView == nil) {
            myScrollView = UIScrollView(frame: CGRect(x:0, y:0, width: 5, height:5))
            self.view.addSubview(myScrollView)
            
            //            myScrollView.scrollRectToVisible(self.view.frame, animated: true)
            myScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            
            layoutTop = NSLayoutConstraint(item: myScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
            
            layoutLeft = NSLayoutConstraint(item: myScrollView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: myScrollView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            layoutBot = NSLayoutConstraint(item: myScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        }
    }
    func addHeaderView() {
        
        
        // add Header
        if (header == nil) {
            header = UIView(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height:(self.view.bounds.size.width * 0.5)))
            header.backgroundColor = UIColor.init(hex: "#EEEEEE")
            self.myScrollView.addSubview(header)
            
            header.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: header, attribute: .top, relatedBy: .equal, toItem: self.myScrollView, attribute: .top, multiplier: 1.0, constant: 0)
            
            layoutHeight = NSLayoutConstraint(item: header
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (self.view.bounds.size.width * 0.5))
            
            layoutRight = NSLayoutConstraint(item: header, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            
            layoutLeft = NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: self.myScrollView, attribute: .leading, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        //add header left---------------------------
        if headerLeft == nil {
            headerLeft = UIView(frame: CGRect(x:0, y:0, width: 100, height: 130))
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
        
        //---------------------------------------
        
        //add header right
        if headerRight == nil {
            headerRight = UIView(frame: CGRect(x:0, y:0, width: 100, height: 130))
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
            titleDetail.textColor = UIColor.black
            titleDetail.font = UIFont.systemFont(ofSize: 17)
            self.headerRight.addSubview(titleDetail)
            
            titleDetail.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: titleDetail, attribute: .top, relatedBy: .equal, toItem: self.headerRight, attribute: .top, multiplier: 1.0, constant: 0)
            
            layoutLeft = NSLayoutConstraint(item: titleDetail, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutRight = NSLayoutConstraint(item: titleDetail, attribute: .trailing, relatedBy: .equal, toItem: self.headerRight, attribute: .trailing, multiplier: 1.0, constant: -8)
            
            layoutHeight = NSLayoutConstraint(item: titleDetail
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutHeight])
        }
        if dateDetail == nil {
            dateDetail = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 130))
            dateDetail.textColor = UIColor.black
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
            typeDetail.textColor = UIColor.black
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
            imageVote = HCSStarRatingView(frame: CGRect(x:0, y:0, width: 100, height: 20))
            imageVote.maximumValue = 10
            imageVote.minimumValue = 0
            
            imageVote.tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            
            imageVote.backgroundColor = UIColor.clear
            self.headerRight.addSubview(imageVote)
            
            imageVote.translatesAutoresizingMaskIntoConstraints = false
            
            layoutHeight = NSLayoutConstraint(item: imageVote
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
            
            layoutWidth = NSLayoutConstraint(item: imageVote
                , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130)
            
            layoutTop = NSLayoutConstraint(item: imageVote, attribute: .top, relatedBy: .equal, toItem: self.typeDetail, attribute: .bottom, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: imageVote, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutWidth, layoutHeight])
        }
        
        if totalVote == nil {
            totalVote = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 130))
            totalVote.textColor = UIColor.black
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
            mySegment.addTarget(self, action: #selector(DetailMovieVC.changeView(_:)), for: .valueChanged)
            (mySegment.subviews[0] as UIView).tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            (mySegment.subviews[1] as UIView).tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            (mySegment.subviews[2] as UIView).tintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
            
            self.headerRight.addSubview(mySegment)
            
            mySegment.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: mySegment, attribute: .top, relatedBy: .equal, toItem: self.imageVote, attribute: .bottom, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: mySegment, attribute: .leading, relatedBy: .equal, toItem: self.headerRight, attribute: .leading, multiplier: 1.0, constant: 0)
            
            layoutWidth = NSLayoutConstraint(item: mySegment
                , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
            
            layoutHeight = NSLayoutConstraint(item: mySegment
                , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutWidth, layoutHeight])
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
            
            self.myScrollView.addSubview(bottom)
            bottom.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: bottom, attribute: .top, relatedBy: .equal, toItem: self.header, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            layoutBot = NSLayoutConstraint(item: bottom, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            
            
            layoutRight = NSLayoutConstraint(item: bottom, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            
            layoutLeft = NSLayoutConstraint(item: bottom, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        }
        //add overView------------
        overView = OverView(nibName: "OverView", bundle: nil)
        overView.movie_id = film.id
        overView.movie_content = film.overview
        overView.movie_title = film.title
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
    
    func setFontSize(_ fontSize: CGFloat) {
        
        let normalTextAttributes: [AnyHashable: Any] = [
            NSForegroundColorAttributeName as NSObject: UIColor.black,
            NSFontAttributeName as NSObject: UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightRegular)
        ]
        
        let boldTextAttributes: [AnyHashable: Any] = [
            NSForegroundColorAttributeName as NSObject : UIColor.white
            ,
            NSFontAttributeName as NSObject : UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightMedium),
            ]
        
        self.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
    func setFontSizeForScope(_ fontSize: CGFloat) {
        
        let normalTextAttributes: [AnyHashable: Any] = [
            NSForegroundColorAttributeName as NSObject: UIColor.white,
            NSFontAttributeName as NSObject: UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightRegular)
        ]
        
        let boldTextAttributes: [AnyHashable: Any] = [
            NSForegroundColorAttributeName as NSObject : UIColor.black
            ,
            NSFontAttributeName as NSObject : UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightMedium),
            ]
        
        self.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
}



