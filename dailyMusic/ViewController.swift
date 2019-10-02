//
//  ViewController.swift
//  dailyMusic
//
//  Created by Chris Lee on 2019-09-26.
//  Copyright © 2019 ChrisLee0727. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    var logNumber = 0
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
                    print("Log[" + String(self.logNumber) + "]: authorized")
                    self.logNumber += 1
                } else {
                    print("Log[" + String(self.logNumber) + "]: unauthorized(1)")
                    self.logNumber += 1
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
            print("Log[" + String(self.logNumber) + "]: music type changed: <" + musicType[0] + ">")
            self.logNumber += 1
        case 1:
            currentMusicType = musicType[1]
            print("Log[" + String(self.logNumber) + "]: music type changed: <" + musicType[1] + ">")
            self.logNumber += 1
        default:
            currentMusicType = musicType[0]
            print("Log[" + String(self.logNumber) + "]: music type changed: <" + musicType[0] + ">")
            self.logNumber += 1
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
                        print("Log[" + String(self.logNumber) + "]: first, setQuery()," + self.currentMusicType)
                        self.logNumber += 1
                    }
                    self.musicPlayer.play()
                    self.isPlay = true
                }
            }
        } else {
            print("Log[" + String(self.logNumber) + "]: unauthorized(2)")
            self.logNumber += 1
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
