//
//  MatchRegisterDetailViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 7. 16..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

struct matchRequestData {
    var matchRequestPk:String = ""
    var matchRequestUserPk:String = ""
    var matchRequestTeamPk:String = ""
    var matchRequestTeamEmblem:String = ""
    var matchRequestTeamName:String = ""
    var matchRequestMemo:String = ""
}

class MatchRegisterDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    @IBOutlet weak var matchColdHotView: UIView!
    @IBOutlet weak var matchExtraTextView: UITextView!
    @IBOutlet weak var matchRequestTableView: UITableView!
    
    @IBOutlet weak var matchRequestTableViewHeightConstraint: NSLayoutConstraint!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var isUserLoggedIn:Bool = false
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
    
    var matchStartTime_:Date = Date()
    
    var arrRes = [[String:AnyObject]]()
    var matchRequestList = [matchRequestData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teamEmblemImageView.layer.cornerRadius = self.teamEmblemImageView.frame.size.width/2
        self.teamEmblemImageView.clipsToBounds = true
        self.teamEmblemImageView.backgroundColor = UIColor.white
        
        self.matchRequestTableView.delegate = self
        self.matchRequestTableView.dataSource = self
        
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
                    }
                }
            }
        }
        
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
                    
                    // 팀명 삽입
                    self.teamNameLabel.text = self.matchTeamName
                    
                    // 교류전 상태 삽입
                    let dateFormatterStatus = DateFormatter()
                    dateFormatterStatus.dateFormat = "yyyy:::MM / dd:::HH:m"
                    let matchStatusTime = dateFormatterStatus.date(from: "\(self.matchDate):::\(self.matchStartTime)")
                    let nowTime = Date()
                    if(matchStatusTime! < nowTime) {
                        self.matchStatusLabel.text = "마감"
                    }else {
                        self.matchStatusLabel.text = "모집중"
                    }
                    
                    // 교류전 날짜 및 시간 삽입
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy:::MM / dd ::: H:m"
                    dateFormatter.locale = Locale(identifier: "ko_KR")
                    
                    let startDate = "\(self.matchDate) ::: \(self.matchStartTime)"
                    let finishDate = "\(self.matchDate) ::: \(self.matchFinishTime)"
                    
                    let startTime = dateFormatter.date(from: startDate)
                    let finishTime = dateFormatter.date(from: finishDate)
                    
                    self.matchStartTime_ = startTime!
                    
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
                    
                    // 교류전 장소 삽입
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
                        self.matchColdHotView.backgroundColor = UIColor.groupTableViewBackground
                    }else {
                        self.matchColdHotView.backgroundColor = UIColor.white
                    }
                    self.matchExtraTextView.text = self.matchExtra
                }
                
                // 교류전 신청 팀 받아오기
                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchRequestDetailJoiner.jsp?Data1=\(self.matchPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        print(responseData.result.value!)
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                        }
                        
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            var matchRequest = matchRequestData()
                            
                            matchRequest.matchRequestPk = dict["matchRequestPk"] as! String
                            matchRequest.matchRequestUserPk = dict["matchRequestUserPk"] as! String
                            matchRequest.matchRequestTeamPk = dict["matchRequestTeamPk"] as! String
                            matchRequest.matchRequestTeamEmblem = dict["matchRequestTeamEmblem"] as! String
                            matchRequest.matchRequestTeamName = dict["matchRequestTeamName"] as! String
                            matchRequest.matchRequestMemo = dict["matchRequestMemo"] as! String
                            
                            self.matchRequestList.append(matchRequest)
                        }
                        
                        self.matchRequestTableViewHeightConstraint.constant = CGFloat(self.matchRequestList.count) * 70
                        self.matchRequestTableView.reloadData()
                        
                        if(self.matchRequestList.count == 0) {
                            self.matchRequestTableView.isHidden = true
                        }else {
                            self.matchRequestTableView.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("Memory Warning!")
        viewDidLoad()
    }
    
    func allowButtonTapped (sender: UIButton) {
        let nowTime = Date()
        if(matchStartTime_ < nowTime) {
            let myAlert = UIAlertController(title: nil, message: "마감된 경기입니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            })
            myAlert.addAction(okAction)
            present(myAlert, animated: true, completion: nil)
        }else {
            let myAlert = UIAlertController(title: nil, message: "수락시 교류전이 성사되며, 다른 신청팀들은 자동 거절됩니다 \n 성사된 교류전은 교류전결과 메뉴에서 확인하실 수 있습니다", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                
                // 로딩 시작
                self.activityIndicator.center = self.view.center
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                self.view.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let row:Int = Int(sender.accessibilityHint!)!
                
                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchRequestDetailJoinerAllow.jsp?Data1=\(self.matchPk)&Data2=\(self.matchRequestList[row].matchRequestPk)&Data3=\(self.matchRequestList[row].matchRequestUserPk)&Data4=\(self.matchRequestList[row].matchRequestTeamPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        print(responseData.result.value!)
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                        }
                        if(self.arrRes[0]["msg1"] as! String == "succed") {
                            
                            // 푸쉬알람
                            let url = "http://210.122.7.193:8080/TodayBasket_manager/push.jsp?Data1=\(self.matchRequestList[row].matchRequestUserPk)&Data2=\(self.teamName)팀 교류전 신청 수락!".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                if((responseData.result.value) != nil) {
                                }
                            }
                            
                            // 경기후 예약 푸쉬
                            let app = UIApplication.shared
                            
                            let notifyAlarm = UILocalNotification() // 알람 객체생성
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy:::MM / dd:::H:m"
                            let matchFinishTime_ = "\(self.matchDate):::\(self.matchFinishTime)"
                            let date:Date = dateFormatter.date(from: matchFinishTime_)!
                            notifyAlarm.timeZone = NSTimeZone.default
                            notifyAlarm.alertBody = "오늘 경기는 즐거우셨나요? 교류전 결과를 입력해보세요!" // 알람 문구
                            notifyAlarm.fireDate = date // 알람이 울릴 날짜
                            notifyAlarm.userInfo = ["id": 11]
                            
                            app.scheduleLocalNotification(notifyAlarm) // 알람추가
                            
                            // 로딩 끝
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            // 신청 완료 알림
                            let myAlert = UIAlertController(title: nil, message: "신청이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            })
            myAlert.addAction(cancelAction)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = matchRequestTableView.dequeueReusableCell(withIdentifier: "matchRequestCell")
        
        let matchRequestTeamEmblemImageView = cell?.viewWithTag(1) as! UIImageView
        let matchRequestTeamNameLabel = cell?.viewWithTag(2) as! UILabel
        let matchRequestMemoLabel = cell?.viewWithTag(3) as! UILabel
        let matchRequestAllowButton = cell?.viewWithTag(4) as! UIButton
        
        // 팀 엠블럼 삽입
        if(matchRequestList[indexPath.row].matchRequestTeamEmblem != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/team/\(matchRequestList[indexPath.row].matchRequestTeamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            matchRequestTeamEmblemImageView.af_setImage(withURL: URL(string: url!)!)
        }else {
            matchRequestTeamEmblemImageView.image = UIImage(named: "ic_team")
        }
        
        // 팀 엠블럼 원
        matchRequestTeamEmblemImageView.layer.cornerRadius = matchRequestTeamEmblemImageView.frame.size.width/2
        matchRequestTeamEmblemImageView.clipsToBounds = true
        
        // 팀 이름 삽입
        matchRequestTeamNameLabel.text = matchRequestList[indexPath.row].matchRequestTeamName
        
        // 한줄 메모 삽입
        matchRequestMemoLabel.text = matchRequestList[indexPath.row].matchRequestMemo
        
        // 수락 버튼 이벤트
        matchRequestAllowButton.accessibilityHint = "\(indexPath.row)"
        matchRequestAllowButton.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func matchDeleteButtonTapped(_ sender: Any) {
        let myAlert = UIAlertController(title: nil, message: "교류전을 삭제하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "아니요", style: UIAlertActionStyle.cancel, handler: nil)
        let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchRegisterDelete.jsp?Data1=\(self.matchPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    print(responseData.result.value!)
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if(self.arrRes[0]["msg1"] as! String == "succed") {
                        let myAlert = UIAlertController(title: nil, message: "교류전이 삭제되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                    }
                }
            }
        })
        myAlert.addAction(cancelAction)
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goTeamDetail") {
            let teamDetailViewController = segue.destination as! TeamDetailViewController
            let myIndexPath = self.matchRequestTableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            teamDetailViewController.teamPk = self.matchRequestList[row].matchRequestTeamPk
        }
    }
    
}
