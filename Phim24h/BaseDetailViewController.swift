//
//  BaseDetailViewController.swift
//  Phim24h
//
//  Created by Chung on 9/29/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
open class BaseDetailViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
        KingfisherManager.shared.downloader.downloadTimeout = 30
       
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
    }
    open func loadImage(url_image: URL?, imageView: UIImageView, key: String?) {
         imageView.image = UIImage(named: "haha")
        if KingfisherManager.shared.cache.isImageCached(forKey: key!).cached {
            KingfisherManager.shared.cache.retrieveImage(forKey: key!, options: nil) { (Image, CacheType) -> () in
                if Image != nil {
                    imageView.image = Image
                }else {
                    imageView.image = UIImage(named: "haha")
                }
            }
        }else {
            imageView.kf.indicatorType = .activity
            imageView.kf.indicator?.startAnimatingView()
            self.downloadImage(url_image: url_image!, imageView: imageView, key: key! )
        }
        
    }
    
    open func downloadImage(url_image: URL, imageView: UIImageView, key: String?) {
        imageView.image = UIImage()
        KingfisherManager.shared.downloader.downloadImage(with: url_image, options: [KingfisherOptionsInfoItem.cacheMemoryOnly], progressBlock: {receivedSize, totalSize in
            print("\(key!): \(receivedSize)/\(totalSize)")
            }, completionHandler: { (image, error, url, data) -> () in
            if image != nil && url != nil {
                if let resizeImage = (image?.kf.resize(to: CGSize(width: imageView.frame.size.width + 50, height: imageView.frame.size.height + 50)))
                {
                    KingfisherManager.shared.cache.store(resizeImage, forKey: key!)
                    imageView.image = resizeImage
                    imageView.kf.indicator?.stopAnimatingView()
                }
            }else {
                imageView.image = UIImage(named: "haha")
                imageView.kf.indicator?.stopAnimatingView()
                
            }
        })
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
//    override open var shouldAutorotate: Bool{
//        if
//        get{
//            return false
//        }
//    }
//    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }

    
}
