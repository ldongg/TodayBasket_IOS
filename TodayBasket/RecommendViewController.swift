//
//  RecommendViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 19..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecommendViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var recommendDataTextView: UITextView!
    
    @IBOutlet weak var checkButton: UIButton!
    var arrRes = [[String:AnyObject]]()
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    
    var status:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
    }

    @IBAction func checkButtonTapped(_ sender: Any) {
        if(!status) {
            status = true
            checkButton.setImage(UIImage(named: "check.png"), for: UIControlState.normal)
        }else {
            status = false
            checkButton.setImage(UIImage(named: "uncheck.png"), for: UIControlState.normal)
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commitButtonTapped(_ sender: Any) {
        if(status) {
            let url = "http://210.122.7.193:8080/Trophy_part3/Suggest.jsp?Data1=\(userPk)&Data2=\(recommendDataTextView.text!)&Data3=\(userEmailTextField.text!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseJSON { (responseData) -> Void in
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    if(dict["status"] as! String == "succed") {
                        let alert = UIAlertController(title: "오늘의농구", message: "문의하기가 완료되었습니다", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }else {
            let alert = UIAlertController(title: "오늘의농구", message: "위 내용 동의하기 버튼을 눌러주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { action in})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
