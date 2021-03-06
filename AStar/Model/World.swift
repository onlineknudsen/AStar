//
//  World.swift
//  AStar
//
//  Created by Lin Knudsen on 6/7/17.
//  Copyright © 2017 Lin Knudsen. All rights reserved.
//

import Foundation

class World
{
    var tiles : [[Tile]] = [[Tile]]()
    
    private(set) var width : Int = 0
    private(set) var height : Int = 0
    
    private var worldSize : CGSize
    
    init(size : CGSize)
    {
        width = Int(round(size.width / Tile.tileSize.width))
        height = Int(round(size.height / Tile.tileSize.height))
        worldSize = size
        createTiles()
    }
    
    private func createTiles()
    {
        for x in (0..<width)
        {
            var col = [Tile]()
            for y in (0..<height)
            {
                col.append(Tile(x: x, y: y, world: self))
            }
            tiles.append(col)
        }
    }
    
    func tileFrom(worldPosition: CGPoint) -> Tile?
    {
        let adjustedWorldPos = CGPoint(x: worldPosition.x - Tile.tileSize.width / 2, y: worldPosition.y - Tile.tileSize.height / 2)
        var percentX = adjustedWorldPos.x / worldSize.width
        var percentY = adjustedWorldPos.y / worldSize.height
        
        if percentX < 0
        {
            percentX = 0
        }
        else if percentX > 1
        {
            percentX = 1
        }
        
        if percentY < 0
        {
            percentY = 0
        }
        else if percentY > 1
        {
            percentY = 1
        }
        
        let x = Int(round(percentX * CGFloat(width)))
        let y = Int(round(percentY * CGFloat(height)))
        return tiles[x][y]
    }
    
    func clear()
    {
        for x in (0..<width)
        {
            for y in (0..<height)
            {
                tiles[x][y].isWalkable = true
            }
        }
    }
    
    //Manhattan heuristic
    func getDistance(_ tileA : Tile, _ tileB : Tile) -> Int
    {
        let dX = abs(tileA.x - tileB.x)
        let dY = abs(tileA.y - tileB.y)
        
        return dX + dY
    }
}
