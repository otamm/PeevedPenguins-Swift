//
//  Gameplay.swift
//  PeevedPenguins
//
//  Created by Otavio Monteagudo on 6/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit;

class Gameplay:CCNode {
    /* linked objects */
    
    // the root physics node of the gameplay scene.
    weak var gamePhysicsNode:CCPhysicsNode!;
    
    // the arm of the catapult.
    weak var catapultArm:CCNode!;
    
    // space where level CCB file will be loaded.
    weak var levelNode:CCNode!;
    
    // content node to hold all elements except for the UI ones.
    weak var contentNode:CCNode!;
    
    /* cocos2d methods */
    
    // called when CCB file has completed loading
    func didLoadFromCCB() {
        self.userInteractionEnabled = true;
        let level1 = CCBReader.load("Levels/Level1");
        self.levelNode.addChild(level1);
        // visualize physics bodies & joints
        self.gamePhysicsNode.debugDraw = true
    }
    
    // code to be triggered when reset button is pressed; Gameplay scene is reloaded.
    func reset() {
        let gameplayScene = CCBReader.loadAsScene("Gameplay");
        CCDirector.sharedDirector().presentScene(gameplayScene);
    }
    /* iOS methods */
    
    // called on every touch in this scene
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        self.launchPenguin();
    }
    
    /* custom methods */
    
    func launchPenguin() {
        // loads the Penguin.ccb we have set up in SpriteBuilder
        let penguin = CCBReader.load("Penguin") as! Penguin; // loads as a Penguin class instance
        // position the penguin at the bowl of the catapult
        penguin.position = ccpAdd(catapultArm.position, CGPoint(x: 16, y: 50))
        
        // add the penguin to the gamePhysicsNode (because the penguin has physics enabled)
        self.gamePhysicsNode.addChild(penguin);
        
        // manually create & apply a force to launch the penguin
        let launchDirection = CGPoint(x: 1, y: 0);
        let force = ccpMult(launchDirection, 8000);
        penguin.physicsBody.applyForce(force);
        
        // ensure followed object is in visible are when starting
        self.position = CGPoint.zeroPoint;
        let actionFollow = CCActionFollow(target: penguin, worldBoundary: boundingBox());
        //self.runAction(actionFollow); will follow penguin, but UI elements would stay behind.
        self.contentNode.runAction(actionFollow);
    }
}
