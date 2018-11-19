//
//  SignInVC.swift
//  photoHandle
//
//  Created by tingz on 2018/11/13.
//  Copyright © 2018 tingz. All rights reserved.
//

import UIKit
import LeanCloud

class SignInVC: UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBAction func signInBtn_clicked(_ sender: UIButton) {
        print("登录按钮被点击")
        
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty{
            let alert = UIAlertController(title: "警告⚠️", message: "ヽ(｀⌒´)ﾉ给我填完整啊", preferredStyle: .alert)
            let ok = UIAlertAction(title: "/(ㄒoㄒ)/OK~~", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
       let okOrNot = LCUser.logIn(username: usernameTxt.text!, password: passwordTxt.text!)
        if okOrNot.isSuccess{
            UserDefaults.standard.set(okOrNot.object?.username, forKey: "username")
            UserDefaults.standard.synchronize()
            
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.login()
        }else{
            print(okOrNot.error as Any)
        }
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }
    
    @objc func hideKeyboard(recognizer: UITapGestureRecognizer)  {
        self.view.endEditing(true)
    }
    

}
