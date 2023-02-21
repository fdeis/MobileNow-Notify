//
//  GlobalFunctions.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 6/27/22.
//

import Foundation
import Cocoa


func checkIfFileExists(for path:String) -> Bool {
    let fm = FileManager.default
    let fileStatus = fm.fileExists(atPath: path)
    return fileStatus
}


func monitorDirectory(for fileURL: URL) {
    let fileManager = FileManager.default
    let folderURL = fileURL.deletingLastPathComponent()
    let fileName = fileURL.lastPathComponent
    
    // Use DispatchSource to monitor the directory for changes
    let queue = DispatchQueue(label: "com.example.monitor" )
    let fileDescriptor = open(
        folderURL.path,
        O_EVTONLY
    )
    guard fileDescriptor != -1 else {
        print("Could not open directory: \(folderURL.path)")
        return 
    }
    let source = DispatchSource.makeFileSystemObjectSource(
        fileDescriptor: fileDescriptor,
        eventMask: .write,
        queue: queue
    )
    
    // Define the handler to run when a new file is created
    source.setEventHandler {
        let contents = try? fileManager.contentsOfDirectory(atPath: folderURL.path)
        if let contents = contents, contents.contains(fileName) {
            print("File created at: \(fileURL)")
            source.cancel() // Stop monitoring the directory once the file is created
        }
    }
    
    // Define the cancellation handler to close the file descriptor
    source.setCancelHandler {
        close(fileDescriptor)
    }
    
    // Start monitoring the directory for changes
    source.resume()
}
