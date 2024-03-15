//
//  ShowInjection.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 07/01/24.
//

import Foundation

struct ShowInjection {
    private func getDataSource() -> ShowAPIDataSource {
        return ShowAPIDataSourceImpl.shared
    }
    
    private func getRepo() -> ShowRepository {
        let dataSource = getDataSource()
        return ShowRepositoryImpl.shared(dataSource)
    }
    
    func getHomeUseCase() -> HomeUseCase {
        let repo = getRepo()
        return HomeUseCaseImpl(repository: repo)
    }
    
    func getDetailUseCase() -> DetailUseCase {
        let repo = getRepo()
        return DetailUseCaseImpl(repository: repo)
    }
}
