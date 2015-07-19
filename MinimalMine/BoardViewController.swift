//
//  BoardViewController.swift
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

class BoardViewController: UIViewController, SquareViewInteractionDelegate {

    var containerView: UIView!
    
    var numberOfRows: Int = 9
    var numberOfColumns: Int = 0
    
    var squareSize: CGFloat = 0.0
    
    var xPosition: CGFloat = 0.0
    var yPosition: CGFloat = 0.0
    
    var board: BoardController!
    var squareViews: [SquareView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.colorWithCSS("#180107")
    
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
        
        self.board = BoardController(rows: self.numberOfRows, columns: self.numberOfColumns)
        
        // Render cells
        for r in 0..<Int(self.numberOfRows) {
            for c in 0..<Int(self.numberOfColumns) {
        
                let squareView = SquareView(squareModel: self.board.squares[r][c], squareFrame: CGRectMake(self.xPosition, self.yPosition, self.squareSize, self.squareSize), delegate: self)
                self.containerView.addSubview(squareView)
                
                self.squareViews.append(squareView)
                
                self.yPosition += self.squareSize
            }
            
            self.xPosition += self.squareSize
            self.yPosition = 0.0
        }
        
        // Resize and reposition superview of cells
        self.containerView.resizeToFitSubviews()
        self.containerView.center = self.view.center
    }
    
    func resetBoard() {
        // resets the board with new mine locations & sets isRevealed to false for each square
        self.board.resetBoard()
        // iterates through each button and resets the text to the default value
        for squareView in self.squareViews {
            squareView.setBackgroundColor()
        }
    }
    
    func startNewGame() {
        //start new game
        self.resetBoard()
    }

    func minePressed() {
    
    }
    
    // SquareViewInteractionDelegate methods
    
    func tappedSquareView(gesture: UITapGestureRecognizer) {
        println("tapped")
        
        let squareView = gesture.view as! SquareView
        
        if !squareView.square.isRevealed {
            squareView.square.isRevealed = true
            squareView.setBackgroundColor()
            //self.moves++
        }
        
        if squareView.square.isMineLocation {
            squareView.setBackgroundColor()
            self.minePressed()
        }
    }
    
    func longPressedSquareView(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.Began {
            println("longPressed")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}