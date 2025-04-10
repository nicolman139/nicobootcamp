

import Foundation

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let sprites: Sprites
    let types: [PokemonType]
}

struct Sprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeDetails
}

struct TypeDetails: Codable {
    let name: String
}

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

