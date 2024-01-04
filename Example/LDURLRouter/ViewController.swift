//
//  ViewController.swift
//  LDURLRouter
//
//  Created by dong Li on 2023/12/27.
//

import UIKit
import LDURLRouter

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ceshi (_ sender : UIButton){
        LDURLRouter.pushURLString("LDURLRouter://Home",query: ["value" : "传值给你"]){ str in
            self.label.text = str as? String
        }
    }


}


