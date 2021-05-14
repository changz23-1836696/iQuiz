//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Chang Zeng on 5/13/21.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    
    var ansVC : AnswerViewController!
    var userChoice = -1
    var ans = [UIButton]()
    var count: Int = 0
    var score : Int = 0
    var questions = [(text: String, answer: Int, answers: [String])]()
    override func viewDidLoad() {
        super.viewDidLoad()
        questionText.text = questions[count].text
        
        b1.setTitle(questions[count].answers[0], for: .normal)
        b2.setTitle(questions[count].answers[1], for: .normal)
        b3.setTitle(questions[count].answers[2], for: .normal)
        b4.setTitle(questions[count].answers[3], for: .normal)
        // Do any additional setup after loading the view.
        
        ans = [b1,b2,b3,b4]
    }
    
    func answerBuilder() {
        if ansVC == nil {
            ansVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "answerVC")
                as! AnswerViewController
        }
    }
    
    @IBAction func choice(_ sender: UIButton) {
        for button in ans {
            button.backgroundColor = UIColor.white
        }
        sender.backgroundColor = UIColor.lightGray
        userChoice = ans.startIndex.distance(to: ans.index(of: sender)!)
    }
    
    @IBAction func submit(_ sender: Any) {
        if (userChoice != -1) {
            answerBuilder()
            ansVC.correct = userChoice + 1 == questions[count].answer
            ansVC.answer = questions[count].answers[questions[count].answer - 1]
            ansVC.questions = self.questions
            ansVC.count = self.count
            ansVC.question = questions[count].text
            if (userChoice + 1 == questions[count].answer) {
                ansVC.score = self.score + 1
            } else {
                ansVC.score = self.score
            }
            
            let navVC = UINavigationController(rootViewController: ansVC!)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        let navVC = UINavigationController(rootViewController: (storyboard?.instantiateViewController(withIdentifier: "main"))!)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
