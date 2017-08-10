//
//  TeamManageUserPopUpViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 22..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class TeamManageUserPopUpViewController: UIViewController {

    @IBOutlet weak var teamUserProfileImage: UIImageView!
    @IBOutlet weak var teamUserNameLabel: UILabel!
    @IBOutlet weak var teamUserAgeLabel: UILabel!
    @IBOutlet weak var teamUserSexLabel: UILabel!
    @IBOutlet weak var teamUserAddressDoLabel: UILabel!
    @IBOutlet weak var teamUserHWLabel: UILabel!
    
    @IBOutlet weak var teamUserCallButton: UIButton!
    @IBOutlet weak var teamUserDelegateButton: UIButton!
    @IBOutlet weak var teamUserRemoveButton: UIButton!
    
    @IBOutlet var mainView: UIView!
    
    var userPk:String = ""
    var teamPk:String = ""
    
    var teamUserPk:String = ""
    var teamUserName:String = ""
    var teamUserProfile:String = ""
    var teamUserAge:String = ""
    var teamUserSex:String = ""
    var teamUserAddressDo:String = ""
    var teamUserAddressSi:String = ""
    var teamUserPhone:String = ""
    var teamUserHeight:String = ""
    var teamUserWeight:String = ""
    var teamUserPosition:String = ""
    
    var arrRes:[[String:AnyObject]] = []
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        if(userPk == teamUserPk) {
            teamUserCallButton.isHidden = true
            teamUserDelegateButton.isHidden = true
            teamUserRemoveButton.isHidden = true
        }

        teamUserNameLabel.text = "\(teamUserPosition). \(teamUserName)"
        teamUserAgeLabel.text = teamUserAge
        teamUserSexLabel.text = teamUserSex
        teamUserAddressDoLabel.text = "\(teamUserAddressDo) \(teamUserAddressSi)"
        teamUserHWLabel.text = "\(teamUserHeight) / \(teamUserWeight)"
        
        if(teamUserProfile != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/profile/\(teamUserProfile).jpg"
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    self.teamUserProfileImage.image = image
                }
            }
        }
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        let url = URL(string: "tel://\(teamUserPhone)")!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func delegateButtonTapped(_ sender: Any) {
        let myAlert = UIAlertController(title: "대표 위임", message: "팀대표를 위임하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "아니요", style: UIAlertActionStyle.cancel, handler: nil)
        myAlert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { action in
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamDetailDelegateCap.jsp?Data1=\(self.teamUserPk)&Data2=\(self.teamPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if self.arrRes.count > 0 {
                        var dict = self.arrRes[0]
                        
                        if(dict["msg1"] as! String == "succed") {
                            let myAlert = UIAlertController(title: "대표 위임", message: "팀대표 권한을 위임하였습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                let revealViewController:SWRevealViewController = self.revealViewController()
                                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let desController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController")
                                let newFrontViewController = UINavigationController.init(rootViewController:desController)
                                revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else {
                            let myAlert = UIAlertController(title: "대표 위임", message: "나중에 다시 시도해주세요", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        let url = "http://210.122.7.193:8080/Trophy_part3/TeamManageRejectUser.jsp?Data1=\(teamUserPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in}
        self.navigationController?.navigationBar.layer.zPosition = 0
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.popViewController(animated: true)
        
    }

    
}
