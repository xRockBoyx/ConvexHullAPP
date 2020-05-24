//
//  ConvexHullViewController.swift
//  ConvexHull
//
//  Created by 黃威愷 on 2020/5/24.
//  Copyright © 2020 iOSClub. All rights reserved.
//

import UIKit


class ConvexHullViewController: UIViewController {
    
    var max_points = 0
    var points = [CGPoint]()
    var convexHull = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomPoints()
        initHull()
        print(self.navigationController?.navigationBar.frame.height)
        let newview = DrawView()
        newview.convexHull = convexHull
        newview.points = points
        newview.backgroundColor = .white
        self.view = newview
        
        print(max_points)
        
    }
    
    func generateRandomPoints(){
        
        let awayfromside:CGFloat = (self.navigationController?.navigationBar.frame.height)! * 3.5
        var randx:CGFloat = 0
        var randy:CGFloat = 0
        for _ in 1...max_points{
            randx = CGFloat(arc4random()) / CGFloat(UInt32.max) * (self.view.frame.width - awayfromside) + 0.5 * awayfromside
            randy = CGFloat(arc4random()) / CGFloat(UInt32.max) * (self.view.frame.height - awayfromside) + 0.5 * awayfromside
            points.append(CGPoint(x: randx, y: randy))
        }
        
        //將隨機產生的點依據x座標做排序
        points.sort{(f:CGPoint,o:CGPoint) -> Bool in
            return f.x < o.x
        }
        
    }
    
    //找到x座標最小及最大的兩點
    func initHull(){
        var ptemp = points
        
        let pLeft = ptemp.removeFirst()
        let pRight = ptemp.removeLast()
        
        convexHull.append(pLeft)
        convexHull.append(pRight)
        
        var Leftpoints = [CGPoint]()
        var Rightpoints = [CGPoint]()
        
        //pLeft to pRight 的向量
        let linevector = CGPoint(x: pRight.x-pLeft.x, y: pRight.y-pLeft.y)
        
        //利用向量外積判斷點是在pLeft to pRight的左邊還是右邊
        var pvector:CGPoint!
        var flag:CGFloat = 0
        for p in ptemp{
            pvector = CGPoint(x: p.x-pLeft.x, y: p.y-pLeft.y)
            flag = linevector.x*pvector.y - linevector.y*pvector.x
            
            //一邊來說向量外績結果 AxB ，若B在A的右邊，結果會小於零，但是Swift View的座標是以左上角為原點，所以外績結果恰好相反
            
            if flag > 0{
                Rightpoints.append(p)
            }else{
                Leftpoints.append(p)
            }
        }
        findHull(Rightpoints, pLeft, pRight)
        findHull(Leftpoints, pRight, pLeft)
    }
    func findHull(_ Points:[CGPoint],_ p1:CGPoint,_ p2:CGPoint){
        
        if Points.isEmpty{
            return
        }
        
        //找到距離p1 p2直線最遠的點並將其加入至convexHull中
        var pts = Points
        var maxDist: CGFloat = -1
        var maxPoint: CGPoint = pts.first!
        var dist:CGFloat!
        
        for p in pts{
            dist = pointToLineDistence(p, p1, p2)
            if dist > maxDist{
                maxDist = dist
                maxPoint = p
            }
            
        }
        convexHull.insert(maxPoint, at: convexHull.index(of: p1)!+1)
        pts.remove(at: pts.index(of: maxPoint)!)
        
        //這次只需檢查是否在線得右邊即可，因為線的左邊一定不會是convexHull的點之一
        
        var sone = [CGPoint]()
        var stwo = [CGPoint]()
        
        let linevector1 = CGPoint(x: maxPoint.x-p1.x, y: maxPoint.y-p1.y)
        let linevector2 = CGPoint(x: p2.x-maxPoint.x, y: p2.y-maxPoint.y)
        
        for p in pts{
            let vec1 = CGPoint(x: p.x-p1.x, y: p.y-p1.y)
            let vec2 = CGPoint(x: p.x - maxPoint.x, y: p.y - maxPoint.y)
            let flag1 = linevector1.x*vec1.y - linevector1.y*vec1.x
            let flag2 = linevector2.x*vec2.y - linevector2.y*vec2.x
            
            if flag1 > 0{
                sone.append(p)
            }else if flag2 > 0{
                stwo.append(p)
            }
        }
        findHull(sone, p1, maxPoint)
        findHull(stwo, maxPoint, p2)
        
    }
    func pointToLineDistence(_ p:CGPoint,_ p1:CGPoint,_ p2:CGPoint) -> CGFloat{
        if p1 == p2 {
          return sqrt(pow(p.x - p1.x, 2) + pow(p.y - p1.y, 2))
        }
        
        
        //點到直線公式
        return abs((p2.y - p1.y) * p.x
        - (p2.x - p1.x) * p.y
        + p2.x * p1.y
        - p2.y * p1.x)
            / sqrt(pow(p2.y - p1.y, 2) + pow(p2.x - p1.x, 2))
    }
//    func drawHull(){
//
//        let context = UIGraphicsGetCurrentContext()
//
//        // Draw hull
//        let lineWidth: CGFloat = 2.0
//
//        context!.setFillColor(UIColor.black.cgColor)
//        context!.setLineWidth(lineWidth)
//        context!.setStrokeColor(UIColor.red.cgColor)
//        context!.setFillColor(UIColor.black.cgColor)
//
//        let firstPoint = convexHull.first!
//        context!.move(to: firstPoint)
//
//        for p in convexHull.dropFirst() {
//          context!.addLine(to: p)
//        }
//        context!.addLine(to: firstPoint)
//
//        context!.strokePath()
//
//        // Draw points
//        for p in points {
//          let radius: CGFloat = 5
//          let circleRect = CGRect(x: p.x - radius, y: p.y - radius, width: 2 * radius, height: 2 * radius)
//          context!.fillEllipse(in: circleRect)
//        }
//    }
    

}
