//
//  KidsController.swift
//  Meditation
//
//  Created by Admin on 24/04/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import JTMaterialSpinner

class KidsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var allmusic = [Music]()
    var filtermusic = [Music]()
    var Player : AVPlayer!
    let searchController = UISearchController(searchResultsController: nil)
    var spinnerView = JTMaterialSpinner()
    var timer : Timer! = nil
    var count_time = 0
    var sel_play = 0
    @IBOutlet weak var musicTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        musicTB.delegate = self
        musicTB.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search music"
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        musicTB.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        getReady()
    }
    func getReady(){
        allmusic = []
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        Alamofire.request(Global.baseUrl+"getmusics", method: .post).responseJSON{ response in
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String : AnyObject]{
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
                        self.musicTB.reloadData()
                    }
                }
            }
        }
        
    }
    
    @IBAction func home_Btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func filterProduct(for searchText: String) {
        filtermusic = allmusic.filter { player in
            return player.title.lowercased().contains(searchText.lowercased())
        }
        musicTB.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filtermusic.count
        }
        return allmusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.musicTB.dequeueReusableCell(withIdentifier: "cell") as! MusicCell
        let onemusic: Music
        if searchController.isActive && searchController.searchBar.text != "" {
            onemusic = filtermusic[indexPath.row]
        } else {
            onemusic = allmusic[indexPath.row]
        }
        
        cell.bgView.layer.cornerRadius = 20
        cell.bgView.layer.masksToBounds = true
        cell.playView.layer.cornerRadius = 20
        cell.playView.layer.masksToBounds = true
//        if(onemusic.category == "Relax"){
//            cell.bgimage.image = UIImage.init(named: "relaxbbg")
//        }
//        if(onemusic.category=="Breath"){
//            cell.bgimage.image = UIImage.init(named: "breathbbg")
//        }
//        if(onemusic.category=="Meditation"){
//            cell.bgimage.image = UIImage.init(named: "meditationbbg")
//        }
        cell.bgimage.sd_setImage(with: URL(string: onemusic.image_url), completed: nil)
        cell.txtTitle.text = onemusic.title
        cell.txtMin.text = onemusic.min + " min"
        cell.txtLevel.text = "Principiante"
        cell.btnPlay.image = UIImage(systemName: "play")
        if(Defaults.getNameAndValue(Defaults.SELINDEX_KEY) == onemusic.id){
            cell.btnPlay.image = UIImage(systemName: "stop")
        }else{
            cell.btnPlay.image = UIImage(systemName: "play")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = musicTB.cellForRow(at: indexPath) as! MusicCell
        
        let onemusic: Music
        if searchController.isActive && searchController.searchBar.text != "" {
            onemusic = filtermusic[indexPath.row]
        } else {
            onemusic = allmusic[indexPath.row]
        }
        
        if(Defaults.getNameAndValue(Defaults.SELINDEX_KEY) == onemusic.id){
            cell.btnPlay.image = UIImage(systemName: "play.circle")
            Defaults.save("no", with: Defaults.SELINDEX_KEY)
            Defaults.save("no", with: Defaults.SELSTATUS_KEY)
            stopsound()
            
        }else{
            cell.btnPlay.image = UIImage(systemName: "stop.circle")
            Defaults.save(onemusic.id, with: Defaults.SELINDEX_KEY)
            Defaults.save("yes", with: Defaults.SELSTATUS_KEY)
            playsound(url: allmusic[indexPath.row].url)
        }
        
        musicTB.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
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
        } catch{
            
        }
    }
    func stopsound(){
        Player.pause()
        Player = nil
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        Defaults.save("no", with: Defaults.SELINDEX_KEY)
        Defaults.save("no", with: Defaults.SELSTATUS_KEY)
        musicTB.reloadData()
    }
}
extension KidsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterProduct(for: searchController.searchBar.text ?? "")
    }
}
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
