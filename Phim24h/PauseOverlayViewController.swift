//
//  PauseOverlayViewController.swift
//  Phim24h
//
//  Created by Chung on 10/26/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import MobilePlayer
import GoogleMobileAds
let AD_UNIT_ID = "ca-app-pub-5462423330690799/5782889860"

class PauseOverlayViewController: MobilePlayerOverlayViewController , GADBannerViewDelegate{
    
    
    @IBOutlet weak var viewParent: UIView!
    
    var banner : GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        addBanner()
    }
    func addBanner() {
        if banner == nil {
            banner = GADBannerView(adSize: kGADAdSizeBanner)
            banner.delegate = self
            banner.adUnitID = AD_UNIT_ID
            banner.rootViewController = self
            let request = GADRequest()
            request.testDevices = [ kGADSimulatorID, "5CD77068EE8F436F957652236AD6A777" ]
            banner.load(request)
            self.viewParent.addSubview(banner)
            
            
            
            
        }
    }
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
            }
    func adView(bannerView: GADBannerView!,
                didFailToReceiveAdWithError error: GADRequestError!) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    }
