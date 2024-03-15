//
//  APIError.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 06/01/24.
//

import Foundation

enum APIError: Error {
    case serverError(statusCode: Int)
    case decodingError(underlyingError: Error)
    case urlError
    case rateLimitExceeded
}
