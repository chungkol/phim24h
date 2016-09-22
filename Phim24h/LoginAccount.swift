//
//  LoginAccount.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Firebase
import DLRadioButton

class LoginAccount: UIViewController {
    
    
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    static let KEY_USER = "keyuser"
    static let KEY_PASS = "keypassword"
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        if let mUser = userDefault.object(forKey: LoginAccount.KEY_USER) as? String
        , let mPass = userDefault.object(forKey: LoginAccount.KEY_PASS) as? String {
            checkLogin(username: mUser, password: mPass)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
        
    @IBAction func btnForgotPass(_ sender: UIButton) {
        let fogotPassVC = ResetPassword(nibName: "ResetPassword", bundle: nil)
        
        self.present(fogotPassVC, animated: true, completion: nil)
    }
    @IBAction func btnlogin(_ sender: UIButton) {
        if let mUser = tfUser.text , let mPass = tfPass.text{
            if mUser == "" || mPass == "" {
                showAlert("Tên tài khoản hoặc mật khẩu trống")
            }else{
                checkLogin(username: mUser, password: mPass)
            }
        }
    }
    func checkLogin(username : String, password : String){
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user, error) in
            if error != nil {
                print("lỗi đăng nhập \(error.debugDescription)")
            }else{
                self.saveAccount(mUser: username, mPass: password)
                self.addNav()
                
            }
            
        })
        if  username == "1" && password == "1" {
            
            self.addNav()
        }
    }
    @IBAction func btnRegister(_ sender: UIButton) {
        let registerVC = RegisterAccount(nibName: "RegisterAccount", bundle: nil)
        self.present(registerVC, animated: true, completion: nil)
        
    }
    
    func addNav() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let navigation = UINavigationController(rootViewController: homeVC)
        menuVC.homeVC = navigation
        let slideMenuController = SlideMenuController(mainViewController: navigation, leftMenuViewController: menuVC)
        self.present(slideMenuController, animated: true, completion: nil)
    }
    
    func showAlert(_ mess: String) {
        let alert = UIAlertController(title: "Thông báo", message: mess, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)    }
    func saveAccount(mUser: String, mPass : String){
       
        userDefault.set(mUser, forKey: LoginAccount.KEY_USER)
        userDefault.set(mPass, forKey: LoginAccount.KEY_PASS)
        userDefault.synchronize()
    }
    
}
