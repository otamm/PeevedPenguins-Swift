import Foundation

class MainScene: CCNode {
    
    /* cocos2d methods */
    
    // automatically executes when scene is loaded.
    func didLoadFromCCB() {
        CCBReader.load("Penguin.ccb");
        CCBReader.load("Seal.ccb");
    }
    
    // triggered when button with selector 'play' is pressed
    func play() {
        //println("Play button pressed");
        let gameplayScene = CCBReader.loadAsScene("Gameplay.ccb"); // loads layer CCB file as scene
        CCDirector.sharedDirector().presentScene(gameplayScene); // replaces current MainScene with gameplayScene
    }
}
