//
//  BackgroundWindowController.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 2/9/23.
//

import Cocoa
import Foundation

class SecondWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let backgroundWindow = self.window {
            let mainDisplayRect = NSScreen.main?.frame
            backgroundWindow.contentRect(forFrameRect: mainDisplayRect!)
            backgroundWindow.setFrame((NSScreen.main?.frame)!, display: true)
            backgroundWindow.setFrameOrigin((NSScreen.main?.frame.origin)!)
            backgroundWindow.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow) - 1 ))
        }
    }
    
    func sendBack() {
        self.window?.orderBack(self)
    }
}
