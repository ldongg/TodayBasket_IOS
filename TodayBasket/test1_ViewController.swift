//
//  test1_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 28..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
class test1_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView_joiner: UICollectionView!
    var TeamName : String = "AldongTeam"
    var HttpStatue: String = "start"
    
    var Http_Joiner_Profile = [String]()
    var Http_Joiner_Name = [String]()
    var Http_Joiner_Pk = [String]()
    
    var Http_Player_Profile = [String]()
    var Http_Player_Name = [String]()
    var Http_Player_Pk = [String]()
    
    var Player_Count : Int = 0
    var Player_ExtraCount : Int = 0
    var Joiner_Count : Int = 0
    var Joiner_ExtraCount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        //////////////////팀원 http
        
    }
    override func viewDidAppear(animated: Bool) {
        //////신청자 http//////////////////////
        let request1 = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_Joiner.jsp")!)
        let parameterString1 = "Data1="+TeamName
        HttpStatue = "start"
        request1.HTTPMethod = "POST"
        request1.HTTPBody = parameterString1.dataUsingEncoding(NSUTF8StringEncoding)
        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data, response, error in
            
            if error != nil {
                return
            }
            print("response = \(response)")
            
            let responseString:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("responseString = \(responseString)")
            do{
                let apiDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let list = apiDictionary["List"] as! NSArray
                for row in list{
                    self.Http_Joiner_Profile.append((row["msg1"] as? String)!)
                    self.Http_Joiner_Name.append((row["msg2"] as? String)!)
                    self.Http_Joiner_Pk.append((row["msg3"] as? String)!)
                    self.Joiner_Count++
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView_joiner.reloadData()
                    }
                }
            }catch{
                
            }
            print(self.Joiner_Count)
            if self.Joiner_Count%3 == 1 {
                self.Http_Joiner_Profile.append(".")
                self.Http_Joiner_Name.append(".")
                self.Http_Joiner_Pk.append(".")
                self.Http_Joiner_Profile.append(".")
                self.Http_Joiner_Name.append(".")
                self.Http_Joiner_Pk.append(".")
                
            }
            else if self.Joiner_Count%3 == 2 {
                self.Http_Joiner_Profile.append(".")
                self.Http_Joiner_Name.append(".")
                self.Http_Joiner_Pk.append(".")
            }
        }
        task1.resume()

        //////////////////팀원 http
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamManager_Player.jsp")!)
        let parameterString = "Data1="+TeamName
        request.HTTPMethod = "POST"
        request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                return
            }
            print("response = \(response)")
            
            let responseString:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("responseString = \(responseString)")
            do{
                let apiDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let list = apiDictionary["List"] as! NSArray
                for row in list{
                    self.Http_Player_Profile.append((row["msg1"] as? String)!)
                    self.Http_Player_Name.append((row["msg2"] as? String)!)
                    self.Http_Player_Pk.append((row["msg3"] as? String)!)
                    self.Player_Count++
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                }
            }catch{
                
            }
            print(self.Player_Count)
            if self.Player_Count%3 == 1 {
                self.Http_Player_Profile.append(".")
                self.Http_Player_Name.append(".")
                self.Http_Player_Pk.append(".")
                self.Http_Player_Profile.append(".")
                self.Http_Player_Name.append(".")
                self.Http_Player_Pk.append(".")
                
            }
            else if self.Player_Count%3 == 2 {
                self.Http_Player_Profile.append(".")
                self.Http_Player_Name.append(".")
                self.Http_Player_Pk.append(".")
            }
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return Http_Player_Pk.count
        }
        else {
            return Http_Joiner_Pk.count
        }
        // #warning Incomplete implementation, return the number of items
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        if collectionView.tag == 1 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath)
            let imageview = cell.viewWithTag(1) as! UIImageView
            let label = cell.viewWithTag(2) as! UILabel
            let ContestUrlString1 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
            let ContestUrl1 = NSURL(string: ContestUrlString1)
            if ContestUrl1 != nil {
                let request = NSURLRequest(URL: ContestUrl1!)
                let session = NSURLSession.sharedSession()
                let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        imageview.image = UIImage(data: data!)
                        label.text = self.Http_Player_Name[indexPath.row]
                    })
                })
                
                dataTask.resume()
            }
            
            // Configure the cell
        }
        else if collectionView.tag == 2{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell_Joiner", forIndexPath: indexPath)
            print("123213")
            let imageview = cell.viewWithTag(1) as! UIImageView
            let label = cell.viewWithTag(2) as! UILabel
            let ContestUrlString1 = "http://210.122.7.193:8080/Trophy_img/team/AldongTeam.jpg"
            let ContestUrl1 = NSURL(string: ContestUrlString1)
            if ContestUrl1 != nil {
                let request = NSURLRequest(URL: ContestUrl1!)
                let session = NSURLSession.sharedSession()
                let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        imageview.image = UIImage(data: data!)
                        label.text = self.Http_Joiner_Name[indexPath.row]
                    })
                })
                
                dataTask.resume()
            }
            
            // Configure the cell
        }
        else{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell_Joiner", forIndexPath: indexPath)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}
