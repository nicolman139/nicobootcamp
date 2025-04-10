//
//  PokemonManager.swift
//  Pokemon2
//
//  Created by Bootcamp on 2025-03-10.
//

import Alamofire

class PokemonManager {
    static let shared = PokemonManager()
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon?limit=1000"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PokemonListResponse.self) { response in
                switch response.result {
                case .success(let pokemonList):
                    completion(.success(pokemonList.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchPokemonDetail(from url: String, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PokemonDetail.self) { response in
                switch response.result {
                case .success(let pokemonDetail):
                    completion(.success(pokemonDetail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
