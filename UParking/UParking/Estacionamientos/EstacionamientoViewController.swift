//
//  EstacionamientoViewController.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/10/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

class EstacionamientoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EstacionamientosDelegate {
    
    static public let ID = "EstacionamientosView"
    
    @IBOutlet weak var tableView: UITableView!
    private var manager: EstacionamientosManager!
    //Modo 1: Mostrar Exterior Interior. Modo 2: Mostrar areas (ejemplo: Pabellon R)
    public var mode: Int!
    private var cont = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager = EstacionamientosManager(with: self)
        tableView.delegate = self
        tableView.dataSource = self
        manager.getParkingSpaces()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cont // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath) as! EstacionamientosTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    func setParkingAreas(with areas: [String: [ParkingArea]]) {
        switch mode {
        case 1:
            cont = areas.count
        case 2:
            for area in areas.values {
                cont += area.count
            }
        default:
            0
        }
    }
}
