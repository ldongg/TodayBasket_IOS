//
//  NoticeViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 19..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noticeTableView: UITableView!
    
    var arrRes = [[String:AnyObject]]()
    
    var noticeSetting = NoticeSetting()
    var noticeList:[NoticeSetting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        Alamofire.request("http://210.122.7.193:8080/Trophy_part3/Notice.jsp").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                print(responseData.result)
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["List"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
                for i in 0 ..< self.arrRes.count {
                    var dict = self.arrRes[i]
                    
                    self.noticeSetting = NoticeSetting()
                    
                    self.noticeSetting.noticeTitle = dict["notice_title"] as! String
                    self.noticeSetting.noticeData = dict["notice_data"] as! String
                    self.noticeSetting.noticeDate = dict["notice_date"] as! String
                    
                    self.noticeList.append(self.noticeSetting)
                }
                self.noticeTableView.reloadData()
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        titleLabel.text = self.noticeList[indexPath.row].noticeTitle
        dateLabel.text = self.noticeList[indexPath.row].noticeDate
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let contestDetailViewController = storyBoard.instantiateViewController(withIdentifier: "Contest_Detail_ViewController") as! Contest_Detail_ViewController
//        
//        //contestDetailViewController.Contest_Pk = Contest_list[indexPath.row].Pk
//        
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        navigationItem.backBarButtonItem = backItem
//        
//        self.navigationController?.pushViewController(contestDetailViewController, animated: true)
//        //self.present(contestDetailViewController, animated: true, completion: nil)
//        //Contest_Detail_ViewController
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let noticeDetailVIewController = segue.destination as! NoticeDetailViewController
        let myIndexPath = self.noticeTableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        
        noticeDetailVIewController.noticeTitle = self.noticeList[row].noticeTitle
        noticeDetailVIewController.noticeDate = self.noticeList[row].noticeDate
        noticeDetailVIewController.noticeData = self.noticeList[row].noticeData
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

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
