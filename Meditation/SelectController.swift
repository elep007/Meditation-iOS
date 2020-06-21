//
//  SelectController.swift
//  Meditation
//
//  Created by Admin on 24/04/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SelectController: UIViewController {
    var homeVC : HomeController!
    var kidsVC : KidsController!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func Sel_Adult(_ sender: UIButton) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeController
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: false, completion: nil)
    }
    
    @IBAction func Sel_Kids(_ sender: UIButton) {
        self.kidsVC = self.storyboard?.instantiateViewController(withIdentifier: "KidsVC") as? KidsController
        self.kidsVC.modalPresentationStyle = .fullScreen
        self.present(self.kidsVC, animated: false, completion: nil)
    }
}
