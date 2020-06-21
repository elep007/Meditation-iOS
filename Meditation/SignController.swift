//
//  SignController.swift
//  Meditation
//
//  Created by Admin on 3/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import JTMaterialSpinner
class SignController: UIViewController {
    var SelectVC : SelectController!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        let username = txtUsername.text!
        let password = txtPassword.text!
        if(username == "" || password == ""){
            self.view.makeToast("Rellenar campo vacío")
        }else{            
            self.view.addSubview(spinnerView)
            spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
            spinnerView.circleLayer.lineWidth = 2.0
            spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
            spinnerView.beginRefreshing()
            let parameters: Parameters = ["username": username, "password" : password]
            
            Alamofire.request(Global.baseUrl + "signin", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
                self.spinnerView.endRefreshing()
                print(response)
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        let user = value["user"] as? [String: AnyObject]
                        let user_id = user!["id"] as! String
                        Defaults.save(user_id, with: Defaults.USERID_KEY)
                        self.SelectVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectVC") as? SelectController
                        self.SelectVC.modalPresentationStyle = .fullScreen
                        self.present(self.SelectVC, animated: false, completion: nil)
                    }else{
                        self.view.makeToast("Usted no está registrado")
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
