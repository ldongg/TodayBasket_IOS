//
//  CourtCommentViewController.swift
//  
//
//  Created by ldong on 2017. 7. 7..
//
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SDWebImage

struct commentData {
    var feedPk:String = ""
    var commentPk:String = ""
    var commentUserPk:String = ""
    var commentUserName:String = ""
    var commentUserImage:String = ""
    var commentMemo:String = ""
    var commentDate:String = ""
}

class CourtCommentViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextFieldView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomCostraint: NSLayoutConstraint!
    
    var feedPk:String = ""
    var feedUserPk:String = ""
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    var userName:String = ""
    
    var isScrollFinished:Bool = false
    
    var commentList = [commentData]()
    var arrRes:[[String:AnyObject]] = []
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var refresher:UIRefreshControl!
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
        }
        
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.tableFooterView = UIView()

        NotificationCenter.default.addObserver(self, selector: #selector(CourtCommentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CourtCommentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refresher.addTarget(self, action: #selector(CourtCommentViewController.getComments), for: UIControlEvents.valueChanged)
        commentTableView.addSubview(refresher)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MatchResultUploadViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getComments()
    }
    
    func getComments() {
        commentList = []
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/CourtComment.jsp?Data1=\(feedPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if(self.arrRes.count > 0) {
                    self.commentTableView.tableHeaderView?.isHidden = true
                    self.commentTableView.tableHeaderView?.frame.size.height = 0
                }else {
                    self.commentTableView.tableHeaderView?.isHidden = false
                    self.commentTableView.tableHeaderView?.frame.size.height = 70
                }
                
                for i in 0 ..< self.arrRes.count {
                    var dict = self.arrRes[i]
                    
                    var comment = commentData()

                    comment.commentPk = dict["msg1"] as! String
                    comment.feedPk = dict["msg2"] as! String
                    comment.commentUserPk = dict["msg3"] as! String
                    comment.commentDate = dict["msg4"] as! String
                    comment.commentMemo = dict["msg5"] as! String
                    comment.commentUserName = dict["msg6"] as! String
                    comment.commentUserImage = dict["msg7"] as! String
                    
                    self.commentList.append(comment)
                }
                
                self.commentTableView.reloadData()
                
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
    
    // 피드 지우기
    func deleteButtonTapped(sender: UIButton) {
        //if (userPk == feedList[indexPath.row].userPk) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let deleteButton = UIAlertAction(title: "삭제", style: UIAlertActionStyle.destructive, handler: { (deleteSeleted) -> Void in
            let row:Int = Int(sender.accessibilityHint!)!
            
            Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/CourtCommentDelete.jsp?Data1=\(self.commentList[row].commentPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print(self.arrRes)
                    }
                }
                self.getComments()
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //self.commentTextFieldView.frame.origin.y -= keyboardSize.height
            //self.commentTableView.frame.origin.y -= keyboardSize.height
            self.bottomConstraint.constant += keyboardSize.height
            self.tableViewBottomCostraint.constant += keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //self.commentTextFieldView.frame.origin.y += keyboardSize.height
            //self.commentTableView.frame.origin.y += keyboardSize.height
            self.bottomConstraint.constant -= keyboardSize.height
            self.tableViewBottomCostraint.constant -= keyboardSize.height
        }
    }
    
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func commentInputButtonTapped(_ sender: Any) {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            
            if(commentTextField.text == "") {
                let myAlert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
            }else {
                let nowDate = Date()
                let nowDateString = dateFormatter.string(from: nowDate)
                print(nowDateString)
                let url = "http://210.122.7.193:8080/TodayBasket_IOS/CourtCommentInput.jsp?Data1=\(feedPk)&Data2=\(userPk)&Data3=\(nowDateString)&Data4=\(commentTextField.text!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                        }
                        
                        if self.arrRes.count > 0 {
                            if(self.arrRes[0]["msg1"] as! String == "succed") {
                                // 푸쉬알람
                                if(self.userPk != self.feedUserPk) {
                                    Alamofire.request("http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo.jsp?Data1=\(self.userPk)").responseJSON { (responseData) -> Void in
                                        if((responseData.result.value) != nil) {
                                            let swiftyJsonVar = JSON(responseData.result.value!)
                                            print(swiftyJsonVar)
                                            
                                            if let resData = swiftyJsonVar["List"].arrayObject {
                                                self.arrRes = resData as! [[String:AnyObject]]
                                            }
                                            
                                            if(self.arrRes.count > 0) {
                                                self.userName = self.arrRes[0]["Name"] as! String
                                                
                                                // 푸쉬 알림
                                                let url = "http://210.122.7.193:8080/TodayBasket_manager/push.jsp?Data1=\(self.feedUserPk)&Data2=\(self.userName)님이 피드에 댓글을 달았습니다".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                                    if((responseData.result.value) != nil) {
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                self.dismissKeyboard()
                                self.getComments()
                                self.commentTextField.text = ""
                            }
                        }
                    }
                }
            }
        }else {
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()

            let myAlert = UIAlertController(title: nil, message: "로그인이 필요합니다", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell")
        
        let profileImageView = cell?.viewWithTag(1) as! UIImageView
        let nameLabel = cell?.viewWithTag(2) as! UILabel
        let dateLabel = cell?.viewWithTag(3) as! UILabel
        let commentTextView = cell?.viewWithTag(4) as! UITextView
        let commentDeleteButton = cell?.viewWithTag(5) as! UIButton
        
        // 이름 삽입
        nameLabel.text = commentList[indexPath.row].commentUserName
        
        // 날짜 삽입
        let nowTime = Date()
        let uploadTime = dateFormatter.date(from: commentList[indexPath.row].commentDate)
        
        let cal = Calendar(identifier: .gregorian)
        
        let comp = cal.dateComponents([.day, .hour, .minute], from: uploadTime!, to: nowTime)
        if(comp.day! == 0) {
            if(comp.hour! == 0) {
                if(comp.minute! == 0) {
                    dateLabel.text = "방금"
                }else {
                    dateLabel.text = "\(comp.minute!)분 전"
                }
            }else {
                dateLabel.text = "\(comp.hour!)시간 전"
            }
        }else if(comp.day! < 8) {
            if(comp.day! == 1) {
                dateLabel.text = "어제"
            }else if(comp.day! == 7) {
                dateLabel.text = "일주일 전"
            }else {
                dateLabel.text = "\(comp.day!)일 전"
            }
        }else {
            let compUploadTime = cal.dateComponents([.year, .month, .day], from: uploadTime!)
            
            dateLabel.text = "\(compUploadTime.month!) / \(compUploadTime.day!)"
        }
        
        
        // 댓글 내용 삽입
        commentTextView.text = commentList[indexPath.row].commentMemo
        
        // 댓글 삭제 버튼 삽입
        if(userPk == commentList[indexPath.row].commentUserPk) {
            commentDeleteButton.isHidden = false
        }else {
            commentDeleteButton.isHidden = true
        }
        
        // 댓글 삭제 이벤트 삽입
        commentDeleteButton.accessibilityHint = "\(indexPath.row)"
        commentDeleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // 프로필 사진 삽입
        if(commentList[indexPath.row].commentUserImage == ".") {
            profileImageView.image = UIImage(named: "user_basic")
        }else {
            let url = "http://210.122.7.193:8080/Trophy_img/profile/\(self.commentList[indexPath.row].commentUserImage).jpg"
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    profileImageView.image = image
                }
            }
        }
        
        // 댓글 내용에 따라 textView 높이 지정
        let size = CGSize(width: view.frame.width, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let rect = NSString(string: commentList[indexPath.row].commentMemo).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        commentTextView.frame.size = CGSize(width: self.view.frame.width, height: rect.height + 20)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = CGSize(width: view.frame.width, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let rect = NSString(string: commentList[indexPath.row].commentMemo).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return 64 + rect.height
    }
}
