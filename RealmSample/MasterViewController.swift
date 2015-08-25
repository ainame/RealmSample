//
//  MasterViewController.swift
//  RealmSample
//
//  Created by 生井 智司 on 2015/08/25.
//  Copyright (c) 2015年 生井 智司. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let realm = Realm()
    var tasks : Results<Task>?
    var token : NotificationToken?

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 詳細画面で消した時に雑に綺麗にする処理
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }

        // tasksを Results<Task> として保持しとくと勝手に更新される
        // 遅延ロードされるのでmainスレッドで全件とっても大体問題ない
        tasks = realm.objects(Task).sorted("id", ascending: false)
        
        // こんなかんじで通知も受け取れる
        token = realm.addNotificationBlock { notification, realm in
            println("更新されたよ!: \(notification.rawValue)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        // 開放しとく
        if token != nil {
            realm.removeNotification(token!)
        }
    }

    @IBAction func insertNewObject(sender: AnyObject) {
        // 書き込み処理は必ずトランザクション用のブロックで囲む
        realm.write {
            let newTask = Task(value: ["id" : Task.nextId(), "title": "aaa", "date" : NSDate()])
            self.realm.add(newTask)
        }

        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let task = tasks![indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = task
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count as Int!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let task = tasks![indexPath.row]
        
        cell.textLabel!.text = "\(task.id.description), \(task.title), \(task.date.description)"
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // 削除処理も必ずトランザクション用のブロックで囲む
            let task = tasks![indexPath.row]
            realm.write{
                self.realm.delete(task)
            }

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}
