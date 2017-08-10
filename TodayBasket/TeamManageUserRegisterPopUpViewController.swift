//
//  TeamManageUserRegisterPopUpViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 29..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TeamManageUserRegisterPopUpViewController: UIViewController {

    @IBOutlet weak var teamUserProfileImage: UIImageView!
    @IBOutlet weak var teamUserNameLabel: UILabel!
    @IBOutlet weak var teamUserAgeLabel: UILabel!
    @IBOutlet weak var teamUserSexLabel: UILabel!
    @IBOutlet weak var teamUserAddressDoLabel: UILabel!
    @IBOutlet weak var teamUserHWLabel: UILabel!
    
    @IBOutlet var mainView: UIView!
    
    var teamPk:String = ""
    
    var teamUserPk:String = ""
    var teamUserName:String = ""
    var teamUserProfile:String = ""
    var teamUserAge:String = ""
    var teamUserSex:String = ""
    var teamUserAddressDo:String = ""
    var teamUserAddressSi:String = ""
    var teamUserHeight:String = ""
    var teamUserWeight:String = ""
    var teamUserPosition:String = ""
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var arrRes = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        teamUserNameLabel.text = "\(teamUserPosition). \(teamUserName)"
        teamUserAgeLabel.text = teamUserAge
        teamUserSexLabel.text = teamUserSex
        teamUserAddressDoLabel.text = "\(teamUserAddressDo) \(teamUserAddressSi)"
        teamUserHWLabel.text = "\(teamUserHeight) / \(teamUserWeight)"
        
        if(teamUserProfile != ".") {
            teamUserProfileImage.af_setImage(withURL: URL(string:"http://210.122.7.193:8080/Trophy_img/profile/\(teamUserProfile).jpg")!)
        }
        
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.navigationController?.navigationBar.layer.zPosition = 0
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.view.removeFromSuperview()
    }
    
    @IBAction func commitButtonTapped(_ sender: Any) {
        let url = "http://210.122.7.193:8080/Trophy_part3/TeamManageCommitUser.jsp?Data1=\(teamUserPk)&Data2=\(teamPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    let status = dict["msg1"] as! String
                    if (status == "succed") {
                        self.navigationController?.navigationBar.layer.zPosition = 0
                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
     func rejcetButtonTapped(_ sender: Any) {
        let url = "http://210.122.7.193:8080/Trophy_part3/TeamManageRejectUser.jsp?Data1=\(teamUserPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    let status = dict["msg1"] as! String
                    if (status == "succed") {
                        self.navigationController?.navigationBar.layer.zPosition = 0
                        self.navigationController?.navigationBar.isUserInteractionEnabled = true
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func startAnimating() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func finishAnimating() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
