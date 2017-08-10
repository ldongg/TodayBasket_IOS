//
//  CourtFeedUpdateViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 5. 10..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CourtFeedUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var courtFeedTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedImageDeleteButton: UIButton!
    
    
    
    @IBOutlet weak var keyboardToolBar: UIView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollviewBottomConstraint: NSLayoutConstraint!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var arrRes = [[String:AnyObject]]()
    
    var userPk:String = ""
    var courtPk:String = ""
    
    var userName:String = ""
    var userProfile:String = ""
    
    var currentDate:String = ""
    var todayDate:String = ""
    var courtFeedContent:String = ""
    var feedImage:Data? = nil
    var feedImageHeight:String = "."
    var feedImageWidth:String = "."
    
    let dateformatter = DateFormatter()
    let todayDateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courtFeedTextView.delegate = self
        courtFeedTextView.text = "몇시에 몇명이서 오실껀가요?"
        courtFeedTextView.textColor = UIColor.lightGray
        
        feedImageDeleteButton.isHidden = true
        
        dateformatter.dateFormat = "yyyy / MM / dd:::HH : mm"
        todayDateFormatter.dateFormat = "yyyy / MM / dd"
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        courtPk = UserDefaults.standard.string(forKey: "courtPk")!
        
        NotificationCenter.default.addObserver(self, selector: #selector(CourtFeedUpdateViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CourtFeedUpdateViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CourtFeedUpdateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo.jsp?Data1=\(userPk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if(self.arrRes.count > 0) {
                    self.userName = self.arrRes[0]["Name"] as! String
                    self.userProfile = self.arrRes[0]["Profile"] as! String
                    
                    if (self.userProfile != ".") {
                        let url = "http://210.122.7.193:8080/Trophy_img/profile/\(self.userProfile).jpg"
                        
                        Alamofire.request(url).responseImage { response in
                            if let image = response.result.value {
                                self.userProfileImageView.image = image
                            }
                        }
                    }else {
                        self.userProfileImageView.image = UIImage(named: "user_basic")
                    }
                    self.userNameLabel.text = self.userName
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollviewBottomConstraint.constant = 40
        self.keyboardBottomConstraint.constant = 0
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width - 16, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        let rect = NSString(string: textView.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        textViewHeightConstraint.constant = rect.height + 20
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollviewBottomConstraint.constant += keyboardSize.height
            self.keyboardBottomConstraint.constant += keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollviewBottomConstraint.constant -= keyboardSize.height
            self.keyboardBottomConstraint.constant -= keyboardSize.height
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if courtFeedTextView.textColor == UIColor.lightGray {
            courtFeedTextView.text = nil
            courtFeedTextView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if courtFeedTextView.text.isEmpty {
            courtFeedTextView.text = "몇시에 몇명이서 오실껀가요?"
            courtFeedTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func feedImageDeleteButtonTapped(_ sender: Any) {
        feedImageView.image = nil
        imageViewHeightConstraint.constant = 0
        feedImageDeleteButton.isHidden = true
        feedImage = nil
        feedImageHeight = "."
        feedImageWidth = "."
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            feedImageView.image = image
            
            feedImageDeleteButton.isHidden = false
            let height:Double = Double(image.size.height)
            let width:Double = Double(image.size.width)
            feedImageHeight = String(describing: image.size.height)
            feedImageWidth = String(describing: image.size.width)
            
            imageViewHeightConstraint.constant = CGFloat((Double(self.view.frame.width) * height) / width)
            
            feedImage = UIImageJPEGRepresentation(image, 0.5)
            
//            let url = "http://210.122.7.193:8080/Trophy_part3/ChangeProfileImage.jsp?Data1=\(Pk)&Data2=\(Pk)"
//            Alamofire.request(url).responseJSON { (responseData) -> Void in
//                if((responseData.result.value) != nil) {
//                    self.uploadWithAlamofire(self.Pk)
//                }
//            }
        }else {
            print("error")
        }
        //myimage.backgroundColor = UIColor.clearColor()
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let date:NSDate = NSDate()
        currentDate = dateformatter.string(from: date as Date)
        todayDate = todayDateFormatter.string(from: date as Date)
        courtFeedContent = courtFeedTextView.text
        
        var url = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if(courtFeedContent == "") {
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let myAlert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }else {
            url = "http://210.122.7.193:8080/Trophy_part3/CourtFeedUpdate.jsp?Data1=\(userPk)&Data2=\(courtPk)&Data3=\(currentDate)&Data4=\(courtFeedContent)&Data5=\(todayDate)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            Alamofire.request(url!).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    print(swiftyJsonVar)
                    if let resData = swiftyJsonVar["List"].arrayObject {
                        self.arrRes = resData as! [[String:AnyObject]]
                    }
                    if(self.arrRes.count > 0) {
                        if(self.arrRes[0]["msg1"] as! String == "succed") {
                            if(self.feedImage == nil) {
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                self.dismiss(animated: true, completion: nil)
                            }else {
                                let feedPk_:String = self.arrRes[0]["msg2"] as! String
                                url = "http://210.122.7.193:8080/TodayBasket_IOS/CourtFeedImageUpload.jsp?Data1=\(feedPk_)&Data2=\(self.feedImageWidth)&Data3=\(self.feedImageHeight)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                Alamofire.request(url!).responseJSON { (responseData) -> Void in
                                    if((responseData.result.value) != nil) {
                                        let swiftyJsonVar = JSON(responseData.result.value!)
                                        print(swiftyJsonVar)
                                        if let resData = swiftyJsonVar["List"].arrayObject {
                                            self.arrRes = resData as! [[String:AnyObject]]
                                        }
                                        if(self.arrRes.count > 0) {
                                            if(self.arrRes[0]["msg1"] as! String == "succed") {
                                                Alamofire.upload(multipartFormData: { multipartFormData in
                                                    multipartFormData.append(self.feedImage!, withName: "file" , fileName: "\(feedPk_).jpg", mimeType: "image/jpg")},
                                                                 to: "http://210.122.7.193:8080/Trophy_part3/feedImageUpload.jsp",
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
                                                                            
                                                                            self?.activityIndicator.stopAnimating()
                                                                            UIApplication.shared.endIgnoringInteractionEvents()
                                                                            
                                                                            self?.dismiss(animated: true, completion: nil)
                                                                        }
                                                                    case .failure(let encodingError):
                                                                        print("error:\(encodingError)")
                                                                        
                                                                        self.activityIndicator.stopAnimating()
                                                                        UIApplication.shared.endIgnoringInteractionEvents()
                                                                        
                                                                        self.dismiss(animated: true, completion: nil)
                                                                    }
                                                })
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
