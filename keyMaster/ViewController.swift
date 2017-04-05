//
//  ViewController.swift
//  keyMaster
//
//  Created by robinson on 2017/3/19.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var mianTableView: UITableView!
    @IBOutlet weak var errorView: UIView!

    var accountArry = [NSManagedObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let queue = DispatchQueue(label: "com.binson.keyMaster", qos: DispatchQoS.userInitiated)
        queue.async {
            let logInVC:LogInViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
            self.present(logInVC, animated: true, completion: nil)
        }

        
    }

    override func viewWillAppear(_ animated: Bool) {
//        print("data cnt:\(self.getDataCount())")

        if self.getDataCount() == 0 {
            self.mianTableView.isHidden = true
            self.errorView.isHidden = false
        }else{
            self.mianTableView.isHidden = false
            self.errorView.isHidden = true

            self.mianTableView.reloadData()
        }
    }


    public func getContext() -> NSManagedObjectContext {
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

            accountArry = searchResults as! [NSManagedObject]
        }catch{
            print("取得資料總數錯誤")
            resultCnt = 0
        }
        
        return resultCnt
    }
    
    
    //MARK: tableview delegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        
//    }

    
    //MARK: tableview datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.getDataCount()
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellID = "keyInfoCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! keyInfoCell
        cell.tag = indexPath.row

        let keyInfo = self.accountArry[indexPath.row]

        let kDescrption = keyInfo.value(forKey: "desctiption") as! String
        let kAccount = keyInfo.value(forKey: "account") as! String

        //敘述
        cell.keyDescrption.text = kDescrption

        //帳號
        cell.keyAccount.text = kAccount

        //icon
        let iconUrl = URL.init(string: "http://favicon.hatena.ne.jp/?url=http://www.\(kDescrption).com"/*"http://www.google.com/s2/favicons?domain=www.\(kDescrption).com"*/)
        do{
            let imgData = try Data.init(contentsOf: iconUrl!) as Data?
            let iconImg = UIImage.init(data: imgData!)
            cell.keyIconImg.image = iconImg
        }catch{
            //fetch icon fail
            cell.keyIconImg.image = UIImage.init(named: "web")
        }



        return cell
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            let vc = ViewController()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KeyAccount")

            do{
                let results = try vc.getContext().fetch(fetchRequest) as! [NSManagedObject]
//                print("[delete] result:\(results)")
                for fetchIdx in 0..<results.count {
                    if fetchIdx == indexPath.row {
//                        print("fetchResult:\(results[fetchIdx])")
                        vc.getContext().delete(results[fetchIdx])
                        break
                    }
                }

                try vc.getContext().save()
                self.mianTableView.reloadData()
            }catch{
                print("fetch error")
            }
        }
    }


    //MARK: button action
    @IBAction func clickBackUpBtn(_ sender: UIBarButtonItem) {
        self.saveToFile()

        print("file content:\(self.loadFile())")


        if MFMailComposeViewController.canSendMail() {
            print("ready send mail")
            let mailPicker = MFMailComposeViewController()
            mailPicker.mailComposeDelegate = self

            let contentStr = self.loadFile()
            let attemptData:Data = contentStr.data(using: String.Encoding.utf8)!
            mailPicker.addAttachmentData(attemptData, mimeType: "robinson.keymaster", fileName: "keyBackUp.txt")

            mailPicker.setSubject("\(Date().easyDate())keyMaster備份")

            self.present(mailPicker, animated: true, completion: nil)
        }else{
            print("mail fail")
            self.showAlert(message: "未設定郵件帳號\n請先到設定->郵件，將帳號設定好。", viewctrl: self)
            
        }
    }

    func saveToFile() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let fileName = "\(documentsDirectory)/keyBackUp.txt"

        do{
            let backUpArry = NSMutableArray()

            for tmpKey in self.accountArry {
                let des = tmpKey.value(forKey: "desctiption") as! String
                let ant = tmpKey.value(forKey: "account") as! String
                let psd = tmpKey.value(forKey: "password") as! String

                let keyDic = ["desctiption":des,"account":ant,"password":psd]
                backUpArry.add(keyDic)
            }

            try backUpArry.write(toFile: fileName, atomically: false)

        }catch{
            print("write file fail")
        }
    }

    func loadFile()->String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let fileName = "\(documentsDirectory)/keyBackUp.txt"
        var content: String = ""

        let fileResult = NSArray.init(contentsOfFile: fileName)


        if fileResult?.count != 0 {
            for tmpDic in fileResult! {
                let keyDic = tmpDic as! Dictionary<String,Any>

                let des = "desctiption:\(keyDic["desctiption"] as! String)\n"
                let ant = "account:\(keyDic["account"] as! String)\n"
                let psd = "password:\(keyDic["password"] as! String)\n"
                let enterLine = "\n\n"

                content.append(des)
                content.append(ant)
                content.append(psd)
                content.append(enterLine)
            }
        }else{
            content = ""
        }

        return content
    }


    //MARK: message delegate
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        controller.dismiss(animated: true, completion: nil)

        //test 送出狀態開啟郵件app
//        controller.dismiss(animated: true) {
//            if result == MFMailComposeResult.sent {
//                let mailUrl = URL.init(string: "mailto://")
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(mailUrl!, options: [:], completionHandler: nil)
//                }else{
//                    UIApplication.shared.openURL(mailUrl!)
//                }
//            }
//        }
    }


    //MARK: show alert
    public func showAlert(message:String, viewctrl:ViewController) {
        let alertCtrl:UIAlertController = UIAlertController.init(title: "警告", message: message, preferredStyle: UIAlertControllerStyle.alert)

        let cancelAction:UIAlertAction = UIAlertAction.init(title: "確定", style: UIAlertActionStyle.cancel, handler: nil)
        alertCtrl.addAction(cancelAction)

        viewctrl.present(alertCtrl, animated: true, completion: nil)
    }



    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addVC:AddKeyViewController = segue.destination as! AddKeyViewController

        if segue.identifier == "addKey" {
            addVC.isAddMode = true

        }else if segue.identifier == "showInfo" {
            let tmpcell = sender as! keyInfoCell

            let tmpInfo = self.accountArry[tmpcell.tag]
            let tmpDescrption = tmpInfo.value(forKey: "desctiption") as! String
            let tmpAccount = tmpInfo.value(forKey: "account") as! String
            let tmpPassword = tmpInfo.value(forKey: "password") as! String

            addVC.recKeyDescrption = tmpDescrption
            addVC.recKeyAccount = tmpAccount
            addVC.recKeyPassword = tmpPassword

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: Date
extension Date {
    func easyDate() -> String {
        let dateformat = DateFormatter()
        dateformat.timeZone = NSTimeZone.system
        dateformat.dateFormat = "YYYY/MM/dd-HH:mm"
        let dateTime:String = dateformat.string(from: self)

        return dateTime
    }
}

