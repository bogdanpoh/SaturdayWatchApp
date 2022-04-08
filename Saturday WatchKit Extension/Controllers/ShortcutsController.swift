//
//  ShortcutsController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 29.03.2022.
//

import WatchKit

class ShortcutsController: WKInterfaceController {
    
    struct ShortcutsContext {
        let title: String
        let socketManager: SocketManagerProtocol?
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var shortcutsTable: WKInterfaceTable!
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTitle("Shortcuts")
    }

    override func willActivate() {
        super.willActivate()
        
        NetworkManager.shared.getShortcuts() { [weak self] result in
            switch result {
            case .failure(let error):
                print("[dev] error fetch shortcuts \(error)")
            
            case .success(let shortcutsResponse):
                self?.shortcutsResponse = shortcutsResponse
                self?.setupTable(shortcutsResponse: shortcutsResponse)
            }
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
        
        NetworkManager.shared.postShortcut(shortcut)
    }
    
}
