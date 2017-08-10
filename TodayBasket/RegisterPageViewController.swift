//
//  RegisterPageViewController.swift
//  TrophyProject
//
//  Created by ldong on 2017. 2. 7..
//  Copyright © 2017년 Trophy. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class RegisterPageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPhoneAnTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userAddressDoTextField: UITextField!
    @IBOutlet weak var userAddressSiTextField: UITextField!
    @IBOutlet weak var userYearTextField: UITextField!
    @IBOutlet weak var userMonthTextField: UITextField!
    @IBOutlet weak var userDayTextField: UITextField!
    @IBOutlet weak var userSexSegmentationControll: UISegmentedControl!
    @IBOutlet weak var userHeightTextField: UITextField!
    @IBOutlet weak var userWeightTextField: UITextField!
    @IBOutlet weak var userPositionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var pickerDo = UIPickerView()
    var pickerSi = UIPickerView()
    var pickerMonth = UIPickerView()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var addressDo = ["서울", "인천","광주","대구", "울산", "대전", "부산", "강원도", "경기도", "충청북도", "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주도"]
    var addressSi = [
        ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],// 서울
        ["강화군", "계양구", "남구", "남동구", "동구", "부평구", "서구", "연수구", "웅진군", "중구"], // 인천
        ["광산구", "남구", "동구", "북구", "서구"], // 광주
        ["남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"], // 대구
        ["남구", "동구", "북구", "울주군", "중구"], // 울산
        ["대덕구", "동구", "서구", "유성구", "중구"], // 대전
        ["강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구", "연제구", "영동구", "중구", "해운대구"], // 부산
        ["춘천시", "강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "인제군", "원주시", "정선군", "철원군", "태백시", "홍천군", "횡성군", "평창군", "화천군"], // 강원도
        ["고양시", "구리시", "광명시", "과천시", "광주시", "가평군", "군포시", "김포시", "강화군", "남양주시", "동두천시", "부천시", "수원시", "성남시", "시흥시", "안양시", "안산시", "용인시", "오산시", "이천시", "안성시", "의왕시", "양주시", "양평군", "여주군", "연천군", "옹진군", "의정부시" ,"평택시", "포천시", "파주시", "하남시", "화성시"], // 경기도
        ["괴산군" ,"단양군", "보은군", "음성군", "영동군", "옥천군", "제천시", "진천군", "청주시", "충주시", "청원군"], // 충청북도
        ["공주시", "금산군", "논산시", "당진군", "보령시", "부여군", "서산시", "세종시", "서천군", "아산시", "연기군", "예산군", "천안시", "청양군", "태안군", "홍성군"], // 충청남도
        ["고창군", "김제시", "군산시", "남원시", "무주군" ,"부안군", "순창군", "익산시", "임실군", "완주군", "전주시", "정읍시", "진안군", "장수군"], // 전라북도
        ["곡성군", "구례군", "고흥군", "광양시", "강진군", "나주시", "담양군", "무안군", "목포시", "보성군", "순천시", "신안군", "여수시", "영암군", "영광군", "완도군", "진도군", "장흥군", "장성군", "화순군", "해남군", "함평군"], // 전라남도
        ["기장군", "고령군", "구미시", "경주시", "김천시", "경산시", "군위군", "문경시", "봉화군", "상주시", "안동시", "영주시", "영천시", "의성군", "영양군", "영덕군", "울주군", "예천군", "울진군", "울릉군", "청송군", "청도군", "칭곡군", "포항시"], // 경상북도
        ["고성군", "김해시", "거제시", "남해군", "마산시", "밀양시", "사천시", "의령군", "양산시", "진주시", "진해시", "창원시", "창녕군", "통영시", "함안군", "하동군"], // 경상남도
        ["서귀포시", "제주시"]] // 제주도
    var birthMonth = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    

    var userPhone:String = ""
    var userPassword:String = ""
    var userName:String = ""
    var userAddressDo:String = ""
    var userAddressSi:String = ""
    var userBirthYear:String = ""
    var userBirthMonth:String = ""
    var userBirthDay:String = ""
    var userSex:String = "남자"
    var userHeight:String = ""
    var userWeight:String = ""
    var userPosition:String = "C"
    var isCheckPhone:Bool = false
    var randomNo: UInt32 = 0
    var exNum:Int = 3
    
    var arrRes = [[String:AnyObject]]()
    
    // To keep track of user's current selection from the main content array
    fileprivate var _currentSelection: Int = 0
    
    // whenever current selection is modified, we need to reload other pickers as their content depends upon the current selection index only.
    
    var currentSelection: Int {
        get {
            return _currentSelection
        }
        set {
            _currentSelection = newValue
            pickerDo .reloadAllComponents()
            pickerSi .reloadAllComponents()
            
            userAddressDoTextField.text = addressDo[_currentSelection]
            userAddressSiTextField.text = addressSi[_currentSelection][0]
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation bar item image load
        let yourBackImage = UIImage(named: "cm_arrow_back_white")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        // Do any additional setup after loading the view.
        pickerDo.delegate = self
        pickerDo.dataSource = self
        pickerSi.delegate = self
        pickerSi.dataSource = self
        pickerMonth.delegate = self
        pickerMonth.dataSource = self
        userYearTextField.delegate = self
        userDayTextField.delegate = self
        userPhoneTextField.delegate = self
        userPhoneAnTextField.delegate = self
        userAddressSiTextField.delegate = self
        userAddressDoTextField.inputView = pickerDo
        userAddressSiTextField.inputView = pickerSi
        userMonthTextField.inputView = pickerMonth
        pickerDo.tag = 1
        pickerSi.tag = 2
        pickerMonth.tag = 3
        userYearTextField.tag = 4
        userDayTextField.tag = 5
        userPhoneTextField.tag = 6
        userPhoneAnTextField.tag = 7
        
        let allToolbar = UIToolbar()
        allToolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
        
        allToolbar.setItems([doneBtn], animated: false)
        
        userPhoneTextField.inputAccessoryView = allToolbar
        userPhoneAnTextField.inputAccessoryView = allToolbar
        userPasswordTextField.inputAccessoryView = allToolbar
        repeatPasswordTextField.inputAccessoryView = allToolbar
        userNameTextField.inputAccessoryView = allToolbar
        userAddressDoTextField.inputAccessoryView = allToolbar
        userAddressSiTextField.inputAccessoryView = allToolbar
        userYearTextField.inputAccessoryView = allToolbar
        userMonthTextField.inputAccessoryView = allToolbar
        userDayTextField.inputAccessoryView = allToolbar
        userHeightTextField.inputAccessoryView = allToolbar
        userWeightTextField.inputAccessoryView = allToolbar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == userAddressDoTextField) {
            mainView.frame.origin.y -= 30
        }else if(textField == userAddressSiTextField) {
            mainView.frame.origin.y -= 30
        }else if(textField == userYearTextField) {
            mainView.frame.origin.y -= 60
        }else if(textField == userMonthTextField) {
            mainView.frame.origin.y -= 60
        }else if(textField == userDayTextField) {
            mainView.frame.origin.y -= 60
        }else if(textField == userHeightTextField) {
            mainView.frame.origin.y -= 90
        }else if(textField == userWeightTextField) {
            mainView.frame.origin.y -= 90
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == userAddressDoTextField || textField == userAddressSiTextField) {
            mainView.frame.origin.y += 30
        }else if(textField == userYearTextField || textField == userMonthTextField || textField == userDayTextField) {
            mainView.frame.origin.y += 60
        }else if(textField == userHeightTextField || textField == userWeightTextField) {
            mainView.frame.origin.y += 90
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.tag == 4) {
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if (newString.length <= maxLength && string == numberFiltered) {
                return true
            }else {
                return false
            }
            
        }else if (textField.tag == 5) {
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            let maxLength = 2
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if (newString.length <= maxLength && string == numberFiltered) {
                return true
            }else {
                return false
            }
        }else if(textField.tag == 6) {
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if (newString.length <= maxLength && string == numberFiltered) {
                return true
            }else {
                return false
            }
        }else if(textField.tag == 7) {
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if (newString.length <= maxLength && string == numberFiltered) {
                return true
            }else {
                return false
            }
        }else if(textField.tag == 8) {
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if (newString.length <= maxLength && string == numberFiltered) {
                return true
            }else {
                return false
            }
        }else if(textField.tag == 9) {
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if (newString.length <= maxLength && string == numberFiltered) {
                return true
            }else {
                return false
            }
        }
        return true
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 1) {
            userAddressSiTextField.text = ""
            return addressDo.count
        }else if(pickerView.tag == 2) {
            return addressSi[currentSelection].count
        }else {
            return birthMonth.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) {
            userAddressSiTextField.text = ""
            return "\(addressDo[row])"
        }else if(pickerView.tag == 2) {
            return "\(addressSi[currentSelection][row])"
        }else {
            return "\(birthMonth[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1) {
            currentSelection = row
            
            userAddressDoTextField.text = "\(addressDo[row])"
            userAddressDoTextField.resignFirstResponder()
        }else if(pickerView.tag == 2) {
            userAddressSiTextField.text = "\(addressSi[currentSelection][row])"
            userAddressSiTextField.resignFirstResponder()

        }else if(pickerView.tag == 3) {
            userMonthTextField.text = "\(birthMonth[row])"
            userMonthTextField.resignFirstResponder()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func userSexIndexChanged(_ sender: AnyObject) {
        switch userSexSegmentationControll.selectedSegmentIndex {
        case 0:
            userSex = "남자"
        case 1:
            userSex = "여자"
        default:
            userSex = "남자";
        }
    }
    
    @IBAction func userPositionIndexChanged(_ sender: Any) {
        switch userPositionSegmentedControl.selectedSegmentIndex {
        case 0:
            userPosition = "C"
        case 1:
            userPosition = "PF"
        case 2:
            userPosition = "SF"
        case 3:
            userPosition = "PG"
        case 4:
            userPosition = "SG"
        default:
            userPosition = "C";
        }
    }
    
    @IBAction func sendAnButtonTapped(_ sender: AnyObject) {
        startIndicator()
        
        let length:Int = (userPhoneTextField.text?.characters.count)!
        if(length == 11) {
            isCheckPhone = false
            userPhone = userPhoneTextField.text!
            
            let url1:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/CheckPhone.jsp?Data1=\(userPhone)")!;
            Alamofire.request(url1).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if(self.arrRes.count > 0) {
                        if(self.arrRes[0]["isDuplicate"]! as! String == "false") {
                            self.randomNo = arc4random_uniform(899999) + 100000;
                            let msg:String = "트로피 인증번호는 [\(self.randomNo)] 입니다"
                            print(msg)
                            
                            let now = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date = dateFormatter.string(from: now)
                            
                            let url2 = "http://210.122.7.193:8080/InetSMSExample/example.jsp?Data1=\(msg)&Data2=\(self.userPhone)&Data3=\(self.userPhone)&Data4=\(date)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            Alamofire.request(url2!).response { (response) -> Void in }
                            
                            self.finishIndicator()
                            self.displayMyAlertMessage("인증번호가 발송되었습니다")
                        }else {
                            self.finishIndicator()
                            self.displayMyAlertMessage("중복된 휴대전화번호입니다")
                        }
                    }
                }
            }

            // 인증번호 전송, 휴대전화번호 텍스트필드 변경시 랜덤 번호 삭제
        }else {
            finishIndicator()
            displayMyAlertMessage("정확한 휴대전화번호를 입력해 주세요")
        }
    }
    
    
    @IBAction func confirmAnButtonTapped(_ sender: AnyObject) {
    
        if(String(randomNo) == userPhoneAnTextField.text!) {
            isCheckPhone = true
            displayMyAlertMessage("인증이 완료되었습니다")
        }else {
            exNum -= 1
            displayMyAlertMessage("정확한 인증번호를 입력해 주세요. 남은 횟수:\(exNum)")
        }
        // 불일치할 경우 Alert 횟수제한 3번
    }
    
    @IBAction func registerButtonTapped(_ sender: AnyObject) {
        startIndicator()
        
        //userPhone = userPhoneTextField.text!
        userPassword = userPasswordTextField.text!
        let userRepeatPassword:String = repeatPasswordTextField.text!
        userAddressDo = userAddressDoTextField.text!
        userAddressSi = userAddressSiTextField.text!
        userName = userNameTextField.text!
        userBirthYear = userYearTextField.text!
        userBirthMonth = userMonthTextField.text!
        userBirthDay = userDayTextField.text!
        userHeight = userHeightTextField.text!
        userWeight = userWeightTextField.text!
        
        let userBirth:String = "\(userBirthYear) / \(userBirthMonth) / \(userBirthDay)"
        
        //Check for Empty fields
        if(userPhone.isEmpty || userPassword.isEmpty || userRepeatPassword.isEmpty || userSex.isEmpty || userBirthYear.isEmpty || userBirthMonth.isEmpty || userBirthDay.isEmpty || userHeight.isEmpty || userWeight.isEmpty) {
            finishIndicator()
            displayMyAlertMessage("모든 칸을 채워주세요")
            return
        }
        
        //Check if passwords match
        if(userPassword != userRepeatPassword) {
            finishIndicator()
            displayMyAlertMessage("비밀번호가 일치하지 않습니다")
            return
        }
        
        //휴대전화번호 인증 확인
        if(isCheckPhone == false) {
            finishIndicator()
            displayMyAlertMessage("휴대전화번호 인증을 진행해주세요")
            return
        }
     
        print("전송되는 데이터 : Data1=\(userName)&Data2=\(userPassword)&Data3=\(userBirth)&Data4=\(userSex)&Data5=\(userAddressDo)&Data6=\(userAddressSi)&Data7=\(userPhone)")
        let url3 = "http://210.122.7.193:8080/Trophy_part1/User_Join.jsp?Data1=\(userName)&Data2=\(userPassword)&Data3=\(userBirth)&Data4=\(userSex)&Data5=\(userAddressDo)&Data6=\(userAddressSi)&Data7=\(userPhone)&Data8=\(userPosition)&Data9=\(userHeight)&Data10=\(userWeight)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(url3!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print(self.arrRes)
                    if(self.arrRes.count > 0) {
                        if(self.arrRes[0]["msg1"]! as! String == "success") {
                            self.finishIndicator()
                            let myAlert = UIAlertController(title: "회원가입", message: "회원가입이 완료되었습니다 로그인을 진행해 주세요", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else {
                            self.finishIndicator()
                            let myAlert = UIAlertController(title: "에러", message: "잠시후 다시 시도해 주세요", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func done() {
        self.view.endEditing(true)
    }
    
    func startIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func finishIndicator() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func displayMyAlertMessage(_ userMessage:String) {
        let myAlert = UIAlertController(title: "오늘의농구", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
