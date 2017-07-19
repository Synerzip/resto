//
//  HomeViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 18/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadMenuList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMenuList() {
        if let menuListSplitVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuListSplitVC") as? UISplitViewController {
            self.addControllerToContainerView(menuListSplitVC)
        }
    }
    
    func loadPlaceOrder() {
        if let placeOrderVC = self.storyboard?.instantiateViewController(withIdentifier: "placeOrderVC") as? PlaceOrderViewController {
            self.addControllerToContainerView(placeOrderVC)
        }
    }
    
    /**
     Add controller view to container view
     
     - parameters:
     - viewController:    View controller
     - returns: Void
     */
    fileprivate func addControllerToContainerView(_ viewController: UIViewController) {
        
        for oldVc in self.childViewControllers {
            oldVc.removeFromParentViewController()
        }
        
        addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0.0, y: 0.0,width: containerView.frame.size.width, height: containerView.frame.size.height)
        removeSubviewsFromContainerView()
        containerView.addSubview(viewController.view)
    }
    
    /**
     Remove the subview from container view
     
     - returns: Void
     */
    fileprivate func removeSubviewsFromContainerView() {
        for subview in self.containerView.subviews {
            if !(subview is UILayoutSupport) {
                subview.removeFromSuperview()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
