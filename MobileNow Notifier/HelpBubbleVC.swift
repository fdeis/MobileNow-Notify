//
//  HelpBubbleVC.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 3/1/23.
//

import Cocoa
import Foundation

class HelpBubbleViewController: NSViewController {

    /// Notification outlets
    @IBOutlet weak var helpBubbleDescription: NSTextField!
    
    var helpTitle = String()
    var helpDescription = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        if helpDescription == "" {
            helpBubbleDescription.stringValue = HelpBubbleDefaults.helpBubbleDescriptionDefaults
        } else {
            helpBubbleDescription.stringValue = helpDescription
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
