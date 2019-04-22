//
//  Error.swift
//  muhattapp
//
//  Created by Arif Doğan on 12.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import Foundation
import UIKit

class Error : UIView {
    
    static let shared = Error(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
