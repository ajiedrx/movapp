//
//  CustomError+Ext.swift
//  movapp
//
//  Created by Ajie DR on 06/11/24.
//

import Foundation

enum URLError: LocalizedError {

    case unknownError(String)
    case invalidResponse
    case addressUnreachable(String)
  
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response"
        case .addressUnreachable(let url): return "\(url) is unreachable."
        default: return "Unknown error"
        }
    }
}
