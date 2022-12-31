//
//  ViewController.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 6/20/22.
//

import Cocoa
import Foundation
import UserNotifications

class ViewController: NSViewController {

    // Popup buttons outlets
    @IBOutlet weak var mainButton: NSButton!
    @IBOutlet weak var secondaryButton: NSButton!
    
    // Popup text outlets
    @IBOutlet weak var notificationTitle: NSTextField!
    @IBOutlet weak var notificationMessage: NSTextField!
    
    // Popup progress bar outlet
    @IBOutlet weak var notificationIndeterminate: NSProgressIndicator!
    @IBOutlet weak var notificationIndeterminateLabel: NSTextField!
    
    
    // We declare the popup variables
    var popupWindowNotificationTitle = String()
    var popupWindowNotificationMessage = String()
    var popupWindowNotificationMainButton = String()
    var popupWindowNotificationSecondaryButton = String()
    var popupWindowNotificationWatch = String()
    var popupWindowNotificationWatchStatus = Bool()
    var popupWindowIndeterminateStatus = Bool()
    var popupWindowIndeterminateLabel = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the notifier window the front window
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        // Get command line arguments
        let commandLineArguments = CommandLine.arguments
        
        /// Cycle through CLI input and set all the options
        for arg in 0...(commandLineArguments.count - 1) {
            switch commandLineArguments[arg] {
                case CommandLineParseArguments.title:
                    popupWindowNotificationTitle = commandLineArguments[arg+1]
                case CommandLineParseArguments.message:
                    popupWindowNotificationMessage = commandLineArguments[arg+1]
                case CommandLineParseArguments.mainButton:
                    popupWindowNotificationMainButton = commandLineArguments[arg+1]
                case CommandLineParseArguments.SecondaryButton:
                    popupWindowNotificationSecondaryButton = commandLineArguments[arg+1]
                case CommandLineParseArguments.watch:
                    popupWindowNotificationWatchStatus = true
                    popupWindowNotificationWatch = commandLineArguments[arg+1]
                case CommandLineParseArguments.indeterminate:
                    popupWindowIndeterminateStatus = true
                    popupWindowIndeterminateLabel = commandLineArguments[arg+1]

                /// End of command line cycling
                  default: break
                  }
              }
        
        // Call function to setup app layout
        layoutSetup()
        
    }
    
    override func viewDidAppear() {
        // Lock notification window in the center of the screen
        self.view.window?.isMovable = false
    }

    override var representedObject: Any? {
        didSet {
        /// Update the view, if already loaded.
        }
    }
    
    func layoutSetup() {
        // Set notification title
        self.notificationTitle.stringValue = popupWindowNotificationTitle
        
        // Set notification message
        self.notificationMessage.stringValue = popupWindowNotificationMessage.replacingOccurrences(of: "\\n", with: "\n")
        
        // Set main button label and status
        self.mainButton.title = popupWindowNotificationMainButton
        if popupWindowNotificationWatchStatus == true {
            self.mainButton.isEnabled = false
        }
        
        
        // Set secondary button label and status
        if popupWindowNotificationSecondaryButton != "" {
            self.secondaryButton.title = popupWindowNotificationSecondaryButton
            self.secondaryButton.isHidden = false
        }
        
        // Set indeterminate progress bar status
        if popupWindowIndeterminateStatus == true {
            self.notificationIndeterminate.isHidden = false
            self.notificationIndeterminateLabel.stringValue = popupWindowIndeterminateLabel
            self.notificationIndeterminateLabel.sizeToFit()
            self.notificationIndeterminateLabel.isHidden = false
            self.notificationIndeterminate.startAnimation(self)
        }
    }
    
    func watchFilePath() {
        
    }
    
    // Receive button actions
    
    @IBAction func mainButtonClicked(_ sender: Any) {
        print(0)
        exit(0)
    }
    
    @IBAction func secondaryButtonClicked(_ sender: Any) {
        print(1)
        exit(1)
    }
    
}

