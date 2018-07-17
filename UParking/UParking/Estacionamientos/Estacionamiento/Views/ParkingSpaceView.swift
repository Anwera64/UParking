    //
//  ParkingSpaceView.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/16/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class ParkingSpaceView: UIView, ParkingSpaceViewDelegate {
    
    var spaces: Int!
    var spacesViews: [SpaceView] = []
    var delegate: ParkingSpaceViewDelegate!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawSpaces()
    }
    
    private func drawSpaces() {
        //Linea de arriba
        let topHalfSpaces = spaces/2
        var y = self.bounds.origin.y
        let horizontalPadding: CGFloat = 8
        let verticalPadding: CGFloat = 8
        let x = self.bounds.origin.x
        
        let width = (self.bounds.width - CGFloat((topHalfSpaces+1)) * horizontalPadding) / CGFloat(topHalfSpaces)+1
        let height = (self.bounds.height - CGFloat(3) * verticalPadding) / CGFloat(3)
        for i in 0...topHalfSpaces-1 {
            drawSpace(at: x, at: y, withY: verticalPadding, withX: horizontalPadding, n: i, width: width, height: height, pos: i)
        }
        
        y = self.bounds.origin.y + self.bounds.height - height - verticalPadding*2
        let lowHalfSpaces = spaces - topHalfSpaces
        for i in 0...lowHalfSpaces-1 {
            drawSpace(at: x, at: y, withY: verticalPadding, withX: horizontalPadding, n: i, width: width, height: height, pos: i+topHalfSpaces)
        }
    }
    
    private func drawSpace(at x: CGFloat, at y: CGFloat, withY verticalPadding: CGFloat, withX horizontalPadding: CGFloat, n i: Int, width: CGFloat, height: CGFloat, pos: Int) {
        //Instanciamos el view del espacio. Color azul por default y borde de tamaño 1
        let view = SpaceView(frame: CGRect(x: x + horizontalPadding + (width+horizontalPadding/2) * CGFloat(i), y: y + verticalPadding, width: width, height: height))
        view.backgroundColor = UIColor(white: 1, alpha: 0.0)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = view.frame.height / 15
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.blue.cgColor
        view.addGesture()
        view.delegate = self
        view.text = String(pos+1)
        view.textColor = UIColor.white
        view.textAlignment = .center
        //Agregamos al arreglo y al view padre
        spacesViews.append(view)
        self.addSubview(view)
    }
    
    func onSpaceSelected(over id: String) {
        delegate.onSpaceSelected(over: id)
        spacesViews.filter { (space) -> Bool in
            space.selected
            }.forEach { (space) in
                space.selected = false
        }
        spacesViews[Int(id)!-1].selected = true
    }
    
    func setOccupied(positionAt id: Int, occupied: Bool) {
        spacesViews[id].occupied = occupied
    }
}

protocol ParkingSpaceViewDelegate {
    func onSpaceSelected(over id: String)
}
