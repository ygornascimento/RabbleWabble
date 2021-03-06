//
//  RandomQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Ygor Nascimento on 07/01/20.
//  Copyright © 2020 Ygor Nascimento. All rights reserved.
//

import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: BaseQuestionStrategy {
    
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        let randomSource = GKRandomSource.sharedRandom()
        let questions = randomSource.arrayByShufflingObjects(in: questionGroup.questions) as! [Question]
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
    
//    public var correctCount: Int = 0
//    public var incorrectCount: Int = 0
//    private let questionGroup: QuestionGroup
//    private var questionIndex = 0
//    private let questions: [Question]
//
//    public init(questionGroup: QuestionGroup) {
//        self.questionGroup = questionGroup
//
//        let randomSource = GKRandomSource.sharedRandom()
//        self.questions = randomSource.arrayByShufflingObjects(in: questionGroup.questions) as! [Question]
//    }
//
//    public var title: String {
//        return questionGroup.title
//    }
//
//    public func advanceToNextQuestion() -> Bool {
//        guard questionIndex + 1 < questions.count else {
//            return false
//        }
//        questionIndex += 1
//        return true
//    }
//
//    public func currentQuestion() -> Question {
//        return questions[questionIndex]
//    }
//
//    public func markQuestionCorrect(_ question: Question) {
//        correctCount += 1
//    }
//
//    public func markQuestionIncorrect(_ question: Question) {
//        incorrectCount += 1
//    }
//
//    public func questionIndexTitle() -> String {
//        return "\(questionIndex + 1)/\(questions.count)"
//    }
    
    
}

