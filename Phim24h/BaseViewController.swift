//
//  BaseViewController.swift
//  iFram
//
//  Created by Tuuu on 8/31/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
open class BaseViewController: UIViewController {
    var current = 0
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.automaticallyAdjustsScrollViewInsets = false
        addLeftButton()
        KingfisherManager.shared.downloader.downloadTimeout = 30
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
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    open func setTitForView(_ title: String)
    {
        self.navigationItem.title = title
    }
    
    open func  addLeftButton(){
        
        
        let leftNav = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(BaseViewController.showMenu))
        self.navigationItem.leftBarButtonItem = leftNav
        
    }
    func showMenu(){
        slideMenuController()?.toggleLeft()
        print("menu")
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    func loadImage(url_image: URL?, imageView: UIImageView, key: String?) {
        
        KingfisherManager.shared.cache.retrieveImage(forKey: key!, options: nil) { (Image, CacheType) -> () in
            //            imageView.image = UIImage(named: "haha")
            if Image != nil {
                imageView.image = Image
            } else {
                imageView.kf.indicatorType = .activity
                imageView.kf.indicator?.startAnimatingView()
                imageView.image = UIImage(named: "haha")
                
                self.downloadImage(url_image: url_image!, imageView: imageView, key: key )
                
            }
            
        }}
    
    func downloadImage(url_image: URL, imageView: UIImageView, key: String?) {
        
        KingfisherManager.shared.downloader.downloadImage(with: url_image, options: nil, progressBlock: nil, completionHandler: { (image, error, url, data) -> () in
            //            DispatchQueue.main.async {
            //                        self.collectionCell.reloadData()
            imageView.kf.indicator?.stopAnimatingView()
            //            }
            if image != nil {
                if let resizeImage = (image?.kf.resize(to: CGSize(width: imageView.frame.size.width + 50, height: imageView.frame.size.height + 50)))
                {
                    print(key)
                    KingfisherManager.shared.cache.store(resizeImage, forKey: key!)
                    imageView.image = resizeImage
                    
                    
                    
                    
                }
            }
            
            
        })
    }
    
}
