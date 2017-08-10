//
//  Contest_Application_ViewController.swift
//  slidetest1
//
//  Created by MD313-007 on 2017. 2. 17..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class Contest_Application_ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    var User_Pk:String = ""
    var Contest_Pk:String = ""
    var Contest_Title:String = ""
    var Team_Pk:String = ""
    
    var Insert_List:[String] = []
    var Select_List:[String] = []
    
    var TeamUser = TeamUserSetting()
    var TeamUserList:[TeamUserSetting] = []
    var arrRes = [[String:AnyObject]]()
    
    var result:String = ""
    
    @IBOutlet weak var ContestTitleLabel: UILabel!
    @IBOutlet weak var TeamNameLabel: UILabel!
    @IBOutlet weak var TeamRepresentNameLabel: UILabel!
    @IBOutlet weak var TeamRepresentPhoneLabel: UILabel!

    @IBOutlet weak var TeamUserTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContestTitleLabel.text = Contest_Title
        TeamUserTableView.allowsMultipleSelection = true
        
        TeamUserTableView.delegate = self
        TeamUserTableView.dataSource = self
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo.jsp?Data1=\(User_Pk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    var dict = self.arrRes[0]
                    self.TeamRepresentNameLabel.text = (dict["Name"] as! String)
                    self.TeamRepresentPhoneLabel.text = (dict["Phone"] as! String)
                }
            }
        }
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamInfo.jsp?Data1=\(Team_Pk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    var dict = self.arrRes[0]
                    self.TeamNameLabel.text = (dict["teamName"] as! String)
                }
            }
        }
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamUserSearch.jsp?Data1=\(Team_Pk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    
                }
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        self.TeamUser = TeamUserSetting()
                        self.TeamUser.userPk = dict["_Pk"] as! String
                        self.TeamUser.userName = dict["_Name"] as! String
                        self.TeamUser.userTeamDuty = dict["_TeamDuty"] as! String
                        self.TeamUser.userAddressDo = dict["_AddressDo"] as! String
                        self.TeamUser.userAddressSi = dict["_AddressSi"] as! String
                        self.TeamUser.userSex = dict["_Sex"] as! String
                        self.TeamUser.userImage = dict["_Image"] as! String
                        self.Insert_List.append("false")
                        self.TeamUserList.append(self.TeamUser)
                    }
                    self.TeamUserTableView.reloadData()
                }
            }
        }
    }
    
    
    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return self.TeamUserList.count
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Select_List.append(String(TeamUserList[indexPath.row].userPk))
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamUserCell", for: indexPath)
        
        
        
        let TeamUserImage = cell.viewWithTag(1) as! UIImageView
        let TeamUserName = cell.viewWithTag(2) as! UILabel
        //let TeamUserAge = cell.viewWithTag(3) as! UILabel
        let TeamUserDuty = cell.viewWithTag(4) as! UILabel
        
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
        
        // Configure the cell...
        if (TeamUserList[indexPath.row].userImage != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(TeamUserList[indexPath.row].userImage).jpg")
                .responseImage { response in
                    debugPrint(response.result)
                    DispatchQueue.main.async(execute: {
                        if let image = response.result.value {
                            debugPrint(response)
                            TeamUserImage.image = image
                        }
                    });
            }
        }
        TeamUserName.text = TeamUserList[indexPath.row].userName
        //Member_Name.text = TeamUserList[indexPath.row].userAge
        TeamUserDuty.text = TeamUserList[indexPath.row].userTeamDuty
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.Insert_List[indexPath.row] = "true"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        self.Insert_List[indexPath.row] = "false"
    }
    
    
    
    @IBAction func ApplicationConfirmButtonTapped(_ sender: Any) {
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/Contest_Detail_Form_Join.jsp?Data1=\(Contest_Pk)&Data2=\(User_Pk)").responseJSON { (responseData) -> Void in
            let swiftyJsonVar = JSON(responseData.result.value!)
            
            if let resData = swiftyJsonVar["List"].arrayObject {
                self.arrRes = resData as! [[String:AnyObject]]
                
            }
            if self.arrRes.count > 0 {
                let dict = self.arrRes[0]
                self.result = dict["msg1"] as! String
            }
        }
        
        if(result == "succed") {
            for i in 0 ..< Insert_List.count {
                if(Insert_List[i] == "true") {
                    Select_List.append(TeamUserList[i].userPk)
                }
            }
            
            for i in 0 ..< Select_List.count {
                Alamofire.request("http://210.122.7.193:8080/Trophy_part3/Contest_Detail_Form_Join.jsp?Data1=\(Select_List[i])&Data2=\(Contest_Pk)").responseJSON { (responseData) -> Void in
                }
            }
            
            Alamofire.request("http://210.122.7.193:8080/Trophy_part3/Contest_Detail_Form_Join_Team.jsp?Data1=\(Contest_Pk)&Data2=\(Team_Pk)").responseJSON { (responseData) -> Void in
            }
        }else {
            //이미 신청한 대회라고 알림
        }
        
        
    }
}
