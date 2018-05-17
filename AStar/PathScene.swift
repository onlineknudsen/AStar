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
    
    let uiZPosition : CGFloat = 1.0
    let pathEndPointZPosition : CGFloat = 0.1
    let startNodeName : String = "StartNode"
    let endNodeName : String = "EndNode"

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
        
        startNode = SKShapeNode(circleOfRadius: Tile.tileSize.width / 2 )
        startNode.name = startNodeName
        startNode.fillColor = .green
        startNode.strokeColor = .black
        startNode.zPosition = pathEndPointZPosition
        
        endNode = SKShapeNode(circleOfRadius: Tile.tileSize.width / 2)
        endNode.name = endNodeName
        endNode.fillColor = .blue
        endNode.strokeColor = .black
        endNode.zPosition = pathEndPointZPosition
        
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
    
    override func mouseDown(with event: NSEvent) {
        let mousePos = event.location(in: self)
        onTileClick(mousePosition: mousePos)
    }
    
    private func drawModeLabel()
    {
        modeLabel.zPosition = uiZPosition
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
                let node = SKShapeNode(rectOf: Tile.tileSize)
                node.fillColor = world.tiles[x][y].isWalkable ? .white : .red
                node.strokeColor = .black
                node.position = CGPoint(x: Tile.tileSize.width * CGFloat(x) + Tile.tileSize.width / 2, y: Tile.tileSize.height * CGFloat(y) + Tile.tileSize.height / 2)
                addChild(node)
                col.append(node)
            }
            tileNodes.append(col)
        }
    }
    
    func switchBuildMode()
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
    
    private func onTileClick(mousePosition: CGPoint)
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
            if childNode(withName: startNodeName) != nil || childNode(withName: endNodeName) != nil
            {
                if tileNode.position == startNode.position || tileNode.position == endNode.position
                {
                    return
                }
            }
            
            tile.isWalkable = false
        case .start:
            if childNode(withName: startNodeName) == nil {
                addChild(startNode)
            }
            
            guard tile.isWalkable else {
                return
            }
            startNode.position = tileNode.position
            startNode.isHidden = false
        case .end:
            if childNode(withName: endNodeName) == nil {
                addChild(endNode)
            }
            
            guard tile.isWalkable else {
                return
            }
            
            endNode.position = tileNode.position
            endNode.isHidden = false
        }
        
        if prevWalkable != tile.isWalkable {
            tileNode.fillColor = tile.isWalkable ? .white : .red
        }
    }
    
    func pathfind()
    {
        guard (childNode(withName: startNodeName) != nil || startNode.isHidden) && (childNode(withName: endNodeName) != nil || endNode.isHidden) else {
            let alert = NSAlert()
            alert.messageText = "Missing start or end node found."
            alert.informativeText = "Please add the missing start or end node."
            alert.addButton(withTitle: "Ok")
            alert.runModal()
            return
        }
        
        let path = Path(world: world)
        path.findPath(from: world.tileFrom(worldPosition: startNode.position)!, to: world.tileFrom(worldPosition: endNode.position)!)
        
        let tilesInPath = path.tilesInPath.toArray()
        
        if tilesInPath.isEmpty {
            let alert = NSAlert()
            alert.messageText = "Path not found."
            alert.addButton(withTitle: "Ok")
            alert.runModal()
            return
        }
        
        for x in (0..<world.width)
        {
            for y in (0..<world.height)
            {
                if tilesInPath.contains(world.tiles[x][y])
                {
                    tileNodes[x][y].fillColor = .yellow
                }
                else
                {
                    tileNodes[x][y].fillColor = world.tiles[x][y].isWalkable ? .white : .red
                }
            }
        }
    }
    
    func clearWorld()
    {
        print("Clearing...")
        world.clear()
        for x in (0..<world.width)
        {
            for y in (0..<world.height)
            {
                tileNodes[x][y].fillColor = .white
            }
        }
        startNode.isHidden = true
        endNode.isHidden = true
    }
}
