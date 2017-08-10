//
//  MatchResultUploadViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 6. 25..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Cosmos



class MatchResultUploadViewController: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var matchCountSegment: UISegmentedControl!
    
    @IBOutlet weak var homeTeamEmblemImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamEmblemImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var game1Label: UILabel!
    @IBOutlet weak var game2Label: UILabel!
    @IBOutlet weak var game3Label: UILabel!
    @IBOutlet weak var game1SubLabel: UILabel!
    @IBOutlet weak var game2SubLabel: UILabel!
    @IBOutlet weak var game3SubLabel: UILabel!
    
    
    @IBOutlet weak var game1HomeTextField: UITextField!
    @IBOutlet weak var game1AwayTextField: UITextField!
    @IBOutlet weak var game2HomeTextField: UITextField!
    @IBOutlet weak var game2AwayTextField: UITextField!
    @IBOutlet weak var game3HomeTextField: UITextField!
    @IBOutlet weak var game3AwayTextField: UITextField!
    
    @IBOutlet weak var cosmos: CosmosView!
    
    
    var game1Home:String = ""
    var game1Away:String = ""
    var game2Home:String = ""
    var game2Away:String = ""
    var game3Home:String = ""
    var game3Away:String = ""
    
    var matchPk:String = ""
    var matchStatus:String = ""
    var arrRes = [[String:AnyObject]]()
    var gameCount:Int = 1
    
    var homeTeamUserPk:String = ""
    var awayTeamUserPk:String = ""
    var homeTeamPk:String = ""
    var awayTeamPk:String = ""
    var homeTeamName:String = ""
    var awayTeamName:String = ""
    var homeTeamEmblem:String = ""
    var awayTeamEmblem:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.mainView.layer.cornerRadius = self.view.frame.size.width / 15
        self.mainView.layer.masksToBounds = true
        self.mainView.clipsToBounds = true
     
        cosmos.settings.fillMode = .full
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MatchResultUploadViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // 홈팀 이름 삽입
        homeTeamNameLabel.text = homeTeamName
        
        // 어웨이팀 이름 삽입
        awayTeamNameLabel.text = awayTeamName
        
        homeTeamEmblemImageView.layer.cornerRadius = homeTeamEmblemImageView.frame.size.width/2
        homeTeamEmblemImageView.clipsToBounds = true
        
        awayTeamEmblemImageView.layer.cornerRadius = awayTeamEmblemImageView.frame.size.width/2
        awayTeamEmblemImageView.clipsToBounds = true
        
        // 홈팀 엠블럼
        if(self.homeTeamEmblem != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.homeTeamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseImage { response in
                if let image = response.result.value {
                    self.homeTeamEmblemImageView.image = image
                }
            }
        }else {
            self.homeTeamEmblemImageView.image = UIImage(named: "ic_team")
        }
        // 어웨이팀 엠블럼
        if(self.awayTeamEmblem != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.awayTeamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseImage { response in
                if let image = response.result.value {
                    self.awayTeamEmblemImageView.image = image
                }
            }
        }else {
            self.awayTeamEmblemImageView.image = UIImage(named: "ic_team")
        }
        
        if(matchStatus == "Home_Insert") {
            confirmButton.setTitle("결과확인", for: .normal)
            
            matchCountSegment.isUserInteractionEnabled = false
            
            game1HomeTextField.isUserInteractionEnabled = false
            game1AwayTextField.isUserInteractionEnabled = false
            game2AwayTextField.isUserInteractionEnabled = false
            game2HomeTextField.isUserInteractionEnabled = false

            
            game3HomeTextField.isUserInteractionEnabled = false
            game3AwayTextField.isUserInteractionEnabled = false
            
            if(game3Home == "." && game2Away == ".") {
                matchCountSegment.selectedSegmentIndex = 0
                
                game1Label.textColor = UIColor.black
                game2Label.textColor = UIColor.lightGray
                game3Label.textColor = UIColor.lightGray
                game1SubLabel.textColor = UIColor.black
                game2SubLabel.textColor = UIColor.lightGray
                game3SubLabel.textColor = UIColor.lightGray
                
                game1HomeTextField.text = game1Home
                game1AwayTextField.text = game1Away
                
            }else if(game3Home == ".") {
                matchCountSegment.selectedSegmentIndex = 1
                
                game1Label.textColor = UIColor.black
                game2Label.textColor = UIColor.black
                game3Label.textColor = UIColor.lightGray
                game1SubLabel.textColor = UIColor.black
                game2SubLabel.textColor = UIColor.black
                game3SubLabel.textColor = UIColor.lightGray
                
                game1HomeTextField.text = game1Home
                game1AwayTextField.text = game1Away
                game2HomeTextField.text = game2Home
                game2AwayTextField.text = game2Away
                
            }else {
                matchCountSegment.selectedSegmentIndex = 2
                
                game1Label.textColor = UIColor.black
                game2Label.textColor = UIColor.black
                game3Label.textColor = UIColor.black
                game1SubLabel.textColor = UIColor.black
                game2SubLabel.textColor = UIColor.black
                game3SubLabel.textColor = UIColor.black
                
                game1HomeTextField.text = game1Home
                game1AwayTextField.text = game1Away
                game2HomeTextField.text = game2Home
                game2AwayTextField.text = game2Away
                game3HomeTextField.text = game3Home
                game3AwayTextField.text = game3Away
                
            }
        }
    }
    
    @IBAction func matchCountChanged(_ sender: Any) {
        switch matchCountSegment.selectedSegmentIndex {
        case 0:
            gameCount = 1
            
            game1Label.textColor = UIColor.black
            game2Label.textColor = UIColor.lightGray
            game3Label.textColor = UIColor.lightGray
            game1SubLabel.textColor = UIColor.black
            game2SubLabel.textColor = UIColor.lightGray
            game3SubLabel.textColor = UIColor.lightGray
            
            game1HomeTextField.isUserInteractionEnabled = true
            game2AwayTextField.isUserInteractionEnabled = true
            
            game2HomeTextField.text = ""
            game2AwayTextField.text = ""
            game2HomeTextField.isUserInteractionEnabled = false
            game2AwayTextField.isUserInteractionEnabled = false
            
            game3HomeTextField.text = ""
            game3AwayTextField.text = ""
            game3HomeTextField.isUserInteractionEnabled = false
            game3AwayTextField.isUserInteractionEnabled = false
        case 1:
            gameCount = 2
            
            game1Label.textColor = UIColor.black
            game2Label.textColor = UIColor.black
            game3Label.textColor = UIColor.lightGray
            game1SubLabel.textColor = UIColor.black
            game2SubLabel.textColor = UIColor.black
            game3SubLabel.textColor = UIColor.lightGray
            
            game2HomeTextField.isUserInteractionEnabled = true
            game2AwayTextField.isUserInteractionEnabled = true
            
            game3HomeTextField.text = ""
            game3AwayTextField.text = ""
            game3HomeTextField.isUserInteractionEnabled = false
            game3AwayTextField.isUserInteractionEnabled = false
        case 2:
            gameCount = 3
            
            game1Label.textColor = UIColor.black
            game2Label.textColor = UIColor.black
            game3Label.textColor = UIColor.black
            game1SubLabel.textColor = UIColor.black
            game2SubLabel.textColor = UIColor.black
            game3SubLabel.textColor = UIColor.black
            
            game2HomeTextField.isUserInteractionEnabled = true
            game2AwayTextField.isUserInteractionEnabled = true
            
            game3HomeTextField.isUserInteractionEnabled = true
            game3AwayTextField.isUserInteractionEnabled = true
        default: break
        }
        
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        if(matchStatus == "Not_Insert") {
            if(gameCount == 1) {
                game1Home = game1HomeTextField.text!
                game1Away = game1AwayTextField.text!
                game2Home = "."
                game2Away = "."
                game3Home = "."
                game3Away = "."
                
                if(game1Home == "" || game1Away == "") {
                    
                    let myAlert = UIAlertController(title: "오늘의농구", message: "점수칸을 모두 채워주세요", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: {action in
                        return
                    })
                }else {
                    let myAlert = UIAlertController(title: "오늘의농구", message: "점수입력이 완료되었습니다! \n상대팀이 점수확인시 교류전 결과에 표시됩니다", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: {action in
                        self.uploadMatchResult()
                    })
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: {action in
                        return
                    })
                }
            }else if(gameCount == 2) {
                game1Home = game1HomeTextField.text!
                game1Away = game1AwayTextField.text!
                game2Home = game2HomeTextField.text!
                game2Away = game2AwayTextField.text!
                game3Home = "."
                game3Away = "."
                
                if(game1Home == "" || game1Away == "" || game2Home == "" || game2Away == "") {
                    
                    let myAlert = UIAlertController(title: "오늘의농구", message: "점수칸을 모두 채워주세요", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: {action in
                        return
                    })
                }else {
                    let myAlert = UIAlertController(title: "오늘의농구", message: "점수입력이 완료되었습니다! \n상대팀이 점수확인시 교류전 결과에 표시됩니다", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: {action in
                        self.uploadMatchResult()
                    })
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: {action in
                        return
                    })
                }
            }else {
                game1Home = game1HomeTextField.text!
                game1Away = game1AwayTextField.text!
                game2Home = game2HomeTextField.text!
                game2Away = game2AwayTextField.text!
                game3Home = game3HomeTextField.text!
                game3Away = game3AwayTextField.text!
                
                if(game1Home == "" || game1Away == "" || game2Home == "" || game2Away == "" || game3Home == "" || game3Away == "") {
                    
                    let myAlert = UIAlertController(title: "오늘의농구", message: "점수칸을 모두 채워주세요", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: {action in
                        return
                    })
                }else {
                    let myAlert = UIAlertController(title: "오늘의농구", message: "점수입력이 완료되었습니다! \n상대팀이 점수확인시 교류전 결과에 표시됩니다", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: {action in
                        self.uploadMatchResult()
                    })
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: {action in
                        return
                    })
                }
            }
        }else {
            uploadMatchResult()
        }
        
        
//        super.navigationController?.navigationBar.layer.zPosition = 0
//        super.navigationController?.navigationBar.isUserInteractionEnabled = true
//        self.view.removeFromSuperview()
    }
    
    func uploadMatchResult() {
        
        if(matchStatus == "Not_Insert") {
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchResultUploadHome.jsp?Data1=\(matchPk)&Data2=\(cosmos.rating)&Data3=\(game1Home)&Data4=\(game1Away)&Data5=\(game2Home)&Data6=\(game2Away)&Data7=\(game3Home)&Data8=\(game3Away)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if(self.arrRes.count > 0) {
                        let dict = self.arrRes[0]
                        
                        if(dict["msg1"] as! String == "succed") {
                            
                            let myAlert = UIAlertController(title: nil, message: "점수등록이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                
                                // 푸쉬 알림
                                let url = "http://210.122.7.193:8080/TodayBasket_manager/push.jsp?Data1=\(self.awayTeamUserPk)&Data2=\(self.homeTeamName)팀이 교류전 점수입력을 하였습니다  \n점수확인을 진행해 주세요!".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                    if((responseData.result.value) != nil) {
                                    }
                                }
                                
                                // 전페이지로 이동
                                let revealViewController:SWRevealViewController = self.revealViewController()
                                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let desController = mainStoryboard.instantiateViewController(withIdentifier: "MatchResultListViewController") as! MatchResultListViewController
                                let newFrontViewController = UINavigationController.init(rootViewController:desController)
                                revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }else if(matchStatus == "Home_Insert") {
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchResultUploadAway.jsp?Data1=\(matchPk)&Data2=\(cosmos.rating)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if(self.arrRes.count > 0) {
                        let dict = self.arrRes[0]
                        
                        if(dict["msg1"] as! String == "succed") {
                            
                            let myAlert = UIAlertController(title: nil, message: "점수확인이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                
                                // 푸쉬 알림
                                let url = "http://210.122.7.193:8080/TodayBasket_manager/push.jsp?Data1=\(self.homeTeamUserPk)&Data2=\(self.awayTeamName)팀이 점수확인을 하였습니다 \n이제 교류전 결과 메뉴에서 확인할 수 있습니다!".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                    if((responseData.result.value) != nil) {
                                    }
                                }
                                
                                // 전페이지로 이동
                                let revealViewController:SWRevealViewController = self.revealViewController()
                                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let desController = mainStoryboard.instantiateViewController(withIdentifier: "MatchResultListViewController") as! MatchResultListViewController
                                let newFrontViewController = UINavigationController.init(rootViewController:desController)
                                revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        self.navigationController?.navigationBar.layer.zPosition = 0
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.view.removeFromSuperview()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        print(matchPk)
        super.navigationController?.navigationBar.layer.zPosition = 0
        super.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.view.removeFromSuperview()
    }
}
