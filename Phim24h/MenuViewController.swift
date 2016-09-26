//
//  MenuViewController.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case home = 0
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
    
    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    var homeVC: UINavigationController!
    var upComing: UIViewController!
    var topRated: UIViewController!
    var popular: UIViewController!
    var nowPlaying: UIViewController!
    
    var menus = [DataTableViewCellData(imageUrl: "home", text: "Trang chủ"),
                 DataTableViewCellData(imageUrl: "film", text: "Up Coming"),
                 DataTableViewCellData(imageUrl: "film", text: "Top Rated"),
                 DataTableViewCellData(imageUrl: "film", text: "Popular"),
                 DataTableViewCellData(imageUrl: "film", text: "Now Playing"),
                 DataTableViewCellData(imageUrl: "logout", text: "Đăng xuất")]
    
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
        self.profileName.text = "Nguyễn Văn A"
        self.profileImage.image = UIImage(named: "haha")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.clear
        self.myTable.backgroundColor = UIColor.clear
        addItemsForMenu()
        
    }
    func addItemsForMenu(){
//        let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
//        self.homeVC = UINavigationController(rootViewController: home)
        
        let upComing = UpComing(nibName: "UpComing", bundle: nil)
        upComing.data_key = ManagerData.UPCOMING
        upComing.data_title = "aa"
        self.upComing = UINavigationController(rootViewController: upComing)
        
        let topRated = TopRated(nibName: "TopRated", bundle: nil)
        self.topRated = UINavigationController(rootViewController: topRated)
        
        let popular = Popular(nibName: "Popular", bundle: nil)
        self.popular = UINavigationController(rootViewController: popular)
        
        let nowPlaying = NowPlaying(nibName: "NowPlaying", bundle: nil)
        self.nowPlaying = UINavigationController(rootViewController: nowPlaying)
        
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
            self.slideMenuController()?.changeMainViewController(self.homeVC, close: true)
        case .upComing:
            let upComing = UpComing(nibName: "UpComing", bundle: nil)
            upComing.data_key = ManagerData.UPCOMING
//            if let nav = self.navigationController
//            {
//                
//            }
            self.slideMenuController()?.changeMainViewController(self.upComing, close: true)
        case .topRated:
            self.slideMenuController()?.changeMainViewController(self.topRated, close: true)
        case .popular:
            self.slideMenuController()?.changeMainViewController(self.popular, close: true)
        case .nowPlaying:
            self.slideMenuController()?.changeMainViewController(self.nowPlaying, close: true)
        case .logout:
            self.dismiss(animated: true, completion: nil)
            let userDefault = UserDefaults.standard
            userDefault.set(nil, forKey: LoginAccount.KEY_USER)
            userDefault.set(nil, forKey: LoginAccount.KEY_PASS)
            
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
