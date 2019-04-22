//
//  DepartmanViewController.swift
//  muhattapp
//
//  Created by Arif Doğan on 12.01.2019.
//  Copyright © 2019 Arif Doğan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

class DepartmanViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var choosenFirmaId : String = ""
    let departmanTableView = UITableView()
    let user_key = UserDefaults.standard.string(forKey: "user_key")
    private lazy var departmanArray = BehaviorRelay(value: [Departman]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 25, width: view.bounds.width, height: 44))
        self.view.addSubview(navBar);
        
        
        let navItem = UINavigationItem(title: "Departmanlar");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(DepartmanViewController.ToMain));
        doneItem.title = "Geri"
        navItem.rightBarButtonItem = doneItem;
        
        navBar.setItems([navItem], animated: false);
        
        
        departmanTableView.register(FirmaTableViewCell.self, forCellReuseIdentifier: "departmanCell")
        departmanTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(departmanTableView)
        departmanTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom);
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        getDepartmanData()
        bindData()
        departmanTableView.rowHeight = 100
        let footerView = UIView()
        footerView.backgroundColor = .white
        departmanTableView.tableFooterView = footerView
    }
    
    @objc func ToMain() {
        
      //  UserDefaults.standard.removeSuite(named: "user_key")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.AuthSystem()
        
    }
    
    
    func bindData() {
        
        departmanArray.bind(to: self.departmanTableView.rx.items(cellIdentifier: "departmanCell", cellType: FirmaTableViewCell.self)){(index,model,cell) in
            cell.setCell(model.title!, "")
        }
        
        self.departmanTableView
            .rx
            .modelSelected(Departman.self)
            .subscribe(onNext: { [weak self] (Departman) in
                
                let bildirimVC = BildirimGonderViewController()
                bildirimVC.departmanId = Departman.id!
                self!.present(bildirimVC,animated : true, completion: nil)
                
            })
    }

    func getDepartmanData() {
        Alamofire.request("\(ApiService.base_url as! String)/firma/get_firma_departman", method: .post, parameters: ["firma_id" : self.choosenFirmaId as! String], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in switch response.result {
            
        case .success(let value):
            print("FIRMA ID", self.choosenFirmaId as! String)
            var innerArray = [Departman]()
            
            let json = JSON(value)
            // List Departments of Company
            
            let departmanArray = json["departmanlar"].arrayValue
            
            
            for departman in departmanArray {
                let departmanObject : Departman = Departman()
                
                var title : String = departman["title"].stringValue
                
                departmanObject.id = departman["id"].stringValue
                departmanObject.title = title
                
                
                innerArray.append(departmanObject)
                
            }

            self.departmanArray.accept(innerArray)
            
        case .failure(let error):
            print(error.localizedDescription)
            }
            
        }
        
    }

 

}
