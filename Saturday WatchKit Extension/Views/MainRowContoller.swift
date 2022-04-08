//
//  MainRowContoller.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 28.03.2022.
//

import WatchKit

final class MainRowController: NSObject {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainLabel: WKInterfaceLabel!
    
}

// MARK: - Setup

extension MainRowController {
    
    func set(_ title: String) {
        mainLabel.setText(title)
    }
    
}
