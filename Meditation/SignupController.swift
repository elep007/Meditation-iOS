//
//  SignupController.swift
//  Meditation
//
//  Created by Admin on 3/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import JTMaterialSpinner
class SignupController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let username = txtUsername.text!
        let fullname = txtFullname.text!
        let email = txtEmail.text!
        let password = txtPassword.text!
        if(username == "" || fullname == "" || email == "" || password == ""){            
            self.view.makeToast("Rellenar campo vacío")
        }else{
            
            self.view.addSubview(spinnerView)
            spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
            spinnerView.circleLayer.lineWidth = 2.0
            spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
            spinnerView.beginRefreshing()
            let parameters: Parameters = ["username": username, "fullname": fullname , "email" : email, "password" : password]
            Alamofire.request(Global.baseUrl + "signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
                self.spinnerView.endRefreshing()
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        self.view.makeToast("Éxito, vaya a la página de inicio de sesión")
                    }else if status == "exist"{
                        self.view.makeToast("Esta usuaria ya existe")
                    }else{
                        self.view.makeToast("Registrarse Fail")
                    }
                }else{
                    self.view.makeToast("Error de red")
                }
            }
        }
        
    }
    
    @IBAction func btnNo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
