//
//  MatchRequestViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 7. 3..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MatchRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var matchTableView: UITableView!
    
    var arrRes = [[String:AnyObject]]()
    var matchSetting = MatchSetting()
    var matchList:[MatchSetting] = []
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchTableView.dataSource = self
        matchTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("Memory Warning!")
        viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
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
            
        }else {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
