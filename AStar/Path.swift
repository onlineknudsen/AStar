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
    
    static let DIAGONAL_DISTANCE : Int = 14
    static let NONDIAGONAL_DISTANCE : Int = 10
    
    init(world : World)
    {
        self.world = world
    }
    
    func findPath(from startTile : Tile, to endTile : Tile)
    {
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
            
            guard let indexOfCurr = openSet.index(of: current) else {
                return
            }
            
            openSet.remove(at: indexOfCurr)
            closedSet.append(current)
            
            if current == endTile {
                //TODO: Retrace path
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
