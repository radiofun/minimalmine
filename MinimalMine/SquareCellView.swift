//
//  SquareCellView.swift
//  MinimalMine
//
//  Created by Jonathon Toon on 7/18/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

protocol SquareViewInteractionDelegate {
    
    func tappedSquareCellView(gesture: UITapGestureRecognizer)
    func longPressedSquareCellView(gesture: UILongPressGestureRecognizer)
    
}

class SquareCellView : UIView {
    
    var square:Square
    var circleView: UIView!
    var counterLabel: UILabel!
    
    var delegate: SquareViewInteractionDelegate!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    init(squareModel:Square, squareFrame: CGRect, delegate: SquareViewInteractionDelegate!) {
        self.square = squareModel
        self.delegate = delegate
        
        super.init(frame: squareFrame)
        
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.circleView = UIView(frame: CGRectMake(0, 0, self.frame.size.width-4, self.frame.size.height-4))
        self.circleView.layer.cornerRadius = self.circleView.frame.size.width/2
        self.circleView.backgroundColor = UIColor.whiteColor()
        self.circleView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addSubview(self.circleView)
        
        self.counterLabel = UILabel()
        self.counterLabel.text = ""
        self.counterLabel.font = UIFont(name: "AvenirNext-Bold", size: 17.0)
        self.counterLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        self.counterLabel.sizeToFit()
        self.circleView.addSubview(self.counterLabel)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedSquareCellView:")
        self.tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(self.tapGestureRecognizer)
        
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressedSquareCellView:")
        self.addGestureRecognizer(self.longPressGestureRecognizer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor() {
        self.circleView.backgroundColor = UIColor.whiteColor()
        
        if self.square.isRevealed {
            if self.square.isMineLocation {
                self.circleView.backgroundColor = UIColor.blueColor()
            } else if self.square.numNeighboringMines == 1 {
                self.circleView.backgroundColor = UIColor.colorWithCSS("#FE5A1D")
            } else if self.square.numNeighboringMines == 2 {
                self.circleView.backgroundColor = UIColor.colorWithCSS("#D8230E")
            } else if self.square.numNeighboringMines == 3 {
                self.circleView.backgroundColor = UIColor.colorWithCSS("#970F01")
            } else if self.square.numNeighboringMines > 3 {
                self.circleView.backgroundColor = UIColor.colorWithCSS("#5E0000")
            }
            
            if !self.square.isMineLocation {
                self.setCounterLabel()
            }
        }
    }
    
    func setCounterLabel() {
        
        self.counterLabel.text = String(self.square.numNeighboringMines)
        self.counterLabel.sizeToFit()
        self.counterLabel.center = CGPointMake(self.circleView.frame.size.width/2, self.circleView.frame.size.height/2)

    }
    
    func tappedSquareCellView(gesture: UITapGestureRecognizer) {
        if self.delegate != nil { self.delegate.tappedSquareCellView(gesture) }
    }
    
    func longPressedSquareCellView(gesture: UILongPressGestureRecognizer) {
        if self.delegate != nil { self.delegate.longPressedSquareCellView(gesture) }
    }
}