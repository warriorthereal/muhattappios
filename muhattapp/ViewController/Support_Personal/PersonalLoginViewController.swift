//
//  PersonalLoginViewController.swift
//  muhattapp
//
//  Created by Arif Doğan on 29.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit
import SwiftVideoBackground

class PersonalLoginViewController: UIViewController {

    let logoImage = UIImageView()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let okButton = UIButton()
    let registerButton = UIButton()
    let forgetLabel = UILabel()
    
    let service = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViews()
        
        try? VideoBackground.shared.play(view: view, videoName: "Pexels Videos 2659", videoType: "mp4")
        VideoBackground.shared.willLoopVideo = true
        
        okButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchDown)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let viewgesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.endEditing))
        
        view.addGestureRecognizer(viewgesture)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func login() {
        if (usernameField.text != "" && passwordField.text != ""){
            
            Alamofire.request("\(ApiService.base_url)/users/login_calisan", method: .post, parameters: ["username" : usernameField.text!, "password" : passwordField.text!], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in switch response.result {
                
            case .success(let value):
                let value = JSON(value)
                let username = value["username"].stringValue
                let user_key = value["key"].stringValue
                print(user_key)
                UserDefaults.standard.set(user_key, forKey: "user_key")
                UserDefaults.standard.set(true, forKey: "isPersonal")
                
                UserDefaults.standard.synchronize()
                
                
                let departmanVC = DepartmanBildirimViewController()
                self.present(departmanVC,animated: true,completion : nil)
                
            case .failure(let json):
                
                self.view.addSubview(Error.shared)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    Error.shared.removeFromSuperview()
                })
                }
            }
        }else{
            self.view.addSubview(Error.shared)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                Error.shared.removeFromSuperview()
            })
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setViews() {
        
        // Logo Image Set
        logoImage.image = UIImage(named: "placeholder")
        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(150);
            make.width.greaterThanOrEqualTo(150);
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(100)
        }
        
        
        // UsernameField Set
        view.addSubview(usernameField)
        usernameField.setForIntro()
        usernameField.placeholder = Strings.kullaniciAdi
        usernameField.attributedPlaceholder = NSAttributedString(string: Strings.kullaniciAdi, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        usernameField.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(100);
            make.height.greaterThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(150)
            make.left.equalToSuperview().offset(75)
            make.right.equalToSuperview().offset(-75)
        }
        
        
        // Password Field
        view.addSubview(passwordField)
        passwordField.attributedPlaceholder = NSAttributedString(string: Strings.sifre, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        passwordField.setForIntro()
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(usernameField.snp.bottom).offset(40);
            make.height.greaterThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(150)
            make.left.equalToSuperview().offset(75)
            make.right.equalToSuperview().offset(-75)
        }
        
        // LoginButton
        view.addSubview(okButton)
        okButton.setTitle(Strings.girisYap, for: [.normal])
        okButton.setForIntro()
        okButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(40);
            make.height.greaterThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(150)
            make.left.equalToSuperview().offset(75)
            make.right.equalToSuperview().offset(-75)
        }
    }
  
}
