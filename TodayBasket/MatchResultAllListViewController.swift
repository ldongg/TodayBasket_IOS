//
//  MatchResultAllListViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 7. 3..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MatchResultAllListViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var matchResultTableView: UITableView!
    
    var arrRes = [[String:AnyObject]]()
    var matchSetting = MatchSetting()
    var matchResultList:[MatchSetting] = []
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var refresher:UIRefreshControl!
    
    var isScrollFinished:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchResultTableView.dataSource = self
        matchResultTableView.delegate = self
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refresher.addTarget(self, action: #selector(MatchResultListViewController.getMatchResults), for: UIControlEvents.valueChanged)
        matchResultTableView.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getMatchResults()
    }
    
    func getMatchResults() {
        matchResultList = []
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchResultAll.jsp").responseJSON { (responseData) -> Void in
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
                        self.matchSetting.teamPk = dict["homeTeamPk"] as! String
                        self.matchSetting.teamEmblem = dict["homeTeamEmblem"] as! String
                        self.matchSetting.teamName = dict["homeTeamName"] as! String
                        self.matchSetting.awayTeamPk = dict["awayTeamPk"] as! String
                        self.matchSetting.awayTeamEmblem = dict["awayTeamEmblem"] as! String
                        self.matchSetting.awayTeamName = dict["awayTeamName"] as! String
                        self.matchSetting.matchTitle = dict["matchTitle"] as! String
                        self.matchSetting.matchPlace = dict["matchPlace"] as! String
                        self.matchSetting.matchDate = dict["matchDate"] as! String
                        self.matchSetting.matchStartTime = dict["matchStartTime"] as! String
                        self.matchSetting.matchFinishTime = dict["matchFinishTime"] as! String
                        self.matchSetting.matchStatus = dict["matchStatus"] as! String
                        self.matchSetting.game1Home = dict["game1Home"] as! String
                        self.matchSetting.game1Away = dict["game1Away"] as! String
                        self.matchSetting.matchUploadTime = dict["matchUploadTime"] as! String
                        
                        self.matchResultList.append(self.matchSetting)
                    }
                    self.matchResultTableView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if(self.refresher.isRefreshing) {
                        self.refresher.endRefreshing()
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchResultCell", for: indexPath)
        
        let homeTeamEmblemImageView = cell.viewWithTag(1) as! UIImageView
        let homeTeamNameLabel = cell.viewWithTag(2) as! UILabel
        let homeTeamScoreLabel = cell.viewWithTag(3) as! UILabel
        let awayTeamEmblemImageView = cell.viewWithTag(4) as! UIImageView
        let awayTeamNameLabel = cell.viewWithTag(5) as! UILabel
        let awayTeamScoreLabel = cell.viewWithTag(6) as! UILabel
        let matchTimeLabel = cell.viewWithTag(7) as! UILabel
        let matchDateLabel = cell.viewWithTag(8) as! UILabel
        let matchPlaceLabel = cell.viewWithTag(9) as! UILabel
        let matchStatusLabel = cell.viewWithTag(10) as! UILabel
        
        // 홈팀 엠블럼 원
        homeTeamEmblemImageView.layer.cornerRadius = homeTeamEmblemImageView.frame.size.width/2
        homeTeamEmblemImageView.clipsToBounds = true
        
        // 어웨이팀 엠블럼 원
        awayTeamEmblemImageView.layer.cornerRadius = awayTeamEmblemImageView.frame.size.width/2
        awayTeamEmblemImageView.clipsToBounds = true
        
        // 홈팀 이름 삽입
        homeTeamNameLabel.text = self.matchResultList[indexPath.row].teamName
        
        // 어웨이팀 이름 삽입
        awayTeamNameLabel.text = self.matchResultList[indexPath.row].awayTeamName
        
        // 점수 삽입
        if (self.matchResultList[indexPath.row].game1Home == ".") {
            homeTeamScoreLabel.text = ""
            awayTeamScoreLabel.text = ""
        }else {
            homeTeamScoreLabel.text = self.matchResultList[indexPath.row].game1Home
            awayTeamScoreLabel.text = self.matchResultList[indexPath.row].game1Away
        }
        
        // 교류전 장소 삽입
        matchPlaceLabel.text = self.matchResultList[indexPath.row].matchPlace
        
        // 홈팀 엠블럼 삽입
        if(matchResultList[indexPath.row].teamEmblem != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/team/\(matchResultList[indexPath.row].teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseImage { response in
                if let image = response.result.value {
                    homeTeamEmblemImageView.image = image
                }
            }
        }else {
            homeTeamEmblemImageView.image = UIImage(named: "ic_team")
        }
        
        // 어웨이팀 엠블럼 삽입
        if(matchResultList[indexPath.row].awayTeamEmblem != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/team/\(matchResultList[indexPath.row].awayTeamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseImage { response in
                if let image = response.result.value {
                    awayTeamEmblemImageView.image = image
                }
            }
        }else {
            awayTeamEmblemImageView.image = UIImage(named: "ic_team")
        }
        
        
        let dateFormatterDB = DateFormatter()
        dateFormatterDB.dateFormat = "yyyy:::MM / dd ::: HH:m"
        dateFormatterDB.locale = Locale(identifier: "ko_KR")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy / MM / dd:::HH : m"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let startDate = "\(matchResultList[indexPath.row].matchDate) ::: \(matchResultList[indexPath.row].matchStartTime)"
        let finishDate = "\(matchResultList[indexPath.row].matchDate) ::: \(matchResultList[indexPath.row].matchFinishTime)"
        
        // 교류전 날짜 및 시간 삽입
        let nowTime = Date()
        let startTime = dateFormatterDB.date(from: startDate)
        let finishTime = dateFormatterDB.date(from: finishDate)
        
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
        matchTimeLabel.text = "\(startTimeString) ~ \(finishTimeString)"
        matchDateLabel.text = "\(compStartTime.year!)년 \(compStartTime.month!)월 \(compStartTime.day!)일"
        
        // 교류전 상태 삽입
        if (nowTime < startTime!) {
            matchStatusLabel.text = "경기전"
        }else if (nowTime < finishTime!) {
            matchStatusLabel.text = "경기중"
        }else {
            if(matchResultList[indexPath.row].matchStatus == "recruiting") {
                matchStatusLabel.text = "경기종료(에러)"
            }else if(matchResultList[indexPath.row].matchStatus == "Not_Insert") {
                matchStatusLabel.text = "경기종료(홈팀 점수 미입력)"
            }else if(matchResultList[indexPath.row].matchStatus == "Home_Insert") {
                matchStatusLabel.text = "경기종료(어웨이팀 점수 미확인)"
            }else if(matchResultList[indexPath.row].matchStatus == "Finish") {
                matchStatusLabel.text = "경기종료"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastCell = matchResultList.count - 1
        if indexPath.row == lastCell {
            let lastMatchResultPk = matchResultList[matchResultList.count - 1].matchPk
            
            if(isScrollFinished == false) {
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchResultAllMore.jsp?Data1=\(lastMatchResultPk)").responseJSON { (responseData) -> Void in
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
                                self.matchSetting.teamPk = dict["homeTeamPk"] as! String
                                self.matchSetting.teamEmblem = dict["homeTeamEmblem"] as! String
                                self.matchSetting.teamName = dict["homeTeamName"] as! String
                                self.matchSetting.awayTeamPk = dict["awayTeamPk"] as! String
                                self.matchSetting.awayTeamEmblem = dict["awayTeamEmblem"] as! String
                                self.matchSetting.awayTeamName = dict["awayTeamName"] as! String
                                self.matchSetting.matchTitle = dict["matchTitle"] as! String
                                self.matchSetting.matchPlace = dict["matchPlace"] as! String
                                self.matchSetting.matchDate = dict["matchDate"] as! String
                                self.matchSetting.matchStartTime = dict["matchStartTime"] as! String
                                self.matchSetting.matchFinishTime = dict["matchFinishTime"] as! String
                                self.matchSetting.matchStatus = dict["matchStatus"] as! String
                                self.matchSetting.game1Home = dict["game1Home"] as! String
                                self.matchSetting.game1Away = dict["game1Away"] as! String
                                self.matchSetting.matchUploadTime = dict["matchUploadTime"] as! String
                                
                                self.matchResultList.append(self.matchSetting)
                            }
                        }else {
                            self.isScrollFinished = true
                        }
                        self.matchResultTableView.reloadData()
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goResultDetail") {
            let matchResultDetailViewController = segue.destination as! MatchResultDetailViewController
            let myIndexPath = self.matchResultTableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            matchResultDetailViewController.matchPk = self.matchResultList[row].matchPk
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
