//
//  LogManager.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/30.
//
import Foundation
import RxSwift
import CocoaLumberjack

public func logDebug(_ message: @autoclosure () -> String) {
    DDLogDebug(DDLogMessageFormat(unicodeScalarLiteral: message()))
}

public func logError(_ message: @autoclosure () -> String) {
    DDLogError(DDLogMessageFormat(unicodeScalarLiteral: message()))
}

public func logInfo(_ message: @autoclosure () -> String) {
    DDLogInfo(DDLogMessageFormat(unicodeScalarLiteral: message()))
}

public func logVerbose(_ message: @autoclosure () -> String) {
    DDLogVerbose(DDLogMessageFormat(unicodeScalarLiteral: message()))

}

public func logWarn(_ message: @autoclosure () -> String) {
    DDLogWarn(DDLogMessageFormat(unicodeScalarLiteral: message()))
}
