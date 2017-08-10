//
//  FindPasswordViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 5..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPhoneAnTextField: UITextField!
    
    var userPhone:String = ""
    var randomNo:UInt32 = 0
    var isCheckPhone:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAnButtonTapped(_ sender: Any) {
        let length:Int = (userPhoneTextField.text?.characters.count)!
        if(length == 11) {
            
            userPhone = userPhoneTextField.text!
            self.randomNo = arc4random_uniform(899999) + 100000;
            let msg:String = "트로피 인증번호는 [\(self.randomNo)] 입니다"
            print(msg)
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.string(from: now)
            
            let url2 = "http://210.122.7.193:8080/InetSMSExample/example.jsp?Data1=\(msg)&Data2=\(self.userPhone)&Data3=\(self.userPhone)&Data4=\(date)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url2!).responseJSON { (responseData) -> Void in }
            displayMyAlertMessage("인증번호가 발송되었습니다")
            
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
        if(isCheckPhone) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let FindPassword2ViewController = storyBoard.instantiateViewController(withIdentifier: "FindPassword2ViewController") as! FindPassword2ViewController
            self.navigationController?.pushViewController(FindPassword2ViewController, animated: true)
        }else {
            displayMyAlertMessage("휴대전화번호 인증을 진행해주세요")
        }
    }
    
    func displayMyAlertMessage(_ userMessage:String) {
        let myAlert = UIAlertController(title: "비밀번호찾기", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
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
