//
//  Path.swift
//  AStar
//
//  Created by Lin Knudsen on 6/8/17.
//  Copyright © 2017 Lin Knudsen. All rights reserved.
//

import Foundation

class Path
{
    private(set) var tilesInPath : Stack<Tile> = Stack<Tile>()
    
    private var world : World
    
    static let diagonalDistance : Int = 14
    static let nondiagonalDistance : Int = 10
    
    init(world : World)
    {
        self.world = world
    }
    
    private var count = 0
    
    func findPath(from startTile : Tile, to endTile : Tile)
    {
        count += 1
        var openSet = [Tile] ()
        var closedSet = [Tile] ()
        
        openSet.append(startTile)
        
        while !openSet.isEmpty
        {
            var current = openSet[0]
            for t in openSet
            {
                if t.fCost < current.fCost || (t.fCost == current.fCost && t.gCost < current.gCost) {
                    current = t
                }
            }
            
            guard let currIndex = openSet.index(of: current) else {
                return
            }
            
            openSet.remove(at: currIndex)
            closedSet.append(current)
            
            if current == endTile {
                retracePath(from: startTile, to: endTile)
                return
            }
            
            for neighbor in current.getNeighbors()
            {
                if !neighbor.isWalkable || closedSet.contains(neighbor) {
                    continue
                }
                
                let newPathThroughNeighbor = current.gCost + world.getDistance(current, neighbor)
                
                if newPathThroughNeighbor < current.gCost || !openSet.contains(neighbor) {
                    neighbor.gCost = newPathThroughNeighbor
                    neighbor.hCost = world.getDistance(neighbor, endTile)
                    neighbor.parent = current
                    
                    if !openSet.contains(neighbor)
                    {
                        openSet.append(neighbor)
                    }
                }
            }
        }
    }
    
    private func retracePath(from startTile : Tile, to endTile : Tile)
    {
        var current : Tile? = endTile
        
        while current != nil {
            tilesInPath.push(current!)
            current = current?.parent
        }
    }
}
