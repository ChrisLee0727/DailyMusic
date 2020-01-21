//
//  ViewController.swift
//  dailyMusic
//
//  Created by Chris Lee on 2019-09-26.
//  Copyright © 2019 ChrisLee0727. All rights reserved.
//

import UIKit
import MediaPlayer

//var songSet: Bool = false

var logNumber = 0

func log(description: String) {
    print("Log[" + String(logNumber) + "]: ", description)
    logNumber += 1
}

//func getSongs()->[MPMediaItemCollection] {
//
//    let songsQuery = MPMediaQuery.songs() //Gets the query
//    let songs = songsQuery.collections //Gets the songs
//
//    if songs != nil {
//        return songs! // Return songs if they exist
//
//    } else {
//        return [] // Return failed
//    }
//
//}
//
//func setSong(song:String) -> Bool { // Pass name of song
//
//    let songs = getSongs() // Get all songs
//    for sng in songs { // Look for song
//        if String(describing: sng.value(forProperty: MPMediaItemPropertyTitle)!) == song { // If you found it
//            MPMusicPlayerController.systemMusicPlayer.setQueue(with: sng) // Set it
//            songSet = true // Set correctly
//            break
//        }
//    }
//
//    return songSet // Return if you set it correctly
//}
//
//func getSongNames() -> [String]{
//
//    var names = [String]()
//    let songs = getSongs()
//    for song in songs {
//        names.append("\(song.value(forProperty: MPMediaItemPropertyTitle)!)")
//    }
//
//    return names
//}

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    var isPlay = false
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    var musicType = ["workout", "chill"]
    var currentMusicType = "default"
    var currentFilterSet: Set<MPMediaPropertyPredicate> = []
    var query = MPMediaQuery()

    var currentTime = ""
    
    
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var musicAlbumArtwork: UIImageView!
    @IBOutlet weak var playBtn: UIButton!

    
    @IBOutlet weak var musicTypeControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeAI()
        
        if !userDefaults.bool(forKey: "authorize") {
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.userDefaults.set(true, forKey: "authorize")
                    log(description: "authroized")
                } else {
                    log(description: "unauthordized(1)")
                }
            }
        }
                
        musicTypeControl.selectedSegmentIndex = 0
        currentMusicType = musicType[0]
    }
    
    @IBAction func musicTypeControlChanged(_ sender: Any) {
        
        switch musicTypeControl.selectedSegmentIndex {
            
        case 0:
            currentMusicType = musicType[0]
            log(description: "music type changed \(musicType[0])")
        case 1:
            currentMusicType = musicType[1]
            log(description: "music type changed \(musicType[1])")

        default:
            currentMusicType = musicType[0]
            log(description: "music type changed \(musicType[0])")
        }
        
        setQuery()
        
    }
    
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if userDefaults.bool(forKey: "authorize") {
            DispatchQueue.main.async {
                if self.isPlay {
                    self.playBtn.setTitle("Play", for: .normal)

                    self.musicPlayer.stop()
                    self.isPlay = false
                    self.refreshItems()
                } else { // main
                    self.playBtn.setTitle("Pause", for: .normal)

                    if first {
                        self.setQuery()
                        first = false
                        log(description: "first, setQuery() \(self.currentMusicType)")
                        self.refreshItems()
                    }
                    
                    self.musicPlayer.play()
                    self.refreshItems()
                    self.isPlay = true
                }
            }
        } else {
            log(description: "unauthorized(2)")
        }
        self.refreshItems()
        self.refreshItems()
        self.refreshItems()

    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.playBtn.setTitle("Pause", for: .normal)
        musicPlayer.skipToNextItem()
        musicPlayer.play()
        self.refreshItems()
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        self.playBtn.setTitle("Pause", for: .normal)
        musicPlayer.skipToPreviousItem()
        musicPlayer.play()
        self.refreshItems()
    }
    
    func setQuery() {
        self.refreshItems()
        
        //        let workoutFilter = MPMediaPropertyPredicate(value: , forProperty: String)
        
        //        let albumTitleFilter = MPMediaPropertyPredicate(value: "Album Title", forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.equalTo)
        //        let songNameFilter = MPMediaPropertyPredicate(value: "Song Title", forProperty: MPMediaItemPropertyTitle, comparisonType: MPMediaPredicateComparison.contains)
        //
        //        let currentFilterSet: Set<MPMediaPropertyPredicate> = [albumTitleFilter, songNameFilter]
        
        
        switch currentMusicType {
        case musicType[0]:
            currentFilterSet = workoutFilterSet
//            query = MPMediaQuery()
        case musicType[1]:
            ()
        default:
            query = MPMediaQuery()
        }
        
        query = MPMediaQuery(filterPredicates: currentFilterSet)
        musicPlayer.setQueue(with: query)
        musicPlayer.shuffleMode = .songs
        musicPlayer.prepareToPlay()
        self.refreshItems()

        
    }
    
    
    func refreshItems() {
        self.musicPlayer.prepareToPlay()
        
        self.musicAlbumArtwork.image = self.musicPlayer.nowPlayingItem?.artwork?.image(at: self.musicAlbumArtwork.bounds.size)
        self.musicTitleLabel.text = self.musicPlayer.nowPlayingItem?.title
        print(self.musicTitleLabel.text)
        self.view.layoutIfNeeded()
        self.view.reloadInputViews()

    }
    
    
    
    
    
    
    func timeAI() {
        let now=NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        currentTime = dateFormatter.string(from: now as Date)
        
        if 5 <= Int(currentTime)! && Int(currentTime)! <= 11 {
            switch arc4random_uniform(3){
            case 0:
                musicTitleLabel.text = "Good Morning."
            case 1:
                musicTitleLabel.text = "Did u eat breakfast?"
                
            case 2:
                musicTitleLabel.text = "Have a great day!"
                
            default:
                musicTitleLabel.text = "Nice to meet you"
            }
        }
        else if 12 <= Int(currentTime)! && Int(currentTime)! <= 17 {
            switch arc4random_uniform(3){
            case 0:
                musicTitleLabel.text = "Good Afternoon."
            case 1:
                musicTitleLabel.text = "Did u eat lunch?"
                
            case 2:
                musicTitleLabel.text = "How is your day going?"
                
            default:
                musicTitleLabel.text = "Glad to meet you"
            }
        }
        else if 17 <= Int(currentTime)! && Int(currentTime)! <= 20 {
            switch arc4random_uniform(3){
            case 0:
                musicTitleLabel.text = "Good Evening."
            case 1:
                musicTitleLabel.text = "Did u eat dinner?"
                
            case 2:
                musicTitleLabel.text = "How was your day?"
                
            default:
                musicTitleLabel.text = "Glad to meet you"
            }
        }
        else if 20 <= Int(currentTime)! && Int(currentTime)! <= 24 {
            switch arc4random_uniform(3){
            case 0:
                musicTitleLabel.text = "Good Night."
            case 1:
                musicTitleLabel.text = "How was your day?"
                
            case 2:
                musicTitleLabel.text = "Well done, U made the day"
                
            default:
                musicTitleLabel.text = "Glad to meet you"
            }
        }
        else if 0 <= Int(currentTime)! && Int(currentTime)! <= 5 {
            switch arc4random_uniform(3){
            case 0:
                musicTitleLabel.text = "You should sleep."
            case 1:
                musicTitleLabel.text = "What's wrong or having fun?"
                
            case 2:
                musicTitleLabel.text = "Cheer up"
                
            default:
                musicTitleLabel.text = "Glad to meet you"
            }
        }
        
        // Good Morning
        // 5 ~ 7
            //chill
        // 7 ~ 8
            //chill + workout
        // 8 ~ 11
            // workout
        
        // Lunch
        // 11 ~ 13
            //workout : did u eat launch?
    }
}



//func playGenre(genre: String) {
//
//    let query = MPMediaQuery()
//    let predicate = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
//
//    query.addFilterPredicate(predicate)
//
//    musicPlayer.setQueue(with: query)
//    musicPlayer.shuffleMode = .songs
//    musicPlayer.play()
//}
//DispatchQueue.main.async {
//    self.playGenre(genre: sender.currentTitle!)
//}
