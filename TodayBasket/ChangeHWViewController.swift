//
//  ChangeHWViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 7. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangeHWViewController: UIViewController {

    @IBOutlet weak var userHeightTextField: UITextField!
    @IBOutlet weak var userWeightTextField: UITextField!
    
    var userPk:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userPk = UserDefaults.standard.string(forKey: "Pk")!
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if(userHeightTextField.text! == "" || userWeightTextField.text! == "") {
            
        }else {
            let url = "http://210.122.7.193:8080/TodayBasket_IOS/UserChangeHW.jsp?Data1=\(userPk)&Data2=\(userHeightTextField.text!)&Data3=\(userWeightTextField.text!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
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
}
