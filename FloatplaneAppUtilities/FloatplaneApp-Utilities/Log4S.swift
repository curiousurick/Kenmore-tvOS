//  Copyright © 2023 George Urick
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Logging

public class Log4S {
    private let logger: Logger
    
    public init(file: String = #file) {
        let label = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        self.logger = Logger(label: label)
    }
    
    public func debug(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line) {
            logger.log(
                level: .debug,
                message(),
                metadata: metadata(),
                source: nil,
                file: file,
                function: function,
                line: line
            )
    }
    
    public func info(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.log(
            level: .info,
            message(),
            metadata: metadata(),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func notice(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.log(
            level: .notice,
            message(),
            metadata: metadata(),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func error(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.log(
            level: .error,
            message(),
            metadata: metadata(),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func trace(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.log(
            level: .trace,
            message(),
            metadata: metadata(),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func warn(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.log(
            level: .warning,
            message(),
            metadata: metadata(),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
    
    public func critical(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        logger.log(
            level: .critical,
            message(),
            metadata: metadata(),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
}
