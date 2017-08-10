//
//  ChangePersonalInfoViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 2. 22..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ChangePersonalInfoViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var addressDoLabel: UILabel!
    @IBOutlet weak var addressSiLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    
    var pw:String = ""
    
    var arrRes: [[String:AnyObject]] = []
    var Pk:String = UserDefaults.standard.string(forKey: "Pk")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/ChangePersonalInfo.jsp?Data1=\(Pk)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                let name:String = (self.arrRes[0]["Name"] as? String)!
                let phone:String = (self.arrRes[0]["Phone"] as? String)!
                self.pw = (self.arrRes[0]["Pw"] as? String)!
                let address_Do:String = (self.arrRes[0]["Do"] as? String)!
                let address_Si:String = (self.arrRes[0]["Si"] as? String)!
                let birth:String = (self.arrRes[0]["Birth"] as? String)!
                let sex:String = (self.arrRes[0]["Sex"] as? String)!
                let weight:String = (self.arrRes[0]["Weight"] as? String)!
                let height:String = (self.arrRes[0]["Height"] as? String)!
                let position:String = (self.arrRes[0]["Position"] as? String)!
                
                self.nameLabel.text = name
                self.phoneLabel.text = phone
                self.addressDoLabel.text = address_Do
                self.addressSiLabel.text = address_Si
                self.birthLabel.text = birth
                self.weightLabel.text = weight
                self.heightLabel.text = height
                self.positionLabel.text = position
                
                if (sex == "W") {
                    self.sexLabel.text = "여자"
                }else {
                    self.sexLabel.text = "남자"
                }
                
                
                Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(self.Pk).jpg")
                    .responseImage { response in
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            // Store the commit date in to our cache
                            // Update the cell
                            DispatchQueue.main.async(execute: {
                                self.profileImageView.image = image
                            });
                        }
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        if(segue.identifier == "goChangePassword") {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ChangePasswordViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            
            ChangePasswordViewController.currentPassword = pw
        }
    }
}
