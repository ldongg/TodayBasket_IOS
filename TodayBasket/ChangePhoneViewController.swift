//
//  ChangePhoneViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 1..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePhoneViewController: UIViewController {
    
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPhoneAnTextField: UITextField!
    var userPk:String = ""
    var userPhone:String = ""
    var randomNo:UInt32 = 0
    
    var isCheckPhone:Bool = false
    var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        isCheckPhone = false
        
        //navigation bar item image load
        let yourBackImage = UIImage(named: "cm_arrow_back_white")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAnButtonTapped(_ sender: Any) {
        let length:Int = (userPhoneTextField.text?.characters.count)!
        if(length == 11) {
            isCheckPhone = false
            userPhone = userPhoneTextField.text!
            
            let url1:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/CheckPhone.jsp?Data1=\(userPhone)")!;
            Alamofire.request(url1).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if(self.arrRes.count > 0) {
                        if(self.arrRes[0]["isDuplicate"]! as! String == "false") {
                            self.randomNo = arc4random_uniform(899999) + 100000;
                            let msg:String = "트로피 인증번호는 [\(self.randomNo)] 입니다"
                            print(msg)
                            
                            let now = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date = dateFormatter.string(from: now)
                            
                            let url2 = "http://210.122.7.193:8080/InetSMSExample/example.jsp?Data1=\(msg)&Data2=\(self.userPhone)&Data3=\(self.userPhone)&Data4=\(date)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            //Alamofire.request(url2!).responseJSON { (responseData) -> Void in }
                            self.displayMyAlertMessage("인증번호가 발송되었습니다")
                        }else {
                            self.displayMyAlertMessage("중복된 휴대전화번호입니다")
                        }
                    }
                }
            }
        }else {
            displayMyAlertMessage("정확한 휴대전화번호를 입력해 주세요")
        }
    }
    
    @IBAction func confirmAnButtonTapped(_ sender: Any) {
        if(String(randomNo) == userPhoneAnTextField.text!) {
            isCheckPhone = true
            displayMyAlertMessage("인증이 완료되었습니다")
        }else {
            displayMyAlertMessage("정확한 인증번호를 입력해 주세요")
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        if(isCheckPhone == false) {
            displayMyAlertMessage("휴대전화번호 인증을 진행해주세요")
            return
        }
        
        let url = "http://210.122.7.193:8080/Trophy_part1/User_ChangePhone.jsp?Data1=\(userPhone)&Data2=\(userPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print(self.arrRes)
                    if(self.arrRes.count > 0) {
                        if(self.arrRes[0]["status"]! as! String == "succed") {
                            let myAlert = UIAlertController(title: "휴대전화번호변경", message: "변경이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else if(self.arrRes[0]["status"]! as! String == "Duplicate") {
                            
                        }else {
                            let myAlert = UIAlertController(title: "에러", message: "잠시후 다시 시도해 주세요", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func displayMyAlertMessage(_ userMessage:String) {
        let myAlert = UIAlertController(title: "트로피", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
