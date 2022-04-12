//
//  ApplicationRow.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 11.04.2022.
//

import WatchKit

final class ApplicationRow: NSObject {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
}

// MARK: - Set

extension ApplicationRow {
    
    @discardableResult
    func set(title: String) -> Self {
        titleLabel.setText(title)
        return self
    }
    
}
