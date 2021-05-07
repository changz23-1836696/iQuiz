//
//  ViewController.swift
//  iQuiz
//
//  Created by 曾畅 on 5/6/21.
//

import UIKit

class QuizCell: UITableViewCell {
    @IBOutlet var name : UILabel?
    @IBOutlet var des : UILabel?
    @IBOutlet var picture : UIImageView?
}

class NameSource: NSObject, UITableViewDataSource {
    
    var title : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
    var desc : [String] = ["Take a mathematics question", "Take a Marvel question", "Take a science question"]
    var images : [UIImage?] = [UIImage(named: "nin"), UIImage(named: "ps"), UIImage(named: "xb")]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as! QuizCell
        cell.name?.text = title[indexPath.row]
        cell.des?.text = desc[indexPath.row]
        cell.picture?.image = images[indexPath.row]
        
        return cell
    }
}

class NameSelector : NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

class ViewController: UIViewController {
    
    let delegate = NameSelector()
    let data = NameSource()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = data
        table.delegate = delegate
    }

    @IBAction func setting(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in }))
        present(alert, animated: true)
    }
    
}

