//
//  MatchUploadViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 23..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MatchUploadViewController: UIViewController {
    
    @IBOutlet weak var matchDateTextField: UITextField!
    @IBOutlet weak var matchStartTimeTextField: UITextField!
    @IBOutlet weak var matchFinishTimeTextField: UITextField!
    @IBOutlet weak var matchPlaceTextField: UITextField!
    @IBOutlet weak var matchPayTextField: UITextField!
    @IBOutlet weak var matchUniformTextField: UITextField!
    @IBOutlet weak var matchUploadTeamEmblem: UIImageView!
    @IBOutlet weak var matchUploadTeamName: UILabel!
    
    @IBOutlet weak var matchParkForbiddenButton: UIButton!
    @IBOutlet weak var matchParkFreeButton: UIButton!
    @IBOutlet weak var matchParkChargeButton: UIButton!
    @IBOutlet weak var matchDisplayButton: UIButton!
    @IBOutlet weak var matchShowerButton: UIButton!
    @IBOutlet weak var matchColdHotButton: UIButton!
    @IBOutlet weak var matchExtraTextView: UITextView!
    
    @IBOutlet weak var matchTextView: UIView!
    @IBOutlet var mainView: UIView!
    
    var keyboardHeigt:CGFloat?
    
    var matchDate:String = ""
    var matchStartTime:String = ""
    var matchFinishTime:String = ""
    var matchPlace:String = ""
    var matchPay:String = ""
    var matchUniform:String = ""
    var matchExtra:String = ""
    
    var matchParkForbidden:String = "true"
    var matchParkFree:String = "false"
    var matchParkCharge:String = "false"
    var matchDisplay:String = "false"
    var matchShower:String = "false"
    var matchColdHot:String = "false"
    
    var arrRes = [[String:AnyObject]]()
    
    var isUserLoggedIn:Bool = false
    var userPk:String = ""
    var teamPk:String = ""
    var teamName:String = ""
    var teamEmblem:String = ""
    
    let datePicker = UIDatePicker()
    let datePickerTime = UIDatePicker()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchExtraTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(MatchUploadViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MatchUploadViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.matchUploadTeamEmblem.layer.cornerRadius = self.matchUploadTeamEmblem.frame.size.width/2
        self.matchUploadTeamEmblem.clipsToBounds = true
        
        createDatePicker()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MatchUploadViewController.dismissKeyboard))
        
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
                        self.teamPk = dict["teamPk"] as! String
                        self.teamName = dict["teamName"] as! String
                        self.teamEmblem = dict["teamEmblem"] as! String
                        
                        if(self.teamPk == ".") { // 가입된 팀이 없을시
                            let myAlert = UIAlertController(title: "오늘의농구", message: "가입된 팀이 없습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: {action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else { // 이상 없을시
                            self.matchUploadTeamName.text = self.teamName
                            
                            if(self.teamEmblem != ".") {
                                let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                Alamofire.request(url!).responseImage { response in
                                    if let image = response.result.value {
                                        self.matchUploadTeamEmblem.image = image
                                    }
                                }
                            }else {
                                self.matchUploadTeamEmblem.image = UIImage(named: "ic_team")
                            }
                            
                        }
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
     
        
        view.addGestureRecognizer(tap)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.mainView.frame.origin.y -= keyboardHeigt!
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.mainView.frame.origin.y += keyboardHeigt!
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.mainView.frame.origin.y -= CGFloat(50)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.mainView.frame.origin.y += CGFloat(50)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(matchExtraTextView.isFocused == false) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyboardHeigt = keyboardSize.height
                
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeigt = keyboardSize.height
        }
    }
    
    func createDatePicker() {
        let nowDate = Date()
        let nowMonthDate = nowDate + 2592000
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nowDate
        datePicker.maximumDate = nowMonthDate
        
        datePickerTime.datePickerMode = .time
        datePicker.minimumDate = nowDate
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let startTimeToolbar = UIToolbar()
        startTimeToolbar.sizeToFit()
        let finishTimeToolbar = UIToolbar()
        finishTimeToolbar.sizeToFit()
        
        let allToolbar = UIToolbar()
        allToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
        let startTimeDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonStartTimeTapped))
        let finishTimeDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonFinishTimeTapped))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
        
        toolbar.setItems([doneButton], animated: false)
        startTimeToolbar.setItems([startTimeDoneButton], animated: false)
        finishTimeToolbar.setItems([finishTimeDoneButton], animated: false)
        allToolbar.setItems([doneBtn], animated: false)
        
        matchDateTextField.inputAccessoryView = toolbar
        matchDateTextField.inputView = datePicker
        
        matchStartTimeTextField.inputAccessoryView = startTimeToolbar
        matchStartTimeTextField.inputView = datePickerTime
        
        matchFinishTimeTextField.inputAccessoryView = finishTimeToolbar
        matchFinishTimeTextField.inputView = datePickerTime
        
        matchPlaceTextField.inputAccessoryView = allToolbar
        matchPayTextField.inputAccessoryView = allToolbar
        matchUniformTextField.inputAccessoryView = allToolbar
        matchExtraTextView.inputAccessoryView = allToolbar
    }
    
    func doneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. d."
        
        matchDateTextField.text = "\(dateFormatter.string(from: datePicker.date))"
        
        self.view.endEditing(true)
    }
    
    func doneButtonStartTimeTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:m"
        
        matchStartTimeTextField.text = "\(dateFormatter.string(from: datePickerTime.date))"
        self.view.endEditing(true)
    }
    
    func doneButtonFinishTimeTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:m"
        
        matchFinishTimeTextField.text = "\(dateFormatter.string(from: datePickerTime.date))"
        self.view.endEditing(true)
    }
    
    func done() {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
        
    }
    
    @IBAction func matchParkForbiddenButtonTapped(_ sender: Any) {
        if(matchParkForbidden == "false") {
            matchParkForbidden = "true"
            matchParkFree = "false"
            matchParkCharge = "false"
            
            matchParkForbiddenButton.backgroundColor = UIColor(red: 252.0/255.0, green: 118.0/255.0, blue: 72.0/255.0, alpha: 1.0)
            matchParkFreeButton.backgroundColor = UIColor.white
            matchParkChargeButton.backgroundColor = UIColor.white
        }
    }
    @IBAction func matchParkFreeButtonTapped(_ sender: Any) {
        if(matchParkFree == "false") {
            matchParkForbidden = "false"
            matchParkFree = "true"
            matchParkCharge = "false"
            
            matchParkForbiddenButton.backgroundColor = UIColor.white
            matchParkFreeButton.backgroundColor = UIColor(red: 252.0/255.0, green: 118.0/255.0, blue: 72.0/255.0, alpha: 1.0)
            matchParkChargeButton.backgroundColor = UIColor.white
        }
    }
    @IBAction func matchParkChargeButtonTapped(_ sender: Any) {
        if(matchParkCharge == "false") {
            matchParkForbidden = "false"
            matchParkFree = "false"
            matchParkCharge = "true"
            
            matchParkForbiddenButton.backgroundColor = UIColor.white
            matchParkFreeButton.backgroundColor = UIColor.white
            matchParkChargeButton.backgroundColor = UIColor(red: 252.0/255.0, green: 118.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        }
    }
    @IBAction func matchDisplayButtonTapped(_ sender: Any) {
        if(matchDisplay == "true") {
            matchDisplay = "false"
            matchDisplayButton.backgroundColor = UIColor.white
        }else {
            matchDisplay = "true"
            matchDisplayButton.backgroundColor = UIColor(red: 252.0/255.0, green: 118.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        }
    }
    @IBAction func matchShowerButtonTapped(_ sender: Any) {
        if(matchShower == "true") {
            matchShower = "false"
            matchShowerButton.backgroundColor = UIColor.white
        }else {
            matchShower = "true"
            matchShowerButton.backgroundColor = UIColor(red: 252.0/255.0, green: 118.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        }
    }
    @IBAction func matchColdHotButtonTapped(_ sender: Any) {
        if(matchColdHot == "true") {
            matchColdHot = "false"
            matchColdHotButton.backgroundColor = UIColor.white
        }else {
            matchColdHot = "true"
            matchColdHotButton.backgroundColor = UIColor(red: 252.0/255.0, green: 118.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        }
    }
    
    
    
    
    @IBAction func matchUploadButtonTapped(_ sender: Any) {
        
        matchDate = matchDateTextField.text!
        matchStartTime = matchStartTimeTextField.text!
        matchFinishTime = matchFinishTimeTextField.text!
        matchPlace = matchPlaceTextField.text!
        matchPay = matchPayTextField.text!
        matchUniform = matchUniformTextField.text!
        matchExtra = matchExtraTextView.text!
        
        if(matchDate == "" || matchStartTime == "" || matchFinishTime == "" || matchPlace == "" || matchPay == "" || matchUniform == "") {
            
            let myAlert = UIAlertController(title: "오늘의농구", message: "모든 칸을 채워주세요", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }else {
            
            uploadMatch()
        }
    }
    
    func uploadMatch() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. d."
        
        let nowDate = Date()
        let matchDate_ = dateFormatter.date(from: matchDate)
        
        let cal = Calendar(identifier: .gregorian)
        
        let compMatchDate = cal.dateComponents([.year, .month, .day, .weekday], from: matchDate_!)
        
        if(compMatchDate.month! < 10) {
            matchDate = "\(compMatchDate.year!):::0\(compMatchDate.month!) / \(compMatchDate.day!)"
        }else {
            matchDate = "\(compMatchDate.year!):::\(compMatchDate.month!) / \(compMatchDate.day!)"
        }
        
        
        dateFormatter.dateFormat = "yyyy / MM / dd:::HH : mm"
        let nowDate_ = dateFormatter.string(from: nowDate)
        
        var matchWeekday = ""
        if (compMatchDate.weekday == 1) {
            matchWeekday = "일"
        }else if(compMatchDate.weekday == 2) {
            matchWeekday = "월"
        }else if(compMatchDate.weekday == 3) {
            matchWeekday = "화"
        }else if(compMatchDate.weekday == 4) {
            matchWeekday = "수"
        }else if(compMatchDate.weekday == 5) {
            matchWeekday = "목"
        }else if(compMatchDate.weekday == 6) {
            matchWeekday = "금"
        }else if(compMatchDate.weekday == 7) {
            matchWeekday = "토"
        }
        
        
        var matchTitle:String = ""
        if(compMatchDate.month! < 10) {
            matchTitle = "0\(compMatchDate.month!)월 \(compMatchDate.day!)일(\(matchWeekday)) 교류전 팀 구합니다."
        }else {
            matchTitle = "\(compMatchDate.month!)월 \(compMatchDate.day!)일(\(matchWeekday)) 교류전 팀 구합니다."
        }
        
        
        
        let url = "http://210.122.7.193:8080/TodayBasket_IOS/MatchUpload.jsp?Data1=\(userPk)&Data2=\(teamPk)&Data3=\(nowDate_)&Data4=\(matchTitle)&Data5=\(matchStartTime)&Data6=\(matchFinishTime)&Data7=\(matchPlace)&Data8=\(matchPay)&Data9=\(matchUniform)&Data10=\(matchExtra)&Data11=\(matchParkForbidden)&Data12=\(matchParkFree)&Data13=\(matchParkCharge)&Data14=\(matchDisplay)&Data15=\(matchShower)&Data16=\(matchColdHot)&Data17=\(matchDate)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    if(dict["msg1"] as! String == "succed") {
                        // 완료 메시지 표시
                        let myAlert = UIAlertController(title: "교류전 신청", message: "교류전 신청이 완료되었습니다!", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                            self.navigationController?.popToRootViewController(animated: true)
                            })
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)

                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }
        }
    }
}
