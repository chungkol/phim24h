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
    case phimBo
    case logout
//    case sensor
//    case logOut
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class MenuViewController: BaseViewController , LeftMenuProtocol{
    
    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var backgroundProfile: UIImageView!
    @IBOutlet weak var progileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    var homeVC: UIViewController!
    var phimBo: UIViewController!
    
    var menus = [DataTableViewCellData(imageUrl: "MonitorFarm", text: "Trang chủ"),
                 DataTableViewCellData(imageUrl: "ViewAlert", text: "Phim Bộ"),
                 DataTableViewCellData(imageUrl: "LogOut", text: "Đăng xuất")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTable.delegate = self
        self.myTable.dataSource = self
        self.myTable.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
  
        self.progileImage.layoutIfNeeded()
        self.progileImage.layer.cornerRadius = self.progileImage.bounds.size.height / 2
        self.progileImage.clipsToBounds = true
        self.progileImage.layer.borderWidth = 1
        self.progileImage.layer.borderColor = UIColor.white.cgColor
        self.profileName.text = "Nguyễn Văn A"
        self.progileImage.image = UIImage(named: "haha")
        self.backgroundProfile.image = UIImage(named: "background.jpg")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addItemsForMenu()
        
    }
    func addItemsForMenu(){
        let phimBo = PhimBo(nibName: "PhimBo", bundle: nil)
        self.phimBo = UINavigationController(rootViewController: phimBo)
        let home = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.homeVC = UINavigationController(rootViewController: home)
    }
    
    func changeViewController(_ menu: LeftMenu) {
                switch menu {
                case .home:
                    self.slideMenuController()?.changeMainViewController(self.homeVC, close: true)
                case .phimBo:
                    self.slideMenuController()?.changeMainViewController(self.phimBo, close: true)
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
        cell.setData(menus[indexPath.row])
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row){
            self.changeViewController(menu)
            print(menu)
        }
    }
    
}
