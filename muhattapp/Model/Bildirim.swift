//
//  Bildirim.swift
//  muhattapp
//
//  Created by Arif Doğan on 29.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import Foundation

struct Bildirim {
    var id : String
    var status : String
    var content : String
    
    init(id : String,status : String , content : String) {
        self.id = id
        self.status = status
        self.content = content
    }
}
