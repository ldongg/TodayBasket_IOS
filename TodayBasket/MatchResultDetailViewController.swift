//
//  MatchResultDetailViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 6. 25..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

struct  matchPointData {
    var homePoint:String = ""
    var awayPoint:String = ""
}

class MatchResultDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTeamEmblemImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    
    @IBOutlet weak var awayTeamEmblemImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    
    @IBOutlet weak var matchDateLabel: UITextField!
    @IBOutlet weak var matchTimeLabel: UITextField!
    @IBOutlet weak var matchPlaceLabel: UITextField!
    @IBOutlet weak var matchPayLabel: UITextField!
    @IBOutlet weak var matchUniformLabel: UITextField!
    
    @IBOutlet weak var matchParkForbiddenView: UIView!
    @IBOutlet weak var matchParkFreeView: UIView!
    @IBOutlet weak var matchParkChargeView: UIView!
    @IBOutlet weak var matchDisplayView: UIView!
    @IBOutlet weak var matchShowerView: UIView!
    @IBOutlet weak var matchColdHotView: UIView!
    
    @IBOutlet weak var matchExtraTextView: UITextView!
    
    @IBOutlet weak var matchResultTableView: UITableView!
    @IBOutlet weak var matchResultTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var resultInputButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    var matchPk:String = ""
    var homeUserPk:String = ""
    var awayUserPk:String = ""
    var homeTeamPk:String = ""
    var homeTeamEmblem:String = ""
    var homeTeamName:String = ""
    var homeTeamUserPk:String = ""
    var awayTeamPk:String = ""
    var awayTeamEmblem:String = ""
    var awayTeamName:String = ""
    var awayTeamUserPk:String = ""
    var matchTitle:String = ""
    var matchDate:String = ""
    var matchStartTime:String = ""
    var matchFinishTime:String = ""
    var matchTime:String = ""
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
    
    var game1Home:String = ""
    var game1Away:String = ""
    var game2Home:String = ""
    var game2Away:String = ""
    var game3Home:String = ""
    var game3Away:String = ""
    
    
    var arrRes = [[String:AnyObject]]()
    
    var matchPoint = matchPointData()
    var matchPointList:[matchPointData] = []
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    
    var isMain:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
        }
        resultInputButton.isHidden = true
        contactButton.isHidden = true
        
        matchResultTableView.delegate = self
        matchResultTableView.dataSource = self
        matchResultTableView.isHidden = true
        
        homeTeamEmblemImageView.layer.cornerRadius = homeTeamEmblemImageView.frame.size.width/2
        homeTeamEmblemImageView.clipsToBounds = true
        
        awayTeamEmblemImageView.layer.cornerRadius = awayTeamEmblemImageView.frame.size.width/2
        awayTeamEmblemImageView.clipsToBounds = true
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        if(isMain) {
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchResultDetail.jsp?Data1=\(matchPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if self.arrRes.count > 0 {
                        
                        var dict = self.arrRes[0]
                        
                        self.homeTeamPk = dict["homeTeamPk"] as! String
                        self.homeTeamEmblem = dict["homeTeamEmblem"] as! String
                        self.homeTeamName = dict["homeTeamName"] as! String
                        self.homeTeamUserPk = dict["homeTeamUserPk"] as! String
                        self.awayTeamPk = dict["awayTeamPk"] as! String
                        self.awayTeamEmblem = dict["awayTeamEmblem"] as! String
                        self.awayTeamName = dict["awayTeamName"] as! String
                        self.awayTeamUserPk = dict["awayTeamUserPk"] as! String
                        self.matchTitle = dict["matchTitle"] as! String
                        self.matchPlace = dict["matchPlace"] as! String
                        self.matchDate = dict["matchDate"] as! String
                        self.matchPay = dict["matchPay"] as! String
                        self.matchUniform = dict["matchUniform"] as! String
                        self.matchExtra = dict["matchExtra"] as! String
                        self.matchStartTime = dict["matchStartTime"] as! String
                        self.matchFinishTime = dict["matchFinishTime"] as! String
                        self.matchStatus = dict["matchStatus"] as! String
                        self.game1Home = dict["game1Home"] as! String
                        self.game1Away = dict["game1Away"] as! String
                        self.game2Home = dict["game2Home"] as! String
                        self.game2Away = dict["game2Away"] as! String
                        self.game3Home = dict["game3Home"] as! String
                        self.game3Away = dict["game3Away"] as! String
                        self.matchParkForbidden = dict["matchParkForbidden"] as! String
                        self.matchParkFree = dict["matchParkFree"] as! String
                        self.matchParkCharge = dict["matchParkCharge"] as! String
                        self.matchDisplay = dict["matchDisplay"] as! String
                        self.matchShower = dict["matchShower"] as! String
                        self.matchColdhot = dict["matchColdHot"] as! String
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultUploadPopUp") as! MatchResultUploadViewController
                        
                        popOverVC.matchPk = self.matchPk
                        popOverVC.matchStatus = self.matchStatus
                        popOverVC.game1Home = self.game1Home
                        popOverVC.game1Away = self.game1Away
                        popOverVC.game2Home = self.game2Home
                        popOverVC.game2Away = self.game2Away
                        popOverVC.game3Home = self.game3Home
                        popOverVC.game3Away = self.game3Away
                        popOverVC.homeTeamUserPk = self.homeTeamUserPk
                        popOverVC.awayTeamUserPk = self.awayTeamUserPk
                        popOverVC.homeTeamPk = self.homeTeamPk
                        popOverVC.awayTeamPk = self.awayTeamPk
                        popOverVC.homeTeamName = self.homeTeamName
                        popOverVC.awayTeamName = self.awayTeamName
                        popOverVC.homeTeamEmblem = self.homeTeamEmblem
                        popOverVC.awayTeamEmblem = self.awayTeamEmblem
                        
                        self.navigationController?.navigationBar.layer.zPosition = -1
                        self.navigationController?.navigationBar.isUserInteractionEnabled = false
                        self.addChildViewController(popOverVC)
                        self.view.addSubview(popOverVC.view)
                        
                        popOverVC.didMove(toParentViewController: self)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchResultDetail.jsp?Data1=\(matchPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    
                    var dict = self.arrRes[0]
                    
                    self.homeTeamPk = dict["homeTeamPk"] as! String
                    self.homeTeamEmblem = dict["homeTeamEmblem"] as! String
                    self.homeTeamName = dict["homeTeamName"] as! String
                    self.homeTeamUserPk = dict["homeTeamUserPk"] as! String
                    self.awayTeamPk = dict["awayTeamPk"] as! String
                    self.awayTeamEmblem = dict["awayTeamEmblem"] as! String
                    self.awayTeamName = dict["awayTeamName"] as! String
                    self.awayTeamUserPk = dict["awayTeamUserPk"] as! String
                    self.matchTitle = dict["matchTitle"] as! String
                    self.matchPlace = dict["matchPlace"] as! String
                    self.matchDate = dict["matchDate"] as! String
                    self.matchPay = dict["matchPay"] as! String
                    self.matchUniform = dict["matchUniform"] as! String
                    self.matchExtra = dict["matchExtra"] as! String
                    self.matchStartTime = dict["matchStartTime"] as! String
                    self.matchFinishTime = dict["matchFinishTime"] as! String
                    self.matchStatus = dict["matchStatus"] as! String
                    self.game1Home = dict["game1Home"] as! String
                    self.game1Away = dict["game1Away"] as! String
                    self.game2Home = dict["game2Home"] as! String
                    self.game2Away = dict["game2Away"] as! String
                    self.game3Home = dict["game3Home"] as! String
                    self.game3Away = dict["game3Away"] as! String
                    self.matchParkForbidden = dict["matchParkForbidden"] as! String
                    self.matchParkFree = dict["matchParkFree"] as! String
                    self.matchParkCharge = dict["matchParkCharge"] as! String
                    self.matchDisplay = dict["matchDisplay"] as! String
                    self.matchShower = dict["matchShower"] as! String
                    self.matchColdhot = dict["matchColdHot"] as! String
                    
                    if(self.matchStatus == "Not_Insert") {
                        if(self.userPk == self.homeTeamUserPk) {
                            self.resultInputButton.isHidden = false
                        }else {
                            self.resultInputButton.isHidden = true
                        }
                    }else if (self.matchStatus == "Home_Insert") {
                        if(self.userPk == self.awayTeamUserPk) {
                            self.resultInputButton.isHidden = false
                        }else {
                            self.resultInputButton.isHidden = true
                        }
                    }else {
                        self.navigationItem.rightBarButtonItem = nil
                    }
                    
                    if(self.userPk == self.homeTeamUserPk || self.userPk == self.awayTeamUserPk) {
                        self.contactButton.isHidden = false
                    }
                    
                    
                    if(self.homeTeamName == ".") {
                        self.homeTeamNameLabel.text = "해산한 팀입니다"
                        self.awayTeamNameLabel.text = self.awayTeamName
                    }else if(self.awayTeamName == ".") {
                        self.homeTeamNameLabel.text = self.homeTeamName
                        self.awayTeamNameLabel.text = "해산한 팀입니다"
                    }else {
                        self.homeTeamNameLabel.text = self.homeTeamName
                        self.awayTeamNameLabel.text = self.awayTeamName
                    }
                    
                    
                    // 메인스코어 설정
                    if(self.game1Home != ".") {
                        self.homeTeamScoreLabel.text = self.game1Home
                        self.awayTeamScoreLabel.text = self.game1Away
                    }else {
                        self.homeTeamScoreLabel.text = ""
                        self.awayTeamScoreLabel.text = ""
                    }
                    
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
                    
                    
                    
                    let cal = Calendar(identifier: .gregorian)
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ko_KR")
                    
                    // 경기 날짜
                    dateFormatter.dateFormat = "yyyy:::M / d"
                    
                    let _matchDate = dateFormatter.date(from: self.matchDate)
                    let comp = cal.dateComponents([.year, .month, .day], from: _matchDate!)
                    
                    self.matchDateLabel.text = "\(comp.year!) / \(comp.month!) / \(comp.day!)"
                    
                    // 경기 시간
                    dateFormatter.dateFormat = "H:m"
                    
                    let _matchStartTime = dateFormatter.date(from: self.matchStartTime)
                    let _matchFinishTime = dateFormatter.date(from: self.matchFinishTime)
                    
                    
                    let comp1 = cal.dateComponents([.hour, .minute], from: _matchStartTime!)
                    if(comp1.minute! == 0) {
                        self.matchStartTime = "\(comp1.hour!)시"
                    }else {
                        self.matchStartTime = "\(comp1.hour!)시 \(comp1.minute!)분"
                    }
                    
                    let comp2 = cal.dateComponents([.hour, .minute], from: _matchFinishTime!)
                    if(comp2.minute! == 0) {
                        self.matchFinishTime = "\(comp2.hour!)시"
                    }else {
                        self.matchFinishTime = "\(comp2.hour!)시 \(comp2.minute!)분"
                    }
                    
                    self.matchTimeLabel.text = "\(self.matchStartTime) ~ \(self.matchFinishTime)"
                    
                    
                    // 나머지 기본 정보
                    self.matchPlaceLabel.text = self.matchPlace
                    self.matchPayLabel.text = self.matchPay
                    self.matchUniformLabel.text = self.matchUniform
                    self.matchExtraTextView.text = self.matchExtra
                    
                    // 주차 여부
                    if(self.matchParkForbidden == "true") {
                        self.matchParkFreeView.backgroundColor = UIColor.white
                        self.matchParkChargeView.backgroundColor = UIColor.white
                        self.matchParkForbiddenView.backgroundColor = UIColor.groupTableViewBackground
                    }else if(self.matchParkFree == "true") {
                        self.matchParkFreeView.backgroundColor = UIColor.groupTableViewBackground
                        self.matchParkChargeView.backgroundColor = UIColor.white
                        self.matchParkForbiddenView.backgroundColor = UIColor.white
                    }else if(self.matchParkCharge == "true") {
                        self.matchParkFreeView.backgroundColor = UIColor.white
                        self.matchParkChargeView.backgroundColor = UIColor.groupTableViewBackground
                        self.matchParkForbiddenView.backgroundColor = UIColor.white
                    }
                    
                    // 전광판
                    if(self.matchDisplay == "true") {
                        self.matchDisplayView.backgroundColor = UIColor.groupTableViewBackground
                    }else {
                        self.matchDisplayView.backgroundColor = UIColor.white
                    }
                    
                    // 샤워
                    if(self.matchShower == "true") {
                        self.matchShowerView.backgroundColor = UIColor.groupTableViewBackground
                    }else {
                        self.matchShowerView.backgroundColor = UIColor.white
                    }
                    
                    // 냉난방
                    if(self.matchColdhot == "true") {
                        self.matchColdHotView.backgroundColor = UIColor.groupTableViewBackground
                    }else {
                        self.matchColdHotView.backgroundColor = UIColor.white
                    }
                    
                    // 포인트 리스트에 점수 저장
                    if(self.game1Home == ".") {
                        self.matchResultTableViewHeightConstraint.constant = 70
                    }else {
                        self.matchResultTableView.tableHeaderView?.frame.size.height = 0
                        self.matchResultTableView.tableHeaderView?.isHidden = true
                        if(self.game2Home == ".") {
                            var matchPoint1 = matchPointData()
                            matchPoint1.homePoint = self.game1Home
                            matchPoint1.awayPoint = self.game1Away
                            self.matchPointList.append(matchPoint1)
                            self.matchResultTableViewHeightConstraint.constant = 70
                        }else {
                            if(self.game3Home == ".") {
                                var matchPoint1 = matchPointData()
                                matchPoint1.homePoint = self.game1Home
                                matchPoint1.awayPoint = self.game1Away
                                self.matchPointList.append(matchPoint1)
                                
                                var matchPoint2 = matchPointData()
                                matchPoint2.homePoint = self.game2Home
                                matchPoint2.awayPoint = self.game2Away
                                self.matchPointList.append(matchPoint2)
                                self.matchResultTableViewHeightConstraint.constant = 140
                            }else {
                                var matchPoint1 = matchPointData()
                                matchPoint1.homePoint = self.game1Home
                                matchPoint1.awayPoint = self.game1Away
                                self.matchPointList.append(matchPoint1)
                                
                                var matchPoint2 = matchPointData()
                                matchPoint2.homePoint = self.game2Home
                                matchPoint2.awayPoint = self.game2Away
                                self.matchPointList.append(matchPoint2)
                                
                                var matchPoint3 = matchPointData()
                                matchPoint3.homePoint = self.game3Home
                                matchPoint3.awayPoint = self.game3Away
                                self.matchPointList.append(matchPoint3)
                                self.matchResultTableViewHeightConstraint.constant = 210
                            }
                        }
                    }
                    self.matchResultTableView.isHidden = false
                    self.matchResultTableView.reloadData()
                    
                    // 인디케이터 종료
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchPointList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = matchResultTableView.dequeueReusableCell(withIdentifier: "matchPointCell")
        
        let homeEmblemImageView = cell?.viewWithTag(1) as! UIImageView
        let homeNameLabel = cell?.viewWithTag(2) as! UILabel
        let homeScoreLabel = cell?.viewWithTag(3) as! UILabel
        let awayEmblemImageView = cell?.viewWithTag(4) as! UIImageView
        let awayNameLabel = cell?.viewWithTag(5) as! UILabel
        let awayScoreLabel = cell?.viewWithTag(6) as! UILabel
        let centerLabel = cell?.viewWithTag(7) as! UILabel
        
        // 엠블럼 삽입
        homeEmblemImageView.layer.cornerRadius = homeEmblemImageView.frame.size.width/2
        homeEmblemImageView.clipsToBounds = true
        awayEmblemImageView.layer.cornerRadius = awayEmblemImageView.frame.size.width/2
        awayEmblemImageView.clipsToBounds = true
        homeEmblemImageView.image = homeTeamEmblemImageView.image
        awayEmblemImageView.image = awayTeamEmblemImageView.image
        
        // 팀 이름 삽입
        homeNameLabel.text = homeTeamNameLabel.text
        awayNameLabel.text = awayTeamNameLabel.text
        
        // 점수 삽입
        homeScoreLabel.text = matchPointList[indexPath.row].homePoint
        awayScoreLabel.text = matchPointList[indexPath.row].awayPoint
        
        // 가운데 라벨 삽입
        centerLabel.text = "\(indexPath.row + 1)경기"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func resultInputButtonTapped(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultUploadPopUp") as! MatchResultUploadViewController
        
        popOverVC.matchPk = self.matchPk
        popOverVC.matchStatus = self.matchStatus
        popOverVC.game1Home = self.game1Home
        popOverVC.game1Away = self.game1Away
        popOverVC.game2Home = self.game2Home
        popOverVC.game2Away = self.game2Away
        popOverVC.game3Home = self.game3Home
        popOverVC.game3Away = self.game3Away
        popOverVC.homeTeamUserPk = self.homeTeamUserPk
        popOverVC.awayTeamUserPk = self.awayTeamUserPk
        popOverVC.homeTeamPk = self.homeTeamPk
        popOverVC.awayTeamPk = self.awayTeamPk
        popOverVC.homeTeamName = self.homeTeamName
        popOverVC.awayTeamName = self.awayTeamName
        popOverVC.homeTeamEmblem = self.homeTeamEmblem
        popOverVC.awayTeamEmblem = self.awayTeamEmblem
        self.navigationController?.navigationBar.layer.zPosition = -1
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        
        popOverVC.didMove(toParentViewController: self)
    }
    
    @IBAction func contactButtonTapped(_ sender: Any) {
        var contactUserPk:String = ""
        var contactUserPhone:String = ""
        if(userPk == homeTeamUserPk) {
            contactUserPk = awayTeamUserPk
        }else {
            contactUserPk = homeTeamUserPk
        }
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/GetPhone.jsp?Data1=\(contactUserPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    if(dict["status"] as! String == "succed") {
                        contactUserPhone = dict["Phone"] as! String
                        if(contactUserPhone != ".") {
                            let url = NSURL(string: "tel://\(contactUserPhone)")!
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url as URL)
                            }else {
                                UIApplication.shared.openURL(url as URL)
                            }
                        }else {
                            let myAlert = UIAlertController(title: nil, message: "상대방 정보가 없습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }else {
                    let myAlert = UIAlertController(title: nil, message: "상대방 정보가 없습니다", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                }
            }
        }
    }
}
