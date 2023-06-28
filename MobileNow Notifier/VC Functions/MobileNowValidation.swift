//
//  MobileNowValidation.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 6/28/23.
//

import Foundation


func checkMobileNowSubscription() -> Bool {
    let task = Process()
    
    task.launchPath = "/usr/bin/defaults"
    task.arguments = ["read", "/Library/Preferences/com.jamfsoftware.jamf.plist", "jss_url"]
    
    let outputPipe = Pipe()
    let errorPipe = Pipe()
    
    task.standardOutput = outputPipe
    task.standardError = errorPipe
    
    task.launch()
    
    let returnedValue = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let processedValue = String(decoding: returnedValue, as: UTF8.self)
    
    if processedValue.contains("mobilenow.mobi") {
        return true
    } else {
        return false
    }
}
