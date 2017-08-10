//
//  MatchDetailViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MatchDetailViewController: UIViewController {

    @IBOutlet weak var matchTitleLabel: UILabel!
    @IBOutlet weak var teamEmblemImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var matchDateTextField: UITextField!
    @IBOutlet weak var matchTimeTextField: UITextField!
    @IBOutlet weak var matchPlaceTextField: UITextField!
    @IBOutlet weak var matchPayTextField: UITextField!
    @IBOutlet weak var matchUniformTextField: UITextField!
    @IBOutlet weak var matchParkForbiddenView: UIView!
    @IBOutlet weak var matchParkFreeView: UIView!
    @IBOutlet weak var matchParkChargeView: UIView!
    @IBOutlet weak var matchDisplayView: UIView!
    @IBOutlet weak var matchShowerView: UIView!
    @IBOutlet weak var matchColdhotView: UIView!
    @IBOutlet weak var matchExtraTextView: UITextView!
    @IBOutlet weak var matchRequestButton: UIButton!
    
    var matchPk:String = ""
    var userPk:String = ""
    var teamPk:String = ""
    var teamName:String = ""
    var memo:String = ""
    var time:String = ""
    
    var matchUserPk:String = ""
    var matchTeamPk:String = ""
    var matchTeamEmblem:String = ""
    var matchTeamName:String = ""
    var matchUploadTime:String = ""
    var matchTitle:String = ""
    var matchDate:String = ""
    var matchStartTime:String = ""
    var matchFinishTime:String = ""
    var matchPlace:String = ""
    var matchPay:String = ""
    var matchUniform:String = ""
    var matchStatus:String = ""
    var matchParkForbidden:String = ""
    var matchParkFree:String = ""
    var matchParkCharge:String = ""
    var matchDisplay:String = ""
    var matchShower:String = ""
    var matchColdhot:String = ""
    var matchExtra:String = ""
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var arrRes = [[String:AnyObject]]()
    
    var isUserLoggedIn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teamEmblemImageView.layer.cornerRadius = self.teamEmblemImageView.frame.size.width/2
        self.teamEmblemImageView.clipsToBounds = true
        self.teamEmblemImageView.backgroundColor = UIColor.white

        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchDetail.jsp?Data1=\(self.matchPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                print(responseData.result.value!)
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    self.matchPk = self.arrRes[0]["matchPk"] as! String
                    self.matchUserPk = self.arrRes[0]["homeUserPk"] as! String
                    self.matchTeamPk = self.arrRes[0]["homeTeamPk"] as! String
                    self.matchUploadTime = self.arrRes[0]["matchUploadTime"] as! String
                    self.matchTitle = self.arrRes[0]["matchTitle"] as! String
                    self.matchDate = self.arrRes[0]["matchDate"] as! String
                    self.matchStartTime = self.arrRes[0]["matchStartTime"] as! String
                    self.matchFinishTime = self.arrRes[0]["matchFinishTime"] as! String
                    self.matchPlace = self.arrRes[0]["matchPlace"] as! String
                    self.matchParkForbidden = self.arrRes[0]["matchParkForbidden"] as! String
                    self.matchParkFree = self.arrRes[0]["matchParkFree"] as! String
                    self.matchParkCharge = self.arrRes[0]["matchParkCharge"] as! String
                    self.matchDisplay = self.arrRes[0]["matchDisplay"] as! String
                    self.matchShower = self.arrRes[0]["matchShower"] as! String
                    self.matchColdhot = self.arrRes[0]["matchColdHot"] as! String
                    self.matchStatus = self.arrRes[0]["matchStatus"] as! String
                    self.matchTeamEmblem = self.arrRes[0]["homeTeamEmblem"] as! String
                    self.matchTeamName = self.arrRes[0]["homeTeamName"] as! String
                    self.matchPay = self.arrRes[0]["matchPay"] as! String
                    self.matchUniform = self.arrRes[0]["matchUniform"] as! String
                    self.matchExtra = self.arrRes[0]["matchExtra"] as! String
                    
                    
                    // 교류전 제목 삽입
                    self.matchTitleLabel.text = self.matchTitle
                    
                    // 팀 엠블럼 삽입
                    if (self.matchTeamEmblem != ".") {
                        let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.matchTeamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        Alamofire.request(url!).responseImage { response in
                            if let image = response.result.value {
                                self.teamEmblemImageView.image = image
                            }
                        }
                    }
                    
                    // 상태 삽입
                    let dateFormatterStatus = DateFormatter()
                    dateFormatterStatus.dateFormat = "yyyy:::MM / dd:::HH:m"
                    let matchStatusTime = dateFormatterStatus.date(from: "\(self.matchDate):::\(self.matchStartTime)")
                    let nowTime = Date()
                    if(matchStatusTime! < nowTime) {
                        self.matchStatusLabel.text = "마감"
                        self.matchRequestButton.backgroundColor = UIColor.gray
                        self.matchRequestButton.setTitle("마감", for: UIControlState.normal)
                        self.matchRequestButton.isUserInteractionEnabled = false
                    }else {
                        self.matchStatusLabel.text = "모집중"
                    }
                    
                    // 팀명 삽입
                    self.teamNameLabel.text = self.matchTeamName
                    
                    // 교류전 날짜 및 시간 삽입
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy:::MM / dd ::: H:m"
                    dateFormatter.locale = Locale(identifier: "ko_KR")
                    
                    let startDate = "\(self.matchDate) ::: \(self.matchStartTime)"
                    let finishDate = "\(self.matchDate) ::: \(self.matchFinishTime)"
                    
                    let startTime = dateFormatter.date(from: startDate)
                    let finishTime = dateFormatter.date(from: finishDate)
                    
                    let cal = Calendar(identifier: .gregorian)
                    
                    let compStartTime = cal.dateComponents([.year, .month, .day, .hour, .minute], from: startTime!)
                    let compFinishTime = cal.dateComponents([.hour, .minute], from: finishTime!)
                    
                    var startTimeString:String = ""
                    var finishTimeString:String = ""
                    
                    if(compStartTime.minute! == 0) {
                        startTimeString = "\(compStartTime.hour!)시"
                    }else {
                        startTimeString = "\(compStartTime.hour!)시 \(compStartTime.minute!)분"
                    }
                    
                    if(compFinishTime.minute! == 0) {
                        finishTimeString = "\(compFinishTime.hour!)시"
                    }else {
                        finishTimeString = "\(compFinishTime.hour!)시 \(compFinishTime.minute!)분"
                    }
                    self.matchTimeTextField.text = "\(startTimeString) ~ \(finishTimeString)"
                    self.matchDateTextField.text = "\(compStartTime.year!)년 \(compStartTime.month!)월 \(compStartTime.day!)일"
                    
                    //교류전 위치 삽입
                    self.matchPlaceTextField.text = self.matchPlace
                    
                    // 교류전 비용 삽입
                    self.matchPayTextField.text = self.matchPay
                    
                    // 교류전 유니폼 삽입
                    self.matchUniformTextField.text = self.matchUniform
                    
                    // 교류전 제한사항 삽입
                    if(self.matchParkForbidden == "true") {
                        self.matchParkForbiddenView.backgroundColor = UIColor.groupTableViewBackground
                        self.matchParkFreeView.backgroundColor = UIColor.white
                        self.matchParkChargeView.backgroundColor = UIColor.white
                    }else if(self.matchParkFree == "true") {
                        self.matchParkForbiddenView.backgroundColor = UIColor.white
                        self.matchParkFreeView.backgroundColor = UIColor.groupTableViewBackground
                        self.matchParkChargeView.backgroundColor = UIColor.white
                    }else if(self.matchParkCharge == "true") {
                        self.matchParkForbiddenView.backgroundColor = UIColor.white
                        self.matchParkFreeView.backgroundColor = UIColor.white
                        self.matchParkChargeView.backgroundColor = UIColor.groupTableViewBackground
                    }
                    if self.matchDisplay == "true" {
                        self.matchDisplayView.backgroundColor = UIColor.groupTableViewBackground
                    }else {
                        self.matchDisplayView.backgroundColor = UIColor.white
                    }
                    if self.matchShower == "true" {
                        self.matchShowerView.backgroundColor = UIColor.groupTableViewBackground
                    }else {
                        self.matchShowerView.backgroundColor = UIColor.white
                    }
                    if self.matchColdhot == "true" {
                        self.matchColdhotView.backgroundColor = UIColor.groupTableViewBackground
                    }else {
                        self.matchColdhotView.backgroundColor = UIColor.white
                    }
                    self.matchExtraTextView.text = self.matchExtra
                }
            }
        }
    }
    
    @IBAction func requestButtonTapped(_ sender: Any) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let dateFormatterStatus = DateFormatter()
        dateFormatterStatus.dateFormat = "yyyy:::MM / dd:::H:m"
        let matchStatusTime = dateFormatterStatus.date(from: "\(self.matchDate):::\(self.matchStartTime)")
        let nowTime = Date()
        if(matchStatusTime! < nowTime) {
            self.matchStatusLabel.text = "마감"
            self.matchRequestButton.backgroundColor = UIColor.groupTableViewBackground
            self.matchRequestButton.setTitle("마감", for: UIControlState.normal)
            self.matchRequestButton.isUserInteractionEnabled = false
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let myAlert = UIAlertController(title: nil, message: "마감된 교류전입니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }else {
            isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            if(self.isUserLoggedIn) {
                self.userPk = UserDefaults.standard.string(forKey: "Pk")!
                Alamofire.request("http://210.122.7.193:8080/Trophy_part3/getTeamPk.jsp?Data1=\(userPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            print("\(self.arrRes)")
                        }
                        
                        if self.arrRes.count > 0 {
                            var dict = self.arrRes[0]
                            self.teamPk = dict["teamPk"] as! String
                            self.teamName = dict["teamName"] as! String
                            
                            if(self.teamPk != ".") { // 팀이 있을시 중복확인
                                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchDetailDuplicate.jsp?Data1=\(self.userPk)&Data2=\(self.matchPk)&Data3=\(self.teamPk)").responseJSON { (responseData) -> Void in
                                    if((responseData.result.value) != nil) {
                                        print(responseData.result.value!)
                                        let swiftyJsonVar = JSON(responseData.result.value!)
                                        if let resData = swiftyJsonVar["List"].arrayObject {
                                            self.arrRes = resData as! [[String:AnyObject]]
                                        }
                                        
                                        if self.arrRes.count > 0 {
                                            let status:String = self.arrRes[0]["msg1"] as! String
                                            if(status == "succed") { // 중복 신청 없을시 (신청 업로드)
                                                
                                                // 로딩 해제
                                                self.activityIndicator.stopAnimating()
                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                
                                                let myAlert = UIAlertController(title: nil, message: "전달할 메시지를 남겨주세요", preferredStyle: UIAlertControllerStyle.alert)
                                                
                                                // 텍스트 필드
                                                myAlert.addTextField { (textField: UITextField) in
                                                    
                                                }
                                                
                                                // 확인 버튼
                                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                                                    
                                                    self.activityIndicator.center = self.view.center
                                                    self.activityIndicator.hidesWhenStopped = true
                                                    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                                                    self.view.addSubview(self.activityIndicator)
                                                    self.activityIndicator.startAnimating()
                                                    UIApplication.shared.beginIgnoringInteractionEvents()
                                                    
                                                    self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
                                                    if(self.isUserLoggedIn) {
                                                        
                                                        // 메모
                                                        if let textField = myAlert.textFields?.first {
                                                            self.memo = textField.text!
                                                        }
                                                        
                                                        // 시간
                                                        let nowDate = Date()
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.dateFormat = "yyyy / MM / dd:::HH : m"
                                                        self.time = dateFormatter.string(from: nowDate)
                                                        
                                                        // 신청
                                                        let url = "http://210.122.7.193:8080/TodayBasket_IOS/MatchDetailRequest.jsp?Data1=\(self.userPk)&Data2=\(self.matchPk)&Data3=\(self.time)&Data4=\(self.memo)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                                        Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                                            if((responseData.result.value) != nil) {
                                                                print(responseData.result.value!)
                                                                let swiftyJsonVar = JSON(responseData.result.value!)
                                                                if let resData = swiftyJsonVar["List"].arrayObject {
                                                                    self.arrRes = resData as! [[String:AnyObject]]
                                                                }
                                                                
                                                                if self.arrRes.count > 0 {
                                                                    if(self.arrRes[0]["msg1"] as! String == "succed") {
                                                                        
                                                                        self.activityIndicator.stopAnimating()
                                                                        UIApplication.shared.endIgnoringInteractionEvents()
                                                                        
                                                                        // 푸쉬 알람
                                                                        let url = "http://210.122.7.193:8080/TodayBasket_manager/push.jsp?Data1=\(self.matchUserPk)&Data2=\(self.teamName)팀이 시합 요청 하였습니다".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                                                        Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                                                            if((responseData.result.value) != nil) {
                                                                            }
                                                                        }
                                                                        
                                                                        // 완료 메시지 표시
                                                                        let myAlert = UIAlertController(title: "교류전 신청", message: "교류전 신청이 완료되었습니다!", preferredStyle: UIAlertControllerStyle.alert)
                                                                        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                                                        myAlert.addAction(okAction)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                })
                                                myAlert.addAction(okAction)
                                                let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
                                                myAlert.addAction(cancelAction)
                                                self.present(myAlert, animated: true, completion: nil)
                                            }else if(status == "overlap") { // 팀에서 중복 신청 있을시
                                                self.activityIndicator.stopAnimating()
                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                
                                                let myAlert = UIAlertController(title: "교류전 신청", message: "이미 팀에서 신청중인 교류전입니다", preferredStyle: UIAlertControllerStyle.alert)
                                                let okAction = UIAlertAction(title: "신청", style: UIAlertActionStyle.default, handler: nil)
                                                myAlert.addAction(okAction)
                                                self.present(myAlert, animated: true, completion: nil)
                                            }else if(status == "sameteam") {
                                                self.activityIndicator.stopAnimating()
                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                
                                                let myAlert = UIAlertController(title: "교류전 신청", message: "같은 팀이 등록한 교류전은 신청이 불가능합니다", preferredStyle: UIAlertControllerStyle.alert)
                                                let okAction = UIAlertAction(title: "신청", style: UIAlertActionStyle.default, handler: nil)
                                                myAlert.addAction(okAction)
                                                self.present(myAlert, animated: true, completion: nil)
                                            }else if(status == "deleted") {
                                                self.activityIndicator.stopAnimating()
                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                
                                                let myAlert = UIAlertController(title: "교류전 신청", message: "삭제된 교류전입니다", preferredStyle: UIAlertControllerStyle.alert)
                                                let okAction = UIAlertAction(title: "신청", style: UIAlertActionStyle.default, handler: nil)
                                                myAlert.addAction(okAction)
                                            }
                                        }
                                    }
                                }
                            }else { // 팀이 없을시
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                let myAlert = UIAlertController(title: nil, message: "팀에 가입되어 있지 않습니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }else { // 로그인 필요
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                let myAlert = UIAlertController(title: nil, message: "로그인이 필요한 페이지입니다", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
            }
        }
    }
}
