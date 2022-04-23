//
//  Enemy.swift
//  TypeRacerTypeBeat
//
//  Created by Justin Dang on 4/8/22.
//

import Foundation

class Enemy{
    var health:Int
    
    init(amount: Int){
        health = amount
    }
    
    func damage(amount: Int){
        health -= amount
    }
}
