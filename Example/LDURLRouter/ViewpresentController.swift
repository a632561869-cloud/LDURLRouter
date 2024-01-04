//
//  ViewpresentController.swift
//  LDURLRouter
//
//  Created by dong Li on 2023/12/27.
//

import UIKit
import LDURLRouter

class ViewpresentController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reserveValue?("模态回调")
        label.text = self.params["value"] as? String
    }




}
