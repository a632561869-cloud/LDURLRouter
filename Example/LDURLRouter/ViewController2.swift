//
//  ViewController2.swift
//  LDURLRouter
//
//  Created by dong Li on 2023/12/27.
//

import UIKit
import LDURLRouter

class ViewController2: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = self.params["value"] as? String
        // Do any additional setup after loading the view.
    }


    @IBAction func jump(_ sender: UIButton) {
        LDURLRouter.presentURLString("LDURLRouter://present",query: ["value": "传值成功"], {
            str in
            self.label.text = str as? String
        })
    }
    @IBAction func ceshi(_ sender : UIButton){
        self.reserveValue?("值回调给你")
        LDURLRouter.popViewController(animated: true)
    }


}
