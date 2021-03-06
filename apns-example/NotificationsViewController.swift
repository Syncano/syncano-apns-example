//
//  NotificationsViewController.swift
//  apns-example
//
//  Created by Jakub Machoń on 19.04.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

import UIKit
import syncano_ios

class NotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var messages = [(String,String)]()
    
    //MARK: - View states
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserverForName(
            AppDelegate.notificationNameNewMessage,
            object: nil, queue: nil,
            usingBlock: newMessageReceived)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AppDelegate.notificationNameNewMessage, object: nil)
    }
    
    func newMessageReceived(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        guard let aps = info["aps"] else {
            return
        }
        guard let alert = aps["alert"] else {
            return
        }
        
        let title = alert?["title"] as? String ?? ""
        let message = alert?["body"] as? String ?? ""
        messages.insert((title,message), atIndex: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
}

// MARK: - UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let (title,text) = messages[indexPath.row]
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = text
        
        return cell
    }
}
