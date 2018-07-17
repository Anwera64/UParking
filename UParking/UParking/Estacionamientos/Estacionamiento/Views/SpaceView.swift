//
//  SpaceView.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/16/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class SpaceView: UILabel {
    public var delegate: ParkingSpaceViewDelegate!
    public var occupied = false {
        didSet {
            changeColor()
        }}
    private var selected = false {
        didSet {
            if selected {
                layer.borderColor = UIColor.yellow.cgColor
            } else {
                changeColor()
            }
        }}
    
    func addGesture() {
        let gesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTouch(_:)))
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
    }
    
    private func changeColor() {
        if occupied {
            layer.borderColor = UIColor.red.cgColor
        } else {
            layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    @objc
    private func onTouch(_ gestureRecognizer: UIGestureRecognizer? = nil) {
        guard !occupied else {
            print("space occupied")
            return
        }
        delegate.onSpaceSelected(over: self.text!)
    }
}
