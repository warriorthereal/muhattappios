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
class DepartmanBildirimViewController: UIViewController {
    
    let user_key = UserDefaults.standard.string(forKey: "user_key")
    private lazy var bildirimArray = BehaviorRelay(value: [Bildirim]())
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
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(DepartmanBildirimViewController.logOut));
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
    
    @objc func logOut() {
        UserDefaults.standard.removeObject(forKey: "user_key")
        UserDefaults.standard.removeObject(forKey: "isPersonal")
        UserDefaults.standard.synchronize()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.AuthSystem()
    }
    
    func setPlayerId() {
        
        Alamofire.request("\(ApiService.base_url)/firma/set_player_id", method: .post, parameters: ["player_id" : self.playerId as! String, "user_key" : self.user_key as! String], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in switch response.result {
        case .success(let value):
            print(value)
        case .failure(let error):
            print(error)
            }
        }
    }
    
    func bindData() {
        self.bildirimArray.bind(to: self.firmaTableView.rx.items(cellIdentifier: "firmaCell", cellType: FirmaTableViewCell.self)){(index,model,cell) in
            cell.setCell(model.content, model.id)
            if(model.status == "0"){
                cell.backgroundColor = .green
            }else {
                cell.backgroundColor = .yellow
            }
        }
        .disposed(by: disposeBag)
        
        self.firmaTableView
            .rx
            .modelSelected(Bildirim.self)
            .subscribe(onNext: { [weak self] (Bildir) in
                
                // BILDIRIM FEEDBACK
                
                Alamofire.request("\(ApiService.base_url)/firma/geriBildirim", method: .post, parameters: ["bildirim_id" : Bildir.id, "user_key" : self?.user_key as! String], encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in switch response.result {
                    
                case .success(let value):
                    let json = JSON(value)
                    
                    let status = json["status"].stringValue
                    if(status == "success"){
                        self!.getFirmaData()
                    }else {
                        print("BISEY OLMADI")
                    }
                case .failure(let err):
                    print(err)
                    }
                    
                })
                
                
            })
    }
    
    func getFirmaData() {
        
        Alamofire.request("\(ApiService.base_url)/firma/departman_bildirimleri", method: .post, parameters: ["user_key" : user_key as! String], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in switch response.result {
            
        case .success(let value):
            
            var innerArray = [Bildirim]()
            
            let json = JSON(value)
            
            
            let bildirimArray = json["bildirimler"].arrayValue
            for bildirim in bildirimArray {
                
                
                let id = bildirim["id"].stringValue
                let content = bildirim["content"].stringValue
                let status = bildirim["status"].stringValue
                
                let bildirimObject : Bildirim = Bildirim(id: id, status: status, content: content)
                innerArray.append(bildirimObject)
                
            }
            
            self.bildirimArray.accept(innerArray)
            
        case .failure(let error):
            print(error.localizedDescription)
            }
            
        }
        
    }
}
