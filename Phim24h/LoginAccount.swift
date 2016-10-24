//
//  LoginAccount.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import OEANotification
class LoginAccount: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    var signInWithGG: GIDSignInButton!
    var signInWithFB: FBSDKLoginButton!
    
    var rep: FIRDatabaseReference!
    
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    static let KEY_USER = "keyuser"
    static let KEY_PASS = "keypassword"
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.gray
        customRadiusTextField()
        addButtonGG()
        addButtonFb()
        
        rep = FIRDatabase.database().reference()
        
        if let mUser = userDefault.object(forKey: LoginAccount.KEY_USER) as? String
            , let mPass = userDefault.object(forKey: LoginAccount.KEY_PASS) as? String {
            checkLogin(mUser, password: mPass)
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
//         GIDSignIn.sharedInstance().signOut()
        if let token = FBSDKAccessToken.current() {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: token.tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                
                if  UserData.instance.user == nil {
                    
                    UserData.instance.user = User(email: (user?.displayName)!, url_image: user?.photoURL!, type: "facebook", uid: (user?.uid)!)
                    //                self.rep.child("users").setValue(user?.displayName)
                }
                self.addNav()
            })        }
        
    }
    override func viewDidLayoutSubviews() {
        //        if (tfUser == nil && tfPass == nil){
        //            customRadiusTextField()
        //        }
        //        if signInWithGG == nil {
        //            addButtonGG()
        //        }
        //        if signInWithFB == nil {
        //            addButtonFb()
        //
        //        }
    }
    func addButtonGG() {
        signInWithGG = GIDSignInButton()
        signInWithGG.center = self.view.center
        signInWithGG.style = .wide
        
        
        self.view.addSubview(signInWithGG)
        
        signInWithGG.translatesAutoresizingMaskIntoConstraints = false
        let layoutTop = NSLayoutConstraint(item: signInWithGG, attribute: .top, relatedBy: .equal, toItem: self.viewCenter, attribute: .bottom, multiplier: 1.0, constant: 8)
        let layoutCenterX = NSLayoutConstraint(item: signInWithGG, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([layoutCenterX, layoutTop])
    }
    
    
    func addButtonFb() {
        signInWithFB = FBSDKLoginButton()
        signInWithFB.center = self.view.center
        signInWithFB.delegate = self
        self.view.addSubview(signInWithFB)
        
        signInWithFB.translatesAutoresizingMaskIntoConstraints = false
        let layoutTop = NSLayoutConstraint(item: signInWithFB, attribute: .top, relatedBy: .equal, toItem: self.signInWithGG, attribute: .bottom, multiplier: 1.0, constant: 8)
        let layoutCenterX = NSLayoutConstraint(item: signInWithFB, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let layoutHeight = NSLayoutConstraint(item: signInWithFB
            , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: signInWithGG.bounds.size.height - 8)
        let layoutWidth = NSLayoutConstraint(item: signInWithFB
            , attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: signInWithGG.bounds.size.width - 8)
        NSLayoutConstraint.activate([layoutCenterX, layoutTop , layoutWidth , layoutHeight])
        
        
    }
    //notification
    func loginSuccess(){
        OEANotification.setDefaultViewController(self)
        OEANotification.notify("Sign In success !", subTitle: "Welcome to Phim24h .... ", image: nil, type: .success, isDismissable: false, completion: { () -> Void in
            self.addNav()
            }, touchHandler: nil)
    }
    func loginError(){
       OEANotification.setDefaultViewController(self)
        OEANotification.notify("Sign In fail", subTitle: "please, check your username and password", type: NotificationType.warning, isDismissable: true)
    }
    //delegate google+
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("error \(error.localizedDescription)")
            self.loginError()
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,accessToken: (authentication?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            print(user)
            if  UserData.instance.user == nil {
                UserData.instance.user = User(email: (user?.displayName)!, url_image: user?.photoURL, type: "google", uid: (user?.uid)!)
            }
            self.loginSuccess()
            
        }
    }
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        
    }
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //        myActivityIndicator.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dimiss")
        self.dismiss(animated: true, completion: nil)
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("diddisconnect")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tfUser.text = ""
        tfPass.text = ""
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
                self.loginError()
            }else{
                self.saveAccount(username, mPass: password)
                if  UserData.instance.user == nil {
                    
                    UserData.instance.user = User(email: username, url_image: nil, type: "firebase", uid: (user?.uid)!)
                }
                self.loginSuccess()

                
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
//        slideMenuController.edgesForExtendedLayout = .bottom
//        slideMenuController.automaticallyAdjustsScrollViewInsets = false
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
extension LoginAccount : FBSDKLoginButtonDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to logout.
     @param loginButton The button that was clicked.
     */
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print("error \(error.localizedDescription)")
            self.loginError()
            return
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
          
            if  UserData.instance.user == nil {
                
                UserData.instance.user = User(email: (user?.displayName)!, url_image: user?.photoURL!, type: "facebook", uid: (user?.uid)!)
                
            }
            self.loginSuccess()

        })
    }
}

