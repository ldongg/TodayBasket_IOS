//

//  ViewController.swift

//  slidetest1

//

//  Created by MD313-008 on 2017. 2. 7..

//  Copyright © 2017년 MD313-008. All rights reserved.

//



import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ContestViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UISearchResultsUpdating{
    
    
    @IBOutlet weak var open: UIBarButtonItem!
    
    var isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    @IBOutlet var Contest_TableView: UITableView!
    var Contest_list:[Contest_Detail_Setting] = []
    var filteredData:[String] = []
    var Contest_Setting = Contest_Detail_Setting()
    
    var isMain:Bool = false
    
    var arrRes = [[String: AnyObject]]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 상단 트로피 이미지
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "Trophy_ic")
//        navigationItem.titleView = imageView
        
        if(isMain) {
            self.navigationItem.leftBarButtonItem = nil
        }else {
            self.navigationItem.leftBarButtonItem = open
        }
        
        if self.revealViewController() != nil {
            //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.Contest_TableView.dataSource = self
        self.Contest_TableView.delegate = self
        
        let url:URL = URL(string: "http://210.122.7.193:8080/Trophy_part3/Contest_Customlist.jsp")!;
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                if self.arrRes.count > 0 {
                    for i in 0 ..< self.arrRes.count {
                        var dict = self.arrRes[i]
                        
                        self.Contest_Setting = Contest_Detail_Setting()
                        self.Contest_Setting.Pk = dict["_Pk"] as! String
                        self.Contest_Setting.Title = dict["_Title"] as! String
                        self.Contest_Setting.Image = dict["_Image"] as! String
                        self.Contest_Setting.CurrentNum = dict["_currentNum"] as! String
                        self.Contest_Setting.MaxNum = dict["_maxNum"] as! String
                        self.Contest_Setting.Payment = dict["_Payment"] as! String
                        self.Contest_Setting.Host = dict["_Host"] as! String
                        self.Contest_Setting.Management = dict["_Management"] as! String
                        self.Contest_Setting.Support = dict["_Support"] as! String
                        self.Contest_Setting.ContestDate = dict["_ContestDate"] as! String
                        self.Contest_Setting.RecruitStartDate = dict["_RecruitStartDate"] as! String
                        self.Contest_Setting.RecruitFinishDate = dict["_RecruitFinishDate"] as! String
                        self.Contest_Setting.DetailInfo = dict["_DetailInfo"] as! String
                        self.Contest_Setting.Place = dict["_Place"] as! String
                        self.Contest_Setting.OutSide = dict["_OutSide"] as! String
                        
                        self.Contest_list.append(self.Contest_Setting)
                    }
                    self.Contest_TableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Contest_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestCell", for: indexPath)
        
        let ContestImageView = cell.viewWithTag(1) as! UIImageView
        let Contest_Title = cell.viewWithTag(2) as! UILabel
        let Contest_Date = cell.viewWithTag(3) as! UILabel
        
        var dict = arrRes[indexPath.row]
        Contest_Title.text = Contest_list[indexPath.row].Title
        Contest_Date.text = Contest_list[indexPath.row].ContestDate
        
        let imageName:String = dict["_Image"] as! String
        ContestImageView.af_setImage(withURL: URL(string: "http://210.122.7.193:8080/Trophy_img/contest/\(imageName).jpg")!)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Contest_Detail_View = segue.destination as! Contest_Detail_ViewController
        let myIndexPath = self.Contest_TableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        
        Contest_Detail_View.Contest_Pk = Contest_list[row].Pk
        Contest_Detail_View.Contest_Title = Contest_list[row].Title
        Contest_Detail_View.Contest_Image = Contest_list[row].Image
        Contest_Detail_View.Contest_CurrentNum = Contest_list[row].CurrentNum
        Contest_Detail_View.Contest_MaxNum = Contest_list[row].MaxNum
        Contest_Detail_View.Contest_Payment = Contest_list[row].Payment
        Contest_Detail_View.Contest_Host = Contest_list[row].Host
        Contest_Detail_View.Contest_Management = Contest_list[row].Management
        Contest_Detail_View.Contest_Support = Contest_list[row].Support
        Contest_Detail_View.Contest_ContestDate = Contest_list[row].ContestDate
        Contest_Detail_View.Contest_RecruitStartDate = Contest_list[row].RecruitStartDate
        Contest_Detail_View.Contest_RecruitFinishDate = Contest_list[row].RecruitFinishDate
        Contest_Detail_View.Contest_DetailInfo = Contest_list[row].DetailInfo
        Contest_Detail_View.Contest_Place = Contest_list[row].Place
        Contest_Detail_View.Contest_OutSide = Contest_list[row].OutSide
        
        
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}
