//
//  MenuTableViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 17/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit
import SwiftyJSON


class MenuTableViewController: UITableViewController {
    
    var menuItemList = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        createRightBarItem()
        registerTableViewCell()
        getMenuList()
    }
    
    private func createRightBarItem() {
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let rightBarButtonItem = UIBarButtonItem(title: "Place Order", style: .done, target: self, action: #selector(MenuTableViewController.placeOrderButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func registerTableViewCell() {
        let nib = UINib(nibName: "MenuItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MenuItemCell")
    }
    
    @objc func placeOrderButtonAction() {
        if let homeVC = splitViewController?.parent as? HomeViewController {
            homeVC.loadPlaceOrder()
        }
    }
    
    func getMenuList() {
        if let path = Bundle.main.path(forResource: "MenuItems", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    let menuListJSON = jsonObj["menuitems"]
                    for menuJson in menuListJSON {
                        let menuItem = MenuItem(menuItemJSON: menuJson.1)
                        menuItemList.append(menuItem)
                    }
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        tableView.reloadData()
    }
}
extension MenuTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemTableViewCell
        let menuItem = menuItemList[indexPath.row]
        cell.configureMenuItemCell(menuItem: menuItem)
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
