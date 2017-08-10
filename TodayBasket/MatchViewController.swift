//
//  MatchViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class MatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var matchTableView: UITableView!
    @IBOutlet weak var matchRegisterButton: UIBarButtonItem!
    
    @IBOutlet weak var matchModeSegmentedControl: UISegmentedControl!
    
    
    var arrRes = [[String:AnyObject]]()
    var matchSetting = MatchSetting()
    var matchList:[MatchSetting] = []
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    
    var matchMode = "search"
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var refresher:UIRefreshControl!

    var isScrollFinished:Bool = false
    var isMain:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchTableView.dataSource = self
        matchTableView.delegate = self
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        matchTableView.addSubview(refresher)

        if(isMain) {
            self.navigationItem.leftBarButtonItem = nil
        }else {
            self.navigationItem.leftBarButtonItem = open
        }
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            Alamofire.request("http://210.122.7.193:8080/Trophy_part3/getTeamPk.jsp?Data1=\(userPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print("\(self.arrRes)")
                    }
                    
                    if self.arrRes.count > 0 {
                        var dict = self.arrRes[0]
                        let teamPk = dict["teamPk"] as! String
                        if(teamPk != ".") {
                            self.navigationItem.rightBarButtonItem = self.matchRegisterButton
                        }else {
                            self.navigationItem.rightBarButtonItem = nil
                        }
                    }
                }
            }
        }else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if(matchMode == "search") {
            getMatchs()
        }else if(matchMode == "request") {
            getRequestMatch()
        }else if(matchMode == "register") {
            getRegisterMatch()
        }
    }
    
    func refresh() {
        if(matchMode == "search") {
            getMatchs()
        }else if(matchMode == "request") {
            getRequestMatch()
        }else if(matchMode == "register") {
            getRegisterMatch()
        }
    }
    
    func getMatchs() {
        startActivity()
        isScrollFinished = false
        matchList = []
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/Match.jsp").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        self.matchSetting = MatchSetting()
                        self.matchSetting.matchPk = dict["matchPk"] as! String
                        self.matchSetting.teamEmblem = dict["teamEmblem"] as! String
                        self.matchSetting.teamName = dict["teamName"] as! String
                        self.matchSetting.matchTitle = dict["matchTitle"] as! String
                        self.matchSetting.matchPlace = dict["matchPlace"] as! String
                        self.matchSetting.matchDate = dict["matchDate"] as! String
                        self.matchSetting.matchStartTime = dict["matchStartTime"] as! String
                        self.matchSetting.matchFinishTime = dict["matchFinishTime"] as! String
                        self.matchSetting.matchStatus = dict["matchStatus"] as! String
                        self.matchSetting.matchUploadTime = dict["matchUploadTime"] as! String
                        
                        
                        // 모집중만 테이블뷰에 삽입
                        if(self.matchSetting.matchStatus == "recruiting") {
                            self.matchList.append(self.matchSetting)
                        }
                    }
                    self.matchTableView.reloadData()
                    
                    self.stopActivity()
                }
            }
        }
    }
    
    func getRequestMatch() {
        startActivity()
        matchList = []
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchRequest.jsp?Data1=\(self.userPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if self.arrRes.count > 0 {
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            self.matchSetting = MatchSetting()
                            self.matchSetting.matchPk = dict["matchPk"] as! String
                            self.matchSetting.teamEmblem = dict["teamEmblem"] as! String
                            self.matchSetting.teamName = dict["teamName"] as! String
                            self.matchSetting.matchTitle = dict["matchTitle"] as! String
                            self.matchSetting.matchPlace = dict["matchPlace"] as! String
                            self.matchSetting.matchStatus = dict["matchStatus"] as! String
                            self.matchSetting.matchDate = dict["matchDate"] as! String
                            self.matchSetting.matchStartTime = dict["matchStartTime"] as! String
                            self.matchSetting.matchFinishTime = dict["matchFinishTime"] as! String
                            
                            
                            self.matchList.append(self.matchSetting)
                            
                        }
                        self.matchTableView.reloadData()
                        
                        
                    }
                }
            }
            self.stopActivity()
            
        }else {
            self.stopActivity()
            let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요한 페이지입니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: {action in
                self.navigationController?.popToRootViewController(animated: true)
            })
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    func getRegisterMatch() {
        startActivity()
        matchList = []
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchRegister.jsp?Data1=\(self.userPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if self.arrRes.count > 0 {
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            self.matchSetting = MatchSetting()
                            self.matchSetting.matchPk = dict["matchPk"] as! String
                            self.matchSetting.teamEmblem = dict["teamEmblem"] as! String
                            self.matchSetting.teamName = dict["teamName"] as! String
                            self.matchSetting.matchTitle = dict["matchTitle"] as! String
                            self.matchSetting.matchPlace = dict["matchPlace"] as! String
                            self.matchSetting.matchDate = dict["matchDate"] as! String
                            self.matchSetting.matchStartTime = dict["matchStartTime"] as! String
                            self.matchSetting.matchFinishTime = dict["matchFinishTime"] as! String
                            self.matchSetting.matchStatus = dict["matchStatus"] as! String
                            self.matchSetting.matchJoinCount = dict["matchJoinerCount"] as! String
                            
                            self.matchList.append(self.matchSetting)
                            
                        }
                        self.matchTableView.reloadData()
                    }
                }
            }
            self.stopActivity()

        }else {
            self.stopActivity()
            let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요한 페이지입니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: {action in
                self.navigationController?.popToRootViewController(animated: true)
            })
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = nil
        if(matchMode == "search") {
            cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)
            
            let teamEmblemImageView = cell.viewWithTag(1) as! UIImageView
            let teamNameLabel = cell.viewWithTag(2) as! UILabel
            let matchTitleLabel = cell.viewWithTag(3) as! UILabel
            let matchTime = cell.viewWithTag(4) as! UILabel
            let matchPlace = cell.viewWithTag(5) as! UILabel
            let matchUploadTime = cell.viewWithTag(6) as! UILabel
            let matchStatus = cell.viewWithTag(7) as! UILabel
            
            // 팀 이름 삽입
            teamNameLabel.text = matchList[indexPath.row].teamName
            
            // 교류전 제목 삽입
            matchTitleLabel.text = matchList[indexPath.row].matchTitle
            
            // 교류전 장소 삽입
            matchPlace.text = matchList[indexPath.row].matchPlace
            
            // 교류전 시간 삽입
            let cal = Calendar(identifier: .gregorian)
            
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "H:m"
            
            let _matchStartTime = dateFormatterTime.date(from: matchList[indexPath.row].matchStartTime)
            let _matchFinishTime = dateFormatterTime.date(from: matchList[indexPath.row].matchFinishTime)
            
            let compStart = cal.dateComponents([.hour, .minute], from: _matchStartTime!)
            let compFinish = cal.dateComponents([.hour, .minute], from: _matchFinishTime!)
            
            var startTime:String = ""
            var finishTime:String = ""
            
            if(compStart.minute! == 0) {
                startTime = "\(compStart.hour!)시"
            }else {
                startTime = "\(compStart.hour!)시 \(compStart.minute!)분"
            }
            
            if(compFinish.minute! == 0) {
                finishTime = "\(compFinish.hour!)시"
            }else {
                finishTime = "\(compFinish.hour!)시 \(compFinish.minute!)분"
            }
            
            matchTime.text = "\(startTime) ~ \(finishTime)"
            
            // 팀 엠블럼 삽입
            teamEmblemImageView.layer.cornerRadius = teamEmblemImageView.frame.size.width / 2
            teamEmblemImageView.clipsToBounds = true
            if(matchList[indexPath.row].teamEmblem != ".") {
                let url = "http://210.122.7.193:8080/Trophy_img/team/\(matchList[indexPath.row].teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseImage { response in
                    if let image = response.result.value {
                        teamEmblemImageView.image = image
                    }
                }
            }else {
                teamEmblemImageView.image = UIImage(named: "ic_team")
            }
            
            // 업로드 시간 삽입
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"
            
            let nowTime = Date()
            let uploadTime = dateFormatter.date(from: matchList[indexPath.row].matchUploadTime)
            
            let comp = cal.dateComponents([.day, .hour, .minute], from: uploadTime!, to: nowTime)
            if(comp.day! == 0) {
                if(comp.hour! == 0) {
                    if(comp.minute! == 0) {
                        matchUploadTime.text = "방금"
                    }else {
                        matchUploadTime.text = "\(comp.minute!)분 전"
                    }
                }else {
                    matchUploadTime.text = "\(comp.hour!)시간 전"
                }
            }else if(comp.day! < 8) {
                if(comp.day! == 1) {
                    matchUploadTime.text = "어제"
                }else if(comp.day! == 7) {
                    matchUploadTime.text = "일주일 전"
                }else {
                    matchUploadTime.text = "\(comp.day!)일 전"
                }
            }else {
                let compUploadTime = cal.dateComponents([.year, .month, .day], from: uploadTime!)
                
                matchUploadTime.text = "\(compUploadTime.month!) / \(compUploadTime.day!)"
            }
            
            // 상태 삽입
            let dateFormatterStatus = DateFormatter()
            dateFormatterStatus.dateFormat = "yyyy:::MM / dd:::H:m"
            let matchStatusTime = dateFormatterStatus.date(from: "\(matchList[indexPath.row].matchDate):::\(matchList[indexPath.row].matchStartTime)")
            if(matchStatusTime! < nowTime) {
                matchStatus.text = "마감"
            }else {
                matchStatus.text = "모집중"
            }
        }else if(matchMode == "request") {
            cell = tableView.dequeueReusableCell(withIdentifier: "matchRequestCell", for: indexPath)
            
            let teamEmblemImageView = cell.viewWithTag(1) as! UIImageView
            let teamNameLabel = cell.viewWithTag(2) as! UILabel
            let matchTitleLabel = cell.viewWithTag(3) as! UILabel
            let matchTime = cell.viewWithTag(4) as! UILabel
            let matchPlace = cell.viewWithTag(5) as! UILabel
            let matchStatusLabel = cell.viewWithTag(6) as! UILabel
            
            // 팀 이름 삽입
            teamNameLabel.text = matchList[indexPath.row].teamName
            
            // 교류전 제목 삽입
            matchTitleLabel.text = matchList[indexPath.row].matchTitle
            
            // 교류전 장소 삽입
            matchPlace.text = matchList[indexPath.row].matchPlace
            
            // 교류전 시간 삽입
            let cal = Calendar(identifier: .gregorian)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"
            dateFormatter.dateFormat = "H:m"
            
            let _matchStartTime = dateFormatter.date(from: matchList[indexPath.row].matchStartTime)
            let _matchFinishTime = dateFormatter.date(from: matchList[indexPath.row].matchFinishTime)
            
            let compStart = cal.dateComponents([.hour, .minute], from: _matchStartTime!)
            let compFinish = cal.dateComponents([.hour, .minute], from: _matchFinishTime!)
            
            var startTime:String = ""
            var finishTime:String = ""
            
            if(compStart.minute! == 0) {
                startTime = "\(compStart.hour!)시"
            }else {
                startTime = "\(compStart.hour!)시 \(compStart.minute!)분"
            }
            
            if(compFinish.minute! == 0) {
                finishTime = "\(compFinish.hour!)시"
            }else {
                finishTime = "\(compFinish.hour!)시 \(compFinish.minute!)분"
            }
            
            
            matchTime.text = "\(startTime) ~ \(finishTime)"
            
            // 교류전 상태 삽입
            if(matchList[indexPath.row].matchStatus == "allow") {
                matchStatusLabel.text = "수락"
            }else if(matchList[indexPath.row].matchStatus == "refuse") {
                matchStatusLabel.text = "거절"
            }else {
                let nowDate = Date()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy:::MM / dd:::H:m"
                
                let matchDateString = "\(matchList[indexPath.row].matchDate):::\(matchList[indexPath.row].matchStartTime)"
                
                print(matchDateString)
                
                let matchDate = dateFormatter.date(from: matchDateString)
                
                if(matchDate! < nowDate) {
                    matchStatusLabel.text = "마감"
                }else {
                    matchStatusLabel.text = "신청중"
                }
            }
            
            // 이미지 삽입
            teamEmblemImageView.layer.cornerRadius = teamEmblemImageView.frame.size.width/2
            teamEmblemImageView.clipsToBounds = true
            
            if(matchList[indexPath.row].teamEmblem != ".") {
                let url = "http://210.122.7.193:8080/Trophy_img/team/\(matchList[indexPath.row].teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                teamEmblemImageView.af_setImage(withURL: URL(string: url!)!)
            }else {
                teamEmblemImageView.image = UIImage(named: "ic_team")
            }
        }else if(matchMode == "register") {
            cell = tableView.dequeueReusableCell(withIdentifier: "matchRegisterCell", for: indexPath)
            
            let teamEmblemImageView = cell.viewWithTag(1) as! UIImageView
            let teamNameLabel = cell.viewWithTag(2) as! UILabel
            let matchTitleLabel = cell.viewWithTag(3) as! UILabel
            let matchTime = cell.viewWithTag(4) as! UILabel
            let matchPlace = cell.viewWithTag(5) as! UILabel
            let matchJoinCount = cell.viewWithTag(6) as! UILabel
            let matchStatus = cell.viewWithTag(7) as! UILabel
            
            // 팀 이름 삽입
            teamNameLabel.text = matchList[indexPath.row].teamName
            
            // 교류전 제목 삽입
            matchTitleLabel.text = matchList[indexPath.row].matchTitle
            
            // 교류전 장소 삽입
            matchPlace.text = matchList[indexPath.row].matchPlace
            
            // 교류전 시간 삽입
            let cal = Calendar(identifier: .gregorian)
            
            let dateFormatterTime = DateFormatter()
            dateFormatterTime.dateFormat = "H:m"
            
            let _matchStartTime = dateFormatterTime.date(from: matchList[indexPath.row].matchStartTime)
            let _matchFinishTime = dateFormatterTime.date(from: matchList[indexPath.row].matchFinishTime)
            
            let compStart = cal.dateComponents([.hour, .minute], from: _matchStartTime!)
            let compFinish = cal.dateComponents([.hour, .minute], from: _matchFinishTime!)
            
            var startTime:String = ""
            var finishTime:String = ""
            
            if(compStart.minute! == 0) {
                startTime = "\(compStart.hour!)시"
            }else {
                startTime = "\(compStart.hour!)시 \(compStart.minute!)분"
            }
            
            if(compFinish.minute! == 0) {
                finishTime = "\(compFinish.hour!)시"
            }else {
                finishTime = "\(compFinish.hour!)시 \(compFinish.minute!)분"
            }
            
            matchTime.text = "\(startTime) ~ \(finishTime)"
            
            // 교류전 신청자 수 삽입
            matchJoinCount.text = "신청한 팀 : \(matchList[indexPath.row].matchJoinCount)"
            
            // 팀 엠블럼 삽입
            teamEmblemImageView.layer.cornerRadius = teamEmblemImageView.frame.size.width / 2
            teamEmblemImageView.clipsToBounds = true
            if(matchList[indexPath.row].teamEmblem != ".") {
                let url = "http://210.122.7.193:8080/Trophy_img/team/\(matchList[indexPath.row].teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseImage { response in
                    if let image = response.result.value {
                        teamEmblemImageView.image = image
                    }
                }
            }else {
                teamEmblemImageView.image = UIImage(named: "ic_team")
            }
            
            
            // 상태 삽입
            let dateFormatterStatus = DateFormatter()
            dateFormatterStatus.dateFormat = "yyyy:::MM / dd:::H:m"
            let matchStatusTime = dateFormatterStatus.date(from: "\(matchList[indexPath.row].matchDate):::\(matchList[indexPath.row].matchStartTime)")
            let nowTime = Date()
            if(matchStatusTime! < nowTime) {
                matchStatus.text = "마감"
            }else {
                matchStatus.text = "모집중"
            }
        }
        return cell
    }
    
    @IBAction func matchModeIndexChanged(_ sender: Any) {
        switch matchModeSegmentedControl.selectedSegmentIndex {
        case 0:
            matchMode = "search"
            getMatchs()
            matchTableView.reloadData()
        case 1:
            matchMode = "request"
            getRequestMatch()
            matchTableView.reloadData()
        case 2:
            matchMode = "register"
            getRegisterMatch()
            matchTableView.reloadData()
        default:
            matchMode = "search";
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(matchMode == "request") {
            if(matchList[indexPath.row].matchStatus == "Joining") {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let matchDetailViewController = storyBoard.instantiateViewController(withIdentifier: "MatchDetailViewController") as! MatchDetailViewController
                matchDetailViewController.matchPk = matchList[indexPath.row].matchPk
                self.navigationController?.pushViewController(matchDetailViewController, animated: true)
            }else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let matchResultDetailViewController = storyBoard.instantiateViewController(withIdentifier: "MatchResultDetailViewController") as! MatchResultDetailViewController
                matchResultDetailViewController.matchPk = matchList[indexPath.row].matchPk
                self.navigationController?.pushViewController(matchResultDetailViewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(matchMode == "search") {
            let lastCell = matchList.count - 1
            if indexPath.row == lastCell {
                let lastMatchResultPk = matchList[matchList.count - 1].matchPk
                
                if(isScrollFinished == false) {
                    startActivity()
                    
                    Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchMore.jsp?Data1=\(lastMatchResultPk)").responseJSON { (responseData) -> Void in
                        if((responseData.result.value) != nil) {
                            let swiftyJsonVar = JSON(responseData.result.value!)
                            
                            if let resData = swiftyJsonVar["List"].arrayObject {
                                self.arrRes = resData as! [[String:AnyObject]]
                            }
                            
                            if self.arrRes.count > 0 {
                                for i in 0 ..< self.arrRes.count {
                                    var dict = self.arrRes[i]
                                    
                                    self.matchSetting = MatchSetting()
                                    
                                    self.matchSetting = MatchSetting()
                                    self.matchSetting.matchPk = dict["matchPk"] as! String
                                    self.matchSetting.teamEmblem = dict["teamEmblem"] as! String
                                    self.matchSetting.teamName = dict["teamName"] as! String
                                    self.matchSetting.matchTitle = dict["matchTitle"] as! String
                                    self.matchSetting.matchPlace = dict["matchPlace"] as! String
                                    self.matchSetting.matchDate = dict["matchDate"] as! String
                                    self.matchSetting.matchStartTime = dict["matchStartTime"] as! String
                                    self.matchSetting.matchFinishTime = dict["matchFinishTime"] as! String
                                    self.matchSetting.matchStatus = dict["matchStatus"] as! String
                                    self.matchSetting.matchUploadTime = dict["matchUploadTime"] as! String
                                    
                                    self.matchList.append(self.matchSetting)
                                }
                            }else {
                                self.isScrollFinished = true
                            }
                            self.matchTableView.reloadData()
                            
                            self.stopActivity()
                        }
                    }
                }
            }
        }
    }

    
    func startActivity() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivity() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        if(self.refresher.isRefreshing) {
            self.refresher.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goDetail") {
            let matchDetailViewController = segue.destination as! MatchDetailViewController
            let myIndexPath = self.matchTableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            matchDetailViewController.matchPk = self.matchList[row].matchPk
            print("aaa : \(self.matchList[row].matchPk)")
        }else if(segue.identifier == "goRegisterDetail") {
            let matchRegisterDetailViewController = segue.destination as! MatchRegisterDetailViewController
            let myIndexPath = self.matchTableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            matchRegisterDetailViewController.matchPk = self.matchList[row].matchPk
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
