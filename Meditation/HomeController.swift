//
//  HomeController.swift
//  Meditation
//
//  Created by Admin on 3/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import JTMaterialSpinner
import SDWebImage
class HomeController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var recentView: UIView!
    @IBOutlet weak var genreCV: UICollectionView!
    @IBOutlet weak var homeBtnView: UIView!
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var playView: UIView!
    var Player : AVPlayer!
    var libraryVC: LibraryController!
    var timerVC : TimerController!
    var selectVC : SelectController!
    var allmusic = [Music]()
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        super.viewDidLoad()
        genreCV.delegate=self
        genreCV.dataSource=self
        setEnvironment()
        getReady()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        if(Defaults.getNameAndValue(Defaults.SELSTATUS_KEY) != "no"){
            Player.pause()
            Player = nil
            Defaults.save("no", with: Defaults.SELINDEX_KEY)
            Defaults.save("no", with: Defaults.SELSTATUS_KEY)
        }
        
    }
    
    func setEnvironment(){
        recentView.layer.cornerRadius=20
        menuView.layer.cornerRadius=20
        homeBtnView.layer.cornerRadius=18
        lastView.layer.cornerRadius = 20
        lastView.layer.masksToBounds = true
        playView.layer.cornerRadius = 20
        playView.layer.masksToBounds = true
    }
    
    func getReady(){
        allmusic=[]
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        Alamofire.request(Global.baseUrl+"getmusics", method: .post).responseJSON{ response in
            print(response)
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
                        self.genreCV.reloadData()
                    }
                }
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allmusic.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "cell"), for: indexPath) as! GenreCell
        cell.bgView.layer.cornerRadius=20
        cell.bgView.layer.masksToBounds=true
        let onemusic: Music
        onemusic = allmusic[indexPath.row]
        cell.bgImge.sd_setImage(with: URL(string: onemusic.image_url), completed: nil)
//        if(onemusic.category == "Relax"){
//            cell.bgImge.image = UIImage.init(named: "relaxbg")
//        }
//        if(onemusic.category=="Breath"){
//            cell.bgImge.image = UIImage.init(named: "breathbg")
//        }
//        if(onemusic.category=="Meditation"){
//            cell.bgImge.image = UIImage.init(named: "meditationbg")
//        }
        cell.txtTitle.text = onemusic.title
        cell.txtMin.text = onemusic.min + " MIN"
        if(Defaults.getNameAndValue(Defaults.SELINDEX_KEY) == "\(indexPath.row)"){
            cell.btnPlay.image = UIImage(systemName: "stop.circle")
        }else{
            cell.btnPlay.image = UIImage(systemName: "play.circle")
        }
//        cell.btnPlay.addTarget(self, action: #selector(editButtonTapped), for: UIControl.Event.touchUpInside)
//        cell.btnPlay.tag = indexPath.row
//        cell.btnPlay.isUserInteractionEnabled = true
//        cell.bgImge.layer.cornerRadius=10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = genreCV.cellForItem(at: indexPath) as! GenreCell
        if(Defaults.getNameAndValue(Defaults.SELINDEX_KEY) == "\(indexPath.row)"){
            cell.btnPlay.image = UIImage(systemName: "play.circle")
            Defaults.save("no", with: Defaults.SELINDEX_KEY)
            Defaults.save("no", with: Defaults.SELSTATUS_KEY)
            stopsound()
            
        }else{
            cell.btnPlay.image = UIImage(systemName: "stop.circle")
            Defaults.save("\(indexPath.row)", with: Defaults.SELINDEX_KEY)
            Defaults.save("yes", with: Defaults.SELSTATUS_KEY)
            playsound(url: allmusic[indexPath.row].url)
        }
        
        genreCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.height*0.3*291/428, height:UIScreen.main.bounds.size.height*0.3)
    }
    
    @IBAction func btn_library(_ sender: UIButton) {
        self.libraryVC = self.storyboard?.instantiateViewController(withIdentifier: "LibraryVC") as? LibraryController
        self.libraryVC.modalPresentationStyle = .fullScreen
        self.present(self.libraryVC, animated: false, completion: nil)
    }
    
    
    @IBAction func btn_Timer(_ sender: Any) {
        self.timerVC = self.storyboard?.instantiateViewController(withIdentifier: "TimerVC") as? TimerController
        self.timerVC.modalPresentationStyle = .fullScreen
        self.present(self.timerVC, animated: false, completion: nil)
    }
    
    @IBAction func btn_Play(_ sender: Any) {
        let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
//        let url = URL(fileURLWithPath: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
        do{
            let playerItem = AVPlayerItem(url: url!)
            Player = try AVPlayer(playerItem: playerItem)
            Player.volume = 2.0
            Player.play()
        } catch{
            
        }
        
    }
    
    @IBAction func home_btn(_ sender: Any) {
        self.selectVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectVC") as? SelectController
        self.selectVC.modalPresentationStyle = .fullScreen
        self.present(self.selectVC, animated: false, completion: nil)
    }
    
    
    func playsound(url:String){
        let url = URL(string: url)
        //        let url = URL(fileURLWithPath: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
            do{
                let playerItem = AVPlayerItem(url: url!)
                Player = try AVPlayer(playerItem: playerItem)
                Player.volume = 2.0
                Player.play()
            } catch{
                
            }
    }
    func stopsound(){
        Player.pause()
        Player = nil
    }
}
