//
//  DetailUseCase.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import Foundation
import Combine

protocol DetailUseCase {
    func getCastList(showId: Int) -> AnyPublisher<[Cast], Error>
    func getEpisodeList(showId: Int) -> AnyPublisher<[Season], Error>
}

struct DetailUseCaseImpl {
    let repository: ShowRepository
}

extension DetailUseCaseImpl: DetailUseCase {
    func getCastList(showId: Int) -> AnyPublisher<[Cast], Error> {
        return repository.fetchShowCasts(showId: showId)
    }
    
    func getEpisodeList(showId: Int) -> AnyPublisher<[Season], Error> {
        return repository.fetchShowEpisodes(showId: showId)
    }
}
