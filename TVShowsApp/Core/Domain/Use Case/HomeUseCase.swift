//
//  HomeUseCase.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 07/01/24.
//

import Foundation
import Combine

protocol HomeUseCase {
    func getShowList(page: Int) -> AnyPublisher<[Show], Error>
    func searchShows(query: String) -> AnyPublisher<[Show], Error>
}

struct HomeUseCaseImpl {
    let repository: ShowRepository
}

extension HomeUseCaseImpl: HomeUseCase {
    func getShowList(page: Int) -> AnyPublisher<[Show], Error> {
        return repository.fetchShows(page: page)
    }
    
    func searchShows(query: String) -> AnyPublisher<[Show], Error> {
        return repository.searchShows(query: query)
    }
}
