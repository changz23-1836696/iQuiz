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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var questionVC : QuestionViewController?
    var titles : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
    var desc : [String] = ["Take a mathematics question", "Take a Marvel question", "Take a science question"]
    var images : [UIImage?] = [UIImage(named: "nin"), UIImage(named: "ps"), UIImage(named: "xb")]
    var scienceQuestions: [(text: String, answer: Int, answers: [String])] =
        [(text: "Oil, natural gas and coal are examples of …", answer: 1, answers: ["Geothermal resources","Biofuels","Renewable resources","Fossil fuels"])]
    var marvelQuestions: [(text: String, answer: Int, answers: [String])] =
        [(text: "Who is Spider Man?", answer: 1, answers: ["Peter Parker","Tony Stark","Kid of Spider Woman","I don't know"]), (text: "What kind of doctor is Dr. Strange?", answer: 1, answers: ["Neurosurgeon","General practitioner","Cardiologist","Oncologist"]), (text: "Which of these is NOT an infinity stone?", answer: 3, answers: ["Space","Reallity","Love","Time"])]
    var mathQuestions: [(text: String, answer: Int, answers: [String])] =
        [(text: "What is the smallest prime number?", answer: 3, answers: ["1","0","2","-1"])]
    var questions = [[(text: String, answer: Int, answers: [String])]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as! QuizCell
        cell.name?.text = titles[indexPath.row]
        cell.des?.text = desc[indexPath.row]
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
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
        questions.append(mathQuestions)
        questions.append(marvelQuestions)
        questions.append(scienceQuestions)
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

