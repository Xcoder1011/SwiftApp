//
//  LibsManager.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/30.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher
import CocoaLumberjack
import KafkaRefresh
import IQKeyboardManagerSwift

class LibsManager {
    static let shared = LibsManager()
    private init() {}
    
    func setupLibs() {
        setupKingfisher()
        setupCocoaLumberjack()
    }
    
    func setupKafkaRefresh() {
        if let defaults = KafkaRefreshDefaults.standard() {
            defaults.headDefaultStyle = .replicatorAllen
            defaults.footDefaultStyle = .replicatorDot
        }
    }
    
    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
    func setupKingfisher() {
        ImageCache.default.diskStorage.config.sizeLimit = UInt(500 * 1024 * 1024) // 500 MB
        ImageCache.default.diskStorage.config.expiration = .days(7) // 1 week
        ImageDownloader.default.downloadTimeout = 15.0 // 15 sec
    }
    
    func setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}
