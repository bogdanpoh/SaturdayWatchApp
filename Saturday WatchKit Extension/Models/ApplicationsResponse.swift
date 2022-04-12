//
//  ApplicationsResponse.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 11.04.2022.
//

import Foundation

struct ApplicationsResponse: Decodable {
    let count: Int
    let applications: [String]
}
