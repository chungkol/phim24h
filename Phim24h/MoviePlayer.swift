//
//  MoviePlayer.swift
//  Phim24h
//
//  Created by Chung on 10/6/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import MobilePlayer
import Kingfisher
import Firebase
import OEANotification
class MoviePlayer: BaseDetailViewController, PauseOrStart {
    
    let heigtNav = 64
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tvComment: CustomTextView!
    
    @IBOutlet weak var btnPost: CustomButtonWithBoderGray!
    
    @IBOutlet weak var viewForComment: UIView!
    @IBOutlet weak var titleMovie: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imBackground: UIImageView!
    var flag: Bool = false
    var ref : FIRDatabaseReference!
    //    var storage: FIRS
    var layoutTop,layoutLeft,layoutRight,layoutBot: NSLayoutConstraint!
    
    @IBOutlet weak var contraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myTable: UITableView!
    
    var trailer: Trailer!
    var img_path: String!
    let video_Path = "https://www.youtube.com/watch?v="
    var videoURL: String!
    var id_film : Int!
    let videoID = "1"
    var movie_Title: String!
    
    var data : [MessageDetail] = []
    var messageDetail: [MessageDetail] = []
    
    var vc: PauseOverlayViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
        tvComment.delegate = self
        myTable.register(UINib.init(nibName: "CellForMessage", bundle: nil), forCellReuseIdentifier: "CellMess")
        ref = FIRDatabase.database().reference()
        self.titleMovie.text = "\(movie_Title!): \(trailer.name!)"
        if let path = img_path {
            let pathImage = "https://image.tmdb.org/t/p/original\(path)"
            super.loadImage(url_image: URL(string: pathImage), imageView: imBackground, key: "slide\(id_film!)")
            
        }
        getdata()
        videoURL = "\(video_Path)\(trailer.key!)"
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func btnPostComment(_ sender: UIButton) {
        if tvComment.text != nil && tvComment.text != "" {
            var mUID = ""
            var mName = ""
            var mImage = ""
            let currentDate = self.convertDateTime()
            if let user = UserData.instance.user {
                mUID = user.uid
                mName = user.email!
                if let path_image = user.url_image {
                    mImage = String(describing: path_image).toBase64()
                    
                }else{
                    mImage = ""
                }
            }
            let comment = tvComment.text
            let state = "1"
            let mess: MessageDetail = MessageDetail()
            mess.uid = mUID
            mess.name = mName
            mess.image_path = mImage
            mess.time = currentDate
            mess.coment = comment
            mess.state = state
            writeData(mess: mess)
            tvComment.endEditing(true)
            
        }else{
            showMess(title: "Post Coment", mess: "Enter your coment")
        }
    }
    func writeData(mess: MessageDetail) {
        let post = ["uid": mess.uid,
                    "name": mess.name,
                    "image_path": NSString(string: mess.image_path!),
                    "time": mess.time,
                    "coment": mess.coment,
                    "state": mess.state
            ] as [String : Any]
        self.ref.child("phim").child("coment").child("\(self.id_film!)").childByAutoId().setValue(post)
        tvComment.text = ""
    }
    
    
    func getdata() {
        data.removeAll()
        self.ref.child("phim").child("coment").child("\(self.id_film!)").observe(.childAdded, with: {
            (snapshot) in
            if !snapshot.exists() {
                return
            }else{
                if let value  = snapshot.value as? [String: AnyObject] {
                    let messDetail: MessageDetail = MessageDetail()
                    messDetail.setValuesForKeys(value)
                    self.data.append(messDetail)
                    DispatchQueue.main.async {
                        self.myTable.reloadData()
                        let oldLastCellIndexPath = NSIndexPath(row: self.data.count - 1, section: 0)
                        self.myTable.scrollToRow(at: oldLastCellIndexPath as IndexPath, at: .bottom, animated: true)
                    }
                }
            }
            
        }, withCancel: nil)
        
        
    }
    func showMess(title: String, mess: String){
        OEANotification.setDefaultViewController(self)
        OEANotification.notify(title, subTitle: mess, type: NotificationType.warning, isDismissable: true)
    }
    func convertDateTime() -> String {
        let currentDate = NSDate()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss dd/MM/yyyy"
        
        return dateFormat.string(from: currentDate as Date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnPlay.setImage(UIImage(named: "play_w"), for: .normal)
        self.btnPlay.isHidden = false
        
    }
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        return UIInterfaceOrientationMask.all
    //    }
    
    
    
    
    
    
    @IBAction func btnPlay(_ sender: UIButton) {
        vc = PauseOverlayViewController()
        btnPlay.setImage(UIImage(named: "play_w"), for: .normal)
        let playerVC = MobilePlayerViewController(contentURL: NSURL(string: videoURL) as! URL, pauseOverlayViewController: vc)
        playerVC.delegateCustom = self
        playerVC.title = "\(trailer.name!)"
        playerVC.activityItems = [NSURL(string: videoURL)!]
        self.viewHeader.addSubview(playerVC.view)
        playerVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        layoutTop = NSLayoutConstraint(item: playerVC.view, attribute: .top, relatedBy: .equal, toItem: self.viewHeader, attribute: .top, multiplier: 1.0, constant: 0)
        
        layoutLeft = NSLayoutConstraint(item: playerVC.view, attribute: .leading, relatedBy: .equal, toItem: self.viewHeader, attribute: .leading, multiplier: 1.0, constant: 0)
        
        layoutRight = NSLayoutConstraint(item: playerVC.view, attribute: .trailing, relatedBy: .equal, toItem: self.viewHeader, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        layoutBot = NSLayoutConstraint(item: playerVC.view, attribute: .bottom, relatedBy: .equal, toItem: self.viewHeader, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        imBackground.isHidden = true
        btnPlay.isHidden = true
        
    }
    
    func pauseorStart(isPause: Bool){
        print(isPause)
        //        if isPause {
        //            vc.presentAd()
        //        }else {
        //            vc.interstitial = vc.createAdmob()
        //        }
    }
    func fullScreen(isFull: Bool) {
        if isFull {
            setLanscape()
            
        }else {
            
            setPortrait()
            
        }
    }
    func setLanscape() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        self.navigationItem.hidesBackButton = true
        
    }
    func setPortrait() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
        self.navigationItem.hidesBackButton = false
        
    }
    
}
extension MoviePlayer: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension MoviePlayer: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "CellMess") as! CellForMessage
        if let mess: MessageDetail =  data[indexPath.row] {
            cell.nameCell.text = mess.name
            cell.contentCell.text = mess.coment
            cell.timeCell.text = mess.time
            if let path = data[indexPath.row].image_path {
                super.loadImage(url_image: URL(string: path.fromBase64()!), imageView: cell.imageCell, key: "\(mess.uid!)")
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
}
extension String {
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    
}
extension MoviePlayer: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////        if tvComment.isEqual("/n") || text == "\n"{
////            tvComment.resignFirstResponder()
////            return false
////        }
//        return true
//    }
}

