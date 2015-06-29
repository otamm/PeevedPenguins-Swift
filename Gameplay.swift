//
//  Gameplay.swift
//  PeevedPenguins
//
//  Created by Otavio Monteagudo on 6/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit;

class Gameplay:CCNode {
    /*** variables & constants ***/
    
    /* linked objects */
    
    // the root physics node of the gameplay scene.
    weak var gamePhysicsNode:CCPhysicsNode!;
    
    // the arm of the catapult.
    weak var catapultArm:CCNode!;
    
    // space where level CCB file will be loaded.
    weak var levelNode:CCNode!;
    
    // content node to hold all elements except for the UI ones.
    weak var contentNode:CCNode!;
    
    // invisible physics node to serve as a hooking point for pivot joint to keep catapult arm from falling.
    weak var pullbackNode:CCNode!;
    
    // will be used to connect catapult arm with joint pivot; when player touches arm, joint is created between this node and the arm.
    weak var mouseJointNode:CCNode!;
    
    /* custom variables */
    
    // mouse joint to be created between catapultArm and mouseJointNode. Its value is optional because the assigned value will be destroyed when touch ends and reset when another touch begins.
    var mouseJoint:CCPhysicsJoint?;
    
    
    /*** methods ***/
    
    /* cocos2d methods */
    
    // called when CCB file has completed loading
    func didLoadFromCCB() {
        self.userInteractionEnabled = true;
        let level1 = CCBReader.load("Levels/Level1");
        self.levelNode.addChild(level1);
        // visualize physics bodies & joints
        self.gamePhysicsNode.debugDraw = true;
        // the collisionMask arrays determines which objects will collide with the node; the pullback node is invisible and serves as a point of the pivot joint to keep the catapult arm steady, so nothing should collide with it.
        self.pullbackNode.physicsBody.collisionMask = [];
        self.mouseJointNode.physicsBody.collisionMask = []
    }
    
    // code to be triggered when reset button is pressed; Gameplay scene is reloaded.
    func reset() {
        let gameplayScene = CCBReader.loadAsScene("Gameplay");
        CCDirector.sharedDirector().presentScene(gameplayScene);
    }
    
    /* iOS methods */
    
    // called on every touch in this scene
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        let touchLocation = touch.locationInNode(self.contentNode);
        
        // start catapult dragging when a touch inside of the catapult arm occurs
        if (CGRectContainsPoint(self.catapultArm.boundingBox(), touchLocation)) {
            // move the mouseJointNode to the touch position
            self.mouseJointNode.position = touchLocation;
            
            // setup a spring joint between the mouseJointNode and the catapultArm
            mouseJoint = CCPhysicsJoint.connectedSpringJointWithBodyA(mouseJointNode.physicsBody, bodyB: catapultArm.physicsBody, anchorA: CGPointZero, anchorB: CGPoint(x: 34, y: 138), restLength: 0, stiffness: 3000, damping: 150);
        }
        //self.launchPenguin();
    }
    
    // called when touch is dragged on the screen
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        // whenever touches move, update the position of the mouseJointNode to the touch position
        let touchLocation = touch.locationInNode(self.contentNode);
        self.mouseJointNode.position = touchLocation;
    }
    
    // when touches end, meaning the user releases their finger, release the catapult
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        self.releaseCatapult();
    }
    
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        self.releaseCatapult();
    }
    
    /* custom methods */
    
    // loads a Penguin.ccb as a Penguin class instance, makes it into a physics object and applies force according to how the catapult is being manipulated.
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
    
    // code executed once a touch event ends
    func releaseCatapult() {
        if let joint = self.mouseJoint {
            // releases the joint and lets the catapult snap back
            joint.invalidate(); // interrupts all current effects of joint
            self.mouseJoint = nil // effectively destroys joint and liberates memory space
        }
    }
}
