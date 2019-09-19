//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Dani on 06/06/2019.
//  Copyright © 2019 DaniCpn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var finalView: UIView!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var finalCommentLabel: UILabel!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ici on veut recupérer la notification qui nous indique que les questions ont bien été chargées
        let name = Notification.Name(rawValue: "QuestionLoaded")
        //Le premier paramatre c'est l'obersveur, celui qui observe la notification et c'est le controller donc on met self
        //Le troisieme parametre permet de savoir d'ou vient la notif, sorte de filtres, et ici on s'en préoccupe pas donc on met nil
        //Pour le deuxieme parametre, il s'agit de la fonction qui va être appelée lorsqu'on va recevoir la notif
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        
        //On appelle cette fonction directe ici pour qu'une partie se lance dès l'ouverture de l'app
        startNewGame()
        
        //On va créer ici la partie sur le geste
        //On la met directement ici pour qu'il fonctionne dès le lancement de l'app
        //Il a besoin de 3 infos pour pouvoir fonctionner
        //1. La Cible (qui est responsable de gérer ce geste et en général ca va être le controller)
        //2. L'Action (quelle action je vais effectuer quand l'action est reconnue)
        //3. La Vue (quelle vue doit détecter le geste)
        
        //Cible et Action
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        //Vue
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
        
        //nouveau
        finalView.isHidden = true
    }

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
//    Affiche interface de chargement
//    Lance le chargement des questions
//    Lorsque les questions sont chargées, la partie peut commencer
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true

        questionView.title = "Loading..."
        questionView.style = .standard
        
        finalView.isHidden = true
        scoreLabel.text = "0 / 10"
        
        game.refresh()
    }
    
    //nouveau
    private func endGame() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.isHidden = true
        
        finalScoreLabel.text = "0 / 10"
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        //Ici on fait un switch car c'est une enum des gestes possibles (qui sont déjà existant avec UIGesture)
        //Ici on écrit cette condition pour que le geste ne soit pris en compte uniquement lorsque le jeux est en cours
        //Pour que sur l'écran de chargement par exemple on puisse pas bouger
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        //Ici on utilise la méthode translation de UIPanG qu'on application à questionView qui est notre case avec la questions qu'on va slider pour jouer
        //On fait les 2 lignes suivantes pour que la translation du doigt et de l'image soit ensemble et identique
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        //On récupère la largeur de l'écran afin de calculer l'angle de translation de la vue
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x/(screenWidth/2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        //On a du coup une transformation de translation et de rotation
        
        //Il faut les combiner
        //Et pour cela on va les concatener/combiner
        let transform = translationTransform.concatenating(rotationTransform)
        
        //Il ne reste plus qu'à affecter cette transformation dans la questionview
        questionView.transform = transform
        
        //Maintenant on veut changer le style de la questionView
        //Pour cela il faut voir quelle est la valeur de x de la translation, car si elle est negative c'est un swipe gauche sinon droit
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
        
    }
    
    private func answerQuestion() {
        //On va déduire la réponse de l'utilisateur du style de la questionView
        //Avec on appelle notre méthode qu'on a créée dans game

        
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        
        if(game.goodAnswer == true) {
            scoreLabel.transform = .identity
//            scoreLabel.transform = CGAffineTransform(translationX: -256, y: -256)
            scoreLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.scoreLabel .transform = .identity
            }, completion: nil)
        }
        
        scoreLabel.text = "\(game.score) / 10"
        

        
        //Le score a été mis a jour
        //Mais il faut modifier dans l'affichage
        //scoreLabel.text = "\(game.score) / 10"
        
//        Cette partie est en comment car à la fin du tuto on a mis tout ça dans la fonction showQuestionView
//        //Enfin il faut afficher une nouvelle question, en commencant par replacer la questionView
//        //La fonction identity permet de ramener à la position d'origine
//        questionView.transform = .identity
//        //Il faut aussi redonner le style standart
//        questionView.style = .standard
//
//
//        //Dernier point, il faut gérer le cas de quand la partie est finie
//        switch game.state {
//        case .ongoing:
//            //Et enfin modifier son titre pour afficher la nouvelle question
//            questionView.title = game.currentQuestion.title
//        case .over:
//            questionView.title = "Game Over"
//        }
        
        
        //Ensuite on va gérer les animations pour la beauté de l'app
        //Ici on définit des trucs pour l'animation
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        //Puis on utilise ça dans notre animate
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }) { (success) in
            if success {
                self.showQuestionView()
            }
        }
    }
    
    private func showQuestionView() {
        //Enfin il faut afficher une nouvelle question, en commencant par replacer la questionView
        //La fonction identity permet de ramener à la position d'origine
        questionView.transform = .identity
        //Une fois que c'est au centre, on veut réduire la taille pour qu'on ne le voit pas
        //Pour ensuite animer son retour à sa taille normale
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        //Il faut aussi redonner le style standart
        questionView.style = .standard
        
        

        //Dernier point, il faut gérer le cas de quand la partie est finie
        switch game.state {
        case .ongoing:
            //Et enfin modifier son titre pour afficher la nouvelle question
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "..."
            //nouveau
            finalView.isHidden = false
            finalScoreLabel.text = "\(game.score) / 10"
            
            if game.score <= 3 {
                finalCommentLabel.text = "☹️"
            } else if game.score >= 4 && game.score <= 6 {
                finalCommentLabel.text = "🤔"
            } else if game.score >= 7 && game.score <= 9 {
                finalCommentLabel.text = "😤"
            } else {
                finalCommentLabel.text = "🥳"
            }
            
//            questionView.isHidden = true
        }
        
        //On anime l'effet "bouing" ici
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)
        
        //Animation finalView
        finalView.transform = .identity
        finalView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.finalView .transform = .identity
        }, completion: nil)
    }
    
}

