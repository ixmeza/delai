//
//  LaunchController.swift
//  respawn
//
//  Created by Ixchel on 19/08/20.
//  Copyright © 2020 flakeystories. All rights reserved.
//

import UIKit

class LaunchController : ViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        // image literal for the background
        let back = #imageLiteral(resourceName: "flakey")
        //setting background with image in back
        self.view.backgroundColor = UIColor(patternImage: back)
    }
    
}
