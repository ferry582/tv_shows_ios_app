//
//  TVShowRepositoryImpl.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 07/01/24.
//

import Foundation
import Combine

struct ShowRepositoryImpl {
    private let dataSource: ShowAPIDataSource
    static let shared: (ShowAPIDataSource) -> ShowRepository = { dataSource in
        return ShowRepositoryImpl(dataSource: dataSource)
    }
}

extension ShowRepositoryImpl: ShowRepository {
    func fetchShows(page: Int) -> AnyPublisher<[Show], Error> {
        return dataSource.fetchShows(page: page)
    }

    func searchShows(query: String) -> AnyPublisher<[Show], Error> {
        let shows = dataSource.searchShows(query: query)
            .map { results in
                ShowMapper.mapSearchToShow(from: results)
            }
            .eraseToAnyPublisher()
        return shows
    }
    
    func fetchShowCasts(showId: Int) -> AnyPublisher<[Cast], Error> {
        return dataSource.fetchShowCasts(showId: showId)
    }
    
    func fetchShowEpisodes(showId: Int) -> AnyPublisher<[Season], Error> {
        let seasons = dataSource.fetchShowEpisodes(showId: showId)
            .map { results in
                return ShowMapper.mapEpisodesToSeasons(from: results)
            }
            .eraseToAnyPublisher()
        return seasons
    }
}
