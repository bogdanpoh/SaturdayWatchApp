//
//  MediaController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 31.03.2022.
//

import WatchKit

class MediaController: WKInterfaceController {
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTitle("Media")
    }

    override func willActivate() {
        super.willActivate()

    }

    override func willDisappear() {
        super.willDisappear()

    }
    
    // MARK: - IBActions
    
    @IBAction func prevAction() {
        sendAction(key: .prev)
    }
    
    @IBAction func playAction() {
        sendAction(key: .play)
    }
    
    @IBAction func nextAction() {
        sendAction(key: .next)
    }
    
    @IBAction func leftAction() {
        sendAction(key: .left)
    }
    
    @IBAction func rightAction() {
        sendAction(key: .right)
    }
    
}

// MARK: - Private Methods

private extension MediaController {
    
    enum MediaKey: String {
        case prev
        case play
        case next
        case left
        case right
    }
    
    func sendAction(key: MediaKey) {
        NetworkManager.shared.postMedia(key.rawValue)
    }
    
}
