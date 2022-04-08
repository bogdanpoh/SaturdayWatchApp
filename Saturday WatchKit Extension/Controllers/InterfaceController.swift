//
//  InterfaceController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 27.03.2022.
//

import WatchKit

enum MainMenu: Int, CaseIterable {
    case batteryCharg
    case soundLevel
    case brightness
    case mediaControl
    case shortcuts
}

class InterfaceController: WKInterfaceController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mainTable: WKInterfaceTable!
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        NetworkManager.shared.getSystemInfo() { [weak self] result in
            switch result {
            case .failure(let error):
                print("[dev] \(error.localizedDescription)")
                
            case .success(let systemInfo):
                self?.systemInfo = systemInfo
                self?.setTitle(systemInfo.deviceName)
                self?.setupTable(systemInfo: systemInfo)
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    // MARK: - Private
    
    var socketManager: SocketManagerProtocol?
//    var shortcutsResponse: ShortcutsResponse?
    var systemInfo: SystemInfo?

}

// MARK: - Setup

private extension InterfaceController {
    
    func setupTable(systemInfo: SystemInfo) {
        mainTable.setNumberOfRows(MainMenu.allCases.count, withRowType: "MainRow")
        
        for index in 0...MainMenu.allCases.count - 1 {
            if let controller = mainTable.rowController(at: index) as? MainRowController {
                switch(MainMenu(rawValue: index)) {
                case .batteryCharg:
                    controller.set("🔋 \(systemInfo.batteryCharg) ")
                
                case .soundLevel:
                    controller.set("🔊 \(systemInfo.soundLevel)")
                
                case .brightness:
                    controller.set("🖥 \(systemInfo.brightnessLevel)")
                
                case .mediaControl:
                    controller.set("Media control")
                    
                case .shortcuts:
                    controller.set("🚹 Shourtctus")
                    
                case .none:
                    controller.set("Undefinatted")
                }
            }
        }
    }
    
}

// MARK: - User interactions

extension InterfaceController {
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(table, didSelectRowAt: rowIndex)
        
        switch MainMenu(rawValue: rowIndex) {
        case .batteryCharg:
            NetworkManager.shared.postTest()
        
        case .soundLevel:
            guard let systemInfo = systemInfo else { return }
            
            let soundLevelContext = SoundLevelController.SystemInfoContext(
                title: "Sound level",
                systemInfo: systemInfo
            )
            pushController(withName: "SoundLevelController", context: soundLevelContext)
            
        case .brightness:
            let brightnessContext = BrightnessController.BrightnessContext(
                title: "Brightness",
                brightnessLevel: systemInfo?.brightnessLevel
            )
            pushController(withName: "BrightnessController", context: brightnessContext)
            
        case .mediaControl:
            pushController(withName: "MediaController", context: nil)
            
        case .shortcuts:
            pushController(withName: "ShortcutsController", context: nil)
            
        case .none:
            break
        }
    }
    
}
