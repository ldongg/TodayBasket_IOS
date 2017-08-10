//
//  TeamUserDetailPopUpViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 3. 16..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TeamUserDetailPopUpViewController: UIViewController {
    
    @IBOutlet weak var teamUserProfileImageView: UIImageView!
    @IBOutlet weak var teamUserNameLabel: UILabel!
    @IBOutlet weak var teamUserAgeLabel: UILabel!
    @IBOutlet weak var teamUserSexLabel: UILabel!
    @IBOutlet weak var teamUserAddressDoLabel: UILabel!
    @IBOutlet weak var teamUserHWLabel: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    
    var teamUserName:String = ""
    var teamUserAge:String = ""
    var teamUserSex:String = ""
    var teamUserAddressDo:String = ""
    var teamUserAddressSi:String = ""
    var teamUserPhone:String = ""
    var teamUserProfile:String = ""
    var teamUserHeight:String = ""
    var teamUserWeight:String = ""
    var teamUserPosition:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.profileView.layer.cornerRadius = self.view.frame.size.width / 15
        self.profileView.layer.masksToBounds = true
        self.profileView.clipsToBounds = true
        
        teamUserNameLabel.text = "\(teamUserPosition). \(teamUserName)"
        teamUserAgeLabel.text = teamUserAge
        teamUserSexLabel.text = teamUserSex
        teamUserAddressDoLabel.text = "\(teamUserAddressDo) \(teamUserAddressSi)"
        teamUserHWLabel.text = "\(teamUserHeight) / \(teamUserWeight)"
        
        if(teamUserProfile != ".") {
            Alamofire.request("http://210.122.7.193:8080/Trophy_img/profile/\(teamUserProfile).jpg")
                .responseImage { response in
                    debugPrint(response.result)
                    DispatchQueue.main.async(execute: {
                        if let image = response.result.value {
                            debugPrint(response)
                            self.teamUserProfileImageView.image = image
                        }
                    });
            }
        }else {
            teamUserProfileImageView.image = UIImage(named: "user_basic")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.navigationController?.navigationBar.layer.zPosition = 0
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.view.removeFromSuperview()
    }
    

    
}
