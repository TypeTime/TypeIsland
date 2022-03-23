//
//  ComboSystem.swift
//  TypeRacerTypeBeat
//
//  Created by Justin Dang on 3/21/22.
//
/*
 shared()       -> Creates an instance of combo system(ex comboSystem = ComboSystem.shared())
                   Used for a singleton, similar to C coding where: ComboSystem comboSystem = new ComboSystem()
 current()      -> Returns the current combo
 increase(int)  -> Adds to the current combo
 reset()        -> Resets the combo meter to 0
 */
import Foundation

class ComboSystem{
    private var combo: Int = 0
    
    private static var sharedComboSystem: ComboSystem = {
        let comboSystem = ComboSystem()
        
        // Future confige goes here if needed
        
        return comboSystem
    }()
    
    class func shared() -> ComboSystem {
        return sharedComboSystem
    }
    
    func current() -> Int{
        return combo
    }
    
    func increase(amount: Int){
        combo += amount
    }
    
    func reset(){
        combo = 0
    }
    
}
