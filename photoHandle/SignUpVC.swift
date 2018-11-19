//
//  SignUpVC.swift
//  photoHandle
//
//  Created by tingz on 2018/11/13.
//  Copyright © 2018 tingz. All rights reserved.
//

import UIKit
import LeanCloud


class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    
    @IBOutlet weak var bioTxt: UITextField!
    
    @IBOutlet weak var webTxt: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func signUpBtn_clicked(_ sender: UIButton) {
        print("注册按钮被按下！")
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty{
            let alert = UIAlertController(title: "警告⚠️", message: "请填好所有信息噢(￣▽￣)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if passwordTxt.text != repeatPasswordTxt.text {
            let alert = UIAlertController(title: "警告⚠️", message: "两次输入的密码不一致(￣.￣)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        let user = LCUser()
        user.username = LCString((usernameTxt.text?.lowercased())!)
        user.email = LCString((emailTxt.text?.lowercased())!)
        user.password = LCString(passwordTxt.text!)
        user["fullname"] = LCString((fullnameTxt.text?.lowercased())!)
        user["bio"] = LCString(bioTxt.text!)
        user["web"] = LCString((webTxt.text?.lowercased())!)
        user["gender"] = LCString("")
        
        user.signUp()
        
        
        if user.signUp().isSuccess{
            print("注册成功！")
        }else{
            print("注册失败！")
            print(user.signUp().error)
        }
        
        
        /*let avaData = avaImg.image?.jpegData(compressionQuality: 0.5)
        //let avaFile = LCFile()
        
        let avaImgObject = LCObject(className: "avaImg")
        avaImgObject.set("img", value: avaData)
        
        user["ava"] = avaImgObject*/
        
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.synchronize()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.login()
        
    }
    
    
    @IBAction func cancelBtn_clicked(_ sender: UIButton) {
        print("取消按钮被按下！")
        self.dismiss(animated: true, completion: nil)
    }
    
    var scrollViewHeight: CGFloat = 0
    
    var keyboard: CGRect = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = self.view.frame.height
        
        //注册广播
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //声明隐藏虚拟键盘的操作
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
        imgTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imgTap)
        
        avaImg.layer.cornerRadius = avaImg.frame.width/2
        avaImg.clipsToBounds = true
    }
    
    @objc func showKeyboard(notification:Notification)  {
        //定义keyboard大小
        let rect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        //当虚拟键盘出现后，将滚动视图的实际高度缩小为屏幕高度减去键盘高度
        UIView.animate(withDuration: 0.4){
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
        }
        
    }
    
    @objc func hideKeyboard(notification:Notification)  {
        //当虚拟键盘消失后，将滚动视图的实际高度改变为屏幕的高度值
        self.scrollView.frame.size.height = self.view.frame.height
        
    }
    
    //隐藏视图中的虚拟键盘
    @objc func hideKeyboardTap(recongnizer : UITapGestureRecognizer)  {
        self.view.endEditing(true)
    }
    
    @objc func loadImg(recongnizer : UITapGestureRecognizer)  {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        avaImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
   
}
