//
//  ResetPassword.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Firebase
import OEANotification
class ResetPassword: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var lbComfirm: UILabel!
    
    @IBOutlet weak var tfComfirm: UITextField!

    
    @IBOutlet weak var tfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        customRadiusTextField()
        OEANotification.setDefaultViewController(self)
        lbComfirm.text = randomText()
    }
    @IBAction func btnRefesh(_ sender: UIButton) {
        lbComfirm.text = randomText()
    }
    override func viewDidLayoutSubviews() {
//        if (tfEmail == nil){
//            customRadiusTextField()
//        }
    }
    
    func resetSuccess(){
        
        OEANotification.notify("Reset password success !", subTitle: "password returned your email ", image: nil, type: .success, isDismissable: false, completion: { () -> Void in
            self.result.text = "password returned your email"
            }, touchHandler: nil)
    }
    func resetError(error: String){
        
        OEANotification.notify("Reset password fail", subTitle: error, type: NotificationType.warning, isDismissable: true)
    }
    func customRadiusTextField(){
        tfEmail.addIconTextField(tfEmail, stringImage: "user")
        
        
        tfEmail.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func dimissToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnResetPass(_ sender: UIButton) {
        if let mEmail = tfEmail.text {
            if mEmail == "" || tfComfirm.text != lbComfirm.text{
                self.resetError(error: "email or string comfirm is empty")

            }
            if (mEmail != "" && tfComfirm.text == lbComfirm.text){
                FIRAuth.auth()?.sendPasswordReset(withEmail: mEmail, completion: { error in
                    if let error = error {
                       self.resetError(error: error.localizedDescription)
                    }
                    else{
                       self.resetSuccess()
                    }
                    
                })
            }
        }
        
    }
    
    func randomText() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: 6)
        
        for index in 0...5{
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
    
//    func showAlert(_ mess: String) {
//        let alert = UIAlertController(title: "Thông báo", message: mess, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)    }

   
}
