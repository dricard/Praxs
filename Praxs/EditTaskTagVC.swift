//
//  EditTaksTagVC.swift
//  prouks
//
//  Created by Arnaud on 2017-04-17.
//  Copyright © 2017 arnaud. All rights reserved.
//

import UIKit

class EditTaskTagVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

//MARK: Propeties
    @IBOutlet weak var doneButt: UIButton!
    @IBOutlet weak var tagTBV: UITableView!
    @IBOutlet weak var tagListView: UITextView!
    @IBOutlet weak var searchBar: UISearchBar!
    var tagList = TagList().tags
    var addedTags:Set<String> = []
    var searchActive: Bool = false
    var lastCharMatch: Bool = true
    var filteredList:[String] = []
//MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegateSettings()
        self.searchBarSettings()
    }
//MARK:  tbv delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (lastCharMatch == false) && (searchActive == false){
            return 0
        }
        if(searchActive){
            return filteredList.count
        }
        if searchBar.text?.isEmpty == true{
            return tagList.count
        }
        return tagList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagFromList", for: indexPath)as! TagListCell
        if(searchActive){cell.tagListLabel!.text = filteredList[indexPath.row]}
        else{
            if addedTags.isEmpty != true && addedTags.contains(tagList[indexPath.row]) {
                    cell.accessoryType = UITableViewCellAccessoryType(rawValue: 3)!
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryType(rawValue: 0)!
                }
            cell.tagListLabel!.text = tagList[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = (tagTBV.cellForRow(at:indexPath))as! TagListCell
        if checker(cell){addedTags.insert(cell.tagListLabel.text!)}
        else {addedTags.remove(cell.tagListLabel.text!)}
        loadList()
    }
    func delegateSettings(){
        tagTBV.dataSource = self
        tagTBV.delegate = self
        searchBar.delegate = self
        tagTBV.tableFooterView = UIView(frame: .zero)
        tagTBV.estimatedRowHeight = 30
    }
    func searchBarSettings() {
        let searchBarCancelButt = searchBar.value(forKey:"cancelButton") as! UIButton
        searchBarCancelButt.setTitle("Done", for: UIControlState.normal)
        let searchField = searchBar.value(forKey: "searchField")as? UITextField
        searchField?.clearButtonMode = .never

    }
//MARK:  search delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true{
            searchActive = false
        }
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        lastCharMatch = true
        searchActive = false;
        tagTBV.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text?.removeAll()
        searchActive = false;
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredList = tagList.filter({ (text) -> Bool in
            let tmp = text
            if tmp.range(of:searchText, options:[.anchored, .caseInsensitive]) != nil{
                return true
            }
            if tmp.range(of:searchText, options:.caseInsensitive) == nil {
                lastCharMatch = false
            }
           if searchBar.text?.isEmpty == true{
                lastCharMatch = true
            }
            return false
        })
        if(filteredList.count == 0){
            searchActive = false
        }
        else{
            searchActive = true
        }
        tagTBV.reloadData()
    }
//MARK: textView delegate
    func loadList(){
        textViewDidBeginEditing(tagListView)
        textViewDidChange(tagListView)
        tagListView.reloadInputViews()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        tagListView.text = ""
    }

    func textViewDidChange(_ textView: UITextView){
        if addedTags.isEmpty != true{
        tagListView.text = "#" + addedTags.joined(separator: "   #")
        }
        else {
            tagListView.text.removeAll()
        }
    }
//MARK:  Methods
    
    @IBAction func backToMainVc(_ sender: Any) {
        performSegue(withIdentifier: "returnTags", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="returnTags"){
            let taskVC = segue.destination as!TaskVC
            taskVC.task.tags = addedTags
            taskVC.tableView.reloadData()
        }
    }
    func checker(_ cell:UITableViewCell) -> Bool{
        if cell.accessoryType == UITableViewCellAccessoryType(rawValue: 0)!{
            cell.accessoryType = UITableViewCellAccessoryType(rawValue: 3)!
            return true
        }
        else if cell.accessoryType == UITableViewCellAccessoryType(rawValue: 3)!{
                cell.accessoryType = UITableViewCellAccessoryType(rawValue: 0)!
            return false
        }
        else{return false}
    }
}

