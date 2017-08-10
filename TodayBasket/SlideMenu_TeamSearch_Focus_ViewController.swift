//
//  SlideMenu_TeamSearch_Focus_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 10..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamSearch_Focus_ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var TeamSearch_Focus_Image1: UIImageView!
    @IBOutlet weak var TeamSearch_Focus_Image3: UIImageView!
    @IBOutlet weak var TeamSearch_Focus_Image2: UIImageView!
    @IBOutlet weak var TeamSearch_Focus_Introduce: UILabel!
    @IBOutlet weak var TeamSearch_Focus_Scroll: UIScrollView!
    @IBOutlet weak var TeamSearch_Focus_PlayerTable: UITableView!
    @IBOutlet weak var TeamSearch_Focus_HomeCourt: UILabel!
    @IBOutlet weak var TeamSearch_Focus_TeamAddress: UILabel!
    @IBOutlet weak var TeamSearch_Focus_TeamName: UILabel!
    
    var Pk: String = "."
    var HttpStatue: String = "start"
    var teamname : String = ""
    var TeamName = [String]()
    var TeamAddress_Do = [String]()
    var TeamAddress_Se = [String]()
    var HomeCourt = [String]()
    var Introduce = [String]()
    var Emblem = [String]()
    var Image1 = [String]()
    var Image2 = [String]()
    var Image3 = [String]()
    
    
    var Http_Player_Profile = [String]()
    var Http_Player_Name = [String]()
    var Http_Player_Pk = [String]()
    
    var Http_Team_OverLap = [String]()
    var Http_Team_Join = [String]()
    
    var Player_Count : Int = 0
    var Player_ExtraCount : Int = 0
    
    func preview (){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TeamSearch_Focus_PlayerTable.dataSource = self
        TeamSearch_Focus_PlayerTable.delegate = self
        TeamSearch_Focus_Scroll.contentSize.height=2000
        
        Pk = UserDefaults.standard.string(forKey: "Pk")!
        
        //http 통신
//        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamSearch_Focus.jsp")!)
//        let parameterString = "Data1="+teamname
//        
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
//            
//            do{
//                let apiDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
//                let list = apiDictionary["List"] as! NSArray
//                for row in list{
//                    self.TeamName.append((row["msg1"] as? String)!)
//                    self.TeamAddress_Do.append((row["msg2"] as? String)!)
//                    self.TeamAddress_Se.append((row["msg3"] as? String)!)
//                    self.HomeCourt.append((row["msg4"] as? String)!)
//                    self.Introduce.append((row["msg5"] as? String)!)
//                    self.Emblem.append((row["msg6"] as? String)!)
//                    self.Image1.append((row["msg7"] as? String)!)
//                    self.Image2.append((row["msg8"] as? String)!)
//                    self.Image3.append((row["msg9"] as? String)!)
//                }
//            }catch{
//                
//            }
//            self.TeamSearch_Focus_TeamName.text = self.TeamName[0]
//            self.TeamSearch_Focus_TeamAddress.text = self.TeamAddress_Do[0] + " " + self.TeamAddress_Se[0]
//            self.TeamSearch_Focus_HomeCourt.text = self.HomeCourt[0]
//            self.TeamSearch_Focus_Introduce.text = self.Introduce[0]
//            if self.Image1[0] == "."
//            {
//                self.TeamSearch_Focus_Image1.isHidden = true
//            }
//            else{
//                let ContestUrlString1 = "http://210.122.7.193:8080/Trophy_img/team/"+self.Image1[0]+".jpg"
//                let ContestUrl1 = URL(string: ContestUrlString1)
//                if ContestUrl1 != nil {
//                    let request = URLRequest(url: ContestUrl1!)
//                    let session = URLSession.shared
//                    let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            self.TeamSearch_Focus_Image1.image = UIImage(data: data!)
//                        })
//                    })
//                    
//                    dataTask.resume()
//                }
//            }
//            if self.Image2[0] == "."
//            {
//                self.TeamSearch_Focus_Image2.isHidden = true
//            }
//            else{
//                let ContestUrlString2 = "http://210.122.7.193:8080/Trophy_img/team/"+self.Image2[0]+".jpg"
//                let ContestUrl2 = URL(string: ContestUrlString2)
//                if ContestUrl2 != nil {
//                    let request = URLRequest(url: ContestUrl2!)
//                    let session = URLSession.shared
//                    let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            self.TeamSearch_Focus_Image2.image = UIImage(data: data!)
//                        })
//                    })
//                    
//                    dataTask.resume()
//                }
//
//            }
//            if self.Image3[0] == "."
//            {
//                self.TeamSearch_Focus_Image3.isHidden = true
//            }
//            else{
//                let ContestUrlString3 = "http://210.122.7.193:8080/Trophy_img/team/"+self.Image3[0]+".jpg"
//                let ContestUrl3 = URL(string: ContestUrlString3)
//                if ContestUrl3 != nil {
//                    let request = URLRequest(url: ContestUrl3!)
//                    let session = URLSession.shared
//                    let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            self.TeamSearch_Focus_Image3.image = UIImage(data: data!)
//                        })
//                    })
//                    
//                    dataTask.resume()
//                }
//            }
//            self.view.setNeedsDisplay()
//        })
//        task.resume()
////팀원 http
//        let request2 = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_Player.jsp")!)
//        let parameterString2 = "Data1="+teamname
//        request2.httpMethod = "POST"
//        request2.httpBody = parameterString2.data(using: String.Encoding.utf8)
//        let task2 = URLSession.shared.dataTask(with: request2, completionHandler: {
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
//                        self.TeamSearch_Focus_PlayerTable.reloadData()
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
//        })
//        task2.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Player_ExtraCount = Player_Count%3
        var RowCount : Int = Player_Count/3
        if Player_ExtraCount == 1 {
            RowCount += 1
        }
        else if Player_ExtraCount == 2{
            RowCount += 1
        }
        else{
            
        }
        return RowCount
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if HttpStatue == "end"{
            cell = tableView.dequeueReusableCell(withIdentifier: "Player_3PersonCell", for: indexPath)
            let Player1Image = cell.viewWithTag(1) as! UIImageView
            let Player2Image = cell.viewWithTag(2) as! UIImageView
            let Player3Image = cell.viewWithTag(3) as! UIImageView
            let Player1Label = cell.viewWithTag(4) as! UILabel
            let Player2Label = cell.viewWithTag(5) as! UILabel
            let Player3Label = cell.viewWithTag(6) as! UILabel
            
            Player1Label.isHidden = false
            Player2Label.isHidden = false
            Player3Label.isHidden = false
            
            
            Player1Image.isUserInteractionEnabled = true
            Player1Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "Player_Image1_ImageView_Action:"))
            
            let ContestUrlString1 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
            let ContestUrl1 = URL(string: ContestUrlString1)
            if ContestUrl1 != nil {
                let request = URLRequest(url: ContestUrl1!)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        Player1Image.image = UIImage(data: data!)
                    })
                } as! (Data?, URLResponse?, Error?) -> Void)
                
                dataTask.resume()
            }
            let ContestUrlString2 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
            let ContestUrl2 = URL(string: ContestUrlString2)
            if ContestUrl2 != nil {
                let request = URLRequest(url: ContestUrl2!)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        //                            Player2Image.image = UIImage(data: data!)
                    })
                } as! (Data?, URLResponse?, Error?) -> Void)
                
                dataTask.resume()
            }
            let ContestUrlString3 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
            let ContestUrl3 = URL(string: ContestUrlString3)
            if ContestUrl3 != nil {
                let request = URLRequest(url: ContestUrl3!)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        //                            Player3Image.image = UIImage(data: data!)
                    })
                } as! (Data?, URLResponse?, Error?) -> Void)
                dataTask.resume()
            }
            if self.Http_Player_Name[indexPath.row*3+1] == "."{
                Player1Label.text = self.Http_Player_Name[indexPath.row*3]
                Player1Label.isHidden = false
                Player2Label.isHidden = true
                Player3Label.isHidden = true
            }
            if self.Http_Player_Name[indexPath.row*3+2] == "."{
                Player1Label.text = self.Http_Player_Name[indexPath.row*3]
                Player2Label.text = self.Http_Player_Name[indexPath.row*3+1]
                Player1Label.isHidden = false
                Player2Label.isHidden = false
                Player3Label.isHidden = true
            }
            else{
                Player1Label.text = self.Http_Player_Name[indexPath.row*3]
                Player2Label.text = self.Http_Player_Name[indexPath.row*3+1]
                Player3Label.text = self.Http_Player_Name[indexPath.row*3+2]
                Player1Label.isHidden = false
                Player2Label.isHidden = false
                Player3Label.isHidden = false
            }
            return cell
        }
        else{
                cell = tableView.dequeueReusableCell(withIdentifier: "PlayerManager_Player_3PersonCell", for: indexPath)
                let Player1Image = cell.viewWithTag(1) as! UIImageView
                let Player2Image = cell.viewWithTag(2) as! UIImageView
                let Player3Image = cell.viewWithTag(3) as! UIImageView
                let Player1Label = cell.viewWithTag(4) as! UILabel
                let Player2Label = cell.viewWithTag(5) as! UILabel
                let Player3Label = cell.viewWithTag(6) as! UILabel
                Player1Label.text = " "
                Player2Label.text = " "
                Player3Label.text = " "
            return cell
        }
    }
    @IBAction func Join_Button_Action(_ sender: AnyObject) {
        if Pk == "."{
            let alert_Join_Login = UIAlertController(title: "확인", message: "팀 가입시 로그인이 필요합니다.", preferredStyle: .alert)
            let alert_Join_Login_Ok = UIAlertAction(title: "로그인 하기", style: .default, handler: {(action:UIAlertAction) in
                let move = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                move?.reloadInputViews()
                self.present(move!, animated: true, completion: nil)
            
            })
            let alert_Join_Login_Cancel = UIAlertAction(title: "취소", style: .default, handler: {(action:UIAlertAction) in alert_Join_Login.dismiss(animated: true, completion: nil)})
            alert_Join_Login.addAction(alert_Join_Login_Ok)
            alert_Join_Login.addAction(alert_Join_Login_Cancel)
            DispatchQueue.main.async(execute: { self.present(alert_Join_Login, animated: true, completion: nil)})
        }
        else{
            //http 통신
//            let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamSearch_Focus_TeamJoin_OverLap.jsp")!)
//            
//            let parameterString = "Data1="+Pk
//            
//            request.httpMethod = "POST"
//            request.httpBody = parameterString.data(using: String.Encoding.utf8)
//            let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                data, response, error in
//                
//                if error != nil {
//                    return
//                }
//                print("response = \(response)")
//                
//                let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                print("responseString = \(responseString)")
//                
//                do{
//                    let apiDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
//                    let list = apiDictionary["List"] as! NSArray
//                    for row in list{
//                        self.Http_Team_OverLap.append((row["msg1"] as? String)!)
//                    }
//                }catch{
//                    
//                }
//                if self.Http_Team_OverLap[0] == "overLap" {
//                    let alert_Join_OverLap = UIAlertController(title: "확인", message: "이미 다른 팀에 가입 중 이십니다.", preferredStyle: .alert)
//                    let alert_Join_Login_Cancel = UIAlertAction(title: "확인", style: .default, handler: {(action:UIAlertAction) in alert_Join_OverLap.dismiss(animated: true, completion: nil)})
//                    alert_Join_OverLap.addAction(alert_Join_Login_Cancel)
//                    DispatchQueue.main.async(execute: { self.present(alert_Join_OverLap, animated: true, completion: nil)})
//                }
//                else {
//                    //http 통신
//                    let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamSearch_Focus_Join.jsp")!)
//                    
//                    let parameterString = "Data1="+self.Pk+"&"+"Data2="+self.teamname
//                    
//                    request.httpMethod = "POST"
//                    request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                    let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                        data, response, error in
//                        
//                        if error != nil {
//                            return
//                        }
//                        print("response = \(response)")
//                        
//                        let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                        print("responseString = \(responseString)")
//                        
//                        do{
//                            let apiDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
//                            let list = apiDictionary["List"] as! NSArray
//                            for row in list{
//                                self.Http_Team_Join.append((row["msg1"] as? String)!)
//                            }
//                        }catch{
//                            
//                        }
//                        print(self.Http_Team_Join[0])
//                        if self.Http_Team_Join[0] == "succed" {
//                            let alert_Join_OverLap = UIAlertController(title: "확인", message: "가입 신청 완료.", preferredStyle: .alert)
//                            let alert_Join_Login_Cancel = UIAlertAction(title: "확인", style: .default, handler: {(action:UIAlertAction) in alert_Join_OverLap.dismiss(animated: true, completion: nil)})
//                            alert_Join_OverLap.addAction(alert_Join_Login_Cancel)
//                            DispatchQueue.main.async(execute: { self.present(alert_Join_OverLap, animated: true, completion: nil)})
//                        }
//                        else {
//                            let alert_Join_OverLap = UIAlertController(title: "확인", message: "해당 팀에 이미 신청중입니다.", preferredStyle: .alert)
//                            let alert_Join_Login_Cancel = UIAlertAction(title: "확인", style: .default, handler: {(action:UIAlertAction) in alert_Join_OverLap.dismiss(animated: true, completion: nil)})
//                            alert_Join_OverLap.addAction(alert_Join_Login_Cancel)
//                            DispatchQueue.main.async(execute: { self.present(alert_Join_OverLap, animated: true, completion: nil)})                        }
//                        
//                    })
//                    task.resume()
//                }
//
//            })
//            task.resume()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
