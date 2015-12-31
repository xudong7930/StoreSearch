//
//  MenuViewController.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/31/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func MenuViewControllerSendSupportEmail(controller: MenuViewController)
}


class MenuViewController: UITableViewController {
    
    // MARK: - VAR AND LET
    weak var delegate: MenuViewControllerDelegate?
    
    
    // MARK: - VIEW AND INIT
    
    
    // MARK: - TABLE VIEW METHOD
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            delegate?.MenuViewControllerSendSupportEmail(self)
        }
    }
}
