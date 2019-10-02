//
//  ViewController.swift
//  dailyMusic
//
//  Created by Chris Lee on 2019-09-26.
//  Copyright © 2019 ChrisLee0727. All rights reserved.
//

import UIKit
import MediaPlayer

var logNumber = 0

func log(description: String) {
    print("Log[" + String(logNumber) + "]: ", description)
    logNumber += 1
}

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    var isPlay = false
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    var musicType = ["workout", "chill"]
    var currentMusicType = "default"
    var currentFilterSet: Set<MPMediaPropertyPredicate> = []
    var query = MPMediaQuery()

    
    @IBOutlet weak var musicTypeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if userDefaults.bool(forKey: "authorize") {
            DispatchQueue.main.async {
                if self.isPlay {
                    self.musicPlayer.stop()
                    self.isPlay = false
                } else { // main
                    if first {
                        self.setQuery()
                        first = false
                        log(description: "first, setQuery() \(self.currentMusicType)")
                    }
                    self.musicPlayer.play()
                    self.isPlay = true
                }
            }
        } else {
            log(description: "unauthorized(2)")
        }
    }
        

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        musicPlayer.skipToNextItem()
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        musicPlayer.skipToPreviousItem()
    }
    
    func setQuery() {
        
        //        let workoutFilter = MPMediaPropertyPredicate(value: , forProperty: String)
        
        //        let albumTitleFilter = MPMediaPropertyPredicate(value: "Album Title", forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.equalTo)
        //        let songNameFilter = MPMediaPropertyPredicate(value: "Song Title", forProperty: MPMediaItemPropertyTitle, comparisonType: MPMediaPredicateComparison.contains)
        //
        //        let currentFilterSet: Set<MPMediaPropertyPredicate> = [albumTitleFilter, songNameFilter]
        
        
        switch currentMusicType {
        case musicType[0]:
            currentFilterSet = workoutFilterSet
            query = MPMediaQuery()
        case musicType[1]:
            ()
        default:
            query = MPMediaQuery()
        }
        
        query = MPMediaQuery(filterPredicates: currentFilterSet)
        musicPlayer.setQueue(with: query)
        musicPlayer.shuffleMode = .songs
        musicPlayer.prepareToPlay()
        
        
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
