//
//  ShowResponse.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 06/01/24.
//

import Foundation

struct Show: Codable, Hashable {
    let id: Int
    let name, status, type: String
    let language: String?
    let genres: [String]
    let summary: String?
    let rating: Rating
    let image: Image?
}

struct Image: Codable, Hashable {
    let medium, original: String?
}

struct Rating: Codable, Hashable {
    let average: Double?
}

