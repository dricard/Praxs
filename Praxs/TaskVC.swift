//
//  ViewController.swift
//  prouks
//
//  Created by Arnaud on 2017-04-12.
//  Copyright © 2017 arnaud. All rights reserved.
//

import UIKit

enum taskVcError: Error {
    case taskExists(msg:String)
    case taskNameIsNil(msg: String)
    case taskDurationIsNil(msg: String)
}
protocol CellProtocol {
//    func didChangeDuration(to:Double)
    func didChangeDuration(_:UITableViewCell)

}
class TaskVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    var task = Task()
    var taskList = TaskList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("the task = \(task)")
        self.tbvSet()
    }
//MARK : TBV protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row){
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier:"taskName", for: indexPath)as! TaskNameCell
            cell.nameLabel.text = task.name
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier:"taskDuration", for: indexPath)as! TaskDurationCell
                cell.timePicker.countDownDuration = task.duration
//                cell.cellDelegate.self
            return cell
        case 2:
             let cell = tableView.dequeueReusableCell(withIdentifier:"taskRoutineBonds", for: indexPath)as! TaskRoutineBondsCell
             return cell
        case 3:
             let cell = tableView.dequeueReusableCell(withIdentifier:"taskTag", for: indexPath)as! TaskTagCell
             if task.tags.isEmpty == false{
                cell.tagTextView.text = "#" + task.tags.joined(separator: "   #")
             }
             else{
                 cell.tagTextView.text = ""
             }
             return cell
        case 4:
             let cell = tableView.dequeueReusableCell(withIdentifier:"taskCompletion", for: indexPath)as! TaskCompletionCell
             if let compNumb = Int(cell.completions.text!){
                task.completions = compNumb
             }
             return cell
        default:
            break
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
        case 0:
           performSegue(withIdentifier: "editName", sender: self)
            break
//        case 1:
//            let cell = tableView.cellForRow(at:indexPath) as! TaskDurationCell
//            task.duration = cell.timePicker.countDownDuration
//            print("new duration \(task.duration)")
        case 3:
            performSegue(withIdentifier: "editTags", sender: self)
            break
        default:
            break
        }
    }
//MARK: Methods
    func tbvSet(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 100
    }

    @IBAction func unwindToTaskVC (segue:UIStoryboardSegue){
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="editName"){
        }
        else if(segue.identifier == "editTags"){
            let tagsVC = segue.destination as!EditTaskTagVC
            tagsVC.addedTags = task.tags
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        do{
//            let durationCell = TaskDurationCell()
//            let duration =  durationCell.timePicker.countDownDuration            
//            task.duration = duration
            taskList.append(task)
            print(taskList)
//            print(taskList)
//            utility = Utility()
//            try self.buildTask(task)
//            self.utility.write
            
        } catch taskVcError.taskNameIsNil(let msg) {
            print("Error: \(msg)")
        } catch taskVcError.taskDurationIsNil(let msg) {
            print("Error: \(msg)")
        } catch {
            print("Error: Unknown Error") 
        }
    }
    func buildTask (_ :Task) throws -> Dictionary<String, Any>{
        
        if task.name.isEmpty || task.name == "Task Name"{
            throw taskVcError.taskNameIsNil(msg:"Oopsy! you forgot to name the task")
        }
        guard task.duration > 0.0 else{
            throw taskVcError.taskDurationIsNil(msg: "Please set the task a duration")
        }
        let taskDict = ["name":task.name,"duration":task.duration,"completions":task.completions,"tags":task.tags,"routineBonds":task.routineBonds] as [String : Any]
         return  taskDict
    }
}
//MARK: nameCell
class TaskNameCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
//MARK: durationCell
class TaskDurationCell: UITableViewCell {
    @IBOutlet weak var timePicker: UIDatePicker!
    var cellDelegate: CellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func updateDuration(){
     print("update picker")
    }
    @IBAction func withdrawTime(_ sender: UIButton) {
        timePicker.countDownDuration -= 300.0
    }
    @IBAction func addTime(_ sender: UIButton) {
        timePicker.countDownDuration += 300.0
    }
    @IBAction func timePickerScroll(_ sender: Any) {
//        self.cellDelegate?.didChangeDuration(to:timePicker.countDownDuration)
        print(timePicker.countDownDuration)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
//MARK: routineBondsCell
class TaskRoutineBondsCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
//MARK: tagCell
class TaskTagCell: UITableViewCell {
    
    @IBOutlet weak var tagTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
//MARK: completionCell
class TaskCompletionCell: UITableViewCell {
    
    @IBOutlet weak var completions: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        completions.isUserInteractionEnabled = false
    }
}
//MARK:
class TagListCell: UITableViewCell {
    
    @IBOutlet weak var tagListLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
