//
//  ViewController.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 6/20/22.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    // Popup buttons outlets
    @IBOutlet weak var mainButton: NSButton!
    @IBOutlet weak var secondaryButton: NSButton!
    
    // Popup text outlets
    @IBOutlet weak var notificationTitle: NSTextField!
    @IBOutlet weak var notificationMessage: NSTextField!
    
    // Popup progress bar outlet
    @IBOutlet weak var notificationIndeterminate: NSProgressIndicator!
    
    
    // We declare the popup variables
    var popupWindowNotificationTitle = String()
    var popupWindowNotificationMessage = String()
    var popupWindowNotificationMainButton = String()
    var popupWindowNotificationSecondaryButton = String()
    var popupWindowNotificationWatch = String()
    
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
                    popupWindowNotificationWatch = commandLineArguments[arg+1]

                /// End of command line cycling
                  default: break
                  }
              }
        
        // Set notification interface values
        self.notificationTitle.stringValue = popupWindowNotificationTitle
        self.notificationMessage.stringValue = popupWindowNotificationMessage.replacingOccurrences(of: "\\n", with: "\n")
        self.mainButton.title = popupWindowNotificationMainButton
        self.secondaryButton.title = popupWindowNotificationSecondaryButton
    }
    
    override func viewDidAppear() {
    }

    override var representedObject: Any? {
        didSet {
        /// Update the view, if already loaded.
        }
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

