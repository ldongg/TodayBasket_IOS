//
//  SlideMenu_TeamSearch_Focus_Cell.swift
//  slidetest1
//
//  Created by MD313-008 on 2017. 2. 13..
//  Copyright © 2017년 MD313-008. All rights reserved.
//

import UIKit

class SlideMenu_TeamSearch_Focus_Cell: UITableViewCell {
    @IBOutlet weak var TeamAddress: UILabel!
    @IBOutlet weak var TeamName: UILabel!

    let teamname = ["클린쳐"]
    let teamaddress = ["경기도 의정부시"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
