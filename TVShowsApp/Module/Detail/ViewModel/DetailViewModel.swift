//
//  DetailViewModel.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 08/01/24.
//

import Foundation
import Combine

class DetailViewModel {
    private let useCase = ShowInjection().getDetailUseCase()
    private var cancellables = Set<AnyCancellable>()
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var casts = CurrentValueSubject<[Cast], Never>([])
    var seasons = CurrentValueSubject<[Season], Never>([])
    
    // Separate flags for cast and external loading
    private var castLoadingFinised = CurrentValueSubject<Bool, Never>(false)
    private var episodeLoadingFinised = CurrentValueSubject<Bool, Never>(false)
    private var externalLoadingFinised = CurrentValueSubject<Bool, Never>(false)
    
    func getCastsAndEpisodes(showId id: Int) {
        isLoading.send(true)
        
        useCase.getCastList(showId: id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
                self.castLoadingFinised.send(true)
            } receiveValue: { [weak self] casts in
                self?.casts.send(casts)
                self?.castLoadingFinised.send(true)
            }
            .store(in: &cancellables)
        
        useCase.getEpisodeList(showId: id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
                self.episodeLoadingFinised.send(true)
            } receiveValue: { [weak self] seasons in
                self?.seasons.send(seasons)
                self?.episodeLoadingFinised.send(true)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest3(castLoadingFinised, episodeLoadingFinised, externalLoadingFinised)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] castFinished, episodeFinished, extFinished in
                if castFinished && episodeFinished && extFinished {
                    self?.isLoading.send(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func startLoading() {
        isLoading.send(true)
    }
    
    func stopLoading() {
        externalLoadingFinised.send(true)
    }
}
