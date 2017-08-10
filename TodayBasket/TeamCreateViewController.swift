//
//  TeamCreateViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 6..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func addToolBar(textView: UITextView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textView.delegate = self
        textView.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        view.endEditing(true)
    }
    
    func cancelPressed() {
        view.endEditing(true) // or do something
    }
}

class TeamCreateViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var open: UIBarButtonItem!
    
    @IBOutlet weak var teamEmblemButton: UIButton!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamAddressDoTextField: UITextField!
    @IBOutlet weak var teamAddressSiTextField: UITextField!
    @IBOutlet weak var teamHomeCourtTextField: UITextField!
    @IBOutlet weak var teamIntroTextView: UITextView!
    
    var url = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
    var userPk:String = ""
    
    var teamName:String = ""
    var teamAddressDo:String = ""
    var teamAddressSi:String = ""
    var teamHomeCourt:String = ""
    var teamIntro:String = ""
    var isTeamEmblemChanged:Bool = false
    
    var pickerDo = UIPickerView()
    var pickerSi = UIPickerView()
    
    var arrRes = [[String:AnyObject]]()
    var teamEmblemImage:Data? = nil
    
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
    
    fileprivate var _currentSelection: Int = 0
    
    var currentSelection: Int {
        get {
            print(_currentSelection)
            return _currentSelection
        }
        set {
            _currentSelection = newValue
            pickerDo .reloadAllComponents()
            pickerSi .reloadAllComponents()
            print(_currentSelection)
            
            teamAddressDoTextField.text = addressDo[_currentSelection]
            teamAddressSiTextField.text = addressSi[_currentSelection][0]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        self.teamEmblemButton.layer.cornerRadius = self.teamEmblemButton.frame.size.width/2
        self.teamEmblemButton.clipsToBounds = true
        
        addToolBar(textField: teamNameTextField)
        addToolBar(textField: teamAddressDoTextField)
        addToolBar(textField: teamAddressSiTextField)
        addToolBar(textField: teamHomeCourtTextField)
        addToolBar(textView: teamIntroTextView)
        
        pickerDo.delegate = self
        pickerDo.dataSource = self
        pickerSi.delegate = self
        pickerSi.dataSource = self
        teamAddressSiTextField.delegate = self
        teamAddressDoTextField.inputView = pickerDo
        teamAddressSiTextField.inputView = pickerSi
        pickerDo.tag = 1
        pickerSi.tag = 2
        
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 1) {
            teamAddressSiTextField.text = ""
            return addressDo.count
        }else { //if(pickerView.tag == 2) {
            return addressSi[currentSelection].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) {
            teamAddressSiTextField.text = ""
            return "\(addressDo[row])"
        }else { //if(pickerView.tag == 2) {
            return "\(addressSi[currentSelection][row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1) {
            currentSelection = row
            teamAddressDoTextField.text = "\(addressDo[row])"
            teamAddressDoTextField.resignFirstResponder()
        }else if(pickerView.tag == 2) {
            teamAddressSiTextField.text = "\(addressSi[currentSelection][row])"
            teamAddressSiTextField.resignFirstResponder()
        }
    }
    
    @IBAction func teamEmblemButtonTapped(_ sender: Any) {

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let libButton = UIAlertAction(title: "라이브러리에서 선택", style: UIAlertActionStyle.default, handler: { (libSelected) -> Void in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        })
        actionSheet.addAction(libButton)
        let cameraButton = UIAlertAction(title: "사진 찍기", style: UIAlertActionStyle.default, handler: { (cameraSeleted) -> Void in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated: true, completion: nil)
        })
        actionSheet.addAction(cameraButton)
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
            
        })
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
        

    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            teamEmblemButton.setImage(image, for: .normal)
            
            self.teamEmblemImage = UIImageJPEGRepresentation(image, 1)!
            
        }else {
            print("error")
        }
        //myimage.backgroundColor = UIColor.clearColor()
        self.dismiss(animated: true, completion: nil)
    }

    

    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        teamName = teamNameTextField.text!
        teamAddressDo = teamAddressDoTextField.text!
        teamAddressSi = teamAddressSiTextField.text!
        teamHomeCourt = teamHomeCourtTextField.text!
        teamIntro = teamIntroTextView.text!
        
        if(teamName.isEmpty || teamAddressDo.isEmpty || teamAddressSi.isEmpty || teamHomeCourt.isEmpty || teamIntro.isEmpty) {
            let myAlert = UIAlertController(title: "팀 생성", message: "모든 칸을 채워주세요", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            
            return
        }
        
        if(isTeamEmblemChanged) {
            self.url = "http://210.122.7.193:8080/Trophy_part3/TeamCreate.jsp?Data1=\(userPk)&Data2=\(teamName)&Data3=\(teamAddressDo)&Data4=\(teamAddressSi)&Data5=\(teamHomeCourt)&Data6=\(teamIntro)&Data7=\(teamName)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }else {
            self.url = "http://210.122.7.193:8080/Trophy_part3/TeamCreate.jsp?Data1=\(userPk)&Data2=\(teamName)&Data3=\(teamAddressDo)&Data4=\(teamAddressSi)&Data5=\(teamHomeCourt)&Data6=\(teamIntro)&Data7=.".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }
        
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print(self.arrRes)
                    if(self.arrRes.count > 0) {
                        if(self.arrRes[0]["status"]! as! String == "succed") {
                            if(self.isTeamEmblemChanged) {
                                self.uploadWithAlamofire(self.teamName)
                            }
                            let myAlert = UIAlertController(title: "팀 생성", message: "팀 생성이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                
                                Alamofire.request("http://210.122.7.193:8080/Trophy_part3/getTeamPk.jsp?Data1=\(self.userPk)").responseJSON { (responseData) -> Void in
                                    if((responseData.result.value) != nil) {
                                        let swiftyJsonVar = JSON(responseData.result.value!)
                                        
                                        if let resData = swiftyJsonVar["List"].arrayObject {
                                            self.arrRes = resData as! [[String:AnyObject]]
                                            print("\(self.arrRes)")
                                        }
                                        
                                        if self.arrRes.count > 0 {
                                            var dict = self.arrRes[0]
                                            let teamPk = dict["teamPk"] as! String
                                            
                                            let revealViewController:SWRevealViewController = self.revealViewController()
                                            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            let desController = mainStoryboard.instantiateViewController(withIdentifier: "TeamDetailViewController") as! TeamDetailViewController
                                            desController.teamPk = teamPk
                                            desController.isMenu = true
                                            let newFrontViewController = UINavigationController.init(rootViewController:desController)
                                            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                                        }
                                    }
                                }
                                
                                self.dismiss(animated: true, completion: nil)
                            })
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else if(self.arrRes[0]["status"]! as! String == "duplicate") {
                            let myAlert = UIAlertController(title: "팀 생성", message: "이미 존재하는 팀명 입니다", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                        }else {
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
    
    func uploadWithAlamofire(_ teamName:String) {
        // define parameters
//        let parameters = [
//            "hometown": "yalikavak",
//            "living": "istanbul"
//        ]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.teamEmblemImage!, withName: "file" , fileName: "\(teamName).jpg", mimeType: "image/jpg")},
                         to: "http://210.122.7.193:8080/Trophy_part3/TeamImageUpload.jsp",
                         method: .post,
                         headers: ["Authorization": "auth_token"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.response { [weak self] response in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    debugPrint(response)
                                }
                            case .failure(let encodingError):
                                print("error:\(encodingError)")
                            }
        })
    }
}
