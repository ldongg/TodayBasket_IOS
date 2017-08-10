//
//  LoginViewController.swift
//  TrophyProject
//
//  Created by ldong on 2017. 2. 7..
//  Copyright © 2017년 Trophy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    var _Pk:String = ""
    var arrRes = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        let userPhone:String = userPhoneTextField.text!;
        let userPassword:String = userPasswordTextField.text!;
        
        if(userPhone.isEmpty || userPassword.isEmpty) { return; }
        
        let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Login_Confirm.jsp?Data1=\(userPhone)&Data2=\(userPassword)")!;
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                let isLoggedIn = self.arrRes[0]["msg1"]!
                if (isLoggedIn as! String == "isOk") {
                    self._Pk = self.arrRes[0]["msg2"] as! String
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.setValue(self._Pk, forKey: "Pk")
                    print(self._Pk)
                    UserDefaults.standard.synchronize()
                    
                    if let refreshedToken = InstanceID.instanceID().token() {
                        let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Fcm_Add_IOS.jsp?Data1=\(self._Pk)&Data2=\(refreshedToken)")!;

                        Alamofire.request(url).responseJSON { (responseData) -> Void in
                            if((responseData.result.value) != nil) {
                                let swiftyJsonVar = JSON(responseData.result.value!)
                                
                                if let resData = swiftyJsonVar["List"].arrayObject {
                                    self.arrRes = resData as! [[String:AnyObject]]
                                }
                            }
                        }
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }else {
                    let myAlert = UIAlertController(title: nil, message: "정확한 휴대전화번호 및 비밀번호를 입력해 주세요", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        action in
                    }
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
