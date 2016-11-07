//
//  RegisterAccount.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Firebase
import OEANotification
class RegisterAccount: UIViewController {
    
    @IBOutlet weak var tfUser: UITextField!
    
    @IBOutlet weak var tfPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfUser.delegate = self
        tfPass.delegate = self
        OEANotification.setDefaultViewController(self)
        customRadiusTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    override func viewDidLayoutSubviews() {
//        if (tfUser == nil && tfPass == nil){
//            customRadiusTextField()
//        }
    }
    func signUpSuccess(){
        OEANotification.notify("Sign Up success !", subTitle: "Welcome to Phim24h .... ", image: nil, type: .success, isDismissable: false, completion: { () -> Void in
            print("completed")
            }, touchHandler: nil)
    }
    func signUpError(error: String){
        
        OEANotification.notify("Sign Up fail", subTitle: error, type: NotificationType.warning, isDismissable: true)
    }
    
    func customRadiusTextField(){
        tfUser.addIconTextField(tfUser, stringImage: "user")
        
        tfPass.addIconTextField(tfPass, stringImage: "pass")
        tfPass.delegate = self
        tfUser.delegate = self
    }
    @IBAction func dimissToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnRegister(_ sender: UIButton) {
        if let mEmail = tfUser.text , let mPass = tfPass.text{
            if mEmail == "" || mPass == "" {
                signUpError(error: "please check your email or password")
            }else if (mPass.length < 6){
                signUpError(error: "password too short")
            } else{
                FIRAuth.auth()?.createUser(withEmail: mEmail, password: mPass, completion: { (user, error) in
                    if error != nil {
                        self.signUpError(error: (error?.localizedDescription)!)
                    }else{
                        self.signUpSuccess()
                    }
                    
                })
            }
        }
    }
    
}
extension RegisterAccount: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 101 {
            tfUser.backgroundColor = UIColor.white
        }else {
            tfPass.backgroundColor = UIColor.white
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 101 {
            tfUser.backgroundColor = UIColor(hex: "#cccccc")
        }else {
            tfPass.backgroundColor = UIColor(hex: "#cccccc")
        }
    }
}
