//
//  SystemInfo.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 28.03.2022.
//

import Foundation

struct SystemInfo: Decodable {
    let deviceName: String
    let batteryCharg: String
    let soundLevel: Int
    let brightnessLevel: Int
}
