//
//  CourtViewController.swift
//  slidetest1
//
//  Created by ldong on 2017. 4. 29..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class CourtViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addressDoTableView: UITableView!
    @IBOutlet weak var addressSiTableView: UITableView!
    
    @IBOutlet weak var open: UIBarButtonItem!
    
    var index:Int = 0
    
    var addressDoList = ["서울", "경기", "인천", "강원", "대전", "충북", "충남", "부산", "울산", "경남", "대구", "경북", "광주", "전남", "전주/전북", "제주"]
    
    var addressSiList = [
        ["강남/서초", "강동/송파", "강서/양천", "구로/영등포/여의도", "금천/관악/동작", "동대문/중랑/성동/광진", "도봉/노원/강북/성북", "종로/중구/용산", "은평/서대문/마포"],// 서울
        ["김포/고양/파주", "부천/광명/시흥", "안산/화성/오산/평택", "안양/군포/과천/의왕", "성남/수원", "용인/안성", "하남/광주", "양평/여주/이천", "양주/의정부/동두천", "연천/포천/가평", "구리/남양주"], // 경기
        ["부평/계양", "서구/동구", "남구/남동구/연수", "강화/중구/옹진"], // 인천
        ["철원/화천/양구", "춘천/홍천", "양구/인제", "고성/속초/양양", "원주/횡성/평창", "영월/정선/강릉", "동해/삼척/태백"], // 강원
        ["유성구", "중구/서구", "동구/대덕구"], // 대전
        ["청주", "충주/제천/진천/음성/단양", "보은/옥천/괴산/증평/영동"], // 충북
        ["천안/세종", "논산/계룡/공주/금산", "태안/서산/당진/아산/예산", "보령/홍성/서천/부여/청양"], // 충남
        ["강서/사하/사상", "서구/동구/중구/남구/영도", "부산진구/북구", "동래/연제/수영", "금정/해운대/기장"], // 부산
        ["남구/중구", "동구/북구/울주군"], // 울산
        ["창원" ,"마산/진해", "김해/양산/밀양", "진주/사천/남해", "거제/통영/거창/하동"], // 경남
        ["동구/북구", "서구/중구/남구", "수성구/달서구/달성군"], // 대구
        ["울진/봉화/영양/영덕/울릉군", "영주/문경/예천/안동", "상주/의성/청송", "포항/영천/군위/구미", "경주/경산/청도", "김천/성주/칠곡/고령"], // 경북
        ["서구/남구", "광산구/북구/동구"], // 광주
        ["여수", "순천/광양", "목포/무안/나주", "전남(기타)"], // 전남
        ["전주/완주", "군산/익산", "남원/정읍/부안/김제/기타"], // 전주/전북
        ["제주시", "서귀포시"]] // 제주도
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            //self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
            open.target = self.revealViewController()
            open.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        addressDoTableView.dataSource = self
        addressSiTableView.dataSource = self
        addressDoTableView.delegate = self
        addressSiTableView.delegate = self
        
        addressDoTableView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        
        if tableView == self.addressDoTableView {
            count = addressDoList.count
        }
        if tableView == self.addressSiTableView {
            count = addressSiList[index].count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = nil
        if tableView == self.addressDoTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "addressDoCell", for: indexPath)
            
            cell?.backgroundColor = UIColor.clear
            
            let addressDoLabel = cell?.viewWithTag(1) as! UILabel
            addressDoLabel.text = addressDoList[indexPath.row]
            
            
        }
        if tableView == self.addressSiTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "addressSiCell", for: indexPath)
            
            let addressSiLabel = cell?.viewWithTag(1) as! UILabel
            addressSiLabel.text = addressSiList[index][indexPath.row]
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.addressDoTableView {
            index = indexPath.row
            addressSiTableView.reloadData()
            
//            tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if tableView == self.addressDoTableView {
//            tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.clear
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        let CourtAddressDetailViewController = segue.destination as! CourtAddressDetailViewController
        let myIndexPath2 = self.addressSiTableView.indexPathForSelectedRow!
        let row2 = myIndexPath2.row
        
        CourtAddressDetailViewController.addressDo = addressDoList[index]
        let addressSiArr = addressSiList[index][row2].components(separatedBy: "/")
        for si in addressSiArr {
            CourtAddressDetailViewController.addressSi.append(si)
        }
        CourtAddressDetailViewController.isMain = false
        CourtAddressDetailViewController.navigationItem.title = addressSiList[index][row2]
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
