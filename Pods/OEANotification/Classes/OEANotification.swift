//
//  OEANotification.swift
//  OEANotification
//
//  Created by Ömer Emre Aslan on 15/11/15.
//  Copyright © 2015 omer. All rights reserved.
//

import UIKit

open class OEANotification : UIView {
    
    static let constant = Constants()
    static var rect = CGRect(x: constant.nvMarginLeft, y: constant.nvStartYPoint, width: OEANotification.viewController.view.frame.width - constant.nvMarginLeft - constant.nvMarginRight, height: constant.nvHeight)
    static var viewController: UIViewController!
    static var notificationCount = 0
    static var rotated:Bool = false
    
    // MARK: - Initial notification methods
    
     /**
     Initial static method of creating notification.
     
     - since:                   0.1.0
     - author:                  @OEASLAN - omeremreaslan@gmail.com
     - parameter title:         The title of notification.
     - parameter subTitle:      The subtitle of notification.
     - parameter type:          The type of notification which are Success, Warning, and Info.
     - parameter isDismissable: The notification center from which the notification should be dispatched.
     - return:                  void
     */
    static open func notify(
        _ title: String,
        subTitle: String,
        type: NotificationType,
        isDismissable: Bool
        ){
            self.notify(title, subTitle: subTitle, image: nil, type: type, isDismissable: isDismissable)
    }
    
    /**
     Initial static method of creating notification.
     
     - since:                   0.1.0
     - author:                  @OEASLAN - omeremreaslan@gmail.com
     - parameter title:         The title of notification.
     - parameter subTitle:      The subtitle of notification.
     - parameter type:          The type of notification which are Success, Warning, and Info.
     - parameter image:         The main icon image of notification like avatar, success, warning etc. icons
     - parameter isDismissable: The notification center from which the notification should be dispatched.
     - return:                  void
     */
    static open func notify(
        _ title: String,
        subTitle: String,
        image: UIImage?,
        type: NotificationType,
        isDismissable: Bool
        ) {
            
            self.notify(title, subTitle: subTitle, image: image, type: type, isDismissable: isDismissable, completion: nil, touchHandler: nil)
    }
    
    /**
     Initial static method of creating notification.
     
     - since:                   0.1.0
     - author:                  @OEASLAN - omeremreaslan@gmail.com
     - parameter title:         The title of notification.
     - parameter subTitle:      The subtitle of notification.
     - parameter type:          The type of notification which are Success, Warning, and Info.
     - parameter image:         The main icon image of notification like avatar, success, warning etc. icons
     - parameter completion:    The main icon image of notification like avatar, success, warning etc. icons
     - parameter isDismissable: The notification center from which the notification should be dispatched.
     - return:                  void
     */
    static open func notify(
        _ title: String,
        subTitle: String,
        image: UIImage?,
        type: NotificationType,
        isDismissable: Bool,
        completion: (() -> Void)?,
        touchHandler: (() ->Void)?
        ) {
            let notificationView: NotificationView = NotificationView(
                frame: rect,
                title: title,
                subTitle: subTitle,
                image: image,
                type: type,
                completionHandler: completion,
                touchHandler: touchHandler,
                isDismissable: isDismissable
            )
            
            OEANotification.notificationCount += 1
            OEANotification.removeOldNotifications()
            
            print(OEANotification.viewController.view.frame)
            if OEANotification.viewController.navigationController != nil {
                OEANotification.viewController.navigationController!.view.addSubview(notificationView)
            } else {
                OEANotification.viewController.view.addSubview(notificationView)
            }
    }
    
    /**
     Sets the default view controller as a main view controller.
     
     - since:                    0.1.0
     - author:                   @OEASLAN - omeremreaslan@gmail.com
     - parameter viewController: The main controller which shows the notification.
     - return:                   void

     */
    static open func setDefaultViewController (_ viewController: UIViewController) {
        self.viewController = viewController
        NotificationCenter.default.addObserver(self, selector: #selector(OEANotification.rotateRecognizer), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    // MARK: - Helper methods
    static open func removeOldNotifications() {
        if OEANotification.viewController.navigationController != nil {
            for subUIView in OEANotification.viewController.navigationController!.view.subviews as [UIView] {
                if subUIView.isKind(of: NotificationView.self) {
                    let view: NotificationView = subUIView as! NotificationView
                    view.notificationTimer.invalidate()
                    subUIView.removeFromSuperview()
                    OEANotification.notificationCount -= 1
                }
            }
        } else {
            for subUIView in OEANotification.viewController.view.subviews as [UIView] {
                if subUIView.isKind(of: NotificationView.self) {
                    let view: NotificationView = subUIView as! NotificationView
                    view.notificationTimer.invalidate()
                    subUIView.removeFromSuperview()
                    OEANotification.notificationCount -= 1
                }
            }
        }
    }
    
    // Close active notification
    static open func closeNotification() {
        if OEANotification.viewController.navigationController != nil {
            for subUIView in OEANotification.viewController.navigationController!.view.subviews as [UIView] {
                if subUIView.isKind(of: NotificationView.self) {
                    let view: NotificationView = subUIView as! NotificationView
                    view.close()
                }
            }
        } else {
            for subUIView in OEANotification.viewController.view.subviews as [UIView] {
                if subUIView.isKind(of: NotificationView.self) {
                    let view: NotificationView = subUIView as! NotificationView
                    view.close()
                }
            }
        }
    }
    
    
    // Checking device's rotation process and remove notifications to handle UI conflicts.
    static open func rotateRecognizer() {
        removeOldNotifications()
        UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelNormal
        self.rect = CGRect(x: constant.nvMarginLeft, y: constant.nvStartYPoint, width: OEANotification.viewController.view.frame.width - constant.nvMarginLeft - constant.nvMarginRight, height: constant.nvHeight)
    }
    
    
}

public enum NotificationType {
    case warning
    case success
    case info
}



