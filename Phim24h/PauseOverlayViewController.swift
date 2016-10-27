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
let AD_UNIT_ID = "ca-app-pub-5462423330690799/2209131460"
class PauseOverlayViewController: MobilePlayerOverlayViewController,GADInterstitialDelegate{
    var interstitial: GADInterstitial!
    var times = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interstitial = createAdmob()
    }
    
    func createAdmob() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: AD_UNIT_ID)
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    
    func presentAd()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            }else {
                self.times = self.times + 1
                if (self.times == 5)
                {
                    return
                }
                self.presentAd()
            }
        }
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        self.interstitial = createAdmob()
        
    }
    
}
