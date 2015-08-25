//
//  DetailViewController.swift
//  RealmSample
//
//  Created by 生井 智司 on 2015/08/25.
//  Copyright (c) 2015年 生井 智司. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteAll(sender: AnyObject) {
        let realm = Realm()
        realm.write {
            realm.deleteAll()
        }
        self.parentViewController?.navigationController?.popViewControllerAnimated(true)
    }
}

