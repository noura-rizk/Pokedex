//
//  PokeDetailsCV.swift
//  Pokedex
//
//  Created by Noura Rizk on 12/17/15.
//  Copyright © 2015 Noura Rizk. All rights reserved.
//

import UIKit

class PokeDetailsCV: UIViewController {
    
    @IBOutlet weak var lblPokeName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgPoke: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDefense: UILabel!
    @IBOutlet weak var lblheight: UILabel!
    @IBOutlet weak var lblPokeId: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblBaseAttack: UILabel!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var imgPrev: UIImageView!
    @IBOutlet weak var lblNext: UILabel!
    var pokemon: Pokemon!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPokeName.text = pokemon.name.capitalizedString;
        let img = UIImage(named: "\(pokemon.pokemonId)");
        imgPoke.image = img;
        
        imgPrev.image = img;
        pokemon.downloadPokemonDetails { () ->() in
            // this will be called after download is complete
            self.updateUI();
        }
    }
    func updateUI(){
        lblBaseAttack.text = pokemon.attack;
        lblDefense.text = pokemon.defense;
        lblDesc.text = pokemon.description;
        lblheight.text = pokemon.height;
        lblType.text = pokemon.type;
        lblWeight.text = pokemon.weight;
        lblPokeId.text = "\(pokemon.pokemonId)";
        if pokemon.nextEvolutionId == "" {
            lblNext.text = "No Evolutions"
            imgNext.hidden = true
        } else {
            imgNext.hidden = false
            imgNext.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
            lblNext.text = str;
        }
        
        
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
