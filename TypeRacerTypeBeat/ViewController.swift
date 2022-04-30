//
//  ViewController.swift
//  TypeRacerTypeBeat
//
//  Created by Ethan Fox on 3/19/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var enemyImages = [UIImage(named: "Animal_Cow.png")!,UIImage(named: "Animal_Turtle.png")!,UIImage(named: "Animal_Duck.png")!,UIImage(named: "Animal_Piglet.png")!,UIImage(named: "Animal_Saimese.png")!]
    
    var totalGold = UserDefaults.standard.integer(forKey: "saveGold")
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var ShopTitle: UILabel!
    
    @IBOutlet weak var ShopFade: UIImageView!
    
    @IBOutlet weak var ShopBackground: UIImageView!
    
    @IBOutlet weak var BackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TableView.dataSource = self
        TableView.delegate = self
        
        save()
        
        
        
        currencyLabel.text = String(totalGold)
        
        closeShop()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enemyImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
/*
 Function(ItemCell)
 itemName -> Name of the item
 itemImage -> Image of the Item
 itemBuy -> This is an IBAction(connected to the button on the cell)
 
 */
        //cell.itemName =
        
        return cell
    }
    
    
    @IBAction func onBackButton(_ sender: Any) {
        closeShop()
    }
    
    @IBAction func onShopButton(_ sender: Any) {
        launchShop()
    }
    
    
    func launchShop(){
        TableView.isHidden = false
        ShopTitle.isHidden = false
        ShopFade.isHidden = false
        ShopBackground.isHidden = false
        BackButton.isHidden = false
    }
    func closeShop(){
        TableView.isHidden = true
        ShopTitle.isHidden = true
        ShopFade.isHidden = true
        ShopBackground.isHidden = true
        BackButton.isHidden = true
    }
    
    func save() {
        let saveGold = 1
        UserDefaults.standard.set(totalGold, forKey: "saveGold")
        
        //Save
        UserDefaults.standard.set(true, forKey: "Key1") //Bool
        UserDefaults.standard.set(1, forKey: "Key2")  //Integer
        UserDefaults.standard.set("This is my string", forKey: "Key3") //String
        UserDefaults.standard.synchronize()
                
        //Retrive
        UserDefaults.standard.bool(forKey: "Key1")
        
        UserDefaults.standard.string(forKey: "Key3")
    }
    
}




