//
//  OpenApp.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 2/22/23.
//

import Foundation
import AppKit
import os

let logger = Logger(subsystem: "mobi.mobilenow.MobileNow-Notifier", category: "Action")

func openAppWithBundleIdentifier(bundleID: String) {
    
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.launchPath = "/usr/bin/open"
    task.arguments = ["-b", bundleID]
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    if !task.isRunning {
        let status = task.terminationStatus
        if status == 0 {
            logger.debug("\(output)")
        } else {
            logger.error("\(output)")
        }
    }
}

func openLinkFromURL(linkURL: String) {
    guard let actionURL = URL(string: linkURL) else {
        logger.error("Error opening URL. Possibly not found")
        return
    }
    NSWorkspace.shared.open(actionURL)
    logger.info("Opened URL in default browser.")
}

func runCommand(executeCommand: String) {
    let task = Process()
    let pipe = Pipe()
    
    task.standardError = pipe
    task.standardOutput = pipe
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", executeCommand]
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    if !task.isRunning {
        let status = task.terminationStatus
        if status == 0 {
            logger.debug("\(output)")
        } else {
            logger.error("\(output)")
        }
    }
    
}
