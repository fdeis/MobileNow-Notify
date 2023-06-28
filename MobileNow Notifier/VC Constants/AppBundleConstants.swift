//
//  AppBundleConstants.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 2/13/23.
//

import Foundation
import AppKit

struct AppBundleDefaults {

    static let notificationIcon = "laptopcomputer.trianglebadge.exclamationmark"
    static let notificationIconSize: CGFloat = 80
    static let notificationIconWeight:NSFont.Weight = .light

    static let notificationTitle = "Security Alert"
    static let notificationMessage = ""
    
    static let mainButton = "OK"
    static let secondaryButton = "Cancel"
}

struct HelpBubbleDefaults {
    static let helpBubbleDescriptionDefaults = "Esta es una notificación enviada por tu departamento de TI a través de los servicios de administración MobileNow."
}

enum FileStatus {
    case pending
    case success
}

enum progressBarType {
    case determinate
    case indeterminate
}

struct MobileNowSubscriptionAlert {
    static let alertTitle = "Ooops!"
    static let alertText = "Necesitas una subscripción a MobileNow."
    static let alertButton = "Salir"
}
