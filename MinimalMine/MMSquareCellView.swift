//
//  MMSquareCellView.swift
//  MinimalMine
//
//  Created by Jonathon Toon on 7/18/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

protocol MMSquareViewInteractionDelegate {
    
    func tappedSquareCellView(gesture: UITapGestureRecognizer)
    func longPressedSquareCellView(gesture: UILongPressGestureRecognizer)
    
}

class MMSquareCellView : UIView {
    
    var square:MMSquare
    var circleView: UIView!
    var flagImageView: UIImageView!
    var counterLabel: UILabel!
    
    
    var delegate: MMSquareViewInteractionDelegate!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    init(squareModel: MMSquare, squareFrame: CGRect, delegate: MMSquareViewInteractionDelegate!) {
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
        
        self.flagImageView = UIImageView(image: UIImage(named: "flagIcon"))
        self.flagImageView.frame = CGRectMake(0, 0, 19, 22)
        self.flagImageView.center = CGPointMake(self.circleView.frame.size.width/2, self.circleView.frame.size.height/2)
        self.flagImageView.alpha = 0.0
        self.circleView.addSubview(self.flagImageView)
        
        self.counterLabel = UILabel()
        self.counterLabel.text = ""
        self.counterLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 17.0)
        self.counterLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        self.counterLabel.sizeToFit()
        self.circleView.addSubview(self.counterLabel)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedSquareCellView:")
        self.addGestureRecognizer(self.tapGestureRecognizer)
        
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressedSquareCellView:")
        self.addGestureRecognizer(self.longPressGestureRecognizer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawSquareCellView() {
        self.circleView.backgroundColor = UIColor.defaultLevelColor()
        
        if self.square.isRevealed {
            
            if self.square.isMineLocation {
                self.circleView.backgroundColor = UIColor.blueColor()
            } else if self.square.numNeighboringMines == 1 {
                self.circleView.backgroundColor = UIColor.normalLevelColor()
            } else if self.square.numNeighboringMines == 2 {
                self.circleView.backgroundColor = UIColor.mediumLevelColor()
            } else if self.square.numNeighboringMines == 3 {
                self.circleView.backgroundColor = UIColor.highLevelColor()
            } else if self.square.numNeighboringMines > 3 {
                self.circleView.backgroundColor = UIColor.maximumLevelColor()
            } else {
                self.circleView.backgroundColor = UIColor.defaultLevelRevealedColor()
            }
            
            if !self.square.isMineLocation {
                self.setCounterLabel()
            }
      
        } else if self.square.isFlagged {
            self.flagImageView.alpha = 1.0
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