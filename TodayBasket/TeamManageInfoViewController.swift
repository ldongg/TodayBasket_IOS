//
//  TeamManageInfoViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 21..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class TeamManageInfoViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var teamEmblemImageView: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamAddressDoLabel: UILabel!
    @IBOutlet weak var teamAddressSiLabel: UILabel!
    @IBOutlet weak var teamHomeCourtLabel: UILabel!
    @IBOutlet weak var teamIntroTextView: UITextView!
    
    
    
    @IBOutlet weak var teamImageButton1: UIButton!
    @IBOutlet weak var teamImageButton2: UIButton!
    @IBOutlet weak var teamImageButton3: UIButton!
    
    
    var teamEmblemImage:Data? = nil
    var teamImageButtonList = [UIButton]()
    var teamName:String = ""
    var teamIntroduce:String = ""
    var teamAddressDo:String = ""
    var teamAddressSi:String = ""
    var teamHomeCourt:String = ""
    var teamImage1:String = ""
    var teamImage2:String = ""
    var teamImage3:String = ""
    var teamEmblem:String = ""
    
    var teamImageList = [String]()
    var userPk:String = ""
    var teamPk:String = ""
    
    var arrRes = [[String:AnyObject]]()
    var i:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamImageButtonList = [teamImageButton1, teamImageButton2, teamImageButton3]
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(TeamManageInfoViewController.emblemTapped))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        teamEmblemImageView.isUserInteractionEnabled = true
        teamEmblemImageView.addGestureRecognizer(singleTap)
        
        self.teamEmblemImageView.layer.cornerRadius = self.teamEmblemImageView.frame.size.width/2
        self.teamEmblemImageView.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        
        // Do any additional setup after loading the view.
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/getTeamPk.jsp?Data1=\(userPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    var dict = self.arrRes[0]
                    
                    let status = dict["status"] as! String
                    self.teamPk = dict["teamPk"] as! String
                    
                    if (status == "succed") {
                        self.getTeamInfo()
                    }
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissTeamButtonTapped(_ sender: Any) {
        let myAlert = UIAlertController(title: "팀해산", message: "정말로 팀 해산을 진행하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { action in
            let url = "http://210.122.7.193:8080/Trophy_part3/TeamManageDismiss.jsp?Data1=\(self.userPk)&Data2=\(self.teamPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(url!).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print(self.arrRes)
                        if(self.arrRes.count > 0) {
                            if(self.arrRes[0]["status"]! as! String == "succed") {
                                let myAlert = UIAlertController(title: "팀해산", message: "팀해산이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                                    UserDefaults.standard.setValue(".", forKey: "Pk")
                                    UserDefaults.standard.synchronize()
                                    self.dismiss(animated: true, completion: nil)
                                })
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }else if(self.arrRes[0]["status"]! as! String == "Exist_Player") {
                                let myAlert = UIAlertController(title: "팀해산", message: "팀원이 존재합니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }else if(self.arrRes[0]["status"]! as! String == "Exist_Joiner") {
                                let myAlert = UIAlertController(title: "팀해산", message: "참가중인 교류전이 존재합니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }else if(self.arrRes[0]["status"]! as! String == "Exist_Contest") {
                                let myAlert = UIAlertController(title: "팀해산", message: "참가중인 대회가 존재합니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }else {
                                let myAlert = UIAlertController(title: "팀해산", message: "에러가 발생했습니다 잠시후 다시 시도해주세요", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: "아니오", style: UIAlertActionStyle.cancel, handler: nil)
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func teamImageButton1Tapped(_ sender: Any) {
        i = 0
        setTeamImage()
    }
    @IBAction func teamImageButton2Tapped(_ sender: Any) {
        i = 1
        setTeamImage()
    }
    @IBAction func teamImageButton3Tapped(_ sender: Any) {
        i = 2
        setTeamImage()
    }
    func emblemTapped() {
        i = 3
        setTeamImage()
    }
    func setTeamImage() {
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
        
        let resetButton = UIAlertAction(title: "기본이미지로 변경", style: UIAlertActionStyle.default, handler: { (resetSeleted) -> Void in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated: true, completion: nil)
        })
        actionSheet.addAction(resetButton)
        
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: { (cancelSeleted) -> Void in
            
        })
        actionSheet.addAction(cancelButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (i == 3) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.teamEmblemImageView.image = image
                
                self.teamEmblemImage = UIImageJPEGRepresentation(image, 1)!
                uploadWithAlamofire("\(self.teamName)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                let url = "http://210.122.7.193:8080/Trophy_part3/TeamChangeImage.jsp?Data1=Emblem&Data2=\(teamName)&Data3=\(teamPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseJSON { (responseData) -> Void in}

            }else {
                print("error")
            }
            //myimage.backgroundColor = UIColor.clearColor()
            self.dismiss(animated: true, completion: nil)
        }else {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.teamImageButtonList[i].setImage(image, for: .normal)
                
                self.teamEmblemImage = UIImageJPEGRepresentation(image, 1)!
                let _teamName = ("\(self.teamName)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                uploadWithAlamofire(_teamName+String(i+1))
                let url = "http://210.122.7.193:8080/Trophy_part3/TeamChangeImage.jsp?Data1=Image\(String(i+1))&Data2=\(teamName+String(i+1))&Data3=\(teamPk)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseJSON { (responseData) -> Void in}

            }else {
                print("error")
            }
            //myimage.backgroundColor = UIColor.clearColor()
            self.dismiss(animated: true, completion: nil)
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
    
    func getTeamInfo() {
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamDetail.jsp?Data1=\(teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        self.teamName = dict["teamName"] as! String 
                        self.teamIntroduce = dict["teamIntroduce"] as! String
                        self.teamAddressDo = dict["teamAddressDo"] as! String
                        self.teamAddressSi = dict["teamAddressSi"] as! String
                        self.teamHomeCourt = dict["teamHomeCourt"] as! String
                        self.teamImage1 = dict["teamImage1"] as! String
                        self.teamImage2 = dict["teamImage2"] as! String
                        self.teamImage3 = dict["teamImage3"] as! String
                        self.teamEmblem = dict["teamEmblem"] as! String
                        
                        self.teamImageList = [self.teamImage1, self.teamImage2, self.teamImage3]
                        self.teamNameLabel.text = self.teamName
                        self.teamIntroTextView.text = self.teamIntroduce
                        self.teamAddressDoLabel.text = self.teamAddressDo
                        self.teamAddressSiLabel.text = self.teamAddressSi
                        self.teamHomeCourtLabel.text = self.teamHomeCourt
                        
                        if(self.teamEmblem != ".") {
                            let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.teamEmblem).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            Alamofire.request(url!).responseImage { response in
                                if let image = response.result.value {
                                    print ("image download : \(image)")
                                    DispatchQueue.main.async(execute: {
                                        //debugPrint(response)
                                        self.teamEmblemImageView.image = image
                                        self.teamEmblemImageView.reloadInputViews()
                                    });
                                }
                            }
                        }else {
                            self.teamEmblemImageView.image = UIImage(named: "ic_team")
                        }
                        
                        for i in 0 ..< 3 {
                            if (self.teamImageList[i] != ".") {
                                print("\(String(i)+self.teamImageList[i])")
                                let url = "http://210.122.7.193:8080/Trophy_img/team/\(self.teamImageList[i]).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                Alamofire.request(url!)
                                    .responseImage { response in
                                        DispatchQueue.main.async(execute: {
                                            if let image = response.result.value {
                                                self.teamImageButtonList[i].setImage(image, for: UIControlState.normal)
                                            }
                                        });
                                }
                            }else {
                                self.teamImageButtonList[i].setImage(UIImage(named: "ic_team"), for: UIControlState.normal)
                            }
                        }
                    }
                }
            }
        }
    }
}
