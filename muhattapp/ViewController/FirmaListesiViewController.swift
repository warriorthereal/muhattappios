//
//  FirmaListesiViewController.swift
//  muhattapp
//
//  Created by Arif Doğan on 16.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import SwiftVideoBackground
class FirmaListesiViewController: UIViewController {

    let user_key = UserDefaults.standard.string(forKey: "user_key")
    private lazy var firmaArray = BehaviorRelay(value: [Firma]())
    let disposeBag = DisposeBag()
    let playerId = UserDefaults.standard.string(forKey: "device_id")
    let firmaTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlayerId()
        
        view.addSubview(firmaTableView)

        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 25, width: view.bounds.width, height: 44))
        self.view.addSubview(navBar);
    
        
        let navItem = UINavigationItem(title: "Firmalar");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(FirmaListesiViewController.SignOut));
        doneItem.title = "Çıkış Yap"
        navItem.rightBarButtonItem = doneItem;
        
        navBar.setItems([navItem], animated: false);
        
        
        firmaTableView.register(FirmaTableViewCell.self, forCellReuseIdentifier: "firmaCell")
        firmaTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        firmaTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom);
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        firmaTableView.rowHeight = 104
        getFirmaData()
        bindData()
        
    }
    
    @objc func SignOut() {
        
        UserDefaults.standard.removeObject(forKey: "user_key")
        UserDefaults.standard.removeObject(forKey: "isPersonal")
        UserDefaults.standard.synchronize()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.AuthSystem()
        
    }
    func setPlayerId() {
        
        Alamofire.request("\(ApiService.base_url)/users/set_player_id", method: .post, parameters: ["player_id" : self.playerId as! String, "user_key" : self.user_key as! String], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in switch response.result {
            
        case .success(let value):
            print("ID", value)
        case .failure(let error):
            print("ERR", error)
            }
            
        }
        
    }
    
    func bindData() {
        self.firmaArray.bind(to: self.firmaTableView.rx.items(cellIdentifier: "firmaCell", cellType: FirmaTableViewCell.self)){(index,model,cell) in
            
            cell.setCell(model.firma_adi as! String, model.firma_foto as! String)
            
        }.disposed(by: disposeBag)
        
        
        self.firmaTableView
        .rx
        .modelSelected(Firma.self)
            .subscribe(onNext: { [weak self] (Firma) in
                
                let departmanVC = DepartmanViewController()
                print(Firma.id!)
                departmanVC.choosenFirmaId = Firma.id!
                self!.present(departmanVC,animated : true, completion: nil)
                
            })
    }

    func getFirmaData() {
        Alamofire.request("\(ApiService.base_url)/firma/get_user_firma", method: .post, parameters: ["user_key" : user_key as! String], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in switch response.result {
        case .success(let value):
            var innerArray = [Firma]()
            let json = JSON(value)

            let firmaArray = json["firmalar"].arrayValue
            for firma in firmaArray {
                
                let firmaObject : Firma = Firma()
                firmaObject.id = firma["id"].stringValue
                firmaObject.firma_adi = firma["title"].stringValue
                firmaObject.firma_foto = firma["mekan_foto"].stringValue
                print(firmaObject.id!)
                innerArray.append(firmaObject)
                
            }
            
            self.firmaArray.accept(innerArray)
            
        case .failure(let error):
            print(error.localizedDescription)
            }
            
        }
        
    }
}
