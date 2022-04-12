//
//  BrightnessController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 29.03.2022.
//

import WatchKit

class BrightnessController: WKInterfaceController {
    
    struct BrightnessContext {
        let title: String
        let brightnessLevel: Int?
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var statusLabel: WKInterfaceLabel!
    @IBOutlet weak var brightnessSwitch: WKInterfaceSwitch!
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let context = context as? BrightnessContext else { return }
        
        brightnessContext = context
        setTitle(context.title)
    }
    
    override func willActivate() {
        super.willActivate()
        
        setValue(value: brightnessContext?.brightnessLevel ?? 0)
    }
    
    override func willDisappear() {
        super.willDisappear()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func valueChanged(_ value: Bool) {
        setValue(value: value ? 100 : 0)
        
        NetworkManager.shared.request(type: PostBrightness(value: value ? 1 : 0)) { (response: ServerResponse?, error: Error?) in
            guard error == nil else {
                print("[dev] \(error!)")
                return
            }
            
            guard let response = response else { return }
            print("[dev] message: \(response.message)")
        }
    }
    
    // MARK: - Private
    
    var brightnessContext: BrightnessContext?
    
}

private extension BrightnessController {
    
    func setValue(value: Int) {
        let isOn: Bool = value == 100
        statusLabel.setText(isOn ? "☀️" : "🌙")
        brightnessSwitch.setOn(isOn)
    }
    
}
