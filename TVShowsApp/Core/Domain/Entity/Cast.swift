//
//  Cast.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import Foundation

struct Cast: Codable {
    let person: Person
    let character: Character
}

struct Character: Codable {
    let id: Int
    let url: String
    let name: String
    let image: Image?
}

struct Person: Codable {
    let id: Int
    let name: String
    let country: Country?
    let birthday: String?
    let gender: String?
    let image: Image?
}

struct Country: Codable {
    let name: String?
}
