//
//  MMBoardViewController.swift
//  MinimalMine
//
//  Created by Jonathon Toon on 7/18/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import AudioToolbox

extension UIView {
    
    func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            var aView = someView as! UIView
            var newWidth = aView.frame.origin.x + aView.frame.width
            var newHeight = aView.frame.origin.y + aView.frame.height
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
    }
    
}

class MMBoardViewController: UIViewController, UIGestureRecognizerDelegate, MMSquareViewInteractionDelegate {

    var containerView: UIView!
    
    var numberOfRows: Int = 9
    var numberOfColumns: Int = 0
    
    var squareSize: CGFloat = 0.0
    
    var xPosition: CGFloat = 0.0
    var yPosition: CGFloat = 0.0
    
    var board: MMBoardLogicController!
    var squareCellViews: [[MMSquareCellView]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.boardBackgroundColor()
    
        self.initBoard()
        self.startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func initBoard() {
        self.containerView = UIView(frame: CGRectMake(8.0, 8.0, self.view.frame.size.width - 8.0, self.view.frame.size.height - 8.0))
        self.containerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.containerView)
        
        // Setup squareSize and number of columns based on width of superview
        self.squareSize = (self.containerView.frame.size.width - (self.xPosition*2))/CGFloat(self.numberOfRows)
        self.numberOfColumns = Int((self.containerView.frame.size.height - self.yPosition)/self.squareSize)
        
        self.board = MMBoardLogicController(rows: self.numberOfRows, columns: self.numberOfColumns)
        
        self.drawCells()
    }
    
    func resetBoard() {
        // resets the board with new mine locations & sets isRevealed to false for each square
        self.board.resetBoard()
        // iterates through each button and resets the text to the default value
        
        for r in 0..<Int(self.numberOfRows) {
            for c in 0..<Int(self.numberOfColumns) {
                squareCellViews[r][c].drawSquareCellView()
            }
        }
    }
    
    func drawCells() {
        // Render Cells
        for r in 0..<Int(self.numberOfRows) {
            
            var squareCellViewColumn:[MMSquareCellView] = []
            
            for c in 0..<Int(self.numberOfColumns) {
                
                let squareCellView = MMSquareCellView(squareModel: self.board.squares[r][c], squareFrame: CGRectMake(self.xPosition, self.yPosition, self.squareSize, self.squareSize), delegate: self)
                self.containerView.addSubview(squareCellView)
                
                squareCellViewColumn.append(squareCellView)
                
                self.yPosition += self.squareSize
            }
            
            self.squareCellViews.append(squareCellViewColumn)
            
            self.xPosition += self.squareSize
            self.yPosition = 0.0
        }
        
        // Resize and reposition superview of cells
        self.containerView.resizeToFitSubviews()
        self.containerView.center = self.view.center
    }
    
    func startNewGame() {
        //start new game
        self.resetBoard()
    }

    func revealSquareCellView(squareCellView: MMSquareCellView) {
        
        if squareCellView.square.isMineLocation {
            
            squareCellView.square.isRevealed = true
            squareCellView.drawSquareCellView()
            self.minePressed()
        
        } else if !squareCellView.square.isRevealed && !squareCellView.square.isFlagged {
            
            squareCellView.square.isRevealed = true
            
            UIView.animateWithDuration(0.1, animations: {
                
                squareCellView.drawSquareCellView()
                
            }, completion: {
            
                finished in
                
                if squareCellView.square.numNeighboringMines == 0 {
                    
                    let neighboringCells = self.board.getNeighboringSquares(squareCellView.square)
                    
                    for cell in neighboringCells {
                        
                        let squareCellView = self.squareCellViews[cell.row][cell.col]
                        
                        self.revealSquareCellView(squareCellView)
                    }
                }
                
            })
        }
    }
    
    func addFlagToSquareCellView(squareCellView: MMSquareCellView) {
    
        if !squareCellView.square.isFlagged {
            if !squareCellView.square.isRevealed {
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                squareCellView.square.isFlagged = true
                squareCellView.drawSquareCellView()
            }
        } else {
            squareCellView.square.isFlagged = false
        }
        
    }
    
    func minePressed() {
        println("minePressed")
    }
    
    // SquareViewInteractionDelegate methods
    
    func tappedSquareCellView(gesture: UITapGestureRecognizer) {
        println("tapped")
        
        let squareCellView = gesture.view as! MMSquareCellView
        
        if gesture.state == UIGestureRecognizerState.Began {
            
        } else if gesture.state == UIGestureRecognizerState.Ended {

            self.revealSquareCellView(squareCellView)
            
        }
    }
    
    func longPressedSquareCellView(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            let squareCellView = gesture.view as! MMSquareCellView
            self.addFlagToSquareCellView(squareCellView)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}