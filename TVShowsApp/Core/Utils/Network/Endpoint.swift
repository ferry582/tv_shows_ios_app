//
//  Endpoint.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 07/01/24.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: String { get }
    func generateURLRequest() -> URLRequest?
}
