//
//  ViewController.swift
//  TypeRacerTypeBeat
//
//  Created by Ethan Fox on 3/19/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        
        closeShop()
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
    
}




