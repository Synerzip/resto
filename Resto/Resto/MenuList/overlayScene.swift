//
//  overlayScene.swift
//  Resto
//
//  Created by Aditya Kulkarni on 26/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit
import SpriteKit

class overlayScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = UIColor.clear
        plotIngredients()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func plotIngredients() {
        let ingredientCount = 5
        let startX: CGFloat = 100.0
        let startY: CGFloat = 500.0
        let endX: CGFloat = size.width - 100
        let endY: CGFloat = 384.0
        let midX: CGFloat = (endX - startX) / 2.0
        let midY: CGFloat = size.height - 50
        
        let xFactor = (endX - startX) / CGFloat(ingredientCount)
        let yFactor = (midY - startY) / CGFloat(ingredientCount)
        
        for index in 1...ingredientCount {
            let node = getIngredientNode()
            let mod = ingredientCount % index
            
            let xPos = CGFloat(index - 1) * xFactor + startX
            let yPos = CGFloat(mod) * yFactor + startY
            node.position = CGPoint(x: xPos, y: yPos)
            self.addChild(node)
        }
    }
    
    func getIngredientNode() -> SKNode {
        let spriteSize = size.width/12
        let imageNode = SKSpriteNode(imageNamed: "PotatoMashed")
        imageNode.size = CGSize(width: spriteSize, height: spriteSize)
        
        let nameNode = SKLabelNode(text: "Mashed Potato")
        nameNode.fontName = "DINAlternate-Bold"
        nameNode.fontColor = UIColor.white
        nameNode.fontSize = 24
        
        let labelBackground = SKSpriteNode(color: UIColor.black, size: CGSize(width: nameNode.frame.size.width + 10, height: nameNode.frame.size.height + 10))
        labelBackground.position = CGPoint(x: imageNode.position.x, y: imageNode.position.y - 70)
        labelBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        labelBackground.xScale = 1.5
//        labelBackground.yScale = 1.5
        nameNode.position = CGPoint(x: 0, y: -10)
        labelBackground.addChild(nameNode)
        
        let ingredientNode = SKNode()
        ingredientNode.addChild(imageNode)
        ingredientNode.addChild(labelBackground)
        return ingredientNode
    }
}
