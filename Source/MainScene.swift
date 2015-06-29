import Foundation

class MainScene: CCNode {
    
    /* cocos2d methods */
    
    func didLoadFromCCB() {
        CCBReader.load("Penguin.ccb");
        CCBReader.load("Seal.ccb");
    }
}
