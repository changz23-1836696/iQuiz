//
//  ViewController.swift
//  iQuiz
//
//  Created by 曾(Zeng)畅(Chang) on 5/6/21.
//

import UIKit
//
class QuizCell: UITableViewCell {
    @IBOutlet var name : UILabel!
    @IBOutlet var des : UILabel!
    @IBOutlet var picture : UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }}

//class NameSource: NSObject, UITableViewDataSource {
//
//    var questionVC : QuestionViewController?
//    var title : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
//    var desc : [String] = ["Take a mathematics question", "Take a Marvel question", "Take a science question"]
//    var images : [UIImage?] = [UIImage(named: "nin"), UIImage(named: "ps"), UIImage(named: "xb")]
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return title.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as! QuizCell
//        cell.name?.text = title[indexPath.row]
//        cell.des?.text = desc[indexPath.row]
//        cell.picture?.image = images[indexPath.row]
//        return cell
//    }
//}
//
//class NameSelector : NSObject, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var table: UITableView!

    var questionURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.txt")
    var images : [UIImage] = [UIImage(named: "nin")!, UIImage(named: "ps")!, UIImage(named: "xb")!]
    var quizs: [(title: String, description: String, image: UIImage)] = [(title: String, description: String, image: UIImage)]()
    var questions = [[(text: String, answer: Int, answers: [String])]]()
    var questionVC : QuestionViewController?



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as! QuizCell
        cell.name?.text = quizs[indexPath.row].title
        cell.des?.text = quizs[indexPath.row].description
        cell.picture?.image = images[indexPath.row]
        return cell
    }

    //define height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    //handle user click on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do view switch when the user choose one cell
        questionBuilder()
        questionVC?.questions = self.questions[indexPath.row]
        let navVC = UINavigationController(rootViewController: questionVC!)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        readFromFile()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.addSubview(self.refreshControl)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        checkURL()
    }

    func readFromFile() {
        do {
            let text = try String(contentsOf: questionURL, encoding: .utf8)
            let data = text.data(using: String.Encoding.utf8)!
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            var imageIndex: Int = 0
            questions.removeAll()
            quizs.removeAll()
            for quiz in json! {
                NSLog(String(describing: quiz))
                let quizDict = quiz as! [String: AnyObject]
                quizs.append((title: quizDict["title"] as! String, description: quizDict["desc"] as! String, image: images[imageIndex]))
                var quizQuestions = [(text: String, answer: Int, answers: [String])]()
                for single in quizDict["questions"] as! [Any] {
                    let singleQuestion = single as! [String: Any]
                    quizQuestions.append((text: singleQuestion["text"] as! String, answer: Int(singleQuestion["answer"] as! String)!, answers: singleQuestion["answers"] as! [String]))
                }
                questions.append(quizQuestions)
                // repeatedly choose icon for quizs
                if (imageIndex >= 9) {
                    imageIndex = 0
                } else {
                    imageIndex = imageIndex + 1
                }
            }
        }
        catch {
            let alert = UIAlertController(title: "Error", message: "Unable to get questions", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }

    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black

        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        checkURL()
        readFromFile()
        self.table.reloadData()
        refreshControl.endRefreshing()
    }

    func checkURL() {
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questionURL.txt")
        do {
            let testURL = try String(contentsOf: fileUrl)
        }
        catch {
            // set default url if no fiel found
            do {
                try "http:/tednewardsandbox.site44.com/questions.json".write(to: fileUrl, atomically: true, encoding: .utf8)
            }
            catch {
            }
        }
        let URLOfQuestions = try! URL(string: String(contentsOf: fileUrl))
        let task = URLSession.shared.dataTask(with: URLOfQuestions!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if let usableData = data {
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! [AnyObject]
                    NSLog(String(describing: json))
                    if (data != nil && json != nil) {
                        self.writeQuestionsToFile(data: String(data: data!, encoding: .utf8)!)
                    }
                }
            }
        }
        task.resume()
    }

    func writeQuestionsToFile(data: String) {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.txt")
        do {
            try data.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            
        }
    }

    @objc func loadList(notification: NSNotification){
        //load data
        readFromFile()
        self.table.reloadData()
    }


    @IBAction func setting(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in }))
        present(alert, animated: true)
    }

    fileprivate func questionBuilder() {
        if questionVC == nil {
            questionVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "questionVC")
                as? QuestionViewController
        }
    }
}
