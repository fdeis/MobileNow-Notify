//
//  OpenApp.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 2/22/23.
//

import Foundation
import AppKit

func openAppWithBundleIdentifier(bundleID: String) {
    
    let openConfiguration = NSWorkspace.OpenConfiguration()
    if let openAppWithURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
        NSWorkspace.shared.openApplication(at: openAppWithURL, configuration: openConfiguration)
    } else {
        print("App with bundle identifier \(bundleID) not found")
    }
}
