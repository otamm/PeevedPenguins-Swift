//
//  Penguin.swift
//  PeevedPenguins
//
//  Created by Otavio Monteagudo on 6/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit;

class Penguin: CCSprite {
    
    /* cocos 2d methods */
    
    // Automatically executed when any penguin sprite is loaded (new instance of Penguin class is created).
    func didLoadFromCCB() {
        println("Penguin created!")
    }
}
