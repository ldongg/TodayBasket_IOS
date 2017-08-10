//
//  SlideMenu_TeamMake_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 13..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamMake_ViewController: UIViewController {

    @IBOutlet weak var TeamName_TextField: UITextField!
    @IBOutlet weak var TeamIntroduce_TextField: UITextField!
    @IBOutlet weak var HomeCourt_TextField: UITextField!
    @IBOutlet weak var TeamAddress_TextField: UITextField!
    
    var Pk : String = "20"
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    @IBAction func TeamMake_Button_Action(_ sender: AnyObject) {
        if TeamName_TextField.text == "" {
            let alert_teamname = UIAlertController(title: "경고", message: "팀명을 입력해주세요.", preferredStyle: .alert)
            let alert_teamname_ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert_teamname.addAction(alert_teamname_ok)
            present(alert_teamname, animated: true, completion: nil)
        }
        else{
            if TeamAddress_TextField.text == "" {
                let alert_teamaddress = UIAlertController(title: "경고", message: "팀 주소를 입력해주세요.", preferredStyle: .alert)
                let alert_teamname_ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert_teamaddress.addAction(alert_teamname_ok)
                present(alert_teamaddress, animated: true, completion: nil)
            }
            else{
                if HomeCourt_TextField.text == "" {
                    let alert_homecourt = UIAlertController(title: "경고", message: "홈코트를 입력해주세요.", preferredStyle: .alert)
                    let alert_teamname_ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert_homecourt.addAction(alert_teamname_ok)
                    present(alert_homecourt, animated: true, completion: nil)
                }
                else{
                    if TeamIntroduce_TextField.text == "" {
                        let alert_teamintroduce = UIAlertController(title: "경고", message: "팀 소개를 입력해주세요.", preferredStyle: .alert)
                        let alert_teamname_ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert_teamintroduce.addAction(alert_teamname_ok)
                        present(alert_teamintroduce, animated: true, completion: nil)
                    }
                    else{
                        //http 통신
//                        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part1/TeamMake.jsp")!)
//                        let parameterString = "Data1="+Pk+"&"+"Data2="+TeamName_TextField.text!+"&"+"Data3="+TeamAddress_TextField.text!+"&"+"Data4="+TeamAddress_TextField.text!+"&"+"Data5="+HomeCourt_TextField.text!+"&"+"Data6="+TeamIntroduce_TextField.text!
//                        
//                        request.httpMethod = "POST"
//                        request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                        let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                            data, response, error in
//                            
//                            if error != nil {
//                                return
//                            }
//                            print("response = \(response)")
//                            
//                            let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                            print("responseString = \(responseString)")
//                            
//                            do{
//                                let apiDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
//                                let list = apiDictionary["List"] as! NSArray
//                                for row in list{
//                                    print(row["msg1"] as! String)
//                                    if row["msg1"] as! String == "succed" {
//                                        let alert_teammake_ok = UIAlertController(title: "확인", message: self.TeamName_TextField.text!+"팀이 생성되었습니다.", preferredStyle: .alert)
//                                        let alert_teamname_ok = UIAlertAction(title: "확인", style: .default, handler: {(action:UIAlertAction) in self.dismiss(animated: true, completion: nil)})
//                                        alert_teammake_ok.addAction(alert_teamname_ok)
//                                        DispatchQueue.main.async(execute: { self.present(alert_teammake_ok, animated: true, completion: nil)})
//                                        
//                                    }
//                                    else{
//                                        print(row["msg1"] as! String)
//                                        let alert_succed = UIAlertController(title: "오류", message: "팀 생성에 실패하였습니다.\n 잠시 후 다시 시도해주시기 바랍니다.", preferredStyle: .alert)
//                                        let alert_succed_ok = UIAlertAction(title: "확인", style: .default, handler: {(action:UIAlertAction) in self.dismiss(animated: true, completion: nil)})
//                                        alert_succed.addAction(alert_succed_ok)
//                                        DispatchQueue.main.async(execute: { self.present(alert_succed, animated: true, completion: nil)})
//                                    }
//                                }
//                            }catch{
//                                
//                            }
//                        })
//                        task.resume()
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
