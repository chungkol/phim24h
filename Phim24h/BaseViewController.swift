//
//  BaseViewController.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.automaticallyAdjustsScrollViewInsets = false
        addLeftButton()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
    }
    open override var shouldAutorotate: Bool {
        return false
    }
    open func setTitForView(_ title: String)
    {
        self.navigationItem.title = title
    }
    
    open func  addLeftButton(){
        
        
        let leftNav = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(BaseViewController.showMenu))
        self.navigationItem.leftBarButtonItem = leftNav
        let rightNav = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(BaseViewController.showSearch))
        self.navigationItem.rightBarButtonItem = rightNav
    }
    func showMenu(){
        slideMenuController()?.toggleLeft()
        print("menu")
    }
    func showSearch(){
        print("search")
        
    }
    
    
}
