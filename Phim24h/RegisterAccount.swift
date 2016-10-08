//
//  RegisterAccount.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Firebase
class RegisterAccount: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfUser: UITextField!
    
    @IBOutlet weak var tfPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customRadiusTextField()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
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
                showAlert("Tên tài khoản hoặc mật khẩu trống")
            }else{
                FIRAuth.auth()?.createUser(withEmail: mEmail, password: mPass, completion: { (user, error) in
                    if error != nil {
                        self.showAlert("lỗi đăng ký \(error)")
                    }else{
                        self.showAlert("Đăng ký tài khoảnn \(user?.email) thành công")
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
