//
//  PathScene.swift
//  AStar
//
//  Created by Lin Knudsen on 6/7/17.
//  Copyright © 2017 Lin Knudsen. All rights reserved.
//

import SpriteKit

enum BuildMode : String {
    case walkable = "Walkable"
    case unwalkable = "Unwalkable"
    case start = "Start"
    case end = "End"
}

class PathScene: SKScene {

    var world: World
    let modeLabel: SKLabelNode
    let startNode : SKShapeNode
    let endNode : SKShapeNode
    
    let UI_Z_POS : CGFloat = 1.0
    let PATH_ENDPOINT_Z_POS : CGFloat = 0.1
    let START_NODE_NAME : String = "StartNode"
    let END_NODE_NAME : String = "EndNode"

    var buildMode : BuildMode = .walkable {
        didSet {
            modeLabel.text = buildMode.rawValue
            modeLabel.position = CGPoint(x: modeLabel.frame.width / 2 + 5, y: 10)
        }
    }
    
    var tileNodes : [[SKShapeNode]] = [[SKShapeNode]]()
    
    override init(size: CGSize) {
        world = World(size: size)
        modeLabel = SKLabelNode()
        
        startNode = SKShapeNode(circleOfRadius: Tile.TILE_SIZE.width / 2 )
        startNode.name = START_NODE_NAME
        startNode.fillColor = .green
        startNode.strokeColor = .black
        startNode.zPosition = PATH_ENDPOINT_Z_POS
        
        endNode = SKShapeNode(circleOfRadius: Tile.TILE_SIZE.width / 2)
        endNode.name = END_NODE_NAME
        endNode.fillColor = .blue
        endNode.strokeColor = .black
        endNode.zPosition = PATH_ENDPOINT_Z_POS
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView)
    {
        drawModeLabel()
        drawWorld()
        
        startNode.position = tileNodes[0][0].position
        endNode.position = tileNodes[0][0].position
    }
    
    override func keyDown(with event: NSEvent)
    {
        guard let chars = event.characters else { return }
        
        if chars == "b" || chars == "B"
        {
            switchBuildMode()
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let rawMousePos = event.location(in: self)
        let mousePos = CGPoint(x: rawMousePos.x - Tile.TILE_SIZE.width / 2, y: rawMousePos.y - Tile.TILE_SIZE.height / 2)
        changeTileAt(mousePosition: mousePos)
    }
    
    private func drawModeLabel()
    {
        modeLabel.zPosition = UI_Z_POS
        modeLabel.text = buildMode.rawValue
        modeLabel.fontColor = NSColor(calibratedWhite: 0.6, alpha: 1.0)
        modeLabel.fontName = "AvenirNext-Medium"
        modeLabel.position = CGPoint(x: modeLabel.frame.width / 2 + 5, y: 10)
        addChild(modeLabel)
    }
    
    private func drawWorld()
    {
        for x in (0..<world.width)
        {
            var col = [SKShapeNode]()
            for y in (0..<world.height)
            {
                let node = SKShapeNode(rectOf: Tile.TILE_SIZE)
                node.fillColor = world.tiles[x][y].isWalkable ? .white : .red
                node.strokeColor = .black
                node.position = CGPoint(x: Tile.TILE_SIZE.width * CGFloat(x) + Tile.TILE_SIZE.width / 2, y: Tile.TILE_SIZE.height * CGFloat(y) + Tile.TILE_SIZE.height / 2)
                addChild(node)
                col.append(node)
            }
            tileNodes.append(col)
        }
    }
    
    private func switchBuildMode()
    {
        switch buildMode
        {
        case .walkable:
            buildMode = .unwalkable
        case .unwalkable:
            buildMode = .start
        case .start:
            buildMode = .end
        case .end:
            buildMode = .walkable
        }
    }
    
    private func changeTileAt(mousePosition: CGPoint)
    {
        guard let tile = world.tileFrom(worldPosition: mousePosition) else {
            print("No tile from world position")
            return
        }
        let prevWalkable = tile.isWalkable
        let tileNode = tileNodes[tile.x][tile.y]
        
        switch buildMode {
        case .walkable:
            tile.isWalkable = true
        case .unwalkable:
            if childNode(withName: START_NODE_NAME) != nil || childNode(withName: END_NODE_NAME) != nil
            {
                if tileNode.position == startNode.position || tileNode.position == endNode.position
                {
                    return
                }
            }
            
            tile.isWalkable = false
        case .start:
            if childNode(withName: START_NODE_NAME) == nil {
                addChild(startNode)
            }
            
            guard tile.isWalkable else {
                return
            }
            startNode.position = tileNode.position
        case .end:
            if childNode(withName: END_NODE_NAME) == nil {
                addChild(endNode)
            }
            
            guard tile.isWalkable else {
                return
            }
            
            endNode.position = tileNode.position
        }
        
        if prevWalkable != tile.isWalkable {
            tileNode.fillColor = tile.isWalkable ? .white : .red
        }
    }
}
