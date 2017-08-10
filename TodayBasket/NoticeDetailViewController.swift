//
//  NoticeDetailViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 20..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    @IBOutlet weak var noticeTitleLabel: UILabel!
    @IBOutlet weak var noticeDateLabel: UILabel!
    @IBOutlet weak var noticeDataTextView: UITextView!
    
    var noticeTitle:String = ""
    var noticeDate:String = ""
    var noticeData:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noticeTitleLabel.text = noticeTitle
        noticeDateLabel.text = noticeDate
        noticeDataTextView.text = noticeData
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
