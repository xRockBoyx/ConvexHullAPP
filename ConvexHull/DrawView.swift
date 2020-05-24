//
//  DrawView.swift
//  ConvexHull
//
//  Created by 黃威愷 on 2020/5/24.
//  Copyright © 2020 iOSClub. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var convexHull = [CGPoint]()
    var points = [CGPoint]()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw hull
        let lineWidth: CGFloat = 2.0

        context!.setFillColor(UIColor.black.cgColor)
        context!.setLineWidth(lineWidth)
        context!.setStrokeColor(UIColor.red.cgColor)
        context!.setFillColor(UIColor.black.cgColor)

        let firstPoint = convexHull.first!
        context!.move(to: firstPoint)

        for p in convexHull.dropFirst() {
          context!.addLine(to: p)
        }
        context!.addLine(to: firstPoint)

        context!.strokePath()

        // Draw points
        for p in points {
          let radius: CGFloat = 5
          let circleRect = CGRect(x: p.x - radius, y: p.y - radius, width: 2 * radius, height: 2 * radius)
          context!.fillEllipse(in: circleRect)
        }
    }

}
