//
//  PopoverViewController.swift
//  iQuiz
//
//  Created by Chang Zeng on 5/18/21.
//

import UIKit

class PopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var textURL: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urlFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questionURL.txt")
        textURL.text = try! String(contentsOf: urlFileURL)
    }
    
    @IBAction func check(_ sender: Any) {
        let requestURL = URL(string: textURL.text!)
        NSLog(textURL.text!)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as! URL)
        let session = URLSession.shared
        let task = URLSession.shared.dataTask(with: requestURL!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if let usableData = data {
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! [AnyObject]
                    NSLog(String(describing: json))
                    if (data != nil && json != nil) {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Download Questions", message: "Questions download successfully from the URL!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.writeQuestionsToFile(data: String(data: data!, encoding: .utf8)!)
                        NSLog("\(requestURL)")
                        self.writeURLToFile(data: "\(requestURL)")
                        DispatchQueue.main.async {
                            NSLog(String(describing: UIApplication.shared.delegate?.window??.rootViewController))
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Get Questions", message: "Unable to get questions from the given URL.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
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
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func writeURLToFile(data: String) {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questionURL.txt")
        do {
            try data.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
