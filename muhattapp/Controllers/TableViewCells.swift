//
//  TableViewCells.swift
//  muhattapp
//
//  Created by Arif Doğan on 16.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class FirmaTableViewCell : UITableViewCell {
    
    let cellImage = UIImageView()
    let cellLabel = UILabel()
  
    override func awakeFromNib() {
        super.awakeFromNib()

        
       


    }
    
    func setCell(_ name : String, _ photo : String) {


        self.addSubview(cellLabel)
        cellLabel.text = name
        cellLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
            make.width.greaterThanOrEqualTo(50)
            make.centerX.equalToSuperview()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
