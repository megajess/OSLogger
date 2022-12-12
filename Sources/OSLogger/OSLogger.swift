//
//  Logger.swift
//  OSLogger
//
//  Created by Jesse Suter on 5/6/22.
//

import Foundation
import os

/// Wrapper to reduce some verbosity of using Apple's unified logging system.
@available(macOS 10.12, *)
public class Logger {
    private let logger: OSLog?  // OSLog instance used to send messages to the console.
    
    // MARK: - Initializers
    
    /// Creates a custom log object for sending messages to the logging system.
    ///
    /// - Parameters:
    ///   - subsystem: An identifier string representing the subsystem that’s performing logging. The subsystem is used for categorization and filtering of related log messages, as well as for grouping related logging settings. If no string is provided defaults to Bundle.main.bundleIdentifier.
    ///   - category: A category within the specified subsystem. The category is used for categorization and filtering of related log messages, as well as for grouping related logging settings within the subsystem’s settings. A category’s logging settings override those of the parent subsystem.
    public init(subsystem: String?, category: String, silent: Bool = false) {
        if #available(iOS 10.0, *) {
            self.logger = OSLog(subsystem: subsystem ?? Bundle.main.bundleIdentifier!, category: category)
        } else {
            self.logger = nil
        }
        
        if !silent {
            self.infoLog(includeCallerData: false, "!! Starting %@ logger !!", category)
        }
    }
    
    
    /// Creates a custom log object for sending messages to the logging system with bundle identifier as the logging subsystem.
    ///
    /// - Parameters:
    ///   - category: A category within the specified subsystem. The category is used for categorization and filtering of related log messages, as well as for grouping related logging settings within the subsystem’s settings. A category’s logging settings override those of the parent subsystem.
    ///   - silent: If true does not log a message that the logger has started.
    public convenience init(category: String, silent: Bool = false) {
        self.init(subsystem: nil, category: category, silent: silent)
    }
    
    // MARK: - Static shortcut functions
    
    /// Static function that sends a message to the logging system at info level, and any message format arguments. Intended for short term logging, the logger is dealocated after the message is sent to console.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - category: A category within the specified subsystem. The category is used for categorization and filtering of related log messages, as well as for grouping related logging settings within the subsystem’s settings. A category’s logging settings override those of the parent subsystem.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public static func i(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, category: String, message: String, _ args: CVarArg...) {
        let shortTermLogger = Logger(category: category, silent: true)
        
        let message = shortTermLogger.messageToLog(includeCallerData, file, function, line, message)
        let type: OSLogType?
        
        if #available(iOS 10.0, *) {
            type = .info
        } else {
            type = nil
        }
        
        shortTermLogger.log(type, message: message, args)
    }
    
    
    /// Static function that sends a message to the logging system at default level, and any message format arguments. Intended for short term logging, the logger is dealocated after the message is sent to console.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - category: A category within the specified subsystem. The category is used for categorization and filtering of related log messages, as well as for grouping related logging settings within the subsystem’s settings. A category’s logging settings override those of the parent subsystem.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public static func d(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, category: String, message: String, _ args: CVarArg...) {
        let shortTermLogger = Logger(category: category, silent: true)
        
        let message = shortTermLogger.messageToLog(includeCallerData, file, function, line, message)
        let type: OSLogType?
        
        if #available(iOS 10.0, *) {
            type = .default
        } else {
            type = nil
        }
        
        shortTermLogger.log(type, message: message, args)
    }
    
    
    /// Static function that sends a message to the logging system at error level, and any message format arguments. Intended for short term logging, the logger is dealocated after the message is sent to console.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - category: A category within the specified subsystem. The category is used for categorization and filtering of related log messages, as well as for grouping related logging settings within the subsystem’s settings. A category’s logging settings override those of the parent subsystem.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public static func e(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, category: String, message: String, _ args: CVarArg...) {
        let shortTermLogger = Logger(category: category, silent: true)
        
        let message = shortTermLogger.messageToLog(includeCallerData, file, function, line, message)
        let type: OSLogType?
        
        if #available(iOS 10.0, *) {
            type = .error
        } else {
            type = nil
        }
        
        shortTermLogger.log(type, message: message, args)
    }
    
    // MARK: - Instance functions
    
    /// Sends a message to the logging system at default level, and any message format arguments.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public func defaultLog(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, _ message: String, _ args: CVarArg...) {
        let type: OSLogType?
        
        
        if #available(iOS 10.0, *) {
            type = .default
        } else {
            type = nil
        }
        
        log(type, message: messageToLog(includeCallerData, file, function, line, message), args)
    }
    
    
    /// Sends a message to the logging system at info level, and any message format arguments.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public func infoLog(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, _ message: String, _ args: CVarArg...) {
        let type: OSLogType?
        
        if #available(iOS 10.0, *) {
            type = .info
        } else {
            type = nil
        }
        
        log(type, message: messageToLog(includeCallerData, file, function, line, message), args)
    }
    
    
    /// Sends a message to the logging system at debug level, and any message format arguments.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public func debugLog(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, _ message: String, _ args: CVarArg...) {
        let type: OSLogType?
        
        if #available(iOS 10.0, *) {
            type = .debug
        } else {
            type = nil
        }
        
        log(type, message: messageToLog(includeCallerData, file, function, line, message), args)
    }
    
    
    /// Sends a message to the logging system at error level, and any message format arguments.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public func errorLog(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, _ message: String, _ args: CVarArg...) {
        let type: OSLogType?
        
        if #available(iOS 10.0, *) {
            type = .error
        } else {
            type = nil
        }
        
        log(type, message: messageToLog(includeCallerData, file, function, line, message), args)
    }

    
    /// Sends a message to the logging system at fault level, and any message format arguments.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    public func faultLog(includeCallerData: Bool = true, file: String = #file, function: String = #function, line: Int = #line, _ message: String, _ args: CVarArg...) {
        let type: OSLogType?
        
        if #available(iOS 10.0, *) {
            type = .fault
        } else {
            type = nil
        }
        
        log(type, message: messageToLog(includeCallerData, file, function, line, message), args)
    }

    // MARK: - Common utility functions
    
    /// Sends a message to the logging system, optionally specifying a log level, and any message format arguments.
    ///
    /// - Parameters:
    ///   - type: The log level. If unspecified, the default log level is used.
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - args: If message is a constant string, do not specify arguments.
    ///           If message is a format string, pass the expected number of arguments in the order that they appear in the string.
    private func log(_ type: OSLogType?, message: String, _ args: [CVarArg]) {
        #if DEBUG
        let modifiedArgs = args.map { (varArg) in
            return varArg is Bool ? "\(varArg)" : varArg
        }

        let formattedMessage = String(format: message, arguments: modifiedArgs)
        
        guard let logger = logger, #available(iOS 10.0, *) else {
            print(formattedMessage)
            
            return
        }
        
        os_log("%{public}@", log: logger, type: type ?? .default, formattedMessage)
        #endif
    }
    
    /// Helper function to build the log message string.
    ///
    /// - Parameters:
    ///   - includeCallerData: Flag to determine if to include information about where the call to log was made form in the log.
    ///   - file: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the file where the call to log is made.
    ///   - function: DO NOT OVERRIDE THE DEFAULT VALUE! The name of the function from which the call to log was made.
    ///   - line: DO NOT OVERRIDE THE DEFAULT VALUE! The line number on which the call tolog was made.
    ///   - message: A constant string or format string that produces a human-readable log message.
    /// - Returns: The message that will be sent to the logger.
    private func messageToLog(_ includeCallerData: Bool, _ file: String, _ function: String, _ line: Int, _ message: String) -> String {
        return includeCallerData ? "\(message)\n\(file)::\(function) line: \(line) @\(Date())" : message
    }
}
