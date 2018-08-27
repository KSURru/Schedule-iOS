//
//  RenderImageTableViewExtension.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 26.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

extension UITableView {
    
    var renderedImage: UIImage? {
        
        get {
            
            if Int(self.contentOffset.y) == 0 {
                
                UIGraphicsBeginImageContextWithOptions(CGSize(width: self.contentSize.width, height: self.contentSize.height - self.contentOffset.y), false, 0.0)
                
                let context = UIGraphicsGetCurrentContext()
                let previousFrame = self.frame
                
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.contentSize.width, height: self.contentSize.height)
                self.layer.render(in: context!)
                
                self.frame = previousFrame
                
                let image = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()

                return image
                
            } else {
                
                let contentOffset = self.contentOffset
                
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
                
                let context = UIGraphicsGetCurrentContext()
                
                context?.translateBy(x: 0, y: -contentOffset.y)
                
                self.layer.render(in: context!)
                
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return image
                
            }
            
        }
        
    }
    
}
