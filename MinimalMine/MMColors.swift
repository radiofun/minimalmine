//
//  MMColors.swift
//  MinimalMine
//
//  Created by Jonathon Toon on 7/20/15.
//  Copyright (c) 2015 Jonathon Toon. All rights reserved.
//

import UIKit

extension UIColor {

    // Ideas
    // http://www.colourlovers.com/palette/3448677/Neon_Sunset
    // http://www.colourlovers.com/palette/1846981/Superfresh_Neon
    // http://www.colourlovers.com/palette/2949073/S_h_i_n_e
    // http://www.colourlovers.com/palette/1344537/Make_Mine_Fizzy
    
    class func boardBackgroundColor() -> UIColor {
        return UIColor.colorWithCSS("#060718")
    }
    
    class func defaultLevelColor() -> UIColor {
        return UIColor.colorWithCSS("#194D63")
    }
    
    class func defaultLevelRevealedColor() -> UIColor {
        return UIColor.defaultLevelColor().colorWithAlphaComponent(0.25)
    }
    
    class func normalLevelColor() -> UIColor {
        return UIColor.colorWithCSS("#499099")
    }
    
    class func mediumLevelColor() -> UIColor {
        return UIColor.colorWithCSS("#FBDF8E")
    }
    
    class func highLevelColor() -> UIColor {
        return UIColor.colorWithCSS("#EB5145")
    }
    
    class func maximumLevelColor() -> UIColor {
        return UIColor.highLevelColor()
    }
}
