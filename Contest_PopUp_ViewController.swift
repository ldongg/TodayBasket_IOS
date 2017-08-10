//
//  Contest_PopUp_ViewController.swift
//  slidetest1
//
//  Created by MD313-007 on 2017. 2. 16..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class Contest_PopUp_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewControllerWithIdentifier("alert")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
