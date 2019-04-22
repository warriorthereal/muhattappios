//
//  BildirimGonderViewController.swift
//  muhattapp
//
//  Created by Arif Doğan on 17.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

class BildirimGonderViewController: UIViewController {
    
    let contextField = UITextView()
    let sendButton = UIButton()
    var departmanId : String = ""
    let user_key = UserDefaults.standard.string(forKey: "user_key")

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        view.backgroundColor = .white
        sendButton.addTarget(self, action: #selector(BildirimGonderViewController.sendNotification), for: .touchDown)
        sendButton.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let viewgesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.endEditing))
        
        view.addGestureRecognizer(viewgesture)
    }
    
    
    @objc func endEditing() {
        view.endEditing(true)
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
        view.addSubview(contextField)
        contextField.layer.cornerRadius = 20
        contextField.layer.borderWidth = 0.5
        contextField.layer.borderColor = UIColor(red: 50/255, green: 36/255, blue: 177/255, alpha: 1).cgColor
        contextField.backgroundColor = .white
        contextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(300)
            make.width.greaterThanOrEqualTo(self.view.frame.width - 30)
        }
        
        view.addSubview(sendButton)
        sendButton.layer.cornerRadius = 20
        sendButton.backgroundColor = UIColor(red: 50/255, green: 36/255, blue: 177/255, alpha: 1)
        sendButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(contextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
            make.left.equalTo(contextField.snp.left)
            make.right.equalTo(contextField.snp.right)
        }
        sendButton.setTitle("Bildirim Gönder", for: .normal)
    }

    @objc func sendNotification() {
            print("\(ApiService.base_url as! String)/bildirim_gonder")
        Alamofire.request("\(ApiService.base_url as! String)/bildirim_gonder", method: .post, parameters: ["content" : self.contextField.text, "user_key" : self.user_key as! String, "departman_id" : self.departmanId as! String], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in switch response.result {
            
        case .success(let value):
            let json = JSON(value)
            
            let status = json["status"].stringValue
            if ( status == "success"){
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.AuthSystem()
            }else {
                self.view.addSubview(Error.shared)
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            }
            
        }
        
    }
}
