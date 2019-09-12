//
//  UIView+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

extension UIView
{
    var width:CGFloat {
        get {
            return bounds.size.width
        }
        set {
            var rect = bounds
            rect.size.width = newValue
            bounds = rect
        }
    }
    
    var height:CGFloat {
        get {
            return bounds.size.height
        }
        set {
            var rect = bounds
            rect.size.height = newValue
            bounds = rect
        }
    }
    
    var size:CGSize {
        get {
            return bounds.size
        }
        set {
            var rect = bounds
            rect.size = newValue
            bounds = rect
        }
    }
    
    var x:CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }
    
    var y:CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }
    
    var origin:CGPoint {
        get {
            return frame.origin
        }
        set {
            var rect = frame
            rect.origin = newValue
            frame = rect
        }
    }
    
    var centerX:CGFloat {
        get {
            return center.x
        }
        set {
            var point = center
            point.x = newValue
            center = point
        }
    }
    
    var centerY:CGFloat {
        get {
            return center.y
        }
        set {
            var point = center
            point.y = newValue
            center = point
        }
    }
}

