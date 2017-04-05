//
//  AddKeyViewController.swift
//  keyMaster
//
//  Created by robinson on 2017/3/26.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit
import CoreData

class AddKeyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navItem: UINavigationItem!
//    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var mainTableView: UITableView!

    var isAddMode:Bool = false
    var isSettingMode:Bool = false


    //接收info descrption,account,password
    var recKeyDescrption = String()
    var recKeyAccount = String()
    var recKeyPassword = String()





    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var rightBtn = UIBarButtonItem()
        if !isAddMode {
            rightBtn = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(clickEditBtn(_:)))

        }else{
            rightBtn = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(clickSaveBtn(_:)))
        }
        self.navItem.rightBarButtonItem = rightBtn
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
        var tmpCell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let cellID = "DescrptionCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DescrptionCell

            if !isAddMode {
                cell.descriptionTxtField.text = self.recKeyDescrption
                cell.descriptionTxtField.borderStyle = .none
                cell.descriptionTxtField.isEnabled = false
            }else{
                cell.descriptionTxtField.isEnabled = true
                cell.descriptionTxtField.borderStyle = .roundedRect
            }

            tmpCell = cell
            break
        case 1:
            let cellID = "AccountCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AccountCell

            if !isAddMode {
                cell.accountTxtField.text = self.recKeyAccount
                cell.accountTxtField.textColor = UIColor.red
                cell.accountTxtField.borderStyle = .none
                cell.accountTxtField.isEnabled = false
            }else{
                cell.accountTxtField.isEnabled = true
                cell.accountTxtField.borderStyle = .roundedRect
            }

            tmpCell = cell
            break
        case 2:
            let cellID = "PasswordCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PasswordCell

            if !isAddMode {
                cell.passwordTxtField.text = self.recKeyPassword
                cell.passwordTxtField.textColor = UIColor.red
                cell.passwordTxtField.borderStyle = .none
                cell.passwordTxtField.isEnabled = false
            }else{
                cell.passwordTxtField.isEnabled = true
                cell.passwordTxtField.borderStyle = .roundedRect
            }

            tmpCell = cell
            break
        default:
            break
        }
        
        return tmpCell
    }


    //MARK: button action
    @IBAction func clickSaveBtn(_ sender: UIBarButtonItem) {
        let descrptionIndexPath:IndexPath = IndexPath.init(row: 0, section: 0)
        let descrptionCell:DescrptionCell = self.mainTableView.cellForRow(at: descrptionIndexPath) as! DescrptionCell
        let descrptionTxt:String = descrptionCell.descriptionTxtField.text!

        let accountIndexPath:IndexPath = IndexPath.init(row: 1, section: 0)
        let accountCell:AccountCell = self.mainTableView.cellForRow(at: accountIndexPath) as! AccountCell
        let accountTxt:String = accountCell.accountTxtField.text!



        let passwordIndexPath:IndexPath = IndexPath.init(row: 2, section: 0)
        let passwordCell:PasswordCell = self.mainTableView.cellForRow(at: passwordIndexPath) as! PasswordCell
        let passwordTxt:String = passwordCell.passwordTxtField.text!



        if descrptionTxt.isEmpty || accountTxt.isEmpty || passwordTxt.isEmpty { //資料有缺
            var errorTxt = String()

            if descrptionTxt.isEmpty {
                errorTxt.append("請輸入敘述\n")
            }

            if accountTxt.isEmpty {
                errorTxt.append("請輸入帳號\n")
            }

            if passwordTxt.isEmpty {
                errorTxt.append("請輸入密碼")
            }

            self.showAlert(message: errorTxt)

        }else{  //資料無誤,寫入core data
            self.saveData(descrption: descrptionTxt, account: accountTxt, password: passwordTxt)
        }

    }

    @IBAction func clickEditBtn(_ sender: UIBarButtonItem) {
        self.isAddMode = true
        self.isSettingMode = true

        let saveBtn = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(clickSaveBtn(_:)))
        self.navItem.rightBarButtonItem = saveBtn

        self.mainTableView.reloadData()

    }



    //MARK: save core data
    func saveData(descrption:String, account:String, password:String) {
        let vc = ViewController()

        let entity = NSEntityDescription.entity(forEntityName: "KeyAccount", in: vc.getContext())


        ///////////////////
        if isSettingMode {

            let predicate = NSPredicate.init(format: "desctiption = %@ && account = %@ && password = %@", self.recKeyDescrption, self.recKeyAccount, self.recKeyPassword)


            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KeyAccount")
            fetchRequest.predicate = nil
            fetchRequest.entity = entity
            fetchRequest.predicate = predicate

            do{
                let searchResults = try vc.getContext().fetch(fetchRequest) as! [NSManagedObject]
                searchResults[0].setValue(descrption, forKey: "desctiption")
                searchResults[0].setValue(account, forKey: "account")
                searchResults[0].setValue(password, forKey: "password")
                
                try vc.getContext().save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                self.showAlert(message: "儲存失敗，稍後在試。")
            }
        }else{
            let accountObj = NSManagedObject.init(entity: entity!, insertInto: vc.getContext())

            accountObj.setValue(descrption, forKey: "desctiption")
            accountObj.setValue(account, forKey: "account")
            accountObj.setValue(password, forKey: "password")

            do{
                try vc.getContext().save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                self.showAlert(message: "儲存失敗，稍後在試。")
            }
        }
        ///////////////////




    }


    //MARK: show alert
    func showAlert(message:String) {
        let alertCtrl:UIAlertController = UIAlertController.init(title: "警告", message: message, preferredStyle: UIAlertControllerStyle.alert)

        let cancelAction:UIAlertAction = UIAlertAction.init(title: "確定", style: UIAlertActionStyle.cancel, handler: nil)
        alertCtrl.addAction(cancelAction)

        self.present(alertCtrl, animated: true, completion: nil)
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
