//
//  Pokemon.swift
//  pokedex
//
//  Created by Laszlo Barabas on 2/20/16.
//  Copyright © 2016 Laszlo Barabas. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name : String!
    private var _pokedexId: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init (name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
    }
    
    
    
}
