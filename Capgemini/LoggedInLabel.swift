//
//  LoggedInLabel.swift
//  Capgemini
//
//  Created by xavier green on 03/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class LoggedInLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.text = "Connecté en tant que "+GlobalVariables.username
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
