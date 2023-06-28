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
import os

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
    @IBOutlet weak var notificationProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var notificationProgressIndicatorLabel: NSTextField!
    
    
    
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
    var mainButtonAction = String()
    
    // Notification window options state
    var popupWindowNotificationIsMovable = false
    var helpButtonIsVisible = false
    var popupWindowHelpButtonDescription = String()
    var useFullScreenApp = Bool()
    var useCustomNotificationIcon = Bool()
    var mainButtonActionType = String()
    
    //
    var popupWindowIndeterminateLabel = String()
    var fileToStartWatching = String()
    
    //
    let logger = Logger(subsystem: "mobi.mobilenow.MobileNow-Notifier", category: "Action")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the notifier window the front window
        NSApp.activate(ignoringOtherApps: true)
        //NSApp.windows[0].makeKeyAndOrderFront(self)
        
        // Get command line arguments
        let commandLineArguments = CommandLine.arguments
        
        /// CycommandLineFore through CLI input and set all the options
        for arg in 0...(commandLineArguments.count - 1) {
            switch commandLineArguments[arg] {
                // Seets the app title
                case CommandLineParseArguments.commandLineForBarTitle:
                    popupWindowNotificationBarTitle = commandLineArguments[arg+1]
                
                // Sets the notification title
                case CommandLineParseArguments.commandLineForTitle:
                    popupWindowNotificationTitle = commandLineArguments[arg+1]
                    
                // Sets the notification message
                case CommandLineParseArguments.commandLineForMessage:
                    popupWindowNotificationMessage = commandLineArguments[arg+1]
                
                // Sets the nofiticaion alert icon
                case CommandLineParseArguments.commandLineForIcon:
                    useCustomNotificationIcon = true
                    popupWindowNotificationIcon = commandLineArguments[arg+1]
                
                // Sets the main button label
                case CommandLineParseArguments.commandLineForMainButton:
                    popupWindowNotificationMainButton = commandLineArguments[arg+1]
                
                // Shows seconday button and sets the secondary button label
                case CommandLineParseArguments.commandLineForSecondaryButton:
                    popupWindowNotificationSecondaryButton = commandLineArguments[arg+1]
                
                // Sets the notification app to use full screen
                case CommandLineParseArguments.commandLineForDisplayFullScreen:
                    useFullScreenApp = true
                
                // Shows the help button and sets the description text
                case CommandLineParseArguments.commandLineForHelpButton:
                    helpButtonIsVisible = true
                    popupWindowHelpButtonDescription = commandLineArguments[arg+1]
                
                // Sets the action for the main button
                case CommandLineParseArguments.commandLineForMainButtonAction:
                    mainButtonAction = commandLineArguments[arg+1]
                    
                case CommandLineParseArguments.commandLineForActionType:
                    mainButtonActionType = commandLineArguments[arg+1]
        
                default: break
            }
        }
        
        layoutSetup()
    
        
    }
    
    
    override func viewDidAppear() {
        
        /// Move window to topmost position and keep there
        view.window?.level = .floating

        
        if popupWindowNotificationBarTitle != "" {
            self.view.window?.title = popupWindowNotificationBarTitle
        }
        
        if helpButtonIsVisible {
            self.notificationHelpButton.isHidden = false
        }
        
        if popupWindowNotificationIsMovable {
            self.view.window?.isMovable = true
        } else {
            self.view.window?.isMovable = false
        }
        
        if useFullScreenApp == true {
            displayBackgroundWindow()
        }
        
        // Check if the Mac is enrolled in MobileNow
        let macIsEnrolled = checkMobileNowSubscription()
        if !macIsEnrolled {
            let alert = NSAlert()
            alert.messageText = MobileNowSubscriptionAlert.alertTitle
            alert.informativeText = MobileNowSubscriptionAlert.alertText
            alert.alertStyle = .warning
            alert.addButton(withTitle: MobileNowSubscriptionAlert.alertButton)
            alert.beginSheetModal(for: NSApp.windows[0]) { response in NSApp.terminate(self)}
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
                let symbolConfiguration = NSImage.SymbolConfiguration(pointSize: AppBundleDefaults.notificationIconSize, weight: AppBundleDefaults.notificationIconWeight)
                notificationIcon.symbolConfiguration = symbolConfiguration
                
                notificationIcon.image = NSImage(systemSymbolName: popupWindowNotificationIcon, accessibilityDescription: nil)
            } else {
                notificationIcon.image = NSImage(named: "NSCaution")
            }

        } else {
            if #available(macOS 11.0, *) {
                let symbolConfiguration = NSImage.SymbolConfiguration(pointSize: AppBundleDefaults.notificationIconSize, weight: AppBundleDefaults.notificationIconWeight)
                notificationIcon.symbolConfiguration = symbolConfiguration
                notificationIcon.image = NSImage(systemSymbolName: AppBundleDefaults.notificationIcon, accessibilityDescription: nil)
            } else {
                notificationIcon.image = NSImage(named: "NSCaution")
            }
        }
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
    
    /// Display progress indicator
    
    func displayProgressIndicator(displayIndicator: Bool) {
        if displayIndicator {
            notificationProgressIndicator.startAnimation(self)
            
            notificationProgressIndicatorLabel.stringValue = "Ejecutando comando..."
            
            notificationProgressIndicator.isHidden = false
            notificationProgressIndicatorLabel.isHidden = false
            
        } else {
            
        }
    }
    
    
    @IBAction func mainButtonClicked(_ sender: Any) {
        guard mainButtonAction != "" else {
            print("0")
            
            logger.error("No button action found. Exiting...")
            
            //NSApp.terminate(self)
            NSApplication.shared.terminate(self)
            return
        }
        
        // Check for and execute main button action
        if mainButtonActionType.lowercased() == "app" {
            displayProgressIndicator(displayIndicator: true)
            openAppWithBundleIdentifier(bundleID: mainButtonAction)
            
        } else if mainButtonActionType.lowercased() == "url" {
            openLinkFromURL(linkURL: mainButtonAction)
            
        } else if mainButtonActionType.lowercased() == "command" {
            runCommand(executeCommand: mainButtonAction)
        }
        
        // Print return code
        print("0")
        
        // Quit app
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func secondaryButtonClicked(_ sender: Any) {
        print("1")
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func helpButtonClicked(_ sender: Any) {
        // Display New Personal Recovery Key in Alert window
        
        let storyboardName = NSStoryboard.Name(stringLiteral: "Main")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "HelpBubbleViewController")
        
        if let helpBubbleViewController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSViewController {
            if helpBubbleViewController is HelpBubbleViewController {
                if let recoveryKeyDisplayVC = helpBubbleViewController as? HelpBubbleViewController {
                    recoveryKeyDisplayVC.helpDescription = popupWindowHelpButtonDescription
                }
                
            }
            self.present(helpBubbleViewController,
                         asPopoverRelativeTo: (sender as AnyObject).convert((sender as AnyObject).bounds, to: self.view),
                         of: self.view,
                         preferredEdge: .maxX,
                         behavior: .semitransient)
        }
            
            

    }
    
}
