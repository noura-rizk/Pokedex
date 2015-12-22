//
//  ViewController.swift
//  Pokedex
//
//  Created by Noura Rizk on 12/16/15.
//  Copyright © 2015 Noura Rizk. A/Users/Noura/Desktop/Pokedex/Pokedex/PokeCell.swiftll rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    var pokemons = [Pokemon]();
    var filteredPokemon = [Pokemon]();
    var musicPlayer: AVAudioPlayer!;
    var isSearchMode = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self;
        collection.dataSource = self;
        searchBar.delegate = self;
        searchBar.returnKeyType = UIReturnKeyType.Done;
        initAudio();
        parsePokemonSCV();
    }
   func initAudio(){
    let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3");
    do{
        musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!);
        musicPlayer.prepareToPlay();
        musicPlayer.numberOfLoops = -1;
        musicPlayer.play();
    }catch let err as NSError{
        print(err.debugDescription);
    }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            let pokemon: Pokemon!;
            if isSearchMode {
                pokemon = filteredPokemon[indexPath.row];
            }else{
                pokemon = pokemons[indexPath.row];
            }
            
            cell.configCell(pokemon);
            return cell;
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var poke: Pokemon!;
        if(isSearchMode){
            poke = filteredPokemon[indexPath.row];
        }else{
            poke = pokemons[indexPath.row];
        }
        performSegueWithIdentifier("PokeDetailsCV", sender: poke);
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchMode {
           return filteredPokemon.count;
        }else{
            return pokemons.count;
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    func parsePokemonSCV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!;
        do{
            let content = try CSV(contentsOfURL: path);
            let rows = content.rows;
            for row in rows{
            let pokeId = Int(row["id"]!)!;
            let name = row["identifier"]!;
                let poke = Pokemon(name: name, pkId: pokeId);
                pokemons.append(poke);
            }
        }catch let err as NSError{
            print(err.debugDescription);
        }
    }
    
    @IBAction func musicBtnPressed(sender: UIButton) {
        
        if(musicPlayer.playing){
            musicPlayer.stop();
            sender.alpha = 0.2;
        }else{
            musicPlayer.play();
            sender.alpha = 1.0;
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchBar.text == ""){
            isSearchMode = false;
            view.endEditing(true);
            collection.reloadData();
        }else{
            isSearchMode = true;
            let lower = searchBar.text!.lowercaseString;
            filteredPokemon = pokemons.filter({$0.name.rangeOfString(lower) != nil});
            collection.reloadData();
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
      view.endEditing(true);
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "PokeDetailsCV"){
            if let detailsCV = segue.destinationViewController as? PokeDetailsCV{
                let poke = sender as? Pokemon;
                detailsCV.pokemon = poke;
            }
        }
    }
}

