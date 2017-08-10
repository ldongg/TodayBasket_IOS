//
//  SlideMenu_TeamManager_TeamIntro_ViewController.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 14..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamManager_TeamIntro_ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var Emblem_ImageView: UIImageView!
    @IBOutlet weak var TeamName_Label: UILabel!
    @IBOutlet weak var TeamAddress: UITextField!
    @IBOutlet weak var HomeCourt_TextField: UITextField!
    @IBOutlet weak var TeamIntro_TextField: UITextField!
    @IBOutlet weak var TeamImage3_ImageView: UIImageView!
    @IBOutlet weak var TeamImage2_ImageView: UIImageView!
    @IBOutlet weak var TeamImage1_ImageView: UIImageView!
    
    var TeamName : String = "1"
    
    var Http_TeamName = [String]()
    var Http_TeamAddress_Do = [String]()
    var Http_TeamAddress_Se = [String]()
    var Http_HomeCourt = [String]()
    var Http_Introduce = [String]()
    var Http_Emblem = [String]()
    var Http_Image1 = [String]()
    var Http_Image2 = [String]()
    var Http_Image3 = [String]()
    var ImageChoice:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.contentSize.height = 1000
        
        Emblem_ImageView.isUserInteractionEnabled = true
        Emblem_ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SlideMenu_TeamManager_TeamIntro_ViewController.Emblem_ImageView_Action(_:))))
        TeamImage1_ImageView.isUserInteractionEnabled = true
        TeamImage1_ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SlideMenu_TeamManager_TeamIntro_ViewController.Image1_ImageView_Action(_:))))
        TeamImage2_ImageView.isUserInteractionEnabled = true
        TeamImage2_ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SlideMenu_TeamManager_TeamIntro_ViewController.Image2_ImageView_Action(_:))))
        TeamImage3_ImageView.isUserInteractionEnabled = true
        TeamImage3_ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SlideMenu_TeamManager_TeamIntro_ViewController.Image3_ImageView_Action(_:))))
        //http 통신
//        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce.jsp")!)
//        let parameterString = "Data1="+TeamName
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
//                    
//                    self.Http_TeamName.append((row["msg1"] as? String)!)
//                    self.Http_TeamAddress_Do.append((row["msg2"] as? String)!)
//                    self.Http_TeamAddress_Se.append((row["msg3"] as? String)!)
//                    self.Http_HomeCourt.append((row["msg4"] as? String)!)
//                    self.Http_Introduce.append((row["msg5"] as? String)!)
//                    self.Http_Emblem.append((row["msg6"] as? String)!)
//                    self.Http_Image1.append((row["msg7"] as? String)!)
//                    self.Http_Image2.append((row["msg8"] as? String)!)
//                    self.Http_Image3.append((row["msg9"] as? String)!)
//
//                }
//            }catch{
//                
//            }
//            self.TeamName_Label.text = self.Http_TeamName[0]
//            self.TeamAddress.text = self.Http_TeamAddress_Do[0] + " " + self.Http_TeamAddress_Se[0]
//            self.HomeCourt_TextField.text = self.Http_HomeCourt[0]
//            self.TeamIntro_TextField.text = self.Http_Introduce[0]
//            
//            if self.Http_Emblem[0] == "." {
//                self.Emblem_ImageView.image = UIImage(named: "basketball_a.png")
//            }
//            else{
//                let url = URL(string:"http://210.122.7.193:8080/Trophy_img/team/"+self.Http_Emblem[0]+".jpg")
//                let data = try? Data(contentsOf: url!)
//                self.Emblem_ImageView.image = UIImage(data:data!)
//
//            }
//            if self.Http_Image1[0] == "." {
//                self.TeamImage1_ImageView.image = UIImage(named: "basketball_a.png")
//            }
//            else{
//                let url = URL(string:"http://210.122.7.193:8080/Trophy_img/team/"+self.Http_Image1[0]+".jpg")
//                let data = try? Data(contentsOf: url!)
//                self.TeamImage1_ImageView.image = UIImage(data:data!)
//                
//            }
//            if self.Http_Image2[0] == "." {
//                self.TeamImage2_ImageView.image = UIImage(named: "basketball_a.png")
//            }
//            else{
//                let url = URL(string:"http://210.122.7.193:8080/Trophy_img/team/"+self.Http_Image2[0]+".jpg")
//                let data = try? Data(contentsOf: url!)
//                self.TeamImage2_ImageView.image = UIImage(data:data!)
//                
//            }
//            if self.Http_Image3[0] == "." {
//                self.TeamImage3_ImageView.image = UIImage(named: "basketball_a.png")
//            }
//            else{
//                let url = URL(string:"http://210.122.7.193:8080/Trophy_img/team/"+self.Http_Image3[0]+".jpg")
//                let data = try? Data(contentsOf: url!)
//                self.TeamImage3_ImageView.image = UIImage(data:data!)
//                
//            }
//            //팀 소개 이미지1
//            
//            self.view.setNeedsDisplay()
//
//        })
//        task.resume()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func Emblem_ImageView_Action(_ sender: UITapGestureRecognizer){
        if(sender.state == .ended){
            ImageChoice = "emblem"
            let alert_emblem = UIAlertController(title: "사진 수정", message: "", preferredStyle: .alert)
            let alert_emblem_basic = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {(action:UIAlertAction) in
                self.Emblem_ImageView.image = UIImage(named: "basketball_a.png")
                //http 통신
//                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
//                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2=."+"&"+"Data3=Emblem"
//                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
            })
            let alert_emblem_album = UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: {(action:UIAlertAction) in
                self.Emblem_ImageView.reloadInputViews()
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(myPickerController, animated: true, completion: nil)
                //http 통신
                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2="+self.Http_TeamName[0]+"&"+"Data3=Emblem"
                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
                
            })
            let alert_emblem_ok = UIAlertAction(title: "확 인", style: .default, handler: nil)
            
            alert_emblem.addAction(alert_emblem_basic)
            alert_emblem.addAction(alert_emblem_album)
            alert_emblem.addAction(alert_emblem_ok)
            
            present(alert_emblem, animated: true, completion: nil)
            
        }
    }
    func Image1_ImageView_Action(_ sender: UITapGestureRecognizer){
        if(sender.state == .ended){
            ImageChoice = "Image1"
            let alert_Image1 = UIAlertController(title: "사진 수정", message: "", preferredStyle: .alert)
            let alert_Image1_basic = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {(action:UIAlertAction) in
                self.TeamImage1_ImageView.image = UIImage(named: "basketball_a.png")
                //http 통신
                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2=."+"&"+"Data3=Image1"
                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
            })
            let alert_Image1_album = UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: {(action:UIAlertAction) in
                self.TeamImage1_ImageView.reloadInputViews()
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(myPickerController, animated: true, completion: nil)
                //http 통신
//                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
//                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2="+self.Http_TeamName[0]+"1"+"&"+"Data3=Image1"
//                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
                
            })
            let alert_Image1_ok = UIAlertAction(title: "확 인", style: .default, handler: nil)
            
            alert_Image1.addAction(alert_Image1_basic)
            alert_Image1.addAction(alert_Image1_album)
            alert_Image1.addAction(alert_Image1_ok)
            
            present(alert_Image1, animated: true, completion: nil)
            
        }
    }
    func Image2_ImageView_Action(_ sender: UITapGestureRecognizer){
        if(sender.state == .ended){
            ImageChoice = "Image2"
            let alert_emblem = UIAlertController(title: "사진 수정", message: "", preferredStyle: .alert)
            let alert_emblem_basic = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {(action:UIAlertAction) in
                self.TeamImage2_ImageView.image = UIImage(named: "basketball_a.png")
                //http 통신
//                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
//                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2=."+"&"+"Data3=Image2"
//                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
            })
            let alert_emblem_album = UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: {(action:UIAlertAction) in
                self.TeamImage2_ImageView.reloadInputViews()
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(myPickerController, animated: true, completion: nil)
                //http 통신
//                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
//                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2="+self.Http_TeamName[0]+"2"+"&"+"Data3=Image2"
//                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
                
            })
            let alert_emblem_ok = UIAlertAction(title: "확 인", style: .default, handler: nil)
            
            alert_emblem.addAction(alert_emblem_basic)
            alert_emblem.addAction(alert_emblem_album)
            alert_emblem.addAction(alert_emblem_ok)
            
            present(alert_emblem, animated: true, completion: nil)
            
        }
    }
    func Image3_ImageView_Action(_ sender: UITapGestureRecognizer){
        if(sender.state == .ended){
            ImageChoice = "Image3"
            let alert_emblem = UIAlertController(title: "사진 수정", message: "", preferredStyle: .alert)
            let alert_emblem_basic = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {(action:UIAlertAction) in
                self.TeamImage3_ImageView.image = UIImage(named: "basketball_a.png")
                //http 통신
//                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
//                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2=."+"&"+"Data3=Image3"
//                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
            })
            let alert_emblem_album = UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: {(action:UIAlertAction) in
                self.TeamImage3_ImageView.reloadInputViews()
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(myPickerController, animated: true, completion: nil)
                //http 통신
//                let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image.jsp")!)
//                let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2="+self.Http_TeamName[0]+"3"+"&"+"Data3=Image3"
//                
//                request.httpMethod = "POST"
//                request.httpBody = parameterString.data(using: String.Encoding.utf8)
//                let task = URLSession.shared.dataTask(with: request, completionHandler: {
//                    data, response, error in
//                    
//                    if error != nil {
//                        return
//                    }
//                    print("response = \(response)")
//                    
//                    let responseString:NSString = NSString(data: data!, encoding: String.Encoding.utf8)!
//                    print("responseString = \(responseString)")
//                })
//                task.resume()
                
            })
            let alert_emblem_ok = UIAlertAction(title: "확 인", style: .default, handler: nil)
            
            alert_emblem.addAction(alert_emblem_basic)
            alert_emblem.addAction(alert_emblem_album)
            alert_emblem.addAction(alert_emblem_ok)
            
            present(alert_emblem, animated: true, completion: nil)
            
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if ImageChoice == "emblem" {
            Emblem_ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        else if ImageChoice == "Image1" {
            TeamImage1_ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        else if ImageChoice == "Image2" {
            TeamImage2_ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        else{
            TeamImage3_ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Back_Button(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Modify_Button_Action(_ sender: AnyObject) {
        
        self.Http_TeamName[0] = self.TeamName_Label.text!
        self.Http_TeamAddress_Do[0] = self.TeamAddress.text!
        self.Http_HomeCourt[0] = self.HomeCourt_TextField.text!
        self.Http_Introduce[0] = self.TeamIntro_TextField.text!
        self.myImageUploadRequest(self.Emblem_ImageView, NameImage: self.TeamName)
        self.myImageUploadRequest(self.TeamImage1_ImageView, NameImage: self.TeamName+"1")
        self.myImageUploadRequest(self.TeamImage2_ImageView, NameImage: self.TeamName+"2")
        self.myImageUploadRequest(self.TeamImage3_ImageView, NameImage: self.TeamName+"3")
        //http 통신
//        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Upload.jsp")!)
//       let parameterString = "Data1="+self.Http_TeamName[0]+"&"+"Data2="+self.Http_TeamAddress_Do[0]+"&"+"Data3="+self.Http_TeamAddress_Do[0]+"&"+"Data4="+self.Http_HomeCourt[0]+"&"+"Data5="+self.Http_Introduce[0]
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
//                let alert_modify = UIAlertController(title: "확 인", message: "팀 정보가 수정되었습니다.", preferredStyle: .alert)
//                let alert_modify_ok = UIAlertAction(title: "확인", style: .default, handler: {(action:UIAlertAction) in
//                    self.dismiss(animated: true, completion: nil)
//                })
//                alert_modify.addAction(alert_modify_ok)
//                DispatchQueue.main.async(execute: { self.present(alert_modify, animated: true, completion: nil)})
//                
//            }catch{
//                
//            }
//            
//        })
//        task.resume()
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func myImageUploadRequest(_ choiceImage:UIImageView, NameImage:String)
    {
        //request
        let request = NSMutableURLRequest(url: URL(string: "http://210.122.7.193:8080/Trophy_part2/TeamManager_TeamIntroduce_Image_Upload.jsp")!)
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=1234567890", forHTTPHeaderField: "Content-Type")
        
        //post data
        let body: NSMutableData = NSMutableData();
        //data
        var imgdata: Data = UIImageJPEGRepresentation(choiceImage.image!, 1)!
        let imgname: String = "Content-Disposition: form-data; name=\"Filedata\"; filename=\""+NameImage+".jpg\"\r\n"
        
        if (imgdata.count > 0) {
            body.append("--1234567890\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append(imgname.data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append(imgdata)
            body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        
        body.append("--1234567890--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        //set body
        request.httpBody = body as Data;
        request.setValue(NSString(format: "%d", body.length) as String, forHTTPHeaderField: "Content-Length")
        
        //var err: NSError?
        //request.setValue("form-data; name=Filedata; filename=temp.jpg", )
        //request.setValue("form-data; name=Filedata; filename=temp.jpg", forHTTPHeaderField: "Content-Disposition")
        //request.HTTPBody = param
        NSURLConnection(request: request as URLRequest, delegate: self)
    }
}
