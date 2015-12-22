//
//  Pokemon.swift
//  Pokedex
//
//  Created by Noura Rizk on 12/16/15.
//  Copyright © 2015 Noura Rizk. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!;
    private var _pokemonId: Int!;
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    var nextEvolutionTxt: String {
        
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var description: String {
        
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    
    
    var name:String{
        return _name;
    }
    var pokemonId: Int{
        return _pokemonId
    }
    init (name: String, pkId: Int){
        _name = name;
        _pokemonId = pkId;
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokemonId)/";
        
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        print("\(self._pokemonUrl)");
        let url = NSURL(string: self._pokemonUrl)!
        Alamofire.request(.GET, url)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if let dict = JSON as? Dictionary<String, AnyObject>{
                        if let weight = dict["weight"] as? String{
                            self._weight = weight;
                        }
                        if let height = dict["height"] as? String{
                            self._height = height;
                        }
                        if let attack = dict["attack"] as? Int{
                            self._attack =  "\(attack)"
                        }
                        if let defense = dict["defense"] as? Int{
                            self._defense = "\(defense)";
                        }
                        
                        print(self._height);
                        print(self.weight);
                        print(self.attack);
                        print(self.defense);
                        if let types = dict["types"] as? [Dictionary<String,String>] where types.count>0 {
                            if let name = types[0]["name"]{
                                self._type = name;
                            }
                            if (types.count > 1){
                                for(var i = 1; i < types.count; i++){
                                    if let name = types[i]["name"]{
                                        self._type! += "/\(name)";
                                    }
                                }
                            }
                        }else {
                            self._type = "";
                        }
                        //print(self._type);
                        
                        if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0{
                            if let responseUrl = descArr[0]["resource_uri"] {
                                let nsurl = NSURL(string: "\(URL_BASE)\(responseUrl)")!
                                Alamofire.request(.GET, nsurl)
                                    .responseJSON { response in
                                        // print(response.request)  // original URL request
                                        //print(response.response) // URL response
                                        //print(response.data)     // server data
                                        //print(response.result)   // result of response serialization
                                        
                                        if let JSONDesc = response.result.value {
                                            if let dictDesc = JSONDesc as? Dictionary<String, AnyObject>{
                                                //  print("DTATA=\(dictDesc)");
                                                if let description = dictDesc["description"] as? String{
                                                    self._description = description;
                                                    print(self._description);
                                                }
                                            }
                                            completed();
                                        }
                                        
                                }
                            }
                            
                        }else {
                            self._description = "";
                        }
                        //
                        if let evelautions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evelautions.count>0{
                            if let to = evelautions[0]["to"] as? String{
                                // can't support mega right now, but api still has mega
                                if to.rangeOfString("mega") == nil{
                                    if let uri = evelautions[0]["resource_uri"] as? String{
                                        let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "");
                                        let nextId = newStr.stringByReplacingOccurrencesOfString("/", withString: "");
                                        self._nextEvolutionId = nextId;
                                        self._nextEvolutionTxt = to;
                                        if let level  = evelautions[0]["level"] as? Int{
                                            self._nextEvolutionLvl = "\(level)";
                                        }
                                        print(self._nextEvolutionId);
                                        print(self._nextEvolutionLvl)
                                        print(self._nextEvolutionTxt);
                                    }
                                }
                            }
                        }else{
                            self._nextEvolutionLvl = "";
                        }
                        //
                    }
                    
                }
        }
    }
}






