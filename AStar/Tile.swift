//
//  Tile.swift
//  AStar
//
//  Created by Lin Knudsen on 6/7/17.
//  Copyright © 2017 Lin Knudsen. All rights reserved.
//

import Foundation

class Tile
{
    static let TILE_SIZE : CGSize = CGSize(width: 50, height: 50)
    
    fileprivate(set) var x: Int
    fileprivate(set) var y: Int
    
    fileprivate weak var world : World?
    
    var isWalkable : Bool
    
    var gCost : Int = 0
    var hCost : Int = 0
    
    var parent : Tile?
    
    var fCost : Int {
        return gCost + hCost
    }
    
    init(x: Int, y: Int, world : World?, walkable : Bool = true)
    {
        self.x = x
        self.y = y
        self.world = world
        isWalkable = walkable
    }
    
    func getNeighbors() -> [Tile]
    {
        var neighbors = [Tile]()
        
        for i in (-1...1)
        {
            for j in (-1...1)
            {
                if i == 0 && j == 0
                {
                    continue
                }
                
                let checkX = x + i
                let checkY = y + j
                
                guard let world = world else { return [] }
                
                if checkX >= 0 && checkX < world.width && checkY >= 0 && checkY < world.height {
                    neighbors.append(world.tiles[checkX][checkY])
                }
            }
        }
        return neighbors
    }
}

extension Tile : Hashable {
    var hashValue: Int {
        return "\(x),\(y)".hashValue ^ x - 7
    }
}

extension Tile : Equatable {
    static func ==(lhs: Tile, rhs: Tile) -> Bool
    {
        return lhs.hashValue == rhs.hashValue
    }
}
