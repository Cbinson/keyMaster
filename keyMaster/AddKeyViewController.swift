//
//  AddKeyViewController.swift
//  keyMaster
//
//  Created by robinson on 2017/3/26.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit

class AddKeyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    //MARK: tableview delegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    //MARK: tableview datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let cellID = "DescrptionCell"
            
            cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DescrptionCell
            break
        case 1:
            let cellID = "AccountCell"
            
            cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AccountCell
            break
        case 2:
            let cellID = "PasswordCell"
            
            cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PasswordCell
            break
        default:
            break
        }
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
