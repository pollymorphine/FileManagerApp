//
//  ViewController.swift
//  FileManagerApp
//
//  Created by Polina on 28.07.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import UIKit

class DocViewController:  UITableViewController  {
    
    private var list = [String]()
    private var currentPath = ""
    private let tableCell = DocTableViewCell()
    private var directoryName: String?
    
    // MARK: Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.navigationItem.title = directoryName
        
        list = FileManagerService.shared.listFiles(at: currentPath)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NameConstants.cellIdentifier, for: indexPath) as? DocTableViewCell
            else { return UITableViewCell() }
        
        let title = list[indexPath.row]
        cell.label.text = title
        
        if list[indexPath.row].contains(".") {
            cell.imageView?.image = UIImage(named: ImageConstants.file )
        } else {
            cell.imageView?.image = UIImage(named: ImageConstants.directory)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if list[indexPath.row].contains(".") {
            if let vc = UIStoryboard(name: NameConstants.main, bundle: nil).instantiateViewController(withIdentifier: NameConstants.contentIdentifier) as? ContentViewController {
                vc.content = FileManagerService.shared.readItem(withName: list[indexPath.row], at: currentPath)
                vc.fileTitle = list[indexPath.row]
                self.show(vc, sender: self)
            }
        } else {
            if let vc = UIStoryboard(name: NameConstants.main, bundle: nil).instantiateViewController(withIdentifier: NameConstants.docIdentifier) as? DocViewController {
                vc.directoryName = list[indexPath.row]
                vc.currentPath = currentPath + "/" + list[indexPath.row] + "/"
                self.show(vc, sender: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            FileManagerService.shared.deleteItem(withName: list[indexPath.row], at: currentPath)
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: Actions
    
    @IBAction func addDirectory(_ sender: Any) {
        showCreateAlert(type: .directory)
    }
    
    @IBAction func addFile(_ sender: Any) {
        showCreateAlert(type: .file)
    }
    
    private func showCreateAlert(type: itemType) {
        var title: String
        
        switch type {
        case .file:
            title = TextConstants.fileName
        case .directory:
            title = TextConstants.directoryName
        }
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: TextConstants.cancel, style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: TextConstants.create, style: .default, handler: { action in
            guard let name = alertController.textFields?.first?.text else {return}
            
            switch type {
            case .directory:
                FileManagerService.shared.addDirectory(withName: name, at: self.currentPath)
            case .file:
                FileManagerService.shared.addFile(containing: TextConstants.fileContent,
                                                  withName: name + TextConstants.txt,
                                                  at: self.currentPath)
            }
            
            //            switch type {
            //            case .directory:
            //                if  FileManagerService.shared.checkItem(withName: name, at: self.currentPath) {
            //                    self.showErrorAlert()
            //                } else {
            //                    FileManagerService.shared.addDirectory(withName: name, at: self.currentPath)
            //                }
            //            case .file:
            //                if FileManagerService.shared.checkItem(withName: name, at: self.currentPath) {
            //                    self.showErrorAlert()
            //                } else {
            //                    FileManagerService.shared.addFile(containing: TextConstants.fileContent,
            //                                                       withName: name + TextConstants.txt,
            //                                                      at: self.currentPath)
            //                }
            //            }
            
            self.list = FileManagerService.shared.listFiles(at: self.currentPath)
            self.tableView.reloadData()
        })
        
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: ErrorConstants.alertError,
                                          message: ErrorConstants.alertMessage,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: TextConstants.ok, style: .default)
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
