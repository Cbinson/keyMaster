//
//  ViewController.swift
//  keyMaster
//
//  Created by robinson on 2017/3/19.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mianTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let queue = DispatchQueue(label: "com.binson.keyMaster", qos: DispatchQoS.userInitiated)
        queue.async {
            let logInVC:LogInViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
            self.present(logInVC, animated: true, completion: nil)
        }
        print("data cnt:\(self.getDataCount())")
        
        
    }
    
    func getContext() -> NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appdelegate.persistentContainer.viewContext
    }
    
    //MARK: 取得資料總數
    public func getDataCount() -> Int {
        var resultCnt = Int()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KeyAccount")
        do{
            let searchResults = try getContext().fetch(fetchRequest)
            
            resultCnt =  searchResults.count
            
        }catch{
            print("取得資料總數錯誤")
            resultCnt = 0
        }
        
        return resultCnt
    }
    
    
    //MARK: tableview delegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    
    //MARK: tableview datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellID = "Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

