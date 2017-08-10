//
//  ChangePasswordViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 1..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {

    var currentPassword:String = ""
    var inputPassword:String = ""
    
    var arrRes = [[String:AnyObject]]()
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation bar item image load
        let yourBackImage = UIImage(named: "cm_arrow_back_white")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        inputPassword = passwordTextField.text!
        let url = "http://210.122.7.193:8080/Trophy_part3/getEncodePassword.jsp?Data1=\(inputPassword)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print(self.arrRes)
                    if(self.arrRes.count > 0) {
                        self.inputPassword = self.arrRes[0]["Password"]! as! String
                        if(self.inputPassword == self.currentPassword) {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let ChangePassword2ViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePassword2ViewController") as! ChangePassword2ViewController
                            self.navigationController?.pushViewController(ChangePassword2ViewController, animated: true)
                        }else {
                            let myAlert = UIAlertController(title: "비밀번호 변경", message: "비밀번호를 확인해 주세요", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
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
