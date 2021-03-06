//
//  SelectQuestionGroupViewController.swift
//  RabbleWabble
//
//  Created by Ygor Nascimento on 04/01/20.
//  Copyright © 2020 Ygor Nascimento. All rights reserved.
//

import UIKit

public final class SelectQuestionGroupViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet internal var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    //MARK: - Properties
    private let appSettings = AppSettings.shared
    //public let questionGroups = QuestionGroup.allGroups()
    private let questionGroupCaretaker = QuestionGroupCaretaker()
    private var questionGroups: [QuestionGroup] {
        return questionGroupCaretaker.questionGroups
    }
    private var selectedQuestionGroup: QuestionGroup!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        questionGroups.forEach {
            print("\($0.title):" +
                "correctCount \($0.score.correctCount), " +
                "incorrectCoutn \($0.score.incorrectCount)")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SelectQuestionGroupViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionGroups.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell") as! QuestionGroupCell
        let questionGroup = questionGroups[indexPath.row]
        
        cell.titleLabel.text = questionGroup.title
        cell.percentageSubscriber = questionGroup.score.$runningPercentage
            .receive(on: DispatchQueue.main)
            .map() {
                return String(format: "%.0f %%", round(100 * $0))
        }.assign(to: \.text, on: cell.percentageLabel)
        
        return cell
    }
}

extension SelectQuestionGroupViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedQuestionGroup = questionGroups[indexPath.row]
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let viewController = segue.destination as? QuestionViewController else {return}
//        viewController.questionStrategy = appSettings.questionStrategy(for: questionGroupCaretaker)
//        viewController.delegate = self
        if let viewController = segue.destination as? QuestionViewController {
            viewController.questionStrategy = appSettings.questionStrategy(for: questionGroupCaretaker)
            viewController.delegate = self
        } else if let navController = segue.destination as? UINavigationController, let viewController = navController.topViewController as? CreateQuestionGroupViewController {
            viewController.delegate = self
        }
    }
}

extension SelectQuestionGroupViewController: QuestionViewControllerDelegate {
    public func questionViewController(_ viewController: QuestionViewController, didCancel questionGroup: QuestionStrategy) {
        navigationController?.popViewController(animated: true)
    }
    
    public func questionViewController(_ viewController: QuestionViewController, didComplete questionGroup: QuestionStrategy) {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectQuestionGroupViewController: CreateQuestionGroupViewControllerDelegate {
    public func createQuestionGroupViewController(_ viewController: CreateQuestionGroupViewController, created questionGroup: QuestionGroup) {
        questionGroupCaretaker.questionGroups.append(questionGroup)
        try? questionGroupCaretaker.save()

        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }


    public func createQuestionGroupViewControllerDidCancel(_ viewController: CreateQuestionGroupViewController) {
        dismiss(animated: true, completion: nil)
    }

}
