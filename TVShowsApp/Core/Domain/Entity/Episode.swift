//
//  Episode.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let name: String
    let season, number: Int
    let airdate: String?
    let airtime: String?
    let runtime: Int?
    let rating: Rating
    let image: Image?
    let summary: String?
}

struct Season {
    let season: Int
    var episodes: [Episode]
}
