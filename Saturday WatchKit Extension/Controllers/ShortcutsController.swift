//
//  ShortcutsController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 29.03.2022.
//

import WatchKit

class ShortcutsController: WKInterfaceController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var shortcutsTable: WKInterfaceTable!
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTitle("Shortcuts")
    }

    override func willActivate() {
        super.willActivate()
        
        NetworkManager.shared.request(type: GetShortcuts()) { [weak self] (response: ShortcutsResponse?, error: Error?) in
            guard error == nil else {
                print("[dev] shortcuts error: \(error!)")
                return
            }
            
            guard let response = response else { return }
            self?.shortcutsResponse = response
            self?.setupTable(shortcutsResponse: response)
        }
    }

    override func willDisappear() {
        super.willDisappear()

    }
    
    // MARK: - Private

    private var shortcutsResponse: ShortcutsResponse?
    
}

// MARK: - Setup

private extension ShortcutsController {
    
    func setupTable(shortcutsResponse: ShortcutsResponse) {
        shortcutsTable.setNumberOfRows(shortcutsResponse.count, withRowType: "ShortcutRow")
        
        for (index, shortcutName) in shortcutsResponse.shortcuts.enumerated() {
            if let controller = shortcutsTable.rowController(at: index) as? ShortcutsRowController {
                controller.set(shortcutName)
            }
        }
    }
    
}

// MARK: - User interactions

extension ShortcutsController {
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(table, didSelectRowAt: rowIndex)
        guard let shortcutsResponse = shortcutsResponse else { return }
        let shortcut = shortcutsResponse.shortcuts[rowIndex]
        
        NetworkManager.shared.request(type: PostShortcut(shortcut: shortcut)) { (response: ServerResponse?, error: Error?) in
            guard error == nil else {
                print("[dev] \(error!)")
                return
            }
            
            guard let response = response else { return }
            print("[dev] message: \(response.message)")
        }
    }
    
}
