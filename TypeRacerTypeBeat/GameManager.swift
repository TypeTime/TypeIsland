//
//  PointManager.swift
//  TypeRacerTypeBeat
//
//  Created by Justin Dang on 3/21/22.
//
/*
 Function(GameManager):
 
 add(int)                   -> Add points on top of the current amount of points
 score()                    -> returns the current amount of points
 increaseMult(amount:Float) -> Adds to current multiplier
 resetMult()                -> Resets the multiplier(no longer affects points gained)
 resetScore()               -> resets score to 0
 reset()                    -> Resets points, multiplier, score
 
 
 Function(GameManager.combo):
 
 shared()                   -> Creates an instance of combo system(ex comboSystem = ComboSystem.shared())
                               Used for a singleton, similar to C coding where: ComboSystem comboSystem = new ComboSystem()
 current()                  -> Returns the current combo
 increase(int)              -> Adds to the current combo
 reset()                    -> Resets the combo meter to 0
 */

import Foundation

class GameManager: ComboSystem{
    private var points = 0
    private var multiplier:Float = 1
    let combo = ComboSystem()
    
    
    
    func score() -> Int{
        return points
    }
    
    func add(points: Int){
        if multiplier > 1 {
            self.points += Int((Float(points) * multiplier))
        }
        else {
            self.points += points
        }
    }
    
    func addMult(amount:Float){
        multiplier += amount
    }
    
    func resetMult(){
        multiplier = 1
    }
    
    func resetScore(){
        points = 0
    }
    
    override func reset(){
        resetMult()
        resetScore()
        combo.reset()
    }
    
    
}
