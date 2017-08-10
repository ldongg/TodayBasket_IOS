//
//  ChangePassword2ViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 5..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePassword2ViewController: UIViewController {

    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    var userPk:String = ""
    
    var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userPk = UserDefaults.standard.string(forKey: "Pk")!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if(userPasswordTextField.text == userRepeatPasswordTextField.text) {
            let url = "http://210.122.7.193:8080/Trophy_part3/ChangePassword.jsp?Data1=\(userPasswordTextField.text!)&Data2=\(userPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print(self.arrRes)
                        if(self.arrRes.count > 0) {
                            if(self.arrRes[0]["status"]! as! String == "succed") {
                                let myAlert = UIAlertController(title: "비밀번호변경", message: "변경이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
