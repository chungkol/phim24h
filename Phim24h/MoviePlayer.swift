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
class MoviePlayer: BaseDetailViewController {
    
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imBackground: UIImageView!
    var flag: Bool = false
    
    var trailer: Trailer!
    var img_path: String!
    let video_Path = "https://www.youtube.com/watch?v="
    var videoURL: String!
    
    let videoID = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        self.titleMovie.text = trailer.name
        if let path = img_path {
            let pathImage = "https://image.tmdb.org/t/p/original\(path)"
            imBackground.kf.setImage(with: URL(string: pathImage), placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { error in
                self.loading.isHidden = true
                self.loading.stopAnimating()
            })
            
        }
        videoURL = "\(video_Path)\(trailer.key!)"
        print(videoURL)
        
        
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
        
        btnPlay.setImage(UIImage(named: "play_w"), for: .normal)
        let playerVC = MobilePlayerViewController(contentURL: NSURL(string: videoURL) as! URL)
        playerVC.title = "\(trailer.name!)"
        playerVC.activityItems = [NSURL(string: videoURL)!]
        presentMoviePlayerViewControllerAnimated(playerVC)
        
        UIView.animate(withDuration: 3, animations: {
            self.btnPlay.isHidden = true
        })
        
    }
    
    
    
}
