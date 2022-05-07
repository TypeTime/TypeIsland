//
//  ViewController.swift
//  TypeRacerTypeBeat
//
//  Created by Ethan Fox on 3/19/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var enemyImages = [UIImage(named: "Animal_Cow(Scaled).png")!,UIImage(named: "Animal_Turtle(Scaled).png")!,UIImage(named: "Animal_Duck(Scaled).png")!,UIImage(named: "Animal_Piglet(Scaled).png")!,UIImage(named: "Animal_Saimese(Scaled).png")!]
    var entity: [Entity]?
    let itemCostLabels = [" 1k "," 5k "," 10k "," 50k "," 100k "]
    let itemCosts = [1000,5000,10000,50000,100000]
    var totalGold = UserDefaults.standard.integer(forKey: "saveGold")
    var purchasedItems = UserDefaults.standard.array(forKey: "purchasedItems")
    
    @IBOutlet weak var pigUnlock: UIImageView!
    @IBOutlet weak var battleButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var ShopTitle: UILabel!
    @IBOutlet weak var ShopFade: UIImageView!
    @IBOutlet weak var ShopBackground: UIImageView!
    @IBOutlet weak var BackButton: UIButton!
    
    //animal unlocks
    @IBOutlet weak var turtleUnlock: UIImageView!
    @IBOutlet weak var catUnlock: UIImageView!
    @IBOutlet weak var duckUnlock: UIImageView!
    @IBOutlet weak var cowUnlock: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TableView.dataSource = self
        TableView.delegate = self
        
        pigUnlock.isHidden = true
        
        self.TableView.layer.cornerRadius = 25
        
        currencyLabel.text = String(totalGold)
        
        closeShop()
        enablePurchases()
        
        save()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enemyImages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        let shopImages = [UIImage(named: "Animal_Turtle(Scaled).png")!,UIImage(named: "Animal_Saimese(Scaled).png")!,UIImage(named: "Animal_Duck(Scaled).png")!,UIImage(named: "Animal_Piglet(Scaled).png")!,UIImage(named: "Animal_Cow(Scaled).png")!]
        let shopNames = ["Carl","Sandy","Juan","Darnell","Betsy"]
        
        
        cell.itemImage.image = shopImages[indexPath.row]
        cell.itemName.text = shopNames[indexPath.row]
        
        cell.purchaseButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        if purchasedItems![indexPath.row] as! Int == 0 {
            cell.purchaseButton.backgroundColor = .green
            cell.purchaseButton.layer.cornerRadius = 10
            cell.purchaseButton.setTitle(itemCostLabels[indexPath.row],for: .normal)
        }
        else {
            cell.purchaseButton.backgroundColor = .red
            cell.purchaseButton.layer.cornerRadius = 10
            cell.purchaseButton.setTitle("owned", for: .normal)
            cell.purchaseButton.isEnabled = false
            cell.purchaseButton.titleLabel?.font = UIFont(name: "Press Start", size: 14)
        }
        cell.purchaseButton.tag = indexPath.row
        cell.purchaseButton.addTarget(self, action: #selector(whichButtonPressed(sender:)), for: .touchUpInside)
        
        /*
         Function(ItemCell)
         itemName -> Name of the item
         itemImage -> Image of the Item
         itemBuy -> This is an IBAction(connected to the button on the cell)
         */
        
        return cell
    }
    
    
    @objc func whichButtonPressed(sender: UIButton) {
        let buttonNumber = sender.tag
        purchasedItems![buttonNumber] = 1
        TableView.reloadData()
        totalGold -= itemCosts[buttonNumber]
        currencyLabel.text = String(totalGold)
        save()
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        closeShop()
        enablePurchases()
    }
    
    @IBAction func onShopButton(_ sender: Any) {
        launchShop()
    }
    
    
    func launchShop(){
        TableView.isHidden = false
        ShopFade.isHidden = false
        ShopBackground.isHidden = false
        BackButton.isHidden = false
        battleButton.isHidden = true
        shopButton.isHidden = true
    }
    func closeShop(){
        TableView.isHidden = true
        ShopFade.isHidden = true
        ShopBackground.isHidden = true
        BackButton.isHidden = true
        battleButton.isHidden = false
        shopButton.isHidden = false
    }
    
    func enablePurchases() {
        
        
        let defaults = UserDefaults.standard
        purchasedItems = defaults.array(forKey: "purchasedItems")  as? [Int] ?? [Int]()
        var i = 1
        while i-1 < purchasedItems!.count {
            if purchasedItems![i-1] as! Int == 1 {
                print(i)
                switch i {
                case 1:
                    turtleUnlock.image = UIImage(named: "Animal_Turtle(Scaled)")
                case 2:
                    catUnlock.image = UIImage(named: "Animal_Saimese(Scaled)")
                case 3:
                    duckUnlock.image = UIImage(named: "Animal_Duck(Scaled)")
                case 4:
                    pigUnlock.isHidden = false
                case 5:
                    cowUnlock.image = UIImage(named: "Animal_Cow(Scaled)")
                default:
                    print("switch error")
                }
            }
            i += 1
        }
    }
    
    func save() {
        UserDefaults.standard.set(totalGold, forKey: "saveGold")
        UserDefaults.standard.set(purchasedItems, forKey: "purchasedItems")
        UserDefaults.standard.synchronize()
    }
    
}
