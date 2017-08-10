//
//  WithdrawalViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 2. 22..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WithdrawalViewController: UIViewController {
    
    @IBOutlet weak var checkButton: UIButton!
    
    var status:Bool = false
    var arrRes = [[String:AnyObject]]()
    var userPk:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        //navigation bar item image load
        let yourBackImage = UIImage(named: "cm_arrow_back_white")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func goTeamManageButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if(status) {
            let myAlert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴를 진행하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { action in
                let url = "http://210.122.7.193:8080/TodayBasket_IOS/UserWithdrawal.jsp?Data1=\(self.userPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            print(self.arrRes)
                            if(self.arrRes.count > 0) {
                                if(self.arrRes[0]["status"]! as! String == "succed") {
                                    let myAlert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴가 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                                        UserDefaults.standard.setValue(".", forKey: "Pk")
                                        UserDefaults.standard.synchronize()
                                        self.dismiss(animated: true, completion: nil)
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
            })
            let cancelAction = UIAlertAction(title: "아니오", style: UIAlertActionStyle.cancel, handler: nil)
            myAlert.addAction(okAction)
            myAlert.addAction(cancelAction)
            self.present(myAlert, animated: true, completion: nil)
        }else {
            let myAlert = UIAlertController(title: "회원탈퇴", message: "위 내용을 확인후 체크버튼을 눌러주세요", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            })
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
