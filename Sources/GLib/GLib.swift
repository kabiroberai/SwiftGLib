//
//  GLib.swift
//  GLib
//
//  Created by Rene Hexel on 27/04/2017.
//  Copyright © 2016, 2017, 2018, 2019 Rene Hexel.  All rights reserved.
//
import CGLib

/// Opaque type. See RecMutexLocker for details.
public struct GRecMutexLocker {}

/// Logging function
///
/// - Parameters:
///   - message: log message
///   - level: log level (defaults to `level_debug`)
public func g_log(_ message: String, level: LogLevelFlags = .level_debug) {
    message.utf8CString.withUnsafeBufferPointer {
        guard let base = $0.baseAddress else { return }
        let varargs = [OpaquePointer(base)]
        let va_list = getVaList(varargs)
        g_logv(nil, level, "%s", va_list)
    }
}

/// Logging function
///
/// - Parameters:
///   - domain: the domain this logging function occurs in
///   - message: log message
///   - level: log level (defaults to `level_debug`)
public func g_log(domain: String, _ message: String, level: LogLevelFlags = .level_debug) {
    message.utf8CString.withUnsafeBufferPointer {
        guard let base = $0.baseAddress else { return }
        let varargs = [OpaquePointer(base)]
        let va_list = getVaList(varargs)
        g_logv(domain, level, "%s", va_list)
    }
}

/// Log a warning message
///
/// - Parameters:
///   - message: warning message
///   - domain: the domain this logging occurs in (defaults to `nil`)
public func g_warning(_ message: String, domain: String? = nil) {
    if let d = domain {
        g_log(domain: d, message, level: .level_warning)
    } else {
        g_log(message, level: .level_warning)
    }
}