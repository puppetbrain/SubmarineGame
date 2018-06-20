
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let scene = GameScene(size: CGSize(width: 667, height: 375))
    //    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // mid
    scene.anchorPoint = CGPoint(x: 0, y: 0) // bottom left
    let skView = view as! SKView
    skView.showsNodeCount = true
    scene.scaleMode = .aspectFill
    skView.presentScene(scene)
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .landscape
    } else {
      return .landscape
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
}
