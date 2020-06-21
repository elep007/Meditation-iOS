//
//  TimerController.swift
//  Meditation
//
//  Created by Admin on 3/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Alamofire
import TransitionButton
import AVFoundation
import JTMaterialSpinner
class TimerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var Player : AVPlayer!
    var audioPlayer = AVAudioPlayer()
    
    var homeVC : HomeController!
    var libraryVC : LibraryController!
    var allmusic = [Music]()
    var sel_timer_index = 0
    var sel_music_index = 0
    var sel_bell_index = 0
    var sel_play = 0
    var count_time = 0
    var timer : Timer! = nil
    var soundurl = ""
    var soundid = ""
    var spinnerView = JTMaterialSpinner()
    @IBOutlet weak var timerBtnView: UIView!
    @IBOutlet weak var timerCV: UICollectionView!
    @IBOutlet weak var musicCV: UICollectionView!
    @IBOutlet weak var ringCV: UICollectionView!
    @IBOutlet weak var btnPlay: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerCV.delegate = self
        timerCV.dataSource = self
        musicCV.delegate = self
        musicCV.dataSource = self
        ringCV.delegate = self
        ringCV.dataSource = self
        setEnvironment()
        getReady()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        if sel_play != 0 {
            Player.pause()
            Player = nil
            self.timer.invalidate()
            self.timer = nil
        }
    }
    func getReady(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        allmusic = []
        Alamofire.request(Global.baseUrl+"getmusics", method: .post).responseJSON{ response in
            if let value = response.value as? [String : AnyObject]{
                self.spinnerView.endRefreshing()
                let status = value["status"] as! String
                if status == "ok"{
                    let musics = value["musics"] as? [[String: Any]]
                    for i in 0 ... musics!.count - 1{
                        let music_id = musics![i]["id"] as! String
                        let music_title = musics![i]["title"] as! String
                        let music_category = musics![i]["category"] as! String
                        let music_url = musics![i]["url"] as! String
                        let music_min = musics![i]["min"] as! String
                        let music_image = musics![i]["image_url"] as! String
                        let musiccell = Music(id: music_id, title: music_title, category: music_category, url: music_url,min: music_min, image_url: music_image)
                        self.allmusic.append(musiccell)
                        self.musicCV.reloadData()
                    }
                }
            }
        }
        
    }
    func setEnvironment(){
        timerBtnView.layer.cornerRadius=18
    }
    
    @IBAction func btn_home(_ sender: UIButton) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeController
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: false, completion: nil)
    }
    
    @IBAction func btn_library(_ sender: UIButton) {
        self.libraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryVC") as? LibraryController
        self.libraryVC.modalPresentationStyle = .fullScreen
        self.present(self.libraryVC, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 101){
            return 4
        }else if(collectionView.tag == 102){
            return allmusic.count
        }else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView.tag == 101){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "cell"), for: indexPath) as! TimerCell
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.layer.borderWidth=2
            if(indexPath.row == sel_timer_index){
                cell.bgView.layer.borderColor = UIColor.red.cgColor
            }else{
                cell.bgView.layer.borderColor = UIColor.white.cgColor
            }
            if(indexPath.row == 0){
                cell.txtLength.text = "RÁPIDA"
                cell.txtTime.text = "15 min"
            }else if(indexPath.row == 1){
                cell.txtLength.text = "MEDIO"
                cell.txtTime.text = "30 min"
            }else if(indexPath.row == 2){
                cell.txtLength.text = "MEDITACIÓN"
                cell.txtTime.text = "45 min"
            }else{
                cell.txtLength.text = "MEDITACIÓN"
                cell.txtTime.text = "1 hour"
            }
            
            return cell
        }else if(collectionView.tag == 102){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "cell"), for: indexPath) as! BMusicCell
            let onemusic: Music
            onemusic = allmusic[indexPath.row]
            
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.layer.borderWidth=2
            cell.bgView.layer.masksToBounds = true
            if(indexPath.row == sel_music_index){
                cell.bgView.layer.borderColor = UIColor.red.cgColor
            }else{
                cell.bgView.layer.borderColor = UIColor.white.cgColor
            }
//            if(onemusic.category == "Relax"){
//                cell.bgImage.image = UIImage.init(named: "relaxbg")
//
//            }
//            if(onemusic.category=="Breath"){
//                cell.bgImage.image = UIImage.init(named: "breathbg")
//            }
//            if(onemusic.category=="Meditation"){
//                cell.bgImage.image = UIImage.init(named: "meditationbg")
//            }
            cell.bgImage.sd_setImage(with: URL(string: onemusic.image_url), completed: nil)
            cell.txtTitle.text = onemusic.title
            cell.txtTime.text = onemusic.min + " MIN"
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "cell"), for: indexPath) as! BellCell
            
            if(indexPath.row == sel_bell_index){
                cell.bgView.layer.borderColor = UIColor.red.cgColor
            }else{
                if(indexPath.row == 0){
                    cell.bgView.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                }else if(indexPath.row == 1){
                    cell.bgView.layer.borderColor = UIColor.white.cgColor
                }else if(indexPath.row == 2){
                    cell.bgView.layer.borderColor = UIColor.white.cgColor
                }
                
            }
            if(indexPath.row == 0){                
                cell.txtTap.text = ""
                cell.txtTitle.text = "None"
                cell.bellImage.image = UIImage(systemName: "bell.slash")
                cell.txtTitle.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                cell.bellImage.tintColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                cell.bgView.layer.cornerRadius = 10
                cell.bgView.layer.borderWidth=2
                cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                
            }else if(indexPath.row == 1){
                cell.txtTap.text = "TAP TO PLAY"
                cell.txtTitle.text = "Aarav"
                cell.bellImage.image = UIImage(systemName: "bell")
                cell.bgView.layer.cornerRadius = 10
                cell.bgView.layer.borderWidth=2
                cell.txtTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.bellImage.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.bgView.backgroundColor = #colorLiteral(red: 0.3335321503, green: 0.8862745166, blue: 0.6028258166, alpha: 1)
            }else{
                cell.txtTap.text = "TAP TO PLAY"
                cell.txtTitle.text = "Gandharv"
                cell.bgView.layer.cornerRadius = 10
                cell.bgView.layer.borderWidth=2
                cell.bellImage.image = UIImage(systemName: "bell")
                cell.txtTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.bellImage.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.bgView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView.tag == 101){
            sel_timer_index = indexPath.row
            timerCV.reloadData()
        }else if(collectionView.tag == 102){
            sel_music_index = indexPath.row
            musicCV.reloadData()
        }else{
            sel_bell_index = indexPath.row
            ringCV.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView.tag == 102){
            let col_height = collectionView.bounds.height
            return CGSize(width: col_height*291/428, height:col_height)
        }else{
            let col_height = collectionView.bounds.height
            return CGSize(width: col_height*1.1, height:col_height)
        }
    }
    
    @IBAction func btn_Play(_ sender: Any) {
        if (sel_play == 0) {
            btnPlay.setImage(UIImage(systemName: "stop"), for: UIControl.State.normal)
            btnPlay.setTitle(" Stop Session", for: UIControl.State.normal)
            sel_play = 1
            soundurl = allmusic[sel_music_index].url
            soundid = allmusic[sel_music_index].id
//            soundurl = "https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav"
            
            let parameters: Parameters = ["userid": Defaults.getNameAndValue(Defaults.USERID_KEY), "musicid" : soundid]
            
            Alamofire.request(Global.baseUrl + "setlastview", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
                self.spinnerView.endRefreshing()
                print(response)
                if let value = response.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                    }else{
                    }
                }else{
                }
            }
            playsound(url: soundurl)
        }else{
            btnPlay.setImage(UIImage(systemName: "play"), for: UIControl.State.normal)
            btnPlay.setTitle(" Start Session", for: UIControl.State.normal)
            sel_play = 0
            stopsound()
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        if(count_time != 0){
            let url = URL(string: soundurl)
            //        let url = URL(fileURLWithPath: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
                do{
                    let playerItem = AVPlayerItem(url: url!)
                    Player = try AVPlayer(playerItem: playerItem)
                    Player.volume = 2.0
                    Player.play()
                } catch{
                    
                }
        }
    }
    
    func playsound(url:String){
        let url = URL(string: url)
        //        let url = URL(fileURLWithPath: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
            do{
                let playerItem = AVPlayerItem(url: url!)
                Player = try AVPlayer(playerItem: playerItem)
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                Player.volume = 2.0
                Player.play()
                self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.fire), userInfo: nil, repeats: true)
            } catch{
                
            }
    }
    func stopsound(){
        Player.pause()
        Player = nil
        count_time = 0
        self.timer.invalidate()
        self.timer = nil
    }
    
    @objc func fire()
    {
        if(count_time == (sel_timer_index + 1) * 15){
            if sel_play != 0{
                Player.pause()
                Player = nil
                count_time = 0
                btnPlay.setImage(UIImage(systemName: "play"), for: UIControl.State.normal)
                btnPlay.setTitle(" Start Session", for: UIControl.State.normal)
                self.timer.invalidate()
                self.timer = nil
                if(sel_bell_index == 1){
                    let path = Bundle.main.resourcePath!+"/aarav.mp3"
                    let url = URL(fileURLWithPath: path)
                    let playerItem = AVPlayerItem(url: url)
                    Player = AVPlayer(playerItem: playerItem)
                    Player.play()
                }else if(sel_bell_index == 2){
                    let path = Bundle.main.resourcePath!+"/gandharv.mp3"
                    let url = URL(fileURLWithPath: path)
                    let playerItem = AVPlayerItem(url: url)
                    Player = AVPlayer(playerItem: playerItem)
                    Player.play()
                }
                
            }
            sel_play = 0
            
        }else{
            count_time = count_time + 1
        }
        print("\(count_time)")
    }

}
