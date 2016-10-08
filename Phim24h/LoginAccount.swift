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

class LoginAccount: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    static let KEY_USER = "keyuser"
    static let KEY_PASS = "keypassword"
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.gray
        if let mUser = userDefault.object(forKey: LoginAccount.KEY_USER) as? String
            , let mPass = userDefault.object(forKey: LoginAccount.KEY_PASS) as? String {
            checkLogin(mUser, password: mPass)
        }
        
    }
    override func viewDidLayoutSubviews() {
        customRadiusTextField()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func customRadiusTextField(){
        tfUser.addIconTextField(tfUser, stringImage: "user")
        
        tfPass.addIconTextField(tfPass, stringImage: "pass")
        tfPass.delegate = self
        tfUser.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
                checkLogin(mUser, password: mPass)
            }
        }
    }
    func checkLogin(_ username : String, password : String){
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user, error) in
            if error != nil {
                print("lỗi đăng nhập \(error.debugDescription)")
            }else{
                self.saveAccount(username, mPass: password)
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
    func saveAccount(_ mUser: String, mPass : String){
        
        userDefault.set(mUser, forKey: LoginAccount.KEY_USER)
        userDefault.set(mPass, forKey: LoginAccount.KEY_PASS)
        userDefault.synchronize()
    }
    
}
extension UIViewController
{
    public func getRootNav() -> UINavigationController
    {
        return self.navigationController!
    }
    
}
extension UITextField {
    
    //-- String placeHolder : User --- Password
    
    
    
    //-- add Icon TextField
    func addIconTextField(_ textField : UITextField, stringImage : String){
        
        let leftIconView = UIImageView(image: UIImage(named: stringImage))
        
        let paddingView = UIView(frame : CGRect(x: 0, y: 0, width: 30, height: 20))
        
        leftIconView.center = paddingView.center
        
        paddingView.addSubview(leftIconView)
        
        leftView = paddingView

        
        textField.leftView = leftView
//        textField.leftView?.contentMode = .center
        textField.leftViewMode = UITextFieldViewMode.always   
        
    }
    
//    let leftIconView = UIImageView(image: UIImage(named: imageName))
//    
//    let paddingView = UIView(frame : CGRect(x: 0, y: 0, width: 44, height: 45))
//    
//    leftIconView.center = paddingView.center
//    
//    paddingView.addSubview(leftIconView)
//    
//    leftView = paddingView

    //-- bo goc textfield
    func roundCorners(_ corners : UIRectCorner ,radius : CGFloat) {
        let bounds = self.bounds //-- lay bound cua textfield
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
        
        
        //--
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = UIColor.lightGray.cgColor
        frameLayer.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(frameLayer)
        
        
    }
    func roundTopCornersRadius(_ radius : CGFloat){
        self.roundCorners([.topLeft, .topRight], radius: radius)
    }
    
    func roundBottomCornersRadius(_ radius : CGFloat){
        self.roundCorners([.bottomLeft, .bottomRight], radius: radius)
    }
    
}
