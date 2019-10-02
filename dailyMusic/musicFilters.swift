//
//  musicFilters.swift
//  dailyMusic
//
//  Created by Chris Lee on 2019-09-29.
//  Copyright © 2019 ChrisLee0727. All rights reserved.
//

import Foundation
import MediaPlayer

let popFilter = MPMediaPropertyPredicate(value: "Pop", forProperty: MPMediaItemPropertyGenre)
let danceFilter = MPMediaPropertyPredicate(value: "Dance", forProperty: MPMediaItemPropertyGenre)
let electornicFilter = MPMediaPropertyPredicate(value: "Electronic", forProperty: MPMediaItemPropertyGenre)
let hiphopFilter = MPMediaPropertyPredicate(value: "Hip-Hop", forProperty: MPMediaItemPropertyGenre)
let hiphoprapFilter = MPMediaPropertyPredicate(value: "Hip-Hop/Rap", forProperty: MPMediaItemPropertyGenre)

let workoutFilterSet: Set<MPMediaPropertyPredicate> = [popFilter, danceFilter, electornicFilter, hiphopFilter, hiphoprapFilter]
