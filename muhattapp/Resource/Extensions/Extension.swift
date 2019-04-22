//
//  Extension.swift
//  muhattapp
//
//  Created by Arif Doğan on 12.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setForIntro(){
        self.borderStyle  = .line;
        self.textColor = .white;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        self.layer.borderColor = UIColor.white.cgColor;
        self.layer.borderWidth = 0.5;
        self.textAlignment = .center;
    }
}

extension UIButton {
    func setForIntro(){
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        self.backgroundColor = UIColor.clear;
        self.layer.borderColor = UIColor.white.cgColor;
        self.layer.borderWidth = 0.5;
    }
}


