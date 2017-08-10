//
//  SlideMenu_TeamManager_PlayerManager_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 16..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamManager_PlayerManager_ViewController: UIViewController{
        override func viewDidLoad() {
        super.viewDidLoad()
//        Joiner_TableView.dataSource = self
//        Joiner_TableView.delegate = self
//        Player_TableView.dataSource = self
//        Player_TableView.delegate = self
        
        //////신청자 http//////////////////////
//        let request1 = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_Joiner.jsp")!)
//        let parameterString1 = "Data1="+TeamName
//        HttpStatue = "start"
//        request1.httpMethod = "POST"
//        request1.httpBody = parameterString1.data(using: String.Encoding.utf8)
//        let task1 = URLSession.shared.dataTask(with: request1, completionHandler: {
//            data, response, error in
//            
//            if error != nil {
//                return
//            }
//            print("response = \(response)")
//            
//            let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//            print("responseString = \(responseString)")
//            do{
//                let apiDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
//                let list = apiDictionary["List"] as! NSArray
//                for row in list{
//                    self.Http_Joiner_Profile.append((row["msg1"] as? String)!)
//                    self.Http_Joiner_Name.append((row["msg2"] as? String)!)
//                    self.Http_Joiner_Pk.append((row["msg3"] as? String)!)
//                    self.Joiner_Count++
//                    DispatchQueue.main.async {
//                        self.Joiner_TableView.reloadData()
//                    }
//                }
//            }catch{
//                
//            }
//            print(self.Joiner_Count)
//            if self.Joiner_Count%3 == 1 {
//                self.Http_Joiner_Profile.append(".")
//                self.Http_Joiner_Name.append(".")
//                self.Http_Joiner_Pk.append(".")
//                self.Http_Joiner_Profile.append(".")
//                self.Http_Joiner_Name.append(".")
//                self.Http_Joiner_Pk.append(".")
//                
//            }
//            else if self.Joiner_Count%3 == 2 {
//                self.Http_Joiner_Profile.append(".")
//                self.Http_Joiner_Name.append(".")
//                self.Http_Joiner_Pk.append(".")
//            }
//        })
//        task1.resume()
//////////////////팀원 http
//        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_Player.jsp")!)
//        let parameterString = "Data1="+TeamName
//        request.httpMethod = "POST"
//        request.httpBody = parameterString.data(using: String.Encoding.utf8)
//        let task = URLSession.shared.dataTask(with: request, completionHandler: {
//            data, response, error in
//            
//            if error != nil {
//                return
//            }
//            print("response = \(response)")
//            
//            let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//            print("responseString = \(responseString)")
//            do{
//                let apiDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
//                let list = apiDictionary["List"] as! NSArray
//                for row in list{
//                    self.Http_Player_Profile.append((row["msg1"] as? String)!)
//                    self.Http_Player_Name.append((row["msg2"] as? String)!)
//                    self.Http_Player_Pk.append((row["msg3"] as? String)!)
//                    self.Player_Count++
//                    DispatchQueue.main.async {
//                        self.Player_TableView.reloadData()
//                    }
//                }
//            }catch{
//                
//            }
//            print(self.Player_Count)
//            if self.Player_Count%3 == 1 {
//                self.Http_Player_Profile.append(".")
//                self.Http_Player_Name.append(".")
//                self.Http_Player_Pk.append(".")
//                self.Http_Player_Profile.append(".")
//                self.Http_Player_Name.append(".")
//                self.Http_Player_Pk.append(".")
//
//            }
//            else if self.Player_Count%3 == 2 {
//                self.Http_Player_Profile.append(".")
//                self.Http_Player_Name.append(".")
//                self.Http_Player_Pk.append(".")
//            }
//            self.HttpStatue = "end"
//
//        })
//        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
