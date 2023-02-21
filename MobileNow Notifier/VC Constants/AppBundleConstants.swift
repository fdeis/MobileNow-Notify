//
//  AppBundleConstants.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 2/13/23.
//

import Foundation

struct AppBundleDefaults {

    static let notificationIcon = "laptopcomputer.trianglebadge.exclamationmark"

    static let notificationTitle = "Security Alert"
    static let notificationMessage = ""
    
    static let mainButton = "OK"
    static let secondaryButton = "Cancel"
}

enum FileStatus {
    case pending
    case success
}

enum progressBarType {
    case determinate
    case indeterminate
}
