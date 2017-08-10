//
//  TeamManageUserViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 21..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SCLAlertView

class TeamManageUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionViewJoinUser: UICollectionView!
    @IBOutlet weak var collectionViewTeamUser: UICollectionView!
    @IBOutlet weak var joinUserCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var teamUserCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subViewHeight: NSLayoutConstraint!
    @IBOutlet weak var warnningHeightConstraint: NSLayoutConstraint!
    
    let collectionViewJoinIdentifier = "joinUserCell"
    let collectionViewTeamIdentifier = "teamUserCell"
    
    var teamUsers = TeamUserSetting()
    var teamUserList:[TeamUserSetting] = []
    var joinUsers = TeamUserSetting()
    var joinUserList:[TeamUserSetting] = []
    var arrRes:[[String:AnyObject]] = []
    
    var userPk:String = ""
    var teamPk:String = ""
    
    var collectionViewCellHeight = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewJoinUser.delegate = self
        collectionViewTeamUser.delegate = self
        collectionViewJoinUser.dataSource = self
        collectionViewTeamUser.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        joinUserCollectionViewHeight.constant = 0
        teamUserCollectionViewHeight.constant = 0
        subViewHeight.constant = 228
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        joinUserList = []
        teamUserList = []
        
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
                        self.teamUserSearch()
                    }
                }
            }
        }

    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewJoinUser {
            let cellJoinUser = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewJoinIdentifier, for: indexPath)
            
            if(self.joinUserList.count > 0) {
                self.warnningHeightConstraint.constant = 0
            }else { // 가입신청자가 없을 경우
                self.warnningHeightConstraint.constant = 40
                self.joinUserCollectionViewHeight.constant = 0
            }
            
            let joinUserImageView = cellJoinUser.viewWithTag(1) as! UIImageView
            let joinUserNameLabel = cellJoinUser.viewWithTag(2) as! UILabel
            
            joinUserImageView.layer.cornerRadius = joinUserImageView.frame.size.width/5
            joinUserImageView.clipsToBounds = true
            
            if(joinUserList[indexPath.row].userImage != ".") {
                Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(joinUserList[indexPath.row].userImage).jpg")
                    .responseImage { response in
                        debugPrint(response.result)
                        DispatchQueue.main.async(execute: {
                            if let image = response.result.value {
                                debugPrint(response)
                                joinUserImageView.image = image
                            }
                        });
                }
            }else {
                joinUserImageView.image = UIImage(named: "user_basic")
            }
            joinUserNameLabel.text = joinUserList[indexPath.row].userName
            
            return cellJoinUser
        }else {
            let cellTeamUser = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewTeamIdentifier, for: indexPath)
            
            let teamUserImageView = cellTeamUser.viewWithTag(1) as! UIImageView
            let teamUserNameLabel = cellTeamUser.viewWithTag(2) as! UILabel
            
            teamUserImageView.layer.cornerRadius = teamUserImageView.frame.size.width/5
            teamUserImageView.clipsToBounds = true
            
            
            if(teamUserList[indexPath.row].userImage != ".") {
                Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(teamUserList[indexPath.row].userImage).jpg")
                    .responseImage { response in
                        debugPrint(response.result)
                        DispatchQueue.main.async(execute: {
                            if let image = response.result.value {
                                debugPrint(response)
                                teamUserImageView.image = image
                            }
                        });
                }
            }else {
                teamUserImageView.image = UIImage(named: "user_basic")
            }
            teamUserNameLabel.text = teamUserList[indexPath.row].userName
            
            
            return cellTeamUser
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewJoinUser {
            return self.joinUserList.count
        }else {
            return self.teamUserList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(view.frame.size.width/4), height: CGFloat(collectionViewCellHeight))
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //teamManageUserPopUp
//        
//        if collectionView == self.collectionViewJoinUser {
//            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamManageUserRegisterPopUp") as! TeamManageUserRegisterPopUpViewController
//            popOverVC.teamPk = self.teamPk
//            
//            popOverVC.teamUserPk = joinUserList[indexPath.row].userPk
//            popOverVC.teamUserName = joinUserList[indexPath.row].userName
//            popOverVC.teamUserProfile = joinUserList[indexPath.row].userImage
//            popOverVC.teamUserAge = joinUserList[indexPath.row].userBirth
//            popOverVC.teamUserSex = joinUserList[indexPath.row].userSex
//            popOverVC.teamUserAddressDo = joinUserList[indexPath.row].userAddressDo
//            popOverVC.teamUserAddressSi = joinUserList[indexPath.row].userAddressSi
//            popOverVC.teamUserHeight = joinUserList[indexPath.row].userHeight
//            popOverVC.teamUserWeight = joinUserList[indexPath.row].userWeight
//            popOverVC.teamUserPosition = joinUserList[indexPath.row].userPosition
//            
//            self.navigationController?.navigationBar.layer.zPosition = -1
//            self.navigationController?.navigationBar.isUserInteractionEnabled = false
//            self.addChildViewController(popOverVC)
//            popOverVC.view.frame = self.view.frame
//            self.view.addSubview(popOverVC.view)
//            popOverVC.didMove(toParentViewController: self)
//        }else {
//            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamManageUserPopUp") as! TeamManageUserPopUpViewController
//            popOverVC.teamPk = self.teamPk
//            
//            popOverVC.teamUserPk = teamUserList[indexPath.row].userPk
//            popOverVC.teamUserName = teamUserList[indexPath.row].userName
//            popOverVC.teamUserProfile = teamUserList[indexPath.row].userImage
//            popOverVC.teamUserAge = teamUserList[indexPath.row].userBirth
//            popOverVC.teamUserSex = teamUserList[indexPath.row].userSex
//            popOverVC.teamUserAddressDo = teamUserList[indexPath.row].userAddressDo
//            popOverVC.teamUserAddressSi = teamUserList[indexPath.row].userAddressSi
//            popOverVC.teamUserPhone = teamUserList[indexPath.row].userPhone
//            popOverVC.teamUserHeight = teamUserList[indexPath.row].userHeight
//            popOverVC.teamUserWeight = teamUserList[indexPath.row].userWeight
//            popOverVC.teamUserPosition = teamUserList[indexPath.row].userPosition
//            
//            self.navigationController?.navigationBar.layer.zPosition = -1
//            self.navigationController?.navigationBar.isUserInteractionEnabled = false
//            self.addChildViewController(popOverVC)
//            popOverVC.view.frame = self.view.frame
//            self.view.addSubview(popOverVC.view)
//            popOverVC.didMove(toParentViewController: self)
//        }
//    }
    
    
    func fixHeightConstraint() {
        if(joinUserList.count > 0) {
            self.joinUserCollectionViewHeight.constant += CGFloat((self.collectionViewCellHeight + 5) * ((self.joinUserList.count / 4) + 1))
            self.subViewHeight.constant += CGFloat((self.collectionViewCellHeight + 5) * ((self.joinUserList.count / 4) + 1))
        }else {
            self.joinUserCollectionViewHeight.constant = 0
        }
        
        if(teamUserList.count > 0) {
            self.teamUserCollectionViewHeight.constant += CGFloat((self.collectionViewCellHeight + 5) * ((self.teamUserList.count / 4) + 1))
            self.subViewHeight.constant += CGFloat((self.collectionViewCellHeight + 5) * ((self.teamUserList.count / 4) + 1))
        }else {
            self.teamUserCollectionViewHeight.constant = 0
        }
    }
    
    func teamUserSearch() {
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamUsersInfo.jsp?Data1=\(teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        let teamDuty = dict["_TeamDuty"] as! String
                        if(teamDuty == "신청중") {
                            self.joinUsers = TeamUserSetting()
                            self.joinUsers.userPk = dict["_Pk"] as! String
                            self.joinUsers.userPhone = dict["_Phone"] as! String
                            self.joinUsers.userName = dict["_Name"] as! String
                            self.joinUsers.userTeamDuty = dict["_TeamDuty"] as! String
                            self.joinUsers.userBirth = dict["_Birth"] as! String
                            self.joinUsers.userAddressDo = dict["_AddressDo"] as! String
                            self.joinUsers.userAddressSi = dict["_AddressSi"] as! String
                            self.joinUsers.userSex = dict["_Sex"] as! String
                            self.joinUsers.userImage = dict["_Image"] as! String
                            self.joinUsers.userHeight = dict["_Height"] as! String
                            self.joinUsers.userWeight = dict["_Weight"] as! String
                            self.joinUsers.userPosition = dict["_Position"] as! String
                            self.joinUserList.append(self.joinUsers)
                            print(i)
                        }else {
                            self.teamUsers = TeamUserSetting()
                            self.teamUsers.userPk = dict["_Pk"] as! String
                            self.teamUsers.userPhone = dict["_Phone"] as! String
                            self.teamUsers.userName = dict["_Name"] as! String
                            self.teamUsers.userTeamDuty = dict["_TeamDuty"] as! String
                            self.teamUsers.userBirth = dict["_Birth"] as! String
                            self.teamUsers.userAddressDo = dict["_AddressDo"] as! String
                            self.teamUsers.userAddressSi = dict["_AddressSi"] as! String
                            self.teamUsers.userSex = dict["_Sex"] as! String
                            self.teamUsers.userImage = dict["_Image"] as! String
                            self.teamUsers.userHeight = dict["_Height"] as! String
                            self.teamUsers.userWeight = dict["_Weight"] as! String
                            self.teamUsers.userPosition = dict["_Position"] as! String
                            self.teamUserList.append(self.teamUsers)
                        }
                    }
                    self.collectionViewJoinUser.reloadData()
                    self.collectionViewTeamUser.reloadData()
                }
                self.fixHeightConstraint()
            }
        }
    }
    func teamUserSearch(teamPk:String) {
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamUsersInfo.jsp?Data1=\(teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        let teamDuty = dict["_TeamDuty"] as! String
                        if(teamDuty == "신청중") {
                            self.joinUsers = TeamUserSetting()
                            self.joinUsers.userPk = dict["_Pk"] as! String
                            self.joinUsers.userPhone = dict["_Phone"] as! String
                            self.joinUsers.userName = dict["_Name"] as! String
                            self.joinUsers.userTeamDuty = dict["_TeamDuty"] as! String
                            self.joinUsers.userBirth = dict["_Birth"] as! String
                            self.joinUsers.userAddressDo = dict["_AddressDo"] as! String
                            self.joinUsers.userAddressSi = dict["_AddressSi"] as! String
                            self.joinUsers.userSex = dict["_Sex"] as! String
                            self.joinUsers.userImage = dict["_Image"] as! String
                            self.joinUsers.userHeight = dict["_Height"] as! String
                            self.joinUsers.userWeight = dict["_Weight"] as! String
                            self.joinUsers.userPosition = dict["_Position"] as! String
                            self.joinUserList.append(self.joinUsers)
                            print(i)
                        }else {
                            self.teamUsers = TeamUserSetting()
                            self.teamUsers.userPk = dict["_Pk"] as! String
                            self.teamUsers.userPhone = dict["_Phone"] as! String
                            self.teamUsers.userName = dict["_Name"] as! String
                            self.teamUsers.userTeamDuty = dict["_TeamDuty"] as! String
                            self.teamUsers.userBirth = dict["_Birth"] as! String
                            self.teamUsers.userAddressDo = dict["_AddressDo"] as! String
                            self.teamUsers.userAddressSi = dict["_AddressSi"] as! String
                            self.teamUsers.userSex = dict["_Sex"] as! String
                            self.teamUsers.userImage = dict["_Image"] as! String
                            self.teamUsers.userHeight = dict["_Height"] as! String
                            self.teamUsers.userWeight = dict["_Weight"] as! String
                            self.teamUsers.userPosition = dict["_Position"] as! String
                            self.teamUserList.append(self.teamUsers)
                        }
                    }
                    self.collectionViewJoinUser.reloadData()
                    self.collectionViewTeamUser.reloadData()
                }
                self.fixHeightConstraint()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goJoiner") {
            let popOverVC = segue.destination as! TeamManageUserRegisterPopUpViewController
        
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionViewJoinUser.indexPath(for: cell)
            let row = indexPath?.row
            
            popOverVC.teamPk = self.teamPk
            popOverVC.teamUserPk = joinUserList[row!].userPk
            popOverVC.teamUserName = joinUserList[row!].userName
            popOverVC.teamUserProfile = joinUserList[row!].userImage
            popOverVC.teamUserAge = joinUserList[row!].userBirth
            popOverVC.teamUserSex = joinUserList[row!].userSex
            popOverVC.teamUserAddressDo = joinUserList[row!].userAddressDo
            popOverVC.teamUserAddressSi = joinUserList[row!].userAddressSi
            popOverVC.teamUserHeight = joinUserList[row!].userHeight
            popOverVC.teamUserWeight = joinUserList[row!].userWeight
            popOverVC.teamUserPosition = joinUserList[row!].userPosition
        }else if (segue.identifier == "goTeamUser") {
            let popOverVC = segue.destination as! TeamManageUserPopUpViewController
            
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionViewTeamUser.indexPath(for: cell)
            let row = indexPath?.row
            
            popOverVC.teamPk = self.teamPk
            popOverVC.teamUserPk = teamUserList[row!].userPk
            popOverVC.teamUserName = teamUserList[row!].userName
            popOverVC.teamUserProfile = teamUserList[row!].userImage
            popOverVC.teamUserAge = teamUserList[row!].userBirth
            popOverVC.teamUserSex = teamUserList[row!].userSex
            popOverVC.teamUserAddressDo = teamUserList[row!].userAddressDo
            popOverVC.teamUserAddressSi = teamUserList[row!].userAddressSi
            popOverVC.teamUserPhone = teamUserList[row!].userPhone
            popOverVC.teamUserHeight = teamUserList[row!].userHeight
            popOverVC.teamUserWeight = teamUserList[row!].userWeight
            popOverVC.teamUserPosition = teamUserList[row!].userPosition
        }
    }
}
