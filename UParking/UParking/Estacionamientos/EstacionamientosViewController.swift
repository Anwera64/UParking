//
//  EstacionamientoViewController.swift
//  UParking
//
//  Created by Anton Tchistiakov on 7/10/18.
//  Copyright © 2018 Anton Tchistiakov. All rights reserved.
//

import UIKit

struct ResumedData {
    var title: String
    var numbers: Int
    var imageURL: String?
}

class EstacionamientosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, EstacionamientosDelegate {
    
    static public let identifier = "EstacionamientosView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var manager: EstacionamientosManager!
    //Modo 1: Mostrar Exterior Interior. Modo 2: Mostrar areas (ejemplo: Pabellon R)
    public var mode: Int!
    //Solo se usa en modo 2 y es especificado por el controllador padre al seleccionar una area padre (Externo o Interno)
    public var areaType: String!
    //Array de ayuda para mostrar la informacion en los cells del collectionView
    private var resumedData: [ResumedData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager = EstacionamientosManager(with: self)
        manager.getParkingSpaces()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpCellsLayout()
    }
    
    private func setUpCellsLayout() {
        let numberOfVisibleCells: CGFloat = 2
        let rowPadding: CGFloat = 32
        let cellWidth = collectionView.frame.width
        let cellHeight = (collectionView.frame.height - (numberOfVisibleCells-1)*rowPadding)/2
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = rowPadding
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resumedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case 1:
            let title = resumedData[indexPath.row].title
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: EstacionamientosViewController.identifier) as! EstacionamientosViewController
            controller.mode = 2
            controller.areaType = title
            controller.navigationItem.title = title
            navigationController?.pushViewController(controller, animated: true)
        case 2:
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: EstacionamientoViewController.identifier) as! EstacionamientoViewController
            
            //Buscamos el objeto ParkingArea por su nombre dentro del array de todas las areas filtradas por tipo
            let cell = collectionView.cellForItem(at: indexPath) as! EstacionamientosTableViewCell
            let title = cell.titleView.text!
            guard let found = manager.filteredByTypeAreas[areaType]?.filter({ (area) -> Bool in
                area.name == title
            }).first else {
                print("Did not find the right area somewhy")
                return
            }
            //Seteamos el tamaño correcto al view personalizado de los espacios para que este los pinte correctamente
            controller.spaces = found.items.count
            controller.objectReference = found.databaseReference
            controller.navigationItem.title = title
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EstacionamientosTableViewCell.identifier, for: indexPath) as! EstacionamientosTableViewCell
        cell.titleView.text = resumedData[indexPath.row].title
        cell.freeSpacesView.text = String(resumedData[indexPath.row].numbers)
        if let urlString = resumedData[indexPath.row].imageURL {
            manager.getImage(with: urlString, at: indexPath)
        }
        return cell
    }
    
    func setParkingAreas(with areas: [String: [ParkingArea]]) {
        resumedData.removeAll()
        switch mode {
        case 1:
            areas.forEach { (area) in
                let title = area.key
                let imageURL = area.value.first?.imgAreaTypeURLString
                var counterFreeSpaces = 0
                area.value.forEach { (parkingArea) in
                    parkingArea.items.forEach({ (space) in
                        if !space.occupied { counterFreeSpaces += 1 }
                    })
                }
                resumedData.append(ResumedData(title: title, numbers: counterFreeSpaces, imageURL: imageURL))
            }
        case 2:
            areas[areaType]?.forEach({ (area) in
                let title = area.name
                let imageURL = area.imgURLString
                var counterFreeSpaces = 0
                area.items.forEach({ (space) in
                    if !space.occupied { counterFreeSpaces += 1 }
                })
                resumedData.append(ResumedData(title: title, numbers: counterFreeSpaces, imageURL: imageURL))
            })
        default:
            break
        }
        collectionView.reloadData()
    }
    
    func imageReady(with image: UIImage, at index: IndexPath) {
        guard let c = collectionView.cellForItem(at: index) else {
            print("wrong index")
            return
        }
        let cell = c as! EstacionamientosTableViewCell
        cell.imageParkingView.image = image
    }
}

