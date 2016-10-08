//
//  ResetPassword.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Firebase
class ResetPassword: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        customRadiusTextField()
        // Do any additional setup after loading the view.
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
            if mEmail == ""{
                showAlert("Bạn chưa nhập email")
            }else{
                FIRAuth.auth()?.sendPasswordReset(withEmail: mEmail, completion: { error in
                    if let error = error {
                        self.showAlert("error \(error)")
                    }
                    else{
                        self.showAlert("Password mới được gửi về email")
                    }
                    
                })
            }
        }
        
    }
    
  
    
    func showAlert(_ mess: String) {
        let alert = UIAlertController(title: "Thông báo", message: mess, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)    }

   
}
