//
//  TVShowAPIImpl.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 06/01/24.
//

import Foundation
import Combine

protocol ShowAPIDataSource {
    func fetchShows(page: Int) -> AnyPublisher<[Show], Error>
    func searchShows(query: String) -> AnyPublisher<[Search], Error>
    func fetchShowCasts(showId: Int) -> AnyPublisher<[Cast], Error>
    func fetchShowEpisodes(showId: Int) -> AnyPublisher<[Episode], Error>
}

struct ShowAPIDataSourceImpl {
    static let shared: ShowAPIDataSource = ShowAPIDataSourceImpl()
}

extension ShowAPIDataSourceImpl: ShowAPIDataSource {
    
    func fetchShows(page: Int) -> AnyPublisher<[Show], Error> {
        let request = ShowAPI.fetch(page: page).generateURLRequest()
        return URLSession.shared.dataTaskPublisher(for: request!)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.urlError
                }
                
                let statusCode = httpResponse.statusCode
                guard (statusCode >= 200 && statusCode < 300) else {
                    throw if statusCode == 429 {
                        APIError.rateLimitExceeded
                    } else {
                        APIError.serverError(statusCode: statusCode)
                    }
                }
                
                return data
            }
            .decode(type: [Show].self, decoder: JSONDecoder())
            .mapError { decodingError in
                return APIError.decodingError(underlyingError: decodingError)
            }
            .eraseToAnyPublisher()
    }
    
    func searchShows(query: String) -> AnyPublisher<[Search], Error> {
        let request = ShowAPI.search(query: query).generateURLRequest()
        return URLSession.shared.dataTaskPublisher(for: request!)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.urlError
                }
                
                let statusCode = httpResponse.statusCode
                guard (statusCode >= 200 && statusCode < 300) else {
                    throw if statusCode == 429 {
                        APIError.rateLimitExceeded
                    } else {
                        APIError.serverError(statusCode: statusCode)
                    }
                }
                
                return data
            }
            .decode(type: [Search].self, decoder: JSONDecoder())
            .mapError { decodingError in
                return APIError.decodingError(underlyingError: decodingError)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchShowCasts(showId: Int) -> AnyPublisher<[Cast], Error> {
        let request = ShowAPI.cast(showId: showId).generateURLRequest()
        return URLSession.shared.dataTaskPublisher(for: request!)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.urlError
                }
                
                let statusCode = httpResponse.statusCode
                guard (statusCode >= 200 && statusCode < 300) else {
                    throw if statusCode == 429 {
                        APIError.rateLimitExceeded
                    } else {
                        APIError.serverError(statusCode: statusCode)
                    }
                }
                
                return data
            }
            .decode(type: [Cast].self, decoder: JSONDecoder())
            .mapError { decodingError in
                return APIError.decodingError(underlyingError: decodingError)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchShowEpisodes(showId: Int) -> AnyPublisher<[Episode], Error> {
        let request = ShowAPI.episodes(showId: showId).generateURLRequest()
        return URLSession.shared.dataTaskPublisher(for: request!)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.urlError
                }
                
                let statusCode = httpResponse.statusCode
                guard (statusCode >= 200 && statusCode < 300) else {
                    throw if statusCode == 429 {
                        APIError.rateLimitExceeded
                    } else {
                        APIError.serverError(statusCode: statusCode)
                    }
                }
                
                return data
            }
            .decode(type: [Episode].self, decoder: JSONDecoder())
            .mapError { decodingError in
                return APIError.decodingError(underlyingError: decodingError)
            }
            .eraseToAnyPublisher()
    }
}
