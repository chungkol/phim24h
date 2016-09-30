//
//  BaseDetailViewController.swift
//  Phim24h
//
//  Created by Chung on 9/29/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import UIKit
open class BaseDetailViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.automaticallyAdjustsScrollViewInsets = false
        
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
    
}
