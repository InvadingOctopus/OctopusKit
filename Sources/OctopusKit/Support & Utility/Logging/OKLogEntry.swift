//
//  OKLogEntry.swift
//  OctopusKit
//
//  Created by ShinryakuTako@invadingoctopus.io on 2014-29-06
//  Copyright © 2020 Invading Octopus. Licensed under Apache License v2.0 (see LICENSE.txt)
//

import Foundation

public typealias OctopusLogEntry = OKLogEntry

/// An entry in an `OKLog`.
public struct OKLogEntry: Identifiable, Hashable, CustomStringConvertible {
    
    /// The prefix of the log, if any, in which this entry was logged. Used for distinguishing entries from different logs. May be emojis or symbols.
    public let prefix:      String
    
    public let time:        Date
    
    /// The number of the scene frame during which this entry was logged. May be `0` if there was no active scene.
    public let frame:       UInt64
   
    /// Specifies whether this entry was logged at the beginning of a new frame of a scene, if any. Used for highlighting new frames in a list of entries.
    public let isNewFrame:  Bool /// CHECK: Rename to `isHighlighted` or `isFirstEntryOfNewFrame`? :p
    
    /// The file name, type name, runtime object, or subsystem from which this entry was logged.
    public let topic:       String
    
    /// The specific function or task inside the topic from which this entry is logged.
    public let function:    String
    
    /// The actual event or message that was logged.
    public let text:        String
    
    /// A unique identifier for compatibility with SwiftUI lists.
    public let id         = UUID()
    
    /// Creates a new log entry.
    /// - Parameters:
    ///   - prefix:     The prefix of the log, if any, in which this entry was logged. May be emojis or symbols for distinguishing entries from different logs.
    ///   - time:       The date and time at which this entry is logged.
    ///   - frame:      The current frame count of the current scene, if any, otherwise `0`.
    ///   - isNewFrame: `true` if the entry is logged at the beginning of a new frame in the current scene, if any. Used for highlighting new frames.
    ///   - text:       The content of the entry.
    ///   - topic:      The file name, type name, runtime object, or subsystem from which this entry is logged. Default: The file name.
    ///   - function:   The specific function or task inside the topic from which this entry is logged. Default: The function signature.
    public init(
        prefix:     String  = "",
        time:       Date    = Date(),
        frame:      UInt64  = OKLog.currentFrame,
        isNewFrame: Bool    = OKLog.isNewFrame,
        text:       String  = "",
        topic:      String  = #file,
        function:   String  = #function)
    {
        self.prefix     = prefix
        self.time       = time
        self.frame      = frame
        self.isNewFrame = isNewFrame
        
        self.text       = text
        self.topic      = topic
        self.function   = function
    }
    
    @inlinable
    public var description: String {
        let text = self.text // CHECK: Trim whitespace?
        
        return ("\(OKLog.timeFormatter.string(from: self.time))\(text.isEmpty ? "" : " ")\(text)")
    }
}

extension OKLogEntry: Codable {
    enum CodingKeys: String, CodingKey {
        /// ℹ️ Exclude the long and unnecessary `id` strings.
        case prefix, time, frame, isNewFrame
        case topic, function, text
    }
}
