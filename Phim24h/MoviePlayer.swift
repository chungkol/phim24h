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
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tvComment: CustomTextView!
    
    @IBOutlet weak var btnPost: CustomButtonWithBoderGray!
    
    @IBOutlet weak var viewForComment: UIView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imBackground: UIImageView!
    var flag: Bool = false
    var ref : FIRDatabaseReference!
    //    var storage: FIRS
    var layoutTop,layoutLeft,layoutRight,layoutBot: NSLayoutConstraint!
    var trailer: Trailer!
    var img_path: String!
    let video_Path = "https://www.youtube.com/watch?v="
    var videoURL: String!
    var id_film : Int!
    let videoID = "1"
    var treeView : UITableView!
    var data : [MessageDetail] = []
    var messageDetail: [MessageDetail] = []
    
    var vc: PauseOverlayViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        addTreeTable()
        ref = FIRDatabase.database().reference()
        
        loading.startAnimating()
        self.titleMovie.text = trailer.name
        if let path = img_path {
            let pathImage = "https://image.tmdb.org/t/p/original\(path)"
            imBackground.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
                self.loading.isHidden = true
                self.loading.stopAnimating()
            })
            
        }
        getdata()
        videoURL = "\(video_Path)\(trailer.key!)"
        print(videoURL)
        
        
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
                        self.treeView.reloadData()
                        let oldLastCellIndexPath = NSIndexPath(row: self.data.count - 1, section: 0)
                        self.treeView.scrollToRow(at: oldLastCellIndexPath as IndexPath, at: .bottom, animated: true)
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
    
    func addTreeTable() {
        if treeView == nil {
            treeView = UITableView(frame: viewForComment.bounds)
            treeView.register(UINib.init(nibName: "CellForMessage", bundle: nil), forCellReuseIdentifier: "CellMess")
            treeView.delegate = self;
            treeView.dataSource = self;
            treeView.separatorColor = UIColor.clear
            treeView.backgroundColor = UIColor.clear
            viewForComment.addSubview(treeView)
            treeView.translatesAutoresizingMaskIntoConstraints = false
            
            layoutTop = NSLayoutConstraint(item: treeView, attribute: .top, relatedBy: .equal, toItem: self.viewForComment, attribute: .top, multiplier: 1.0, constant: 8)
            
            layoutLeft = NSLayoutConstraint(item: treeView, attribute: .leading, relatedBy: .equal, toItem: self.viewForComment, attribute: .leading, multiplier: 1.0, constant: 8)
            
            layoutRight = NSLayoutConstraint(item: treeView, attribute: .trailing, relatedBy: .equal, toItem: self.viewForComment, attribute: .trailing, multiplier: 1.0, constant: 8)
            
            layoutBot = NSLayoutConstraint(item: treeView, attribute: .bottom, relatedBy: .equal, toItem: self.viewForComment, attribute: .bottom, multiplier: 1.0, constant: 8)
            
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //        UIDevice.current.setValue(value, forKey: "orientation")
        
        btnPlay.setImage(UIImage(named: "play_w"), for: .normal)
        self.btnPlay.isHidden = false
        
    }
    open override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeLeft
    }
    @IBAction func btnPlay(_ sender: UIButton) {
        vc = PauseOverlayViewController()
        btnPlay.setImage(UIImage(named: "play_w"), for: .normal)
        let playerVC = MobilePlayerViewController(contentURL: NSURL(string: videoURL) as! URL, pauseOverlayViewController: vc)
        playerVC.delegateCustom = self
        playerVC.title = "\(trailer.name!)"
        playerVC.fullScreen(isFull: true)
        playerVC.getViewForElementWithIdentifier("share")?.isHidden = true
        playerVC.activityItems = [NSURL(string: videoURL)!]
        self.viewHeader.addSubview(playerVC.view)
        playerVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        layoutTop = NSLayoutConstraint(item: playerVC.view, attribute: .top, relatedBy: .equal, toItem: self.viewHeader, attribute: .top, multiplier: 1.0, constant: 0)
        
        layoutLeft = NSLayoutConstraint(item: playerVC.view, attribute: .leading, relatedBy: .equal, toItem: self.viewHeader, attribute: .leading, multiplier: 1.0, constant: 0)
        
        layoutRight = NSLayoutConstraint(item: playerVC.view, attribute: .trailing, relatedBy: .equal, toItem: self.viewHeader, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        layoutBot = NSLayoutConstraint(item: playerVC.view, attribute: .bottom, relatedBy: .equal, toItem: self.viewHeader, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutRight, layoutBot])
        
        
        //        presentMoviePlayerViewControllerAnimated(playerVC)
        //        UIView.animate(withDuration: 3, animations: {
        //            self.btnPlay.isHidden = true
        //        })
        
    }
    
    func pauseorStart(isPause: Bool){
        if isPause {
            vc.presentAd()
        }else {
            vc.interstitial = vc.createAdmob()
        }
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
        let cell = treeView.dequeueReusableCell(withIdentifier: "CellMess") as! CellForMessage
        if let mess: MessageDetail =  data[indexPath.row] {
            cell.nameCell.text = mess.name
            cell.contentCell.text = mess.coment
            cell.timeCell.text = mess.time
            if let path = data[indexPath.row].image_path {
                cell.imageCell.kf.setImage(with: URL(string: path.fromBase64()!), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
                
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
