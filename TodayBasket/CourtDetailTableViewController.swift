//
//  CourtDetailTableViewController.swift
//  TodayBasket
//
//  Created by ldong on 2017. 7. 11..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class CourtDetailTableViewController: UITableViewController {
    
    var feedCell:UICollectionViewCell?
    var courtPk:String = ""
    
    var courtName:String = ""
    var courtAddressDo:String = ""
    var courtAddressSi:String = ""
    var courtImage:String = ""
    var courtIntroModifier:String = ""
    var courtIntro:String = ""
    var courtIntroModifyDate:String = ""
    var courtTodayContent:String = ""
    
    var isUserLoggedIn:Bool = false
    var isScrollFinished:Bool = false
    var userPk:String = ""
    
    var feedSetting = CourtFeedSetting()
    var feedList:[CourtFeedSetting] = []
    var willDeleteFeedPk:String = ""
    var arrRes:[[String:AnyObject]] = []
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var refresher:UIRefreshControl!
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refresher.addTarget(self, action: #selector(CourtDetailTableViewController.getFeeds), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFeeds()
    }
    
    func getFeeds() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
        }
        
        feedList = []
        
        // 야외코트 정보 및 피드
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/CourtDetail.jsp?Data1=\(courtPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    self.courtName = dict["msg1"] as! String
                    self.courtAddressDo = dict["msg2"] as! String
                    self.courtAddressSi = dict["msg3"] as! String
                    self.courtImage = dict["msg5"] as! String
                    self.courtIntro = dict["msg6"] as! String
                    self.courtIntroModifier = dict["msg7"] as! String
                    self.courtIntroModifyDate = dict["msg8"] as! String
                    self.courtTodayContent = dict["msg9"] as! String
                    
                    
                    let courtImageView = self.tableView.tableHeaderView?.viewWithTag(1) as! UIImageView
                    let courtNameLabel = self.tableView.tableHeaderView?.viewWithTag(2) as! UILabel
                    let courtAddressDoLabel = self.tableView.tableHeaderView?.viewWithTag(3) as! UILabel
                    let courtAddressSiLabel = self.tableView.tableHeaderView?.viewWithTag(4) as! UILabel
                    let courtIntroModifierLabel = self.tableView.tableHeaderView?.viewWithTag(5) as! UILabel
                    let courtIntroModifyButton = self.tableView.tableHeaderView?.viewWithTag(6) as! UIButton
                    let courtIntroTextView = self.tableView.tableHeaderView?.viewWithTag(7) as! UITextView
                    let courtUserProfileImageView = self.tableView.tableHeaderView?.viewWithTag(8) as! UIImageView
                    let courtUploadFeedButton = self.tableView.tableHeaderView?.viewWithTag(9) as! UIButton
                    let courtTodayContentLabel = self.tableView.tableHeaderView?.viewWithTag(10) as! UILabel
                    
                    courtNameLabel.text = self.courtName
                    courtAddressDoLabel.text = self.courtAddressDo
                    courtAddressSiLabel.text = self.courtAddressSi
                    courtIntroModifierLabel.text = "마지막 변경 : \(self.courtIntroModifier)"
                    courtIntroTextView.text = self.courtIntro
                    courtTodayContentLabel.text = "오늘의 게시글 : \(self.courtTodayContent)"
                    
                    courtIntroModifyButton.addTarget(self, action: #selector(self.updateIntroButtonTapped), for: .touchUpInside)
                    courtUploadFeedButton.addTarget(self, action: #selector(self.updateFeedButtonTapped), for: .touchUpInside)
                    
                    // 코트 사진 지정
                    if(self.courtImage != ".") {
                        courtImageView.sd_setImage(with: URL(string: "http://210.122.7.193:8080/Trophy_img/court/\(self.courtImage).jpg"))
                    }else {
                        courtImageView.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 55/255, alpha: 1)
                        courtImageView.image = nil
                    }
                    
                    // 피드 올리기 부분 지정
                    self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
                    if(self.isUserLoggedIn) {
                        self.userPk = UserDefaults.standard.string(forKey: "Pk")!
                        let url = "http://210.122.7.193:8080/Trophy_img/profile/\(self.userPk).jpg"
                        Alamofire.request(url).responseImage { response in
                            if let image = response.result.value {
                                courtUserProfileImageView.image = image
                            }
                        }
                    }else {
                        courtUserProfileImageView.image = UIImage(named: "user_basic")
                    }
                    
                    // 헤더 뷰 높이 지정
                    let size = CGSize(width: self.view.frame.width, height: 1000)
                    let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
                    let rect = NSString(string: self.courtIntro).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                    
                    self.tableView.tableHeaderView?.frame.size.height = rect.height + 314
                    
                }
                Alamofire.request("http://210.122.7.193:8080/Trophy_part3/CourtContent.jsp?Data1=\(self.courtPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                        }
                        
                        for i in 0 ..< self.arrRes.count {
                            var dict = self.arrRes[i]
                            
                            self.feedSetting = CourtFeedSetting()
                            
                            self.feedSetting.courtFeedPk = dict["msg1"] as! String
                            self.feedSetting.userPk = dict["msg3"] as! String
                            self.feedSetting.feedDate = dict["msg4"] as! String
                            self.feedSetting.feedContent = dict["msg5"] as! String
                            self.feedSetting.feedImage = dict["feedImage"] as! String
                            self.feedSetting.feedImageWidth = dict["feedImageWidth"] as! String
                            self.feedSetting.feedImageHeight = dict["feedImageHeight"] as! String
                            self.feedSetting.userName = dict["msg7"] as! String
                            self.feedSetting.userProfile = dict["msg6"] as! String
                            
                            if(self.feedSetting.feedImage != ".") {
                                let height:Double = Double(self.feedSetting.feedImageHeight)!
                                let width:Double = Double(self.feedSetting.feedImageWidth)!
                                
                                self.feedSetting.feedImageHeightDouble = (Double(self.view.frame.width) * height) / width
                            }
                            self.feedList.append(self.feedSetting)
                        }
                        self.tableView.reloadData()
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if(self.refresher.isRefreshing) {
                            self.refresher.endRefreshing()
                        }
                    }else {
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if(self.refresher.isRefreshing) {
                            self.refresher.endRefreshing()
                        }
                    }
                }
            }
        }
    }
    
    //상태 업데이트
    func updateFeedButtonTapped() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(isUserLoggedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourtUpdateFeedNavigationController")
            present(vc!, animated: true, completion: nil)
        }else {
            let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요합니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    //코트 소개 변경
    func updateIntroButtonTapped() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if(isUserLoggedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourtIntroUpdateNavigationController")
            present(vc!, animated: true, completion: nil)
        }else {
            let myAlert = UIAlertController(title: "오늘의농구", message: "로그인이 필요합니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    // 피드 지우기
    func deleteButtonTapped(sender: UIButton) {
        //if (userPk == feedList[indexPath.row].userPk) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let deleteButton = UIAlertAction(title: "삭제", style: UIAlertActionStyle.destructive, handler: { (deleteSeleted) -> Void in
            let courtFeedPk = sender.accessibilityHint!
            
            Alamofire.request("http://210.122.7.193:8080/Trophy_part3/CourtFeedDelete.jsp?Data1=\(courtFeedPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print(self.arrRes)
                    }
                }
                self.getFeeds()
            }
            
        })
        actionSheet.addAction(deleteButton)
        
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
            
        })
        actionSheet.addAction(cancelButton)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        //}else {
        //   return
        //}
    }
    
    // 피드 댓글
    func commentButtonTapped (sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let courtCommentViewController = storyBoard.instantiateViewController(withIdentifier: "CourtCommentViewController") as! CourtCommentViewController
        let row:Int = Int(sender.accessibilityHint!)!
        courtCommentViewController.feedPk = feedList[row].courtFeedPk
        courtCommentViewController.feedUserPk = feedList[row].userPk
        self.navigationController?.pushViewController(courtCommentViewController, animated: true)
    }
    
    // 유저프로필
    func userInfoButtonTapped(_ sender: UITapGestureRecognizer) {
        let userPk = sender.accessibilityHint!
        print(userPk)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)

        let userProfileImageView = cell.viewWithTag(1) as! UIImageView
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        let feedDateLabel = cell.viewWithTag(3) as! UILabel
        let feedContentTextView = cell.viewWithTag(4) as! UITextView
        let feedDeleteButton = cell.viewWithTag(5) as! UIButton
        let feedCommentButton = cell.viewWithTag(6) as! UIButton
        let feedImageView = cell.viewWithTag(7) as! UIImageView
        
        // 피드 유저 이릅 삽입
        userNameLabel.text = feedList[indexPath.row].userName
        
        // 피드 날짜 삽입
        let nowTime = Date()
        let uploadTime = dateFormatter.date(from: feedList[indexPath.row].feedDate)
        
        let cal = Calendar(identifier: .gregorian)
        
        let comp = cal.dateComponents([.day, .hour, .minute], from: uploadTime!, to: nowTime)
        if(comp.day! == 0) {
            if(comp.hour! == 0) {
                if(comp.minute! == 0) {
                    feedDateLabel.text = "방금"
                }else {
                    feedDateLabel.text = "\(comp.minute!)분 전"
                }
            }else {
                feedDateLabel.text = "\(comp.hour!)시간 전"
            }
        }else if(comp.day! < 8) {
            if(comp.day! == 1) {
                feedDateLabel.text = "어제"
            }else if(comp.day! == 7) {
                feedDateLabel.text = "일주일 전"
            }else {
                feedDateLabel.text = "\(comp.day!)일 전"
            }
        }else {
            let compUploadTime = cal.dateComponents([.year, .month, .day], from: uploadTime!)
            
            feedDateLabel.text = "\(compUploadTime.month!) / \(compUploadTime.day!)"
        }
        
        // 피드 내용 삽입
        feedContentTextView.text = feedList[indexPath.row].feedContent
        
        // 피드 삭제 이벤트
        feedDeleteButton.accessibilityHint = "\(feedList[indexPath.row].courtFeedPk)"
        feedDeleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // 피드 댓글 이벤트
        feedCommentButton.accessibilityHint = "\(indexPath.row)"
        feedCommentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        
        // 프로필 보기 이벤트
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userInfoButtonTapped))
        tapGesture.accessibilityHint = "\(feedList[indexPath.row].userPk)"
        
        // 내가 올린 게시글에만 지우기 버튼 보이기
        if(self.userPk == feedList[indexPath.row].userPk) {
            feedDeleteButton.isHidden = false
        }else {
            feedDeleteButton.isHidden = true
        }
        
        // 댓글 더보기 버튼 설정
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/CourtComment.jsp?Data1=\(feedList[indexPath.row].courtFeedPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if(self.arrRes.count > 0) {
                    feedCommentButton.setTitle("댓글 \(self.arrRes.count)개 더보기", for: UIControlState.normal)
                }
            }
        }
        
        // 프로필 사진 삽입
        if(feedList[indexPath.row].userProfile != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/profile/\(feedList[indexPath.row].userProfile).jpg"
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    userProfileImageView.image = image
                }
            }
        }else {
            userProfileImageView.image = UIImage(named: "user_basic")
        }
        
        
        userProfileImageView.isUserInteractionEnabled = true
        userNameLabel.isUserInteractionEnabled = true
        userProfileImageView.addGestureRecognizer(tapGesture)
        userNameLabel.addGestureRecognizer(tapGesture)
        
        // 피드 내용에 따라 textView 높이 지정
        let size = CGSize(width: view.frame.width, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let rect = NSString(string: feedList[indexPath.row].feedContent).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        feedContentTextView.frame.size = CGSize(width: self.view.frame.width, height: rect.height + 20)
        feedImageView.backgroundColor = UIColor.groupTableViewBackground
        
        if(feedList[indexPath.row].feedImage != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/content/\(self.feedList[indexPath.row].feedImage).jpg"
            feedImageView.sd_setImage(with: URL(string: url)!)
            
            feedImageView.frame.size = CGSize(width: self.view.frame.width, height: CGFloat(self.feedList[indexPath.row].feedImageHeightDouble))
            print("\(indexPath.row) : \(self.feedList[indexPath.row].feedImageHeightDouble)")
        }else {
            feedImageView.frame.size = CGSize(width: self.view.frame.width, height: 0)
        }
        
        feedContentTextView.layer.masksToBounds = true
        feedImageView.layer.masksToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = CGSize(width: view.frame.width, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let rect = NSString(string: feedList[indexPath.row].feedContent).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return 112 + rect.height + CGFloat(feedList[indexPath.row].feedImageHeightDouble)
    }
}
