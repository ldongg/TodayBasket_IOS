//
//  SlideMenu_TeamManager_ContestJoin_Focus_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 15..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamManager_ContestJoin_Focus_ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    var TeamName : String = ""
    var Contest_Pk : String = ""
    var Contest_Image : String = ""
    var Contest_Title : String = ""
    var Contest_Status : String = ""
    var AcountName : String = ""
    var AcountNumber : String = ""
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var ContestImage_ImageView: UIImageView!
    @IBOutlet weak var ContestAcountNumber_Label: UILabel!
    @IBOutlet weak var ContestAcountName_Label: UILabel!
    @IBOutlet weak var ContestStatus_Label: UILabel!
    @IBOutlet weak var ContestName_Label: UILabel!
    @IBOutlet weak var ContestDetail: UILabel!
    @IBOutlet weak var ContestDate: UILabel!
    @IBOutlet weak var ContestJoinDate: UILabel!
    @IBOutlet weak var ContestRepresent_Phone_Label: UILabel!
    @IBOutlet weak var ContestRepresent_Label: UILabel!
    @IBOutlet weak var TeamName_Label: UILabel!
    @IBOutlet weak var Joiner_TableView: UITableView!
    
    var Http_ContestJoinDate_Start = [String]()
    var Http_ContestJoinDate_End = [String]()
    var Http_ContestDate = [String]()
    var Http_ContestDetail = [String]()
    var Http_ContestRepresent = [String]()
    var Http_ContestRepresent_Phone = [String]()
    
    var Http_Joiner_Name = [String]()
    var Http_Joiner_Date = [String]()
    var Http_Joiner_Profile = [String]()
    var Http_Joiner_Pk = [String]()
    var Http_Joiner_Duty = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Joiner_TableView.dataSource = self
        Joiner_TableView.delegate = self
        scroll.contentSize.height = 2000
        
        
//        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_ContestJoin_ContestFocus_ContestInfo.jsp")!)
//        let parameterString = "Data1="+Contest_Pk
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
//                    self.Http_ContestJoinDate_Start.append((row["msg1"] as? String)!)
//                    self.Http_ContestJoinDate_End.append((row["msg2"] as? String)!)
//                    self.Http_ContestDate.append((row["msg3"] as? String)!)
//                    self.Http_ContestDetail.append((row["msg4"] as? String)!)
//                }
//            }catch{
//                
//            }
//            
//        })
//        task.resume()
//////////////////////////////////////////////////////////////////////
//        let request2 = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_ContestJoin_ContestFocus_Represent.jsp")!)
//        let parameterString2 = "Data1="+TeamName
//        
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
//            
//            do{
//                let apiDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
//                let list = apiDictionary["List"] as! NSArray
//                for row in list{
//                    self.Http_ContestRepresent.append((row["msg1"] as? String)!)
//                    self.Http_ContestRepresent_Phone.append((row["msg2"] as? String)!)
//                }
//            }catch{
//                
//            }
//            
//        })
//        task2.resume()
    //////////////////////////////////////////////////////////////////////
//        let request3 = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_ContestJoin_ContestFocus_Joiner.jsp")!)
//        let parameterString3 = "Data1="+TeamName+"&"+"Data2="+Contest_Pk
//        
//        request3.httpMethod = "POST"
//        request3.httpBody = parameterString3.data(using: String.Encoding.utf8)
//        let task3 = URLSession.shared.dataTask(with: request3, completionHandler: {
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
//                    self.Http_Joiner_Name.append((row["msg1"] as? String)!)
//                    self.Http_Joiner_Date.append((row["msg2"] as? String)!)
//                    self.Http_Joiner_Profile.append((row["msg3"] as? String)!)
//                    self.Http_Joiner_Pk.append((row["msg4"] as? String)!)
//                    self.Http_Joiner_Duty.append((row["msg4"] as? String)!)
//                }
//            }catch{
//                
//            }
//            
//        })
//        task3.resume()
        //////////////////////////////////////////////////////////////
        let url = URL(string:"http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg")
        let data = try? Data(contentsOf: url!)
        self.ContestImage_ImageView.image = UIImage(data:data!)
        
        
        ContestName_Label.text = Contest_Title
        ContestStatus_Label.text = Contest_Status
        ContestAcountName_Label.text = AcountName
        ContestAcountNumber_Label.text = AcountNumber
        ContestJoinDate.text = Http_ContestJoinDate_Start[0] + " ~ " + Http_ContestJoinDate_End[0]
        ContestDate.text = Http_ContestDate[0]
        ContestDetail.text = Http_ContestDetail[0]
        TeamName_Label.text = TeamName
        ContestRepresent_Label.text = Http_ContestRepresent[0]
        ContestRepresent_Phone_Label.text = Http_ContestRepresent_Phone[0]
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Http_Joiner_Pk.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestJoin_Focus_Joiner", for: indexPath)
        
        let JoinerDuty = cell.viewWithTag(2) as! UILabel
        let JoinerName = cell.viewWithTag(3) as! UILabel
        let JoinerDate = cell.viewWithTag(4) as! UILabel
        
        JoinerDuty.text = self.Http_Joiner_Duty[indexPath.row]
        JoinerName.text = self.Http_Joiner_Name[indexPath.row]
        JoinerDate.text = self.Http_Joiner_Date[indexPath.row]
        
        let ContestUrlString = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
        let ContestUrl = URL(string: ContestUrlString)
        if ContestUrl != nil {
            let request = URLRequest(url: ContestUrl!)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    let imageView = cell.viewWithTag(5) as! UIImageView
                    imageView.image = UIImage(data: data!)
                })
            } as! (Data?, URLResponse?, Error?) -> Void)
            
            dataTask.resume()
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction internal func Back_Button_Action(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
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
