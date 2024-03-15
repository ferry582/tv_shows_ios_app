//
//  APICall.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 06/01/24.
//

import Foundation

enum ShowAPI {
    case fetch(page: Int)
    case search(query: String)
    case cast(showId: Int)
    case episodes(showId: Int)
}

extension ShowAPI: Endpoint {
    var scheme: String {
        return "https"
    }
    
    var baseURL: String {
        return "api.tvmaze.com"
    }
    
    var path: String {
        switch self {
        case .fetch(_):
            return "/shows"
        case .search(_):
            return "/search/shows"
        case .cast(showId: let showId):
            return "/shows/\(showId)/cast"
        case .episodes(showId: let showId):
            return "/shows/\(showId)/episodes"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetch(page: let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .search(query: let query):
            return [URLQueryItem(name: "q", value: String(query))]
        default :
            return []
        }
    }
    
    var method: String {
        return "get"
    }
    
    func generateURLRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
    
    
}
