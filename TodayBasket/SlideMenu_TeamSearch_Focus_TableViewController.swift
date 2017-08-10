//
//  SlideMenu_TeamSearch_Focus_TableViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 10..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamSearch_Focus_TableViewController: UITableViewController {
    @IBOutlet weak var UIIntroduce: UILabel!
    @IBOutlet weak var UIHomeCourt: UILabel!
    @IBOutlet weak var UITeamAddress: UILabel!
    @IBOutlet weak var UITeamName: UILabel!
    var teamname : String = ""
    
    var TeamName = [String]()
    var TeamAddress_Do = [String]()
    var TeamAddress_Se = [String]()
    var HomeCourt = [String]()
    var Introduce = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //http 통신
        let request = NSMutableURLRequest(URL: NSURL(string: "http://210.122.7.193:8080/Trophy_part1/TeamSearch_Focus.jsp")!)
        let parameterString = "Data1="+teamname
        
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
                    self.TeamName.append((row["msg1"] as? String)!)
                    self.TeamAddress_Do.append((row["msg2"] as? String)!)
                    self.TeamAddress_Se.append((row["msg3"] as? String)!)
                    self.HomeCourt.append((row["msg4"] as? String)!)
                    self.Introduce.append((row["msg5"] as? String)!)
                }
            }catch{
                
            }
            
            //self.view.setNeedsDisplay()
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//        self.UITeamName.text = self.TeamName[0]
//        self.UITeamAddress.text = self.TeamAddress_Do[0] + " " + self.TeamAddress_Se[0]
//        self.UIHomeCourt.text = self.HomeCourt[0]
//        self.UIIntroduce.text = self.Introduce[0]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
