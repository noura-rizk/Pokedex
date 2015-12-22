//
//  PokeCellCollectionViewCell.swift
//  Pokedex
//
//  Created by Noura Rizk on 12/16/15.
//  Copyright © 2015 Noura Rizk. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!;
    @IBOutlet weak var lblCell: UILabel!;
    var pokemon: Pokemon!;

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
       layer.cornerRadius = 5.0;
    }
    
    func configCell(pokemon: Pokemon){
        self.pokemon = pokemon;
        lblCell.text = self.pokemon.name;
        imgView.image = UIImage(named: "\(self.pokemon.pokemonId)");
    }
    
}
