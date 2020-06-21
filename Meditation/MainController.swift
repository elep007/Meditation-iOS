//
//  ViewController.swift
//  Meditation
//
//  Created by Admin on 3/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import TransitionButton
class MainController: UIViewController {

    @IBOutlet weak var btnSignIn: TransitionButton!
    @IBOutlet weak var btnSignUp: TransitionButton!
    var homeVC: HomeController!
    var signVC: SignController!
    var signupVC : SignupController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.borderColor = UIColor(red: 250/255, green: 126/255, blue: 90/255, alpha: 1).cgColor
        
    }

    @IBAction func btn_SignIn(_ sender: TransitionButton) {
        btnSignIn.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {

            sleep(1) // 3: Do your networking task or background work here.

            DispatchQueue.main.async(execute: { () -> Void in self.btnSignIn.stopAnimation(animationStyle: .expand, completion: {
                    self.signVC = self.storyboard?.instantiateViewController(withIdentifier: "signVC") as? SignController
                    self.signVC.modalPresentationStyle = .fullScreen
                    self.present(self.signVC, animated: false, completion: nil)
                })
            })
        })
        
        
    }
    @IBAction func btn_SignUp(_ sender: TransitionButton) {
        btnSignUp.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {

            sleep(1) // 3: Do your networking task or background work here.

            DispatchQueue.main.async(execute: { () -> Void in self.btnSignUp.stopAnimation(animationStyle: .expand, completion: {
                    self.signupVC = self.storyboard?.instantiateViewController(withIdentifier: "signupVC") as? SignupController
                    self.signupVC.modalPresentationStyle = .fullScreen
                    self.present(self.signupVC, animated: false, completion: nil)
                })
            })
        })
    }
    
}

