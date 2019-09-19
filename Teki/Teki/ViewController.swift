//
//  ViewController.swift
//  Teki
//
//  Created by Dani on 12/05/2019.
//  Copyright © 2019 DaniCpn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var celebrities = ["le Steve Jobs", "le Zinedine Zidane", "la Madonna", "le Karl Lagarfeld", "la Scarlett Johansson"]
    var activities = ["du dancefloor", "du barbecue", "de la surprise ratée", "des blagues lourdes", "de la raclette party"]

    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBAction func changeQuote() {
        print("Youpi ! Notre fonction marche super bien !")
        
        // On séléctionne un élément alétoire parmi les célébrités
        let randomIndex1 = Int(arc4random_uniform(UInt32(celebrities.count)))
        let celebrity = celebrities[randomIndex1]
        print(celebrity)
        
        // On séléctionne un élément aléatoire parmi les activités
        let randomIndex2 = Int(arc4random_uniform(UInt32(activities.count)))
        let activity = activities[randomIndex2]
       
        // On construit la citation et on l'affecte au texte du label
        let quote = "Tu es " + celebrity + " " + activity + " !"
        quoteLabel.text = quote
    }
}

