//
//  WaitingPenguin.swift
//  PeevedPenguins
//
//  Created by Otavio Monteagudo on 6/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class WaitingPenguin:CCSprite {
    
    /* cocos2d methods */
    func didLoadFromCCB() {
        // generate a random number between 0.0 and 2.0
        let delay = CCRANDOM_0_1() * 2
        // call method to start animation after random delay
        self.scheduleOnce("startBlinkAndJump", delay: CCTime(delay))
    }
    
    /* custom methods */
    func startBlinkAndJump() {
        // timelines can be referenced and run by name using the animation manager
        self.animationManager.runAnimationsForSequenceNamed("BlinkAndJump");
    }
    
}
