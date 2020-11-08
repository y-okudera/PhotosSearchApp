//
//  Logger.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/08.
//

import Foundation
import XCGLogger

let log: XCGLogger? = {
    #if DEBUG
    let log = XCGLogger.default
    log.setup(showThreadName: true)
    return log
    #else
    return nil
    #endif
}()

private let simpleLog: XCGLogger? = {
    #if DEBUG
    let log = XCGLogger.default
    log.setup(
        showFunctionName: false,
        showLevel: false,
        showFileNames: false,
        showLineNumbers: false,
        showDate: false
    )
    return log
    #else
    return nil
    #endif
}()

/// スタックトレースをコンソールに出力する
func printStackTrace() {
    log?.debug("【Stack trace】↓↓↓")
    Thread.callStackSymbols.forEach {
        simpleLog?.error($0)
    }
    log?.debug("↑↑↑【Stack trace】")
}
