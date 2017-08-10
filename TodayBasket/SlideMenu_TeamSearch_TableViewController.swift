//
//  SlideMenu_TeamSearch_TableViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 8..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class SlideMenu_TeamSearch_TableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var open: UIBarButtonItem!
    
    
    var Team_List:[TeamSearchSetting] = []
    var Team_Setting = TeamSearchSetting()
    
    var tableData = [String]()
    var filteredData:[String] = []
    var resultSearchController:UISearchController!
    var arrRes:[[String:AnyObject]] = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // drawer 설정
        if self.revealViewController() != nil {
            //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/TeamList.jsp").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                print(responseData.result)
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                for row in self.arrRes{
                    
                    self.Team_Setting = TeamSearchSetting()
                    self.Team_Setting.teamName = ((row["teamName"] as? String)!)
                    self.Team_Setting.teamEmblem = (row["teamEmblem"] as? String)!
                    self.Team_Setting.teamPk = ((row["teamPk"] as? String)!)
                    self.Team_Setting.teamAddressDo = ((row["teamAddressDo"] as? String)!)
                    self.Team_Setting.teamAddressSi = ((row["teamAddressSi"] as? String)!)
                    self.Team_Setting.teamHomeCourt = ((row["teamHomeCourt"] as? String)!)
                    self.Team_Setting.teamIntroduce = ((row["teamIntroduce"] as? String)!)
                    self.Team_Setting.teamImage1 = ((row["teamImage1"] as? String)!)
                    self.Team_Setting.teamImage2 = ((row["teamImage2"] as? String)!)
                    self.Team_Setting.teamImage3 = ((row["teamImage3"] as? String)!)
                    
                    if(self.Team_Setting.teamName != ".") {
                        self.Team_List.append(self.Team_Setting)
                        self.tableData.append((row["teamName"] as? String)!)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        
        //검색어 구현
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        //////
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    @IBAction func Back_Button_Action(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if resultSearchController.isActive {
            return filteredData.count
        }else{
            return tableData.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        let titleLabel = cell.viewWithTag(2) as! UILabel
        let addressDoLabel = cell.viewWithTag(3) as! UILabel
        let addressSiLabel = cell.viewWithTag(4) as! UILabel
        // Configure the cell...
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        
        if resultSearchController.isActive {
            //cell.textLabel?.text = filteredData[indexPath.row]
            titleLabel.text = filteredData[indexPath.row]
            for i in 0 ..< Team_List.count {
                if(filteredData[indexPath.row] == Team_List[i].teamName) {
                    addressDoLabel.text = Team_List[i].teamAddressDo
                    addressSiLabel.text = Team_List[i].teamAddressSi
                    
                    let imageName:String = Team_List[i].teamEmblem
                    
                    if (imageName != ".") {
                        let url = "http://210.122.7.193:8080/Trophy_img/team/\(imageName).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        Alamofire.request(url!).responseImage { response in
                            if let image = response.result.value {
                                debugPrint(response.result)
                                imageView.image = image
                            }
                        }
                    }else {
                        imageView.image = UIImage(named: "ic_team")
                    }
                }
            }
            
        }else {
            //cell.textLabel?.text = tableData[indexPath.row]
            titleLabel.text = tableData[indexPath.row]
            addressDoLabel.text = Team_List[indexPath.row].teamAddressDo
            addressSiLabel.text = Team_List[indexPath.row].teamAddressSi
        
            let imageName:String = Team_List[indexPath.row].teamEmblem

            if (imageName != ".") {
                let url = "http://210.122.7.193:8080/Trophy_img/team/\(imageName).jpg".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                Alamofire.request(url!).responseImage { response in
                    if let image = response.result.value {
                        debugPrint(response.result)
                        imageView.image = image
                    }
                }
            }else {
                imageView.image = UIImage(named: "ic_team")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.characters.count > 0 {
            filteredData.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", searchController.searchBar.text!)
            let array = (tableData as NSArray).filtered(using: searchPredicate)
            filteredData = array as! [String]
            tableView.reloadData()
        }else{
            filteredData.removeAll(keepingCapacity: false)
            filteredData = tableData
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTeamDetail" {
            let TeamDetailViewController = segue.destination as! TeamDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            if resultSearchController.isActive {
                for i in 0 ..< Team_List.count {
                    if(filteredData[row] == Team_List[i].teamName) {
                        TeamDetailViewController.teamPk = Team_List[i].teamPk
                    }
                }
            }else {
                TeamDetailViewController.teamPk = Team_List[row].teamPk
            }
        }
    }
}
