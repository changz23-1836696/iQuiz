//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Chang Zeng on 5/13/21.
//.

import UIKit

class AnswerViewController: UIViewController {
    // properities
    var questionVC : QuestionViewController!
    var finishVC : FinishViewController!
    var count: Int = 0
    var correct: Bool = false
    var answer: String = ""
    var question: String = ""
    var score: Int = 0
    var questions = [(text: String, answer: Int, answers: [String])]()
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var correctText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (!correct) {
            message.text = "WRONG"
            message.textColor = .red
        }
        correctText.text = answer
        questionText.text = question
    }
    
    func questionBuilder() {
        if questionVC == nil {
            questionVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "questionVC")
                as! QuestionViewController
        }
    }
    func finishBuilder() {
        if finishVC == nil {
            finishVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "finishVC")
                as! FinishViewController
        }
    }
    @IBAction func next(_ sender: Any) {
        if (count + 1 < questions.count){
            questionBuilder()
            questionVC.questions = self.questions
            questionVC.count = self.count + 1
            questionVC.score = self.score
            let navVC = UINavigationController(rootViewController: questionVC!)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true, completion: nil)
        } else {
            finishBuilder()
            finishVC.score = self.score
            let navVC = UINavigationController(rootViewController: finishVC!)
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
