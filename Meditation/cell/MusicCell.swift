//
//  MusicCell.swift
//  Meditation
//
//  Created by Admin on 3/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import TransitionButton
class MusicCell: UITableViewCell {
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgimage: UIImageView!
    @IBOutlet weak var btnPremium: TransitionButton!
    @IBOutlet weak var btnPlay: UIImageView!
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtMin: UILabel!
    @IBOutlet weak var txtLevel: UILabel!
    
}
