//
//  EchoErrors.swift
//  Echo
//
//  Created by Cyril Zakka on 10/12/24.
//

import Foundation

enum EchoError {

    case invalidStringConversion
    case helperInstallation(String)
    case helperConnection(String)
    case unknown
}

// MARK: - LocalizedError

extension EchoError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .invalidStringConversion: return "The output data is not convertible to a String (utf8)"
        case .helperInstallation(let description): return "Helper installation error. \(description)"
        case .helperConnection(let description): return "Helper connection error. \(description)"
        case .unknown: return "Unknown error"
        }
    }
}
