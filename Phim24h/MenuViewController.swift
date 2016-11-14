//
//  MenuViewController.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FBSDKLoginKit
import GoogleSignIn

enum LeftMenu: Int {
    case home = 0
    case favorite
    case genre
    case upComing
    case topRated
    case popular
    case nowPlaying
    case logout
    
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class MenuViewController: BaseViewController , LeftMenuProtocol{
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    var userData = UserData.instance
    var homeVC: UIViewController!
    var favoriteVC: UIViewController!
    var upComing: UIViewController!
    var topRated: UIViewController!
    var popular: UIViewController!
    var nowPlaying: UIViewController!
    var genre: UIViewController!
    
    var menus = [DataTableViewCellData(imageUrl: "home", text: "Home"),
                 DataTableViewCellData(imageUrl: "star_fill", text: "Favorite"),
                 DataTableViewCellData(imageUrl: "film", text: "Genre"),
                 DataTableViewCellData(imageUrl: "film", text: "Up Coming"),
                 DataTableViewCellData(imageUrl: "film", text: "Top Rated"),
                 DataTableViewCellData(imageUrl: "film", text: "Popular"),
                 DataTableViewCellData(imageUrl: "film", text: "Now Playing"),
                 DataTableViewCellData(imageUrl: "logout", text: "Logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTable.delegate = self
        self.myTable.dataSource = self
        self.myTable.register(UINib(nibName: "DataTableViewCell", bundle: nil),
                              
                              forCellReuseIdentifier: "Cell")
        
        self.profileImage.layoutIfNeeded()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        let user = userData.user
        profileName.text = user?.email
        if let url_image = user?.url_image {
//            profileImage.kf.setImage(with: url_image, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            super.loadImage(url_image: url_image, imageView: profileImage, key: "\(user?.uid!)")
        }else {
            profileImage.image = UIImage(named: "haha")
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.clear
        self.myTable.backgroundColor = UIColor.clear
        addItemsForMenu()
        
    }
    func addItemsForMenu(){
        let favoriteVC = TableWithPage(nibName: "TableWithPage", bundle: nil)
    
        favoriteVC.data_title = "Favorite"
        favoriteVC.type = 3
        self.favoriteVC = favoriteVC
        
        self.genre = GenreViewController(nibName: "GenreViewController", bundle: nil)
        
        let upComing = UpComing(nibName: "UpComing", bundle: nil)
        upComing.type = 1
        upComing.data_key = ManagerData.UPCOMING
        upComing.data_title = "Up Comming"
        self.upComing = upComing
        
        let topRated = TopRated(nibName: "TopRated", bundle: nil)
        topRated.type = 1
        topRated.data_key = ManagerData.TOP_RATED
        topRated.data_title = "Top Rated"
        self.topRated = topRated
        
        let popular = Popular(nibName: "Popular", bundle: nil)
        popular.type = 1
        popular.data_key = ManagerData.POPULAR
        popular.data_title = "Popular"
        self.popular = popular
        
        let nowPlaying = NowPlaying(nibName: "NowPlaying", bundle: nil)
        nowPlaying.type = 1
        nowPlaying.data_key = ManagerData.NOW_PLAYING
        nowPlaying.data_title = "Now Playing"
        self.nowPlaying = nowPlaying
        
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
            self.slideMenuController()?.changeMainViewController(self.homeVC, close: true)
        case .favorite:
            self.slideMenuController()?.changeMainViewController(self.favoriteVC, close: true)

        
        case .genre:
            self.slideMenuController()?.changeMainViewController(self.genre, close: true)
        case .upComing:
            self.slideMenuController()?.changeMainViewController(self.upComing, close: true)
        case .topRated:
            self.slideMenuController()?.changeMainViewController(self.topRated, close: true)
        case .popular:
            self.slideMenuController()?.changeMainViewController(self.popular, close: true)
        case .nowPlaying:
            self.slideMenuController()?.changeMainViewController(self.nowPlaying, close: true)
        case .logout:
            let type = userData.user?.type
            if type == "firebase" {
                let userDefault = UserDefaults.standard
                userDefault.set(nil, forKey: LoginAccount.KEY_USER)
                userDefault.set(nil, forKey: LoginAccount.KEY_PASS)
            }
            if type == "google" {
                GIDSignIn.sharedInstance().signOut()
            }
            if type == "facebook" {
                FBSDKLoginManager().logOut()
            }
            try! FIRAuth.auth()!.signOut()
            self.dismiss(animated: true, completion: nil)
            userData.user = nil
            
            
        }
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
}
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DataTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.setData(menus[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row){
            
            self.changeViewController(menu)
            
            print(menu)
        }
    }
    
}
