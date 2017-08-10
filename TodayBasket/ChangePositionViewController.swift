//
//  ChangePositionViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 7. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePositionViewController: UIViewController {

    @IBOutlet weak var userPositionSegmentedControl: UISegmentedControl!
    
    var userPk:String = ""
    var userPosition:String = "C"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
    }
    
    @IBAction func userPositionIndexChanged(_ sender: Any) {
        switch userPositionSegmentedControl.selectedSegmentIndex {
        case 0:
            userPosition = "C"
        case 1:
            userPosition = "PF"
        case 2:
            userPosition = "SF"
        case 3:
            userPosition = "PG"
        case 4:
            userPosition = "SG"
        default:
            userPosition = "C";
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let url = "http://210.122.7.193:8080/TodayBasket_IOS/UserChangePosition.jsp?Data1=\(userPk)&Data2=\(userPosition)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in}
        
        //self.navigationController?.popToRootViewController(animated: true)
        let myAlert = UIAlertController(title: "오늘의농구", message: "변경이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
