//
//  TVShowRepository.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 07/01/24.
//

import Foundation
import Combine

protocol ShowRepository {
    func fetchShows(page: Int) -> AnyPublisher<[Show], Error>
    func searchShows(query: String) -> AnyPublisher<[Show], Error>
    func fetchShowCasts(showId: Int) -> AnyPublisher<[Cast], Error>
    func fetchShowEpisodes(showId: Int) -> AnyPublisher<[Season], Error>
}

