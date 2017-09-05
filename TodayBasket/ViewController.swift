//

//  ViewController.swift

//  slidetest1

//

//  Created by MD313-008 on 2017. 2. 7..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Firebase

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var scrollViewTop: UIScrollView!
    
    @IBOutlet weak var collectionViewRecentContest: UICollectionView!
    @IBOutlet weak var collectionViewMyRank: UICollectionView!
    @IBOutlet weak var collectionViewMyRankHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewRecentContest: UITableView!
    @IBOutlet weak var tableViewRecentMatch: UITableView!
    @IBOutlet weak var tableViewRecommendCourt: UITableView!
    
    @IBOutlet weak var bannerView1: UIView!
    @IBOutlet weak var midBannerImageView: UIImageView!
    
    var version:String = "1.0"
    
    var isUserLoggedIn:Bool = false
    var userPk:String = "."
    var userAddressDo:String = ""
    var userTeamPk:String = ""
    
    var timer:Timer?
    var indicatorTimer:Timer?
    
    var filteredData:[String] = []
    
    var Contest_Setting = Contest_Detail_Setting()
    var Contest_list:[Contest_Detail_Setting] = []
    
    var Rank_Setting = TeamRankSetting()
    var Rank_list:[TeamRankSetting] = []
    
    var matchSetting = MatchSetting()
    var matchList:[MatchSetting] = []
    
    var courtSetting = CourtSetting()
    var courtList:[CourtSetting] = []
    
    var arrRes = [[String: AnyObject]]()
    var arrResRank = [[String: AnyObject]]()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var notificationMode = ""
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.indicatorTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.stopIndicator), userInfo: nil, repeats: false)
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/getUserInfo.jsp?Data1=\(userPk)")!;
            Alamofire.request(url).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    
                    if self.arrRes.count > 0 {
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            self.userTeamPk = dict["teamPk"] as! String
                            self.userAddressDo = dict["addressDo"] as! String
                        }
                    }
                    self.getRecommendCourt()
                }
            }
        }else {
            getRecommendCourt()
        }
        
        getRecentContest()
        getTeamRank()
        getRecentMatch()
        
        // 상단 스크롤 뷰 자동 넘기기
//        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.autoScroll), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(userPk.isEmpty) {
            UserDefaults.standard.setValue(".", forKey: "Pk")
            UserDefaults.standard.synchronize()
        }
        
        if(notificationMode == "teamUserManage") {
            print("==============================teamUserManage================================")
        }
        
        getVersion()
        
        self.indicatorTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(ViewController.stopIndicator), userInfo: nil, repeats: false)
        
        collectionViewRecentContest.delegate = self
        collectionViewMyRank.delegate = self
        collectionViewRecentContest.dataSource = self
        collectionViewMyRank.dataSource = self
        collectionViewMyRankHeight.constant = (view.frame.width / 4) + 20
        
        tableViewRecentContest.delegate = self
        tableViewRecentMatch.delegate = self
        tableViewRecommendCourt.delegate = self
        tableViewRecentContest.dataSource = self
        tableViewRecentMatch.dataSource = self
        tableViewRecommendCourt.dataSource = self
        
        
        // 상단 트로피 그림
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "title1")
        navigationItem.titleView = imageView
        
        
        // drawer 설정
        if self.revealViewController() != nil {
            //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(goGuide))
        bannerView1.addGestureRecognizer(gesture)
        
        getMatchResultNeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("Memory Warning!")
        viewDidLoad()
    }
    
    func stopIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    func autoScroll() {
        if(scrollViewTop.contentOffset.x == self.view.frame.width * 3) {
            DispatchQueue.main.async(execute: {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.scrollViewTop.contentOffset.x = 0
                    print(self.scrollViewTop.contentOffset.x)
                }, completion: nil)
            });
        }else {
            DispatchQueue.main.async(execute: {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.scrollViewTop.contentOffset.x += self.view.frame.width
                    print(self.scrollViewTop.contentOffset.x)
                }, completion: nil)
            });
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewRecentContest {
            return Contest_list.count - 5
        }else {
            return Rank_list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewRecentContest {
            let cellRecentContest = collectionView.dequeueReusableCell(withReuseIdentifier: "recentConstestCell", for: indexPath)
            
            let contestImage = cellRecentContest.viewWithTag(1) as! UIImageView
            let contestRecruitStatus = cellRecentContest.viewWithTag(2) as! UILabel
            
            if(Contest_list.count > 0) {
                let nowDate:Date = Date()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy / M / d"
                let finishDate:Date = dateFormatter.date(from: Contest_list[indexPath.row].RecruitFinishDate)!
                let cal = Calendar(identifier: .gregorian)
                let comp = cal.dateComponents([.day, .hour, .minute], from: nowDate, to: finishDate)
                
                if(comp.day! >= 0) {
                    contestRecruitStatus.text = "마감 \(comp.day!)일전"
                }else {
                    contestRecruitStatus.text = "마감"
                }
                if(Contest_list[indexPath.row].Image != ".") {
                    let imageName = Contest_list[indexPath.row].Image
                    contestImage.af_setImage(withURL: URL(string: "http://210.122.7.193:8080/Trophy_img/contest/\(imageName).jpg")!)
                }
            }
            return cellRecentContest
        }else {
            let cellMyRank = collectionView.dequeueReusableCell(withReuseIdentifier: "myRankCell", for: indexPath)
            
            let rankTeamEmblem = cellMyRank.viewWithTag(1) as! UIImageView
            let rankTeamName = cellMyRank.viewWithTag(2) as! UILabel
            let rankTeamRank = cellMyRank.viewWithTag(3) as! UILabel
            
            rankTeamEmblem.layer.cornerRadius = rankTeamEmblem.frame.size.width / 2
            rankTeamEmblem.clipsToBounds = true
            
            rankTeamName.text = Rank_list[indexPath.row].teamName
            rankTeamRank.text = Rank_list[indexPath.row].teamRank
            
            if(Rank_list[indexPath.row].teamEmblem != ".") {
                let url = "http://210.122.7.193:8080/Trophy_img/team/\(Rank_list[indexPath.row].teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseImage { response in
                    if let image = response.result.value {
                        rankTeamEmblem.image = image
                    }
                }
            }else {
                rankTeamEmblem.image = UIImage(named: "ic_team")
            }
            return cellMyRank
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == self.collectionViewRecentContest) {
            
            return CGSize(width: CGFloat(view.frame.size.width/2), height: CGFloat(200))
        }else {
            
            return CGSize(width: CGFloat(view.frame.size.width/4), height: CGFloat(view.frame.size.width/4) + 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == self.collectionViewRecentContest) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let contestDetailViewController = storyBoard.instantiateViewController(withIdentifier: "Contest_Detail_ViewController") as! Contest_Detail_ViewController
            contestDetailViewController.Contest_Pk = Contest_list[indexPath.row].Pk
            contestDetailViewController.Contest_Title = Contest_list[indexPath.row].Title
            contestDetailViewController.Contest_Image = Contest_list[indexPath.row].Image
            contestDetailViewController.Contest_CurrentNum = Contest_list[indexPath.row].CurrentNum
            contestDetailViewController.Contest_MaxNum = Contest_list[indexPath.row].MaxNum
            contestDetailViewController.Contest_Payment = Contest_list[indexPath.row].Payment
            contestDetailViewController.Contest_Host = Contest_list[indexPath.row].Host
            contestDetailViewController.Contest_Management = Contest_list[indexPath.row].Management
            contestDetailViewController.Contest_Support = Contest_list[indexPath.row].Support
            contestDetailViewController.Contest_ContestDate = Contest_list[indexPath.row].ContestDate
            contestDetailViewController.Contest_RecruitStartDate = Contest_list[indexPath.row].RecruitStartDate
            contestDetailViewController.Contest_RecruitFinishDate = Contest_list[indexPath.row].RecruitFinishDate
            contestDetailViewController.Contest_DetailInfo = Contest_list[indexPath.row].DetailInfo
            contestDetailViewController.Contest_Place = Contest_list[indexPath.row].Place
            contestDetailViewController.Contest_OutSide = Contest_list[indexPath.row].OutSide
            
            self.navigationController?.pushViewController(contestDetailViewController, animated: true)
        }else if(collectionView == self.collectionViewMyRank) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let teamDetailVeiwController = storyBoard.instantiateViewController(withIdentifier: "TeamDetailViewController") as! TeamDetailViewController
            teamDetailVeiwController.teamPk = Rank_list[indexPath.row].teamPk
            self.navigationController?.pushViewController(teamDetailVeiwController, animated: true)
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.tableViewRecentMatch) {
            return matchList.count
        }else if(tableView == self.tableViewRecentContest) {
            return Contest_list.count - 2
        }else {
            return courtList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell?
        if(tableView == self.tableViewRecentContest) {
            cell = tableView.dequeueReusableCell(withIdentifier: "contestTableCell", for: indexPath)
            
            let contestTitle = cell?.viewWithTag(1) as! UILabel
            
            contestTitle.text = Contest_list[indexPath.row + 2].Title
            
            return cell!
        }else if (tableView == self.tableViewRecentMatch) {
            cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)
            
            let teamEmblemImageView = cell?.viewWithTag(1) as! UIImageView
            let teamNameLabel = cell?.viewWithTag(2) as! UILabel
            let matchTitleLabel = cell?.viewWithTag(3) as! UILabel
            let matchPlace = cell?.viewWithTag(4) as! UILabel
            let matchTime = cell?.viewWithTag(5) as! UILabel
            let matchUploadTime = cell?.viewWithTag(6) as! UILabel
            
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
            
            // 교류전 업로드 시간 삽입
            let uploadDate:String = matchList[indexPath.row].matchUploadTime
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            
            let nowTime = Date()
            let uploadTime = dateFormatter.date(from: uploadDate)
            
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
            
            // 팀 엠블럼 삽입
            teamEmblemImageView.layer.cornerRadius = teamEmblemImageView.frame.size.width/2
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
            
            
            return cell!
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: "courtCell", for: indexPath)
            
            let courtImage = cell?.viewWithTag(1) as! UIImageView
            let courtName = cell?.viewWithTag(2) as! UILabel
            let courtAddressDo = cell?.viewWithTag(3) as! UILabel
            let courtAddressSi = cell?.viewWithTag(4) as! UILabel
            let courtTodayFeed = cell?.viewWithTag(5) as! UILabel
            
            courtName.text = courtList[indexPath.row].courtName
            courtAddressDo.text = courtList[indexPath.row].courtAddressDo
            courtAddressSi.text = courtList[indexPath.row].courtAddressSi
            courtTodayFeed.text = "오늘의 게시글 : \(courtList[indexPath.row].courtTodayContent)"
            
            if(courtList[indexPath.row].courtImage != ".") {
                courtImage.af_setImage(withURL: URL(string: "http://210.122.7.193:8080/Trophy_img/court/\(courtList[indexPath.row].courtImage).jpg")!)

            }else {
                courtImage.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 55/255, alpha: 1)
                courtImage.image = nil
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tableViewRecentContest) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let contestDetailViewController = storyBoard.instantiateViewController(withIdentifier: "Contest_Detail_ViewController") as! Contest_Detail_ViewController
            contestDetailViewController.Contest_Pk = Contest_list[indexPath.row + 2].Pk
            contestDetailViewController.Contest_Title = Contest_list[indexPath.row + 2].Title
            contestDetailViewController.Contest_Image = Contest_list[indexPath.row + 2].Image
            contestDetailViewController.Contest_CurrentNum = Contest_list[indexPath.row + 2].CurrentNum
            contestDetailViewController.Contest_MaxNum = Contest_list[indexPath.row + 2].MaxNum
            contestDetailViewController.Contest_Payment = Contest_list[indexPath.row + 2].Payment
            contestDetailViewController.Contest_Host = Contest_list[indexPath.row + 2].Host
            contestDetailViewController.Contest_Management = Contest_list[indexPath.row + 2].Management
            contestDetailViewController.Contest_Support = Contest_list[indexPath.row + 2].Support
            contestDetailViewController.Contest_ContestDate = Contest_list[indexPath.row + 2].ContestDate
            contestDetailViewController.Contest_RecruitStartDate = Contest_list[indexPath.row + 2].RecruitStartDate
            contestDetailViewController.Contest_RecruitFinishDate = Contest_list[indexPath.row + 2].RecruitFinishDate
            contestDetailViewController.Contest_DetailInfo = Contest_list[indexPath.row + 2].DetailInfo
            contestDetailViewController.Contest_Place = Contest_list[indexPath.row + 2].Place
            contestDetailViewController.Contest_OutSide = Contest_list[indexPath.row + 2].OutSide
            
            self.navigationController?.pushViewController(contestDetailViewController, animated: true)
        }else if(tableView == tableViewRecentMatch) {
        }else if(tableView == tableViewRecommendCourt) {
            //CourtDetailViewController
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func goGuide() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GuideViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goMatch") {
            let matchDetailViewController = segue.destination as! MatchDetailViewController
            let myIndexPath = self.tableViewRecentMatch.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            matchDetailViewController.matchPk = self.matchList[row].matchPk
            //print("aaa : \(self.matchList[row].matchPk)")
        }else if (segue.identifier == "goCourt") {
            let courtDetailTableViewController = segue.destination as! CourtDetailTableViewController
            let myIndexPath = self.tableViewRecommendCourt.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            courtDetailTableViewController.courtPk = courtList[row].courtPk
            courtDetailTableViewController.navigationItem.title = courtList[row].courtName
//
//            UserDefaults.standard.set(courtList[row].courtPk, forKey: "courtPk")
//            UserDefaults.standard.synchronize()
        }
        else if (segue.identifier == "goCourtMore") {
            let CourtAddressDetailViewController = segue.destination as! CourtAddressDetailViewController
            if(isUserLoggedIn) {
                CourtAddressDetailViewController.addressDo = userAddressDo
                CourtAddressDetailViewController.addressSi.append(".")
                CourtAddressDetailViewController.isMain = true
                CourtAddressDetailViewController.navigationItem.title = userAddressDo
            }else {
                CourtAddressDetailViewController.addressDo = "서울"
                CourtAddressDetailViewController.addressSi.append(".")
                CourtAddressDetailViewController.isMain = true
                CourtAddressDetailViewController.navigationItem.title = "서울"
            }
            
        }else if (segue.identifier == "goMatchMore") {
            let matchViewController = segue.destination as! MatchViewController
            matchViewController.isMain = true
        }else if (segue.identifier == "goRankMore") {
            let slideMenuTeamRankViewController = segue.destination as! SlideMenuTeamRankViewController
            slideMenuTeamRankViewController.isMain = true
        }else if (segue.identifier == "goContestMore") {
            let contestViewController = segue.destination as! ContestViewController
            contestViewController.isMain = true
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func getRecentContest() {
        // 최근대회정보 가져오기
        Contest_list = []
        let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Contest_Customlist.jsp")!;
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< 7 {
                        var dict = self.arrRes[i]
                        
                        self.Contest_Setting = Contest_Detail_Setting()
                        self.Contest_Setting.Pk = dict["_Pk"] as! String
                        self.Contest_Setting.Title = dict["_Title"] as! String
                        self.Contest_Setting.Image = dict["_Image"] as! String
                        self.Contest_Setting.CurrentNum = dict["_currentNum"] as! String
                        self.Contest_Setting.MaxNum = dict["_maxNum"] as! String
                        self.Contest_Setting.Payment = dict["_Payment"] as! String
                        self.Contest_Setting.Host = dict["_Host"] as! String
                        self.Contest_Setting.Management = dict["_Management"] as! String
                        self.Contest_Setting.Support = dict["_Support"] as! String
                        self.Contest_Setting.ContestDate = dict["_ContestDate"] as! String
                        self.Contest_Setting.RecruitStartDate = dict["_RecruitStartDate"] as! String
                        self.Contest_Setting.RecruitFinishDate = dict["_RecruitFinishDate"] as! String
                        self.Contest_Setting.DetailInfo = dict["_DetailInfo"] as! String
                        self.Contest_Setting.Place = dict["_Place"] as! String
                        self.Contest_Setting.OutSide = dict["_OutSide"] as! String
                        
                        
                        self.Contest_list.append(self.Contest_Setting)
                    }
                }
            }
            self.collectionViewRecentContest.reloadData()
            self.tableViewRecentContest.reloadData()
        }
    }
    
    func getTeamRank() {
        // 팀 랭킹 가져오기
        Rank_list = []
        let rankUrl:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Main_Ranking.jsp?Data1=\(userPk)")!;
        Alamofire.request(rankUrl).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrResRank = resData as! [[String:AnyObject]]
                }
                
                if self.arrResRank.count > 0 {
                    for i in 0 ..< 4 {
                        var dict = self.arrResRank[i]
                        
                        self.Rank_Setting = TeamRankSetting()
                        self.Rank_Setting.teamPk = dict["msg1"] as! String
                        self.Rank_Setting.teamEmblem = dict["msg2"] as! String
                        self.Rank_Setting.teamName = dict["msg3"] as! String
                        self.Rank_Setting.teamRank = String(dict["msg4"] as! Int)
                        
                        self.Rank_list.append(self.Rank_Setting)
                    }
                }
            }
            self.collectionViewMyRank.reloadData()
        }
    }
    
    func getRecentMatch() {
        matchList = []
        let matchUrl:URL = URL(string: "http://210.122.7.193:8080/TodayBasket_IOS/MatchMain.jsp")!;
        Alamofire.request(matchUrl).responseJSON { (responseData) -> Void in
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
                    self.tableViewRecentMatch.reloadData()
                }
            }
        }
    }
    
    func getRecommendCourt() {
        
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"
        let nowDateString = dateFormatter.string(from: nowDate)
        
        courtList = []
        
        var courtURL = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        if(isUserLoggedIn) {
            courtURL = "http://210.122.7.193:8080/Trophy_part3/Main_Court.jsp?Data1=\(userAddressDo)&Data2=.&Data3=\(nowDateString)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            print("userAddressDo : \(userAddressDo)")
        }else {
            courtURL = "http://210.122.7.193:8080/Trophy_part3/Main_Court.jsp?Data1=서울&Data2=.&Data3=\(nowDateString)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }
        
        Alamofire.request(courtURL!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        self.courtSetting = CourtSetting()
                        self.courtSetting.courtName = dict["msg1"] as! String
                        self.courtSetting.courtAddressDo = dict["msg2"] as! String
                        self.courtSetting.courtAddressSi = dict["msg3"] as! String
                        self.courtSetting.courtPk = dict["msg4"] as! String
                        self.courtSetting.courtImage = dict["msg5"] as! String
                        self.courtSetting.courtTodayContent = dict["msg6"] as! String
                        
                        self.courtList.append(self.courtSetting)
                    }
                }
            }
            self.tableViewRecommendCourt.reloadData()
        }
    }
    
    func getMatchResultNeed() {
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            
            let url = "http://210.122.7.193:8080/TodayBasket_IOS/MainMatchResultHomeNeed.jsp?Data1=\(userPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy:::MM / dd:::H:m"
            
            Alamofire.request(url!).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if self.arrRes.count > 0 {
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            let finishDateString:String = "\(dict["msg2"] as! String):::\(dict["msg4"] as! String)"
                            let finishDate = dateFormatter.date(from: finishDateString)
                            let nowDate = Date()
                            
                            if(nowDate > finishDate!) {
                                let myAlert = UIAlertController(title: "교류전 결과 미입력", message: "점수를 미입력한 교류전이 있습니다   지금 입력하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
                                let cancelAction = UIAlertAction(title: "나중에", style: UIAlertActionStyle.cancel, handler: {action in
                                    return
                                })
                                myAlert.addAction(cancelAction)
                                let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { action in
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MatchResultDetailViewController") as! MatchResultDetailViewController
                                    vc.isMain = true
                                    vc.matchPk = dict["msg1"] as! String
                                    self.navigationController?.pushViewController(vc , animated: true)
                                })
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }
                            
                        }
                    }else {
                        let url = "http://210.122.7.193:8080/TodayBasket_IOS/MainMatchResultAwayNeed.jsp?Data1=\(self.userPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        
                        Alamofire.request(url!).responseJSON { (responseData) -> Void in
                            if((responseData.result.value) != nil) {
                                let swiftyJsonVar = JSON(responseData.result.value!)
                                if let resData = swiftyJsonVar["List"].arrayObject {
                                    self.arrRes = resData as! [[String:AnyObject]]
                                }
                                if self.arrRes.count > 0 {
                                    for i in 0 ..< self.arrRes.count {
                                        var dict = self.arrRes[i]
                                        
                                        let finishDateString:String = "\(dict["msg2"] as! String):::\(dict["msg4"] as! String)"
                                        let finishDate = dateFormatter.date(from: finishDateString)
                                        let nowDate = Date()
                                        
                                        if(nowDate > finishDate!) {
                                            let myAlert = UIAlertController(title: "교류전 결과 미확인", message: "점수를 미확인한 교류전이 있습니다   지금 확인하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
                                            let cancelAction = UIAlertAction(title: "나중에", style: UIAlertActionStyle.cancel, handler: { action in
                                                return
                                            })
                                            myAlert.addAction(cancelAction)
                                            let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { action in
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MatchResultDetailViewController") as! MatchResultDetailViewController
                                                vc.isMain = true
                                                vc.matchPk = dict["msg1"] as! String
                                                self.navigationController?.pushViewController(vc , animated: true)
                                            })
                                            myAlert.addAction(okAction)
                                            self.present(myAlert, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getVersion() {
        let url = "http://210.122.7.193:8080/TodayBasket_manager/version.jsp".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        if(self.version != dict["version"] as! String) {
                            let myAlert = UIAlertController(title: "", message: "마켓에 새로운 업데이트가 있습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "업데이트", style: UIAlertActionStyle.default, handler: { action in
                                UIApplication.shared.openURL(NSURL(string: dict["appStoreUrl"] as! String)! as URL)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
