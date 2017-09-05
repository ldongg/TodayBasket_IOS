//
//  MatchRegisterViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 7. 3..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MatchRegisterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var matchTableView: UITableView!
    
    var arrRes = [[String:AnyObject]]()
    var matchSetting = MatchSetting()
    var matchList:[MatchSetting] = []
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    var teamPk:String = ""
    
    
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
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goDetail") {
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
