//
//  Game.swift
//  OpenQuizz
//
//  Created by Dani on 15/06/2019.
//  Copyright © 2019 DaniCpn. All rights reserved.
//

import Foundation

class Game {
    var score = 0
    var goodAnswer = false
    
    private var questions = [Question]()
    private var currentIndex = 0
    
    var state: State = .ongoing
    
    enum State {
        case ongoing, over
    }
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
//    Pattern Singleton
    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
//        FERMETURE (très utile pour le requêtes réseau, pour effectuer une action inconnue genre l'utilisateur doit choisir une action et sinon les animatiosns)
//        On va simplifier ça
//        QuestionManager.shared.get(completionHandler: receiveQuestions)
//        Et ca va nous donner ça
        QuestionManager.shared.get() {(questions) in
            self.questions = questions
//            Une fois qu'on a chargé les questions, on peut continuer
            self.state = .ongoing
//            print(questions)
            
//            Notifications
            //On envoie une notification quand les questions sont chargées
            let name = Notification.Name(rawValue: "QuestionLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }
    
//    Avec ce qu'on a au dessous on a plus besoin de cette fonction
//    Cette fonction permet d'attendre la réponse des questions avant de continuer
//    private func receiveQuestions(_ questions: [Question]) {
//        self.questions = questions
//        Une fois qu'on a chargé les questions, on peut continuer
//        state = .ongoing
//        print(questions)
//    }
    
    func answerCurrentQuestion(with answer: Bool) {
        goodAnswer = false
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
            goodAnswer = true
        }
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
    }
    

}
