//
//  CourtIntroUpdateViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 5. 8..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CourtIntroUpdateViewController: UIViewController {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var courtIntroTextView: UITextView!

    var arrRes = [[String:AnyObject]]()
    
    var userPk:String = ""
    var courtPk:String = ""
    
    var userName:String = ""
    var userProfile:String = ""
    
    var currentDate:String = ""
    var courtIntroContent:String = ""
    
    let dateformatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courtIntroTextView.delegate = self
        courtIntroTextView.text = "간단한 코트소개를 입력해 주세요"
        courtIntroTextView.textColor = UIColor.lightGray

        dateformatter.dateFormat = "yyyy / MM / dd"
        userPk = UserDefaults.standard.string(forKey: "Pk")!
        courtPk = UserDefaults.standard.string(forKey: "courtPk")!
        
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
                        Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(self.userProfile).jpg")
                            .responseImage { response in
                                if let image = response.result.value {
                                    DispatchQueue.main.async(execute: {
                                        self.userProfileImageView.image = image
                                    });
                                }
                        }
                    }
                    self.userNameLabel.text = self.userName
                }
            }
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if courtIntroTextView.textColor == UIColor.lightGray {
            courtIntroTextView.text = nil
            courtIntroTextView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if courtIntroTextView.text.isEmpty {
            courtIntroTextView.text = "간단한 코트소개를 입력해 주세요"
            courtIntroTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        let date:NSDate = NSDate()
        currentDate = dateformatter.string(from: date as Date)
        courtIntroContent = courtIntroTextView.text
        
        print("currentDate = \(currentDate)")
        print("courtFeedContent = \(courtIntroContent)")
        
        let url = "http://210.122.7.193:8080/Trophy_part3/CourtIntroUpdate.jsp?Data1=\(courtPk)&Data2=\(currentDate)&Data3=\(userPk)&Data4=\(courtIntroContent)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(String(describing: courtIntroTextView.text))
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if(self.arrRes.count > 0) {
                    
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
