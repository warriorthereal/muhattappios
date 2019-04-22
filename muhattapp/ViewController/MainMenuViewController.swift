//
//  MainMenuViewController.swift
//  muhattapp
//
//  Created by Arif Doğan on 12.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import UIKit
import SnapKit
import SwiftVideoBackground
import PopupDialog
class MainMenuViewController: UIViewController {
    
    let logoImage = UIImageView()
    let firmaButton = UIButton()
    let creditsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? VideoBackground.shared.play(view: view, videoName: "background", videoType: "mp4")
        VideoBackground.shared.willLoopVideo = true

        setViews()
        
        firmaButton.addTarget(self, action: #selector(MainMenuViewController.toFirmalar), for: .touchDown)
    }
    
    func setViews() {
        
        // Logo Image Set
        logoImage.image = UIImage(named: "logo")
        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.height.equalTo(150);
            make.width.equalTo(150);
            make.top.greaterThanOrEqualToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        view.addSubview(firmaButton)
        firmaButton.setTitle(Strings.firmalar, for: [.normal])
        firmaButton.setForIntro()
        firmaButton.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(150);
            make.height.greaterThanOrEqualTo(50)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalToSuperview().offset(75)
            make.right.equalToSuperview().offset(-75)
            
        }
        
        view.addSubview(creditsButton)
        creditsButton.setTitle(Strings.bizKimiz, for: [.normal])
        creditsButton.setForIntro()
        creditsButton.snp.makeConstraints { (make) in
            make.top.equalTo(firmaButton.snp.bottom).offset(40);
            make.height.greaterThanOrEqualTo(50)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalToSuperview().offset(75)
            make.right.equalToSuperview().offset(-75)
        }
        creditsButton.addTarget(self, action: #selector(credit), for: .touchUpInside)
        
        
    }
    @objc func credit() {
        
        // Prepare the popup assets
        let title = "Muhattap"
        let message = """
Muhattap uygulaması otel, tatil köyü, restaurant, beach club, özel hastaneler, apartman ve site gibi tüm işletmelerde; müşteri, patron ve ev sahipleri tarafından çalışanları çağırmak için kulanılabilir. Yapılan bütün çağırma ve bildirim işlemleri kayıt edilerek çalışanların performanslarının
 takibini kolaylaştırır. Işlemleri cepten ve tabletten istediğiniz yerden 7/24 takip edebilmenizi sağlar.
"""
        let image = UIImage(named: "logo")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Kapat") {
            print("You canceled the car dialog.")
        }
        
      
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func toFirmalar() {
        
        let firmaVC = FirmaListesiViewController()
        
        self.present(firmaVC,animated : true, completion : nil)
        
    }
}
