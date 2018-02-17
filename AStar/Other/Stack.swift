//
//  Stack.swift
//  AStar
//
//  Created by Lin Knudsen on 6/8/17.
//  Copyright © 2017 Lin Knudsen. All rights reserved.
//

import Foundation

struct Stack<T>
{
    private var array: [T] = []
    
    mutating func push(_ element : T)
    {
        array.append(element)
    }
    
    mutating func pop() -> T?
    {
        return array.popLast()
    }
    
    func peek() -> T? {
        return array.last
    }
    
    func toArray() -> [T] {
        return array
    }
}
