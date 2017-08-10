//
//  TeamDetailViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 9..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Cosmos

class TeamDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamAddressLabel: UILabel!
    @IBOutlet weak var teamHomeCourtLabel: UILabel!
    @IBOutlet weak var teamIntroduceLabel: UITextView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var teamEmblemImageView: UIImageView!
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var teamUserCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var teamUserColletionView: UICollectionView!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var teamManageButton: UIButton!
    @IBOutlet weak var changeEmblemButton: UIButton!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var changeCourtButton: UIButton!
    @IBOutlet weak var changeIntroButton: UIButton!
    @IBOutlet weak var manageTeamUserButton: UIButton!
    
    @IBOutlet weak var matchResultTableView: UITableView!
    @IBOutlet weak var matchResultTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var confirmButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var teamRatingLabel: UILabel!
    
    @IBOutlet weak var open: UIBarButtonItem!
    
    var isMenu:Bool = false
    var isUserLoggedIn:Bool = false
    var isMyTeam:Bool = false
    var isMyTeamManager:Bool = false
    var userPk:String = ""
    
    var teamPk:String = ""
    
    var teamNameString:String = ""
    var teamIntroduceString:String = ""
    var teamAddressDoString:String = ""
    var teamAddressSiString:String = ""
    var teamHomeCourtString:String = ""
    var teamEmblemString:String = ""
    var teamImageString:String = ""
    
    var teamEmblemImage:Data? = nil
    var teamImage:Data? = nil
    
    var teamImageList:[String] = []
    var teamImageViewList:[UIImageView] = []
    var teamImageViewConstraintList:[NSLayoutConstraint] = []
    var collectionViewCellHeight = 120
    
    var teamImageURL = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    var teamEmblemURL = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

    var teamUsers = TeamUserSetting()
    var teamUserList:[TeamUserSetting] = []
    
    var matchSetting = MatchSetting()
    var matchResultList:[MatchSetting] = []
    
    var arrRes:[[String:AnyObject]] = []
    var userState:String = ""
    
    var manageMode:Bool = false
    var imageMode:String = "Emblem"
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        URLCache.shared.removeAllCachedResponses()
        
        cosmos.settings.fillMode = .precise
        
        teamManageButton.isHidden = true
        setButtonTitleForDuty()
        
        teamEmblemImageView.layer.cornerRadius = teamEmblemImageView.frame.size.width/2
        teamEmblemImageView.clipsToBounds = true
        
        teamUserColletionView.dataSource = self
        teamUserColletionView.delegate = self
        
        matchResultTableView.dataSource = self
        matchResultTableView.delegate = self
        
        
        matchResultTableViewHeightConstraint.constant = 70
        teamUserCollectionViewHeightConstraint.constant = 120
        
        if(isMenu == false) {
            self.navigationItem.leftBarButtonItem = nil
        }else {
            self.navigationItem.leftBarButtonItem = open
        }
        
        // drawer menu 설정
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.changeEmblemButton.isHidden = true
        self.changeImageButton.isHidden = true
        self.changeAddressButton.isHidden = true
        self.changeCourtButton.isHidden = true
        self.changeIntroButton.isHidden = true
        self.manageTeamUserButton.isHidden = true
        
        
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
                        
                        self.teamNameString = dict["teamName"] as! String
                        self.teamIntroduceString = dict["teamIntroduce"] as! String
                        self.teamAddressDoString = dict["teamAddressDo"] as! String
                        self.teamAddressSiString = dict["teamAddressSi"] as! String
                        self.teamHomeCourtString = dict["teamHomeCourt"] as! String
                        self.teamEmblemString = dict["teamEmblem"] as! String
                        self.teamImageString = dict["teamImage1"] as! String
                        
                        self.teamNameLabel.text = self.teamNameString
                        self.teamIntroduceLabel.text = self.teamIntroduceString
                        self.teamAddressLabel.text = "\(self.teamAddressDoString) \(self.teamAddressSiString)"
                        self.teamHomeCourtLabel.text = self.teamHomeCourtString
                        
                        if(self.teamEmblemString != ".") {
                            self.teamEmblemURL = "http://210.122.7.193:8080/Trophy_img/team/\(self.teamEmblemString).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            Alamofire.request(self.teamEmblemURL!).responseImage { response in
                                if let image = response.result.value {
                                    self.teamEmblemImageView.image = image
                                }
                            }
                        }else {
                            self.teamEmblemImageView.image = UIImage(named: "ic_team")
                        }
                        
                        if(self.teamImageString != ".") {
                            self.teamImageURL = "http://210.122.7.193:8080/Trophy_img/team/\(self.teamImageString).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            
                            Alamofire.request(self.teamImageURL!).responseImage { response in
                                if let image = response.result.value {
                                    self.teamImageView.image = image
                                }
                            }
                        }
                        
                        let size = CGSize(width: self.view.frame.width, height: 1000)
                        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
                        let rect = NSString(string: self.teamIntroduceString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                        self.textViewHeightConstraint.constant = rect.height + 20

                    }
                }
            }
        }
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamGrade.jsp?Data1=\(teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        if(dict["msg1"] as! String != "NaN") {
                            self.cosmos.rating = Double(dict["msg1"] as! String)!
                            self.teamRatingLabel.text = dict["msg1"] as? String
                        }else {
                            self.cosmos.rating = 0
                            self.teamRatingLabel.text = "0"
                        }
                        
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTeamUsers()
        getMatchResults()
        
    }
    
    @IBAction func changeTeamEmblemButtonTapped(_ sender: Any) {
        imageMode = "Emblem"
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
    
    @IBAction func changeTeamImageButtonTapped(_ sender: Any) {
        imageMode = "Image"
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
            if(imageMode == "Emblem") {
                teamEmblemImageView.image = image
                teamEmblemImage = UIImageJPEGRepresentation(image, 0.5)
                
                let url = "http://210.122.7.193:8080/TodayBasket_IOS/TeamImageQueryUpload.jsp?Data1=\(teamNameString)&Data2=\(teamNameString)&Data3=Emblem".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        self.uploadWithAlamofire(self.teamNameString)
                    }
                }
            }else {
                teamImageView.image = image
                teamImageView.af_cancelImageRequest()
                teamImage = UIImageJPEGRepresentation(image, 0.5)
                
                let url = "http://210.122.7.193:8080/TodayBasket_IOS/TeamImageQueryUpload.jsp?Data1=\(teamNameString)&Data2=\(teamNameString)1&Data3=Image1".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        self.uploadWithAlamofire("\(self.teamNameString)1")
                    }
                }
            }
        }else {
            print("error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadWithAlamofire(_ fileName:String) {
        var image:Data? = nil
        if(imageMode == "Emblem") {
            image = self.teamEmblemImage
        }else {
            image = self.teamImage
        }
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image!, withName: "file" , fileName: "\(fileName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!).jpg", mimeType: "image/jpg")},
                         to: "http://210.122.7.193:8080/TodayBasket_IOS/TeamImageUpload.jsp",
                         method: .post,
                         headers: ["Authorization": "auth_token"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.response { [weak self] response in
                                    guard self != nil else {
                                        return
                                    }
                                    debugPrint(response)
                                }
                            case .failure(let encodingError):
                                print("==========error:\(encodingError)===========")
                            }
        })
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.teamUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamUserCell", for: indexPath) as UICollectionViewCell
        
        
        let teamUserImageView = cell.viewWithTag(1) as! UIImageView
        let teamUserNameLabel = cell.viewWithTag(2) as! UILabel
        
        teamUserImageView.layer.cornerRadius = teamUserImageView.frame.size.width/5
        teamUserImageView.clipsToBounds = true
        
        if(teamUserList[indexPath.row].userImage != ".") {
            let url = "http://210.122.7.193:8080/Trophy_img/profile/\(teamUserList[indexPath.row].userImage).jpg"
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    teamUserImageView.image = image
                }
            }
        }else {
            teamUserImageView.image = UIImage(named: "user_basic")
        }
        teamUserNameLabel.text = "\(teamUserList[indexPath.row].userPosition). \(teamUserList[indexPath.row].userName)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(view.frame.size.width/4), height: CGFloat(collectionViewCellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! TeamUserDetailPopUpViewController
        
        popOverVC.teamUserName = teamUserList[indexPath.row].userName
        popOverVC.teamUserAge = teamUserList[indexPath.row].userBirth
        popOverVC.teamUserSex = teamUserList[indexPath.row].userSex
        popOverVC.teamUserAddressDo = teamUserList[indexPath.row].userAddressDo
        popOverVC.teamUserAddressSi = teamUserList[indexPath.row].userAddressSi
        popOverVC.teamUserPhone = teamUserList[indexPath.row].userPhone
        popOverVC.teamUserProfile = teamUserList[indexPath.row].userImage
        popOverVC.teamUserHeight = teamUserList[indexPath.row].userHeight
        popOverVC.teamUserWeight = teamUserList[indexPath.row].userWeight
        popOverVC.teamUserPosition = teamUserList[indexPath.row].userPosition
        
        self.navigationController?.navigationBar.layer.zPosition = -1
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.addChildViewController(popOverVC)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchResultCell")
        
        let homeTeamEmblemImageView = cell?.viewWithTag(1) as! UIImageView
        let homeTeamNameLabel = cell?.viewWithTag(2) as! UILabel
        let homeTeamScoreLabel = cell?.viewWithTag(3) as! UILabel
        let awayTeamEmblemImageView = cell?.viewWithTag(4) as! UIImageView
        let awayTeamNameLabel = cell?.viewWithTag(5) as! UILabel
        let awayTeamScoreLabel = cell?.viewWithTag(6) as! UILabel
        let matchTimeLabel = cell?.viewWithTag(7) as! UILabel
        let matchDateLabel = cell?.viewWithTag(8) as! UILabel
        let matchPlaceLabel = cell?.viewWithTag(9) as! UILabel
        let matchStatusLabel = cell?.viewWithTag(10) as! UILabel
        
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
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        setButtonTitleForDuty()
        
        if(userState == "isMyTeamManager") { // 팀 해산
            let myAlert = UIAlertController(title: nil, message: "팀해산을 진행하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "아니요", style: UIAlertActionStyle.cancel, handler: nil)
            myAlert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { action in
                self.startAnimating()
                
                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamDetailDisperse.jsp?Data1=\(self.userPk)&Data2=\(self.teamPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            print("\(self.arrRes)")
                            var dict = self.arrRes[0]
                            if((dict["msg1"] as! String) == "Exist_Player") { // 팀원 존재할시
                                self.finishAnimating()
                                
                                let myAlert = UIAlertController(title: nil, message: "가입중인 팀원이 존재할 경우 팀해산이 불가능합니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }else if ((dict["msg1"] as! String) == "Exist_Joiner") { // 참가 신청중 인원 존재할시
                                self.finishAnimating()
                                
                                let myAlert = UIAlertController(title: nil, message: "참가신청중인 인원이 존재할 경우 팀해산이 불가능합니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }else if ((dict["msg1"] as! String) == "succed") {
                                self.finishAnimating()
                                
                                let myAlert = UIAlertController(title: nil, message: "팀해산이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.default, handler: { action in
                                    let revealViewController:SWRevealViewController = self.revealViewController()
                                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let desController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController")
                                    let newFrontViewController = UINavigationController.init(rootViewController:desController)
                                    revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                                })
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            
            
        }else if(userState == "isMyTeam") { // 팀 탈퇴
            let myAlert = UIAlertController(title: nil, message: "팀에서 탈퇴하겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
            myAlert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                self.startAnimating()
                
                self.userPk = UserDefaults.standard.string(forKey: "Pk")!
                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamDetailJoinCancel.jsp?Data1=\(self.userPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            
                            var dict = self.arrRes[0]
                            if(dict["msg1"] as! String == "succed") {
                                
                                // refresh
                                self.finishAnimating()
                                let myAlert = UIAlertController(title: nil, message: "팀 탈퇴가 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                    self.setButtonTitleForDuty()
                                    self.getTeamUsers()
                                })
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }else if (userState == "notJoinTeam") { // 가입 신청
            let myAlert = UIAlertController(title: nil, message: "가입신청 하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
            myAlert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                self.startAnimating()
                
                self.userPk = UserDefaults.standard.string(forKey: "Pk")!
                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamDetailJoinRequest.jsp?Data1=\(self.userPk)&Data2=\(self.teamPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            
                            var dict = self.arrRes[0]
                            if(dict["msg1"] as! String == "succed") {
                                // 팀 대표에게 가입신청 하였다고 푸쉬 알람
                                let teamCapPk:String = dict["msg2"] as! String
                                let userName:String = dict["msg3"] as! String
                                let url = "http://210.122.7.193:8080/TodayBasket_manager/push.jsp?Data1=\(teamCapPk)&Data2=\(userName)님이 \(self.teamNameString)팀에 가입신청 하였습니다".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                    if((responseData.result.value) != nil) {
                                    }
                                }
                                // refresh
                                self.finishAnimating()
                                let myAlert = UIAlertController(title: nil, message: "가입신청이 완료되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                    self.setButtonTitleForDuty()
                                })
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }else if (userState == "waiting") { // 신청 취소
            let myAlert = UIAlertController(title: nil, message: "가입신청을 취소하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
            myAlert.addAction(cancelAction)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                self.startAnimating()
                
                self.userPk = UserDefaults.standard.string(forKey: "Pk")!
                Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/TeamDetailJoinCancel.jsp?Data1=\(self.userPk)").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        
                        if let resData = swiftyJsonVar["List"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            
                            var dict = self.arrRes[0]
                            if(dict["msg1"] as! String == "succed") {
                                
                                // refresh
                                self.finishAnimating()
                                let myAlert = UIAlertController(title: nil, message: "가입신청이 취소되었습니다", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { action in
                                    self.setButtonTitleForDuty()
                                    self.getTeamUsers()
                                })
                                myAlert.addAction(okAction)
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    func setButtonTitleForDuty() {
        isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(isUserLoggedIn) {
            userPk = UserDefaults.standard.string(forKey: "Pk")!
            Alamofire.request("http://210.122.7.193:8080/Trophy_part3/isMyTeam.jsp?Data1=\(userPk)&Data2=\(teamPk)").responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                        print("\(self.arrRes)")
                        var dict = self.arrRes[0]
                        if((dict["isMyTeam"] as! String) == "isMyTeamManager") { //팀대표일시
                            self.userState = "isMyTeamManager"
                            self.teamManageButton.isHidden = false
                            self.confirmButton.isEnabled = true
                            self.confirmButton.backgroundColor = UIColor(red: 255.0/255.0, green: 181.0/255.0, blue: 84.0/255.0, alpha: 1.0)
                            self.confirmButton.setTitle("팀해산", for: .normal)
                        }else if ((dict["isMyTeam"] as! String) == "isMyTeam") { //팀원일시
                            self.userState = "isMyTeam"
                            self.confirmButtonHeightConstraint.constant = 40
                            self.confirmButton.isEnabled = true
                            self.confirmButton.backgroundColor = UIColor(red: 255.0/255.0, green: 181.0/255.0, blue: 84.0/255.0, alpha: 1.0)
                            self.confirmButton.setTitle("팀탈퇴", for: .normal)
                        }else if ((dict["isMyTeam"] as! String) == "waiting") { //신청중일시
                            self.userState = "waiting"
                            self.confirmButtonHeightConstraint.constant = 40
                            self.confirmButton.isEnabled = true
                            self.confirmButton.backgroundColor = UIColor(red: 255.0/255.0, green: 181.0/255.0, blue: 84.0/255.0, alpha: 1)
                            self.confirmButton.setTitle("신청취소", for: .normal)
                        }
                        else { //팀원이 아닐시
                            if((dict["isMyTeam"] as! String) == ".") { //가입된 팀이 없을시
                                self.userState = "notJoinTeam"
                                //경고 없애기
                                //버튼 레드 && enable true && 버튼 text : 가입신청
                                self.confirmButtonHeightConstraint.constant = 40
                                self.confirmButton.isEnabled = true
                                self.confirmButton.backgroundColor = UIColor(red: 255.0/255.0, green: 181.0/255.0, blue: 84.0/255.0, alpha: 1)
                                self.confirmButton.setTitle("가입신청", for: .normal)
                            }else {//가입된 다른 팀이 있을시
                                self.userState = "notMyTeam"
                            }
                        }
                    }
                }
            }
        }else { //로그인 안했을시
            userState = "notLoggedIn"
        }
    }


    func getTeamUsers() {
        //팀원정보 받아오기
        startAnimating()
        
        teamUserList = []
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamUserSearch.jsp?Data1=\(teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("\(self.arrRes)")
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        self.teamUsers = TeamUserSetting()
                        self.teamUsers.userPk = dict["_Pk"] as! String
                        self.teamUsers.userPhone = dict["_Phone"] as! String
                        self.teamUsers.userName = dict["_Name"] as! String
                        self.teamUsers.userTeamDuty = dict["_TeamDuty"] as! String
                        self.teamUsers.userBirth = dict["_Birth"] as! String
                        self.teamUsers.userAddressDo = dict["_AddressDo"] as! String
                        self.teamUsers.userAddressSi = dict["_AddressSi"] as! String
                        self.teamUsers.userSex = dict["_Sex"] as! String
                        self.teamUsers.userImage = dict["_Image"] as! String
                        self.teamUsers.userHeight = dict["_Height"] as! String
                        self.teamUsers.userWeight = dict["_Weight"] as! String
                        self.teamUsers.userPosition = dict["_Position"] as! String
                        self.teamUserList.append(self.teamUsers)
                    }
                    self.teamUserColletionView.reloadData()
                }
                self.teamUserCollectionViewHeightConstraint.constant = (CGFloat((self.teamUserList.count / 4) + 1)) * 120
                
                self.finishAnimating()
            }
        }
    }
    
    func getMatchResults() {
        startAnimating()
        
        self.matchResultList = []
        Alamofire.request("http://210.122.7.193:8080/TodayBasket_IOS/MatchResultTeam3.jsp?Data1=\(self.teamPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                print(self.teamPk)
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
                    
                    print("================= \(self.matchResultList.count) ==================")
                    if(self.matchResultList.count > 0 && self.matchResultList.count < 4) {
                        self.matchResultTableView.tableHeaderView?.frame.size.height = 0
                        self.matchResultTableView.tableHeaderView?.isHidden = true
                        self.matchResultTableViewHeightConstraint.constant = CGFloat(self.matchResultList.count * 100)
                    }
                    
                    self.matchResultTableView.reloadData()
                }
                self.finishAnimating()
            }
        }
    }
    
    @IBAction func teamMatchResultMoreButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func teamManageButtonTapped(_ sender: Any) {
        if(manageMode == false) {
            manageMode = true
            self.teamManageButton.setTitle("팀정보", for: UIControlState.normal)
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: { _ in
                self.confirmButtonHeightConstraint.constant = 40
                self.changeEmblemButton.isHidden = false
                self.changeImageButton.isHidden = false
                self.changeAddressButton.isHidden = false
                self.changeCourtButton.isHidden = false
                self.changeIntroButton.isHidden = false
                self.manageTeamUserButton.isHidden = false
            }, completion: nil)
            
        }else {
            manageMode = false
            self.teamManageButton.setTitle("팀관리", for: UIControlState.normal)
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: { _ in
                self.confirmButtonHeightConstraint.constant = 0
                self.changeEmblemButton.isHidden = true
                self.changeImageButton.isHidden = true
                self.changeAddressButton.isHidden = true
                self.changeCourtButton.isHidden = true
                self.changeIntroButton.isHidden = true
                self.manageTeamUserButton.isHidden = true
            }, completion: nil)
        }
    }
    
    func startAnimating() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func finishAnimating() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goResultDetail") {
            let matchResultDetailViewController = segue.destination as! MatchResultDetailViewController
            let myIndexPath = self.matchResultTableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            matchResultDetailViewController.matchPk = self.matchResultList[row].matchPk
        }else if(segue.identifier == "goMatchResultMore") {
            let matchResultTeamListVC = segue.destination as! MatchResultTeamListViewController
            matchResultTeamListVC.isTeamDetail = true
            matchResultTeamListVC.teamPk = self.teamPk
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
