//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Chang Zeng on 5/13/21.
//

import UIKit

class FinishViewController: UIViewController {
    
    var score: Int = 0
    
    @IBOutlet weak var scoreText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreText.text = "\(score)"

        // Do any additional setup after loading the view.
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
