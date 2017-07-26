//
//  MenuTableViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 17/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol MenuListActionDelegate: class {
    func didSelectItem(menuItem: MenuItem, suggestedItems: [MenuItem], atIndexpath indexPath: IndexPath)
}

class MenuTableViewController: UITableViewController {
    
    var menuItemList = [MenuItem]()
    weak var menuListActionDelegate: MenuListActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailVC = self.splitViewController!.viewControllers.last as! MenuDetailsViewController
        detailVC.menuDetailsActionDelegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        registerTableViewCell()
        getMenuList()
    }
    
    private func registerTableViewCell() {
        let nib = UINib(nibName: "MenuItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MenuItemCell")
    }
    
    func getMenuList() {
        if let path = Bundle.main.path(forResource: "MenuItemList", ofType: "json") {
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
        showDefaultSelection()
    }
    
    private func showDefaultSelection() {
        // Show First item selected by Default
        let firstIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: firstIndexPath, animated: false, scrollPosition: .top)
        tableView(tableView, didSelectRowAt: firstIndexPath)
    }
    
    private func getSuggestedItems() -> [MenuItem] {
        var suggestedItems = [MenuItem]()
        for _ in 0..<3 {
            let randomNo = randomNumber(MIN: 0, MAX: menuItemList.count - 1)
            suggestedItems.append(menuItemList[randomNo])
        }
        return suggestedItems
    }
    
    private func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItemList[indexPath.row]
        let suggestedItems = getSuggestedItems()
        menuListActionDelegate?.didSelectItem(menuItem: menuItem, suggestedItems: suggestedItems, atIndexpath: indexPath)
    }
}

extension MenuTableViewController: MenuDetailsActionDelegate {
    func didChangeItemQuantity(menuItem: MenuItem, quantity: Int, atIndexpath indexPath: IndexPath) {
        menuItemList[indexPath.row].quantity = quantity
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
}
