//
//  ViewController.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 6/20/22.
//

/**
 List of things to do:
 
 - watch list of files from array
 - button actions
 -
 */

import Cocoa
import Foundation
import UserNotifications

var backgroundWindow: SecondWindowController?

class ViewController: NSViewController {
    
    // Action button outlets
    @IBOutlet weak var mainButton: NSButton!
    @IBOutlet weak var secondaryButton: NSButton!
    
    // Notification text and icon outlets
    @IBOutlet weak var notificationIcon: NSImageView!
    @IBOutlet weak var notificationTitle: NSTextField!
    @IBOutlet weak var notificationMessage: NSTextField!
    
    // Help button outlet
    @IBOutlet weak var notificationHelpButton: NSButton!
    
    // Progress bar outlets
    @IBOutlet weak var notificationProgressBar: NSProgressIndicator!
    @IBOutlet weak var notificationProgressBarLabel: NSTextField!
    
    
    // Command line argument variable types
    var popupWindowNotificationBarTitle = String()
    var popupWindowNotificationTitle = String()
    var popupWindowNotificationMessage = String()
    var popupWindowNotificationMainButton = String()
    var popupWindowNotificationSecondaryButton = String()
    var popupWindowNotificationWatchPath = String()
    var popupWindowNotificationWatchStatus = Bool()
    var popupWindowIndeterminateStatus = Bool()
    var popupWindowNotificationIcon = String()
    
    // Notification window options state
    var popupWindowNotificationIsMovable = false
    var popupWindowHelpButtonIsHidden = false
    var useFullScreen = Bool()
    var useCustomNotificationIcon = Bool()
    
    //
    var popupWindowIndeterminateLabel = String()
    var fileToStartWatching = String()
    var watchForFileState = Bool()
    var softwareArrayComplete = Bool()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the notifier window the front window
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        // Get command line arguments
        let commandLineArguments = CommandLine.arguments
        
        /// CycommandLineFore through CLI input and set all the options
        for arg in 0...(commandLineArguments.count - 1) {
            switch commandLineArguments[arg] {
                case CommandLineParseArguments.commandLineForBarTitle:
                    popupWindowNotificationBarTitle = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForTitle:
                    popupWindowNotificationTitle = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForMessage:
                    popupWindowNotificationMessage = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForPopupIcon:
                    useCustomNotificationIcon = true
                    popupWindowNotificationIcon = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForMainButton:
                    popupWindowNotificationMainButton = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForSecondaryButton:
                    popupWindowNotificationSecondaryButton = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForWatchForFile:
                    watchForFileState = true
                    fileToStartWatching = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForWatchForFileLabel:
                    popupWindowIndeterminateLabel = commandLineArguments[arg+1]
                case CommandLineParseArguments.commandLineForDisplayFullScreen:
                    useFullScreen = true
                case CommandLineParseArguments.commandLineForHelpButton:
                    popupWindowHelpButtonIsHidden = true
                    
                default: break
            }
        }
        
        layoutSetup()
        
        
        
        if watchForFileState {
            startWatchingForFile(pathToWatch: fileToStartWatching, label: popupWindowIndeterminateLabel)
        }
        
    }
    
    
    override func viewDidAppear() {
        
        if popupWindowNotificationBarTitle != "" {
            self.view.window?.title = popupWindowNotificationBarTitle
        }
        
        if popupWindowHelpButtonIsHidden {
            self.notificationHelpButton.isHidden = true
        }
        
        if popupWindowNotificationIsMovable {
            self.view.window?.isMovable = true
        } else {
            self.view.window?.isMovable = false
        }
        
        if useFullScreen {
            displayBackgroundWindow()
        }
        
    }

    override var representedObject: Any? {
        didSet {
        /// Update the view, if already loaded.
        }
    }
    
    
    /**
     Below the functions we call during the app execution
     
     */
    
    func layoutSetup() {
        
        if popupWindowNotificationTitle != "" {
            self.notificationTitle.stringValue = popupWindowNotificationTitle
        }
        
        if popupWindowNotificationMessage != "" {
            self.notificationMessage.stringValue = popupWindowNotificationMessage.replacingOccurrences(of: "\\n", with: "\n")
        }
        
        if popupWindowNotificationMainButton != "" {
            self.mainButton.title = popupWindowNotificationMainButton
        }
        
        if popupWindowNotificationWatchStatus == true {
            self.mainButton.isEnabled = false
        }
        
        if popupWindowNotificationSecondaryButton != "" {
            self.secondaryButton.title = popupWindowNotificationSecondaryButton
            self.secondaryButton.isHidden = false
        }
        
        if useCustomNotificationIcon {
            if #available(macOS 11.0, *) {
                let symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 72, weight: .light)
                notificationIcon.symbolConfiguration = symbolConfiguration
                notificationIcon.image = NSImage(systemSymbolName: popupWindowNotificationIcon, accessibilityDescription: nil)
            } else {
                notificationIcon.image = NSImage(named: "NSCaution")
            }

        } else {
            if #available(macOS 11.0, *) {
                let symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 72, weight: .light)
                notificationIcon.symbolConfiguration = symbolConfiguration
                notificationIcon.image = NSImage(systemSymbolName: AppBundleDefaults.notificationIcon, accessibilityDescription: nil)
            } else {
                notificationIcon.image = NSImage(named: "NSCaution")
            }
        }
    }

    func startWatchingForFile(pathToWatch: String, label: String) {

        mainButton.isEnabled = false
        notificationProgressBarLabel.stringValue = label
        notificationProgressBarLabel.isHidden = false
        notificationProgressBar.doubleValue = 0
        notificationProgressBar.maxValue = 1
        notificationProgressBar.isIndeterminate = true
        notificationProgressBar.isHidden = false
        notificationProgressBar.startAnimation(self)

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                let pathToWatch = FileManager.default.fileExists(atPath: pathToWatch)
                if pathToWatch == true {

                self.notificationProgressBar.isIndeterminate = false
                self.notificationProgressBar.doubleValue = 1
                self.mainButton.isEnabled = true
        
                self.notificationProgressBarLabel.stringValue = "Proceso completo."
                timer.invalidate()
            }
        }
    }
    
    func updateProgressBarLabel(label: String) {
        notificationProgressBarLabel.isHidden = false
        notificationProgressBarLabel.stringValue = label
    }
    
    func initProgressBar(stepsCount:Int) {
        // Disable main and secondary buttons
        mainButton.isEnabled = false
        secondaryButton.isEnabled = false
        
        // Enable progress bar
        notificationProgressBar.isIndeterminate = true
        notificationProgressBar.startAnimation(self)
        notificationProgressBar.maxValue = Double(stepsCount)
        notificationProgressBar.doubleValue = 0
        notificationProgressBar.isHidden = false
        
    }
    
    func incrementProgressBar() {
        notificationProgressBar.isIndeterminate = false
        notificationProgressBar.increment(by: 1)
    }
    
    /// Display a blurred background window
    func displayBackgroundWindow() {
        NSApp.activate(ignoringOtherApps: true)
        self.view.window?.makeKeyAndOrderFront(self)
        
        backgroundWindow = storyboard?.instantiateController(withIdentifier: "BackgroundWindowController") as? SecondWindowController
        backgroundWindow?.showWindow(self)
        backgroundWindow?.sendBack()
        NSApp.windows[0].level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
    }
    

    @IBAction func mainButtonClicked(_ sender: Any) {
        print("0")
        NSApp.terminate(self)
    }
    
    @IBAction func secondaryButtonClicked(_ sender: Any) {
        print("2")
        NSApp.terminate(self)
    }
    
    
}
