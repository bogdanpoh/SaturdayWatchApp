//
//  ShortcutsTable.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 27.03.2022.
//

import WatchKit

final class ShortcutsRowController: NSObject {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
}

// MARK: - Set

extension ShortcutsRowController {
    
    func set(_ title: String) {
        titleLabel.setText(title)
    }
    
}
