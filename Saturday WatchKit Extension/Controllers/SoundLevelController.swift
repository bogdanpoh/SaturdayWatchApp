//
//  SoundLevelController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 28.03.2022.
//

import WatchKit

class SoundLevelController: WKInterfaceController {
    
    struct SystemInfoContext {
        let title: String
        let systemInfo: SystemInfo
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var soundLevelLabel: WKInterfaceLabel!
    @IBOutlet weak var slider: WKInterfaceSlider!
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let context = context as? SystemInfoContext else { return }
        systemInfoContext = context
        setTitle(systemInfoContext?.title)
    }
    
    override func willActivate() {
        super.willActivate()
        
        let currentSoundLevel = Int(systemInfoContext?.systemInfo.soundLevel ?? 0) / 10
        setValue(currentSoundLevel)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
    // MARK: - Private
    
    private var systemInfoContext: SystemInfoContext?
    
    // MARK: - IBActions
    
    @IBAction func changeValue(_ value: Float) {
        let intValue = Int(value)
        
        setValue(intValue)
        NetworkManager.shared.postVolume(String(intValue))
    }
    
}

private extension SoundLevelController {
    
    func setValue(_ value: Int) {
        soundLevelLabel.setText("\(value)")
        slider.setValue(Float(value))
    }
    
}
