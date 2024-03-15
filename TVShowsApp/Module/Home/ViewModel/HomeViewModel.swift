//
//  HomeViewModel.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 07/01/24.
//

import Foundation
import Combine

class HomeViewModel {
    private let useCase = ShowInjection().getHomeUseCase()
    private var cancellables = Set<AnyCancellable>()
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var shows = CurrentValueSubject<[Show], Never>([])
    var isSearchActive = CurrentValueSubject<Bool, Never>(false)
    
    func getShows(page: Int) {
        isSearchActive.send(false)
        isLoading.send(true)
        
        useCase.getShowList(page: page)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
                self.isLoading.send(false)
            } receiveValue: { [weak self] shows in
                let newShows = (self?.shows.value)! + shows
                self?.shows.send(newShows)
                self?.isLoading.send(false)
            }
            .store(in: &cancellables)
    }
    
    func searchShows(for text: String) {
        isSearchActive.send(true)
        isLoading.send(true)
        
        useCase.searchShows(query: text)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
                self.isLoading.send(false)
            } receiveValue: { [weak self] shows in
                self?.shows.send(shows)
                self?.isLoading.send(false)
            }
            .store(in: &cancellables)
    }
    
    func removeAllShows() {
        shows.send([])
    }
}
