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
    
    func findPath(from startTile : Tile, to endTile : Tile)
    {
        //The start tile should never have a parent, or an infinite loop will happen
        startTile.parent = nil
        
        var openSet = [Tile] ()
        var closedSet = [Tile] ()
        
        //We want to explore the start tile
        openSet.append(startTile)
        
        //As long as there are possibilities to check, we should keep running the algorithm
        while !openSet.isEmpty
        {
            //The first tile in the open set should be the one we are on
            var current = openSet[0]
            
            //However, if there is another tile in the open set that has a lower f-cost or, if a tie, a lower g-cost, we will pick that one instead.
            for t in openSet
            {
                if t.fCost < current.fCost || (t.fCost == current.fCost && t.gCost < current.gCost) {
                    current = t
                }
            }
            
            guard let currentIndex = openSet.index(of: current) else {
                return
            }
            
            //Since we have now "explored" the current tile, we can put it in the closed set.
            openSet.remove(at: currentIndex)
            closedSet.append(current)
            
            //Are we there yet?
            if current == endTile {
                retracePath(from: startTile, to: endTile)
                return
            }
            
            //We need to find our next options
            for neighbor in current.getNeighbors()
            {
                //We don't want our path to cut corners. That's not realistic and looks disgusting.
                var cutsCorner = false
                //is it the top left corner?
                if neighbor.x == current.x - 1 && neighbor.y  == current.y + 1 {
                    //If so, are the tiles to the right or bottom of it blocked?
                    if !world.tiles[neighbor.x + 1][neighbor.y].isWalkable || !world.tiles[neighbor.x][neighbor.y - 1].isWalkable {
                        //If so, that is cutting a corner and IS NOT ACCEPTABLE!
                        cutsCorner = true
                    }
                } //Repeat for other corners
                else if neighbor.x == current.x + 1 && neighbor.y == current.y + 1 { //Is it a top right corner?
                    if !world.tiles[neighbor.x - 1][neighbor.y].isWalkable || !world.tiles[neighbor.x][neighbor.y - 1].isWalkable {
                        cutsCorner = true
                    }
                }
                else if neighbor.x == current.x - 1 && neighbor.y == current.y - 1 { //Is it a bottom left corner?
                    if !world.tiles[neighbor.x + 1][neighbor.y].isWalkable || !world.tiles[neighbor.x][neighbor.y + 1].isWalkable {
                        cutsCorner = true
                    }
                }
                else if neighbor.x == current.x + 1 && neighbor.y == current.y - 1 { //Is it a bottom right corner?
                    if !world.tiles[neighbor.x - 1][neighbor.y].isWalkable || !world.tiles[neighbor.x][neighbor.y + 1].isWalkable {
                        cutsCorner = true
                    }
                }
                
                if !neighbor.isWalkable || closedSet.contains(neighbor) || cutsCorner {
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
