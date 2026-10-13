//
//  NewsCard+UIGestureRecognizerDelegate.swift
//  NewsHub
//
//  Created by breno.farias on 13/10/26.
//

import UIKit

extension NewsCard: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        var touchedView = touch.view
        
        while let view = touchedView {
            if view is UIControl {
                return false
            }
            
            if view === self {
                break
            }
            
            touchedView = view.superview
        }
        
        return true
    }
}
