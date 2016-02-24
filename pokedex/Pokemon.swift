//
//  Pokemon.swift
//  pokedex
//
//  Created by Laszlo Barabas on 2/20/16.
//  Copyright © 2016 Laszlo Barabas. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name : String!
    private var _pokedexId: Int!
    private var _desc : String!
    private var _type : String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var name: String { return _name  }
    var pokedexId: Int { return _pokedexId }
    var desc: String {
        if _desc == nil { _desc = "" }
        return _desc }
    var type: String {
        if _type == nil { _type = "" }
        return _type }
    var defense: String {
        if _defense == nil { _defense = "" }
        return _defense }
    var height: String {
        if _height == nil { _height = "" }
        return _height }
    var weight: String {
        if _weight == nil { _weight = "" }
        return _weight }
    var attack: String {
        if _attack == nil { _attack = "" }
        return _attack }
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil { _nextEvolutionTxt = "" }
        return _nextEvolutionTxt }
    var nextEvolutionId: String {
        if _nextEvolutionId == nil { _nextEvolutionId = "" }
        return _nextEvolutionId }

    // alternate way with "get"
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {  _nextEvolutionLevel = "" }
            return _nextEvolutionLevel
        }
    }
    
    init (name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadCompete) {
        
        let url = NSURL(string: _pokemonURL)!
      
        /* alamo v1.3 syntax
        Alamofire.request(.GET, url).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
        
        }
        */
            
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            //print(result.value.debugDescription)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                } else { self._weight = "unknown" }
                
                if let height = dict["height"] as? String {
                    self._height = height
                } else { self._height = "unknown" }
                
                // the API returns this value as an Int
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                } else { self._attack = "unknown" }

                // the API returns this value as an Int
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                } else { self._defense = "unknown" }
                
                // the API returns "types" as an array
                //      normally it is safer to do [Dictionary<String,AnyObject>] but we know the result is a String
                
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name)"
                            }
                        }
                    }
                } else { self._type = "" }
                
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        //this is an asynch statement - the section in the { } won't run until the request is done
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let des_result = response.result
                            if let descDict = des_result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._desc = description
                                    //print(self._desc)
                                }
                            }
                            
                            completed()
                        
                        }
                    }
                    
                    
                } else { self._desc = "" }
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to_character = evolutions[0]["to"] as? String {
                        
                        if to_character.rangeOfString("mega") == nil {
                            //only come here if the next evolution character is not a "mega" because we don't have the mega character images
                            //grab the pokedex_id from the resource_uri 
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                //strip unnecessary string by replacing it with ""
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to_character
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                                
                               // print(self._nextEvolutionLevel)
                               // print(self._nextEvolutionTxt)
                               // print(self._nextEvolutionId)
                            }
                            
                            
                        }
                        
                    }
                }
                
                
                //print( self._type)
                
                
            }
            
        }
        
    }
    
}
