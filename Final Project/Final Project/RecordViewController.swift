//
//  RecordViewController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-19.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: [Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecordTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecordTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecordTableViewCell")
        }
        let task = tasks[indexPath.row]
        
        if let myName = task.name {
            cell.nameLbl.text = myName
        }
            cell.distanceLbl.text = "\(task.distance)km"
            cell.durationLbl.text = Util().timeStringForStore(time: TimeInterval(task.second))
            cell.timeLbl.text =  task.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        ResultController.distance = task.distance
        ResultController.duration = Util().timeStringForStore(time: TimeInterval(task.second))
        ResultController.second = Int(task.second)
        print(task.fileName!)
        ResultController.xml = LocationRecord.loadFile(fileName: task.fileName!)
    }
    
    func getData() {
        do {
            tasks = try context.fetch(Route.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            context.delete(task)
            LocationRecord.deleteFile(fileName: task.fileName!)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                tasks = try context.fetch(Route.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
}
