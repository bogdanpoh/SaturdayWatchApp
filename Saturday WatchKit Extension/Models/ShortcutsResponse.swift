//
//  ShortcutsResponse.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 28.03.2022.
//

import Foundation

struct ShortcutsResponse: Decodable {
    let count: Int
    let shortcuts: [String]
}
