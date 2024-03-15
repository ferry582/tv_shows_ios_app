//
//  ShowMapper.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 08/01/24.
//

import Foundation

struct ShowMapper {
    static func mapSearchToShow(from search: [Search]) -> [Show] {
        var result = [Show]()
        for data in search {
            result.append(data.show)
        }
        return result
    }
    
    static func mapEpisodesToSeasons(from episodes: [Episode]) -> [Season] {
        var results = [Season]()
        for data in episodes {
            let seasonNumber = data.season
            
            if let index = results.firstIndex(where: { $0.season == seasonNumber }) {
                results[index].episodes.append(data)
            } else {
                let newSection = Season(season: data.season, episodes: [data])
                results.append(newSection)
            }
        }
        return results
    }
}
