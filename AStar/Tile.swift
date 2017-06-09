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
    
    private(set) var x: Int
    private(set) var y: Int
    
    private weak var world : World?
    
    var isWalkable : Bool
    
    init(x: Int, y: Int, world : World?, walkable : Bool = true)
    {
        self.x = x
        self.y = y
        self.world = world
        isWalkable = walkable
    }
}
