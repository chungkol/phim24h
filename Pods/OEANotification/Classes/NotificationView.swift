//
//  NotificationView.swift
//  OEANotification
//
//  Created by Ömer Emre Aslan on 24/11/15.
//  Copyright © 2015 omer. All rights reserved.
//

import Foundation
import UIKit

class NotificationView : UIView{
    let bundle = Bundle(identifier: "com.omer.OEANotification")
    var notificationTimer: Timer!
    var title: String?
    var subTitle: String?
    var image: UIImage?
    var type: NotificationType?
    var isDismissable: Bool = false
    let constants: Constants = Constants()
    var completionHandler:(() -> Void)?
    var touchHandler:(() -> Void)?
    
    init(frame: CGRect, title: String, subTitle: String?, type: NotificationType?, isDismissable: Bool) {
        super.init(frame: frame)
        self.initVariables(title, subTitle: subTitle, image: nil, type: type, completionHandler: nil, touchHandler: nil, isDismissable: isDismissable)
        self.setupNotification()
       
    }
    
    init(frame: CGRect, title: String, subTitle: String?, image: UIImage?, type: NotificationType?, isDismissable: Bool) {
        super.init(frame: frame)
        self.initVariables(title, subTitle: subTitle, image: image, type: type, completionHandler: nil, touchHandler: nil, isDismissable: isDismissable)
        self.setupNotification()
    }
    
    init(frame: CGRect, title: String, subTitle: String?, image: UIImage?, type: NotificationType?, completionHandler: (() -> Void)?, isDismissable: Bool) {
        super.init(frame: frame)
        self.initVariables(title, subTitle: subTitle, image: image, type: type, completionHandler: completionHandler, touchHandler: nil, isDismissable: isDismissable)
        self.setupNotification()
    }
    
    init(frame: CGRect, title: String, subTitle: String?, image: UIImage?, type: NotificationType?, completionHandler: (() -> Void)?, touchHandler: (() -> Void)?, isDismissable: Bool) {
        super.init(frame: frame)
        
        self.initVariables(title, subTitle: subTitle, image: image, type: type, completionHandler: completionHandler, touchHandler: touchHandler, isDismissable: isDismissable)
        self.setupNotification()
    }
    
    fileprivate func initVariables(_ title: String, subTitle: String?, image: UIImage?, type: NotificationType?, completionHandler: (() -> Void)?, touchHandler: (() -> Void)?, isDismissable: Bool) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.type = type
        self.completionHandler = completionHandler
        self.touchHandler = touchHandler
        self.isDismissable = isDismissable
        
    }
    
    fileprivate func setupNotification() {
        
        self.createBackground()
        if self.isDismissable {
            constants.nvPaddingRight += constants.nvdWidth
            self.createCloseButton()
            constants.nvPaddingRight += constants.nvdPaddingLeft
        }
        
        if self.image != nil {
            self.createImageView()
        }
        
        self.createTitleLabel()
        constants.nvPaddingTop += constants.nvtPaddingTop
        self.createSubtitleLabel()
        
        if self.isDismissable {
            constants.nvPaddingRight -= constants.nvdPaddingLeft
        }
        
        if self.touchHandler != nil {
            self.createTouchEvent()
        }
        self.addNotificationView()
    }
    
    fileprivate func createTouchEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(NotificationView.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        self.touchHandler!()
    }
    
    fileprivate func addNotificationView() {
        NotificationView.animate(withDuration: constants.nvaTimer, animations: { () -> Void in
            self.frame.origin.y = self.constants.nvMarginTop
            
            }, completion: { (flag) -> Void in
                if flag {
                    if self.completionHandler != nil {
                        self.completionHandler!()
                    }
                }
                
        }) 
        
        self.addTimer(constants.nvaShownTimer)
        UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelStatusBar+1
        

    }
    
    fileprivate func createBackground() {
        if type == NotificationType.success {
            self.backgroundColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)

        } else if type == NotificationType.warning {
            self.backgroundColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)

        } else if type == NotificationType.info {
            self.backgroundColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1)

        }
    }
    
    fileprivate func createTitleLabel() {
        let label = UILabel()
        label.frame = CGRect(x: constants.nvPaddingLeft, y: constants.nvPaddingTop, width: self.frame.width - constants.nvPaddingLeft - constants.nvPaddingRight, height: constants.nvtHeight)
        label.textAlignment = NSTextAlignment.left
        label.text = self.title
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textColor = UIColor.white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 1
        self.addSubview(label)
    }
    
    fileprivate func createSubtitleLabel() {
        let subLabel = UILabel()
        subLabel.frame = CGRect(x: constants.nvPaddingLeft, y: constants.nvPaddingTop, width: self.frame.width - constants.nvPaddingLeft - constants.nvPaddingRight, height: constants.nvtHeight)
        subLabel.textAlignment = NSTextAlignment.left
        subLabel.text = self.subTitle
        subLabel.font = UIFont(name: "Helvetica", size: 9)
        subLabel.textColor = UIColor.white
        subLabel.layer.shadowColor = UIColor.black.cgColor
        subLabel.layer.shadowOpacity = 1
        subLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        subLabel.layer.shadowOpacity = 0.8
        subLabel.layer.shadowRadius = 1
        self.addSubview(subLabel)
    }
    
    fileprivate func createImageView() {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: constants.nvPaddingLeft, y: constants.nvPaddingTop, width: constants.nviHeight, height: constants.nviWidth))
        constants.nvPaddingLeft += constants.nviPaddingLeft
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = image
        self.addSubview(imageView)
    }
    
    fileprivate func createCloseButton() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "OEANotification", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let closeButton = UIButton()
                closeButton.frame = CGRect(x: self.frame.width - constants.nvPaddingRight, y: constants.nvdPaddingTop, width: constants.nvdHeight, height: constants.nvdWidth)
                closeButton.setImage(UIImage(named: "close", in: bundle, compatibleWith: nil), for: UIControlState())
                closeButton.addTarget(self, action: #selector(NotificationView.close), for: .touchDown)
                self.addSubview(closeButton)
            }
        }
    }
    
    fileprivate func addTimer(_ time: Double) {
        self.notificationTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(NotificationView.close), userInfo: nil, repeats: false)

    }
  
    
    func close() {
        self.notificationTimer.invalidate()
       
        NotificationView.animate(withDuration: constants.nvaTimer, animations: { () -> Void in
                self.frame.origin.y = self.constants.nvStartYPoint
            }, completion: { (Bool) -> Void in
                if OEANotification.notificationCount == 1 {
                    UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelNormal
                    OEANotification.removeOldNotifications()
                }
        }) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
