//
//  GameScene.swift
//  Project20
//
//  Created by Vladimir Vinageras on 25.02.2023.
//

import SpriteKit


class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    var leftEdge = -22
    var bottomEdge = -22
    var rightEdge = 1024 + 22
    
    var score = 0{
        didSet{
            //something heree
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
            background.position = CGPoint(x: 512, y: 384)
            background.blendMode = .replace
            background.zPosition = -1
            addChild(background)

        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
    }
    
    
     func createFireworks(xMovement: CGFloat, x: Int, y: Int){
        let node = SKNode()
        node.position = CGPoint(x: Double(x), y: Double(y))
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
         
         switch Int.random(in: 0...2){
         case 0:
             firework.color = .systemMint
         case 1:
             firework.color = .yellow
         default:
             firework.color = .purple
         }
         
         let path = UIBezierPath()
         path.move(to: .zero)
         path.addLine(to: CGPoint(x: xMovement, y: 1000))
         
         let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
         node.run(move)
         
         if let emitter = SKEmitterNode(fileNamed: "fuse"){
             emitter.position = CGPoint(x: 0, y: -22)
             node.addChild(emitter)
         }
         fireworks.append(node)
         addChild(node)
    }
    
    @objc func launchFireworks(){
        let movementAmount: CGFloat = 1800
        
        switch (Int.random(in: 0...400) % 4){
        case 0:
            // fire 5 FW, straight up
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            // fire 5 FW, in a fan
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFireworks(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFireworks(xMovement: 100, x: 512 + 100 , y: bottomEdge)
            createFireworks(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            // fire 5 FW, left to right
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireworks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            // fire 5 FW, right to left
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireworks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch =touches.first else {return}
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint{
            guard node.name = "firework" else {continue}
            node.name = "selected "
        }
    }
    
}
