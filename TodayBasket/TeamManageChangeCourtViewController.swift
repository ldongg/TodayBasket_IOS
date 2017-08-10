//
//  TeamManageChangeCourtViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 15..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TeamManageChangeCourtViewController: UIViewController {

    @IBOutlet weak var teamHomeCourtTextField: UITextField!
    
    var userPk:String = ""
    var teamPk:String = ""
    var teamHomeCourt:String = ""
    
    var arrRes = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        teamHomeCourt = teamHomeCourtTextField.text!
        if (teamHomeCourt.isEmpty) {
            displayMyAlertMessage("모든 칸을 채워주세요")
        }else {
            Alamofire.request("http://210.122.7.193:8080/Trophy_part3/getTeamPk.jsp?Data1=\(userPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print("\(self.arrRes)")
                    }
                    
                    if self.arrRes.count > 0 {
                        var dict = self.arrRes[0]
                        
                        let status = dict["status"] as! String
                        self.teamPk = dict["teamPk"] as! String
                        
                        if (status == "succed") {
                            self.updateCourt()
                        }
                    }
                }
            }
        }
    }
    
    func updateCourt() {
        let url = "http://210.122.7.193:8080/Trophy_part3/TeamChangeCourt.jsp?Data1=\(teamHomeCourt)&Data2=\(teamPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    let status = dict["status"] as! String
                    if (status == "succed") {
                        //self.navigationController?.popToRootViewController(animated: true)
                        let myAlert = UIAlertController(title: "팀주소변경", message: "변경이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func displayMyAlertMessage(_ userMessage:String) {
        let myAlert = UIAlertController(title: "팀주소변경", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    

}
