//
//  BoardController.swift
//  MinimalMine
//
//  Created by Jonathon Toon on 7/18/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import Foundation

class BoardController {

    let rows:Int
    let columns:Int
    var squares:[[Square]] = []
    
    init(rows:Int, columns:Int) {
        self.rows = rows
        self.columns = columns
        
        for r in 0..<self.rows {
            var squareRow:[Square] = []
            
            for c in 0..<self.columns {
             
                let square = Square(row: r, col: c)
                squareRow.append(square)
                
            }
            
            squares.append(squareRow)
        }
    }
    
    func resetBoard() {
     
        // assign mines to squares
        for r in 0..<self.rows {
            
            for c in 0..<self.columns {
                
                self.squares[r][c].isRevealed = false
                self.calculateIsMineLocationForSquare(squares[r][c])
                
            }
        }
        
        // count number of neighboring squares
        for r in 0..<self.rows {
            for c in 0..<self.columns {
                self.calculateNumNeighborMinesForSquare(squares[r][c])
            }
        }
        
    }

    func calculateIsMineLocationForSquare(square: Square) {
        square.isMineLocation = ((arc4random()%10) == 0) // 1-in-10 chance that each location contains a mine
    }
    
    func calculateNumNeighborMinesForSquare(square : Square) {
        // first get a list of adjacent squares
        let neighbors = getNeighboringSquares(square)
        var numNeighboringMines = 0
        
        // for each neighbor with a mine, add 1 to this square's count
        for neighborSquare in neighbors {
            if neighborSquare.isMineLocation {
                numNeighboringMines++
            }
        }
        square.numNeighboringMines = numNeighboringMines
    }
    
    func getNeighboringSquares(square : Square) -> [Square] {
        var neighbors:[Square] = []
        
        // an array of tuples containing the relative position of each neighbor to the square
        let adjacentOffsets =
        [(-1,-1),(0,-1),(1,-1),
            (-1,0),(1,0),
            (-1,1),(0,1),(1,1)]
        
        for (rowOffset,colOffset) in adjacentOffsets {
            // getTileAtLocation might return a Square, or it might return nil, so use the optional datatype "?"
            let optionalNeighbor:Square? = getTileAtLocation(square.row+rowOffset, col: square.col+colOffset)
            // only evaluates true if the optional tile isn't nil
            if let neighbor = optionalNeighbor {
                neighbors.append(neighbor)
            }
        }
        return neighbors
    }
    
    func getTileAtLocation(row : Int, col : Int) -> Square? {
        if row >= 0 && row < self.rows && col >= 0 && col < self.columns {
            return squares[row][col]
        } else {
            return nil
        }
    }
    
    
}

