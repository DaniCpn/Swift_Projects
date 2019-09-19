/*: 
⬇️ *Vous pouvez ignorez le code ci-dessous, il nous permet juste d'initialiser et de visualiser le canvas à droite.*
 */
import PlaygroundSupport
let canvas = Canvas()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = canvas

/*:
 - - -
 # Découverte du canevas
 Le canevas, c'est l'étendue de pelouse verte qui se trouve sur la droite 🌿.
 Sur ce canevas, nous allons pouvoir dessiner notre route. Et nous allons faire cela en utilisant les fonctions proposées par le canevas :
 ## Route

 `canvas.createRoadSection()`
 - 🛣 Cette fonction permet de **créer une section de route**. A chaque appel de cette fonction, une nouvelle section de route est crée.

 `canvas.createHomeRoadSection()`
 - 🛣🏠 Similaire à la précédente, cette fonction permet de créer une section de route **qui contient une maison**.

 `canvas.createSchoolRoadSection()`
 - 🛣🏫 Similaire à la précédente, cette fonction permet de créer une section de route **qui contient une école**.

 ## Bus
 `canvas.moveBusForward()`

 - 🚌➡️ Cette fonction permet de faire avancer le bus jusqu'à la section de route suivante. Attention, le bus ne peut pas avancer s'il n'y a plus de route devant lui.

 `canvas.stopBus()`
 - 🚌🛑 Cette fonction permet de faire marquer un arrêt au bus.

 ## A vous de jouer !
 */
/*canvas.createRoadSection()
canvas.createRoadSection()
canvas.createRoadSection()
canvas.createHomeRoadSection()
canvas.createRoadSection()
canvas.createSchoolRoadSection()

canvas.moveBusForward()
canvas.moveBusForward()
canvas.moveBusForward()
canvas.stopBus()
canvas.moveBusForward()
canvas.moveBusForward()
canvas.stopBus()*/


class Bus {
    var driverName: String
    var seats = 20
    var occupiedSeats = 0
    let numberOfWheel = 4 // Le nombre de roues est constant et vaut 4
    
    init(driverName: String) {
        self.driverName = driverName
    }
    
    //Fonction pour créer une route droite
    static func createStraightRoad() -> Road {
        return Road(length: 11)
    }
    
    func stop() {
        canvas.stopBus()
    }
    
    func moveForward() {
        canvas.moveBusForward()
    }

    func drive(road: Road) {
        for _ in road.sections {
            moveForward()
        }
    }
}

enum RoadSectionType {
    case plain
    case home
    case school
}

class RoadSection {
    var type: RoadSectionType
    
    init(type: RoadSectionType) {
        self.type = type
        switch type {
        case .plain:
            canvas.createRoadSection()
        case .home:
            canvas.createHomeRoadSection()
        case .school:
            canvas.createSchoolRoadSection()
        }
    }
}

//super correspond au "self" mais version classe mère
class HomeRoadSection: RoadSection {
    var children: Int
    
    init(children: Int) {
        self.children = children
        super.init(type: .home)
    }
}
class SchoolRoadSection: RoadSection {
    init() {
        super.init(type: .school)
    }
}

//HomeRoadSection(children: 5)
class Road {
    static let maxLength = 77
    var sections = [RoadSection]()
    
    init(length: Int) {
        var length = length
        if length > Road.maxLength {
            length = Road.maxLength
        }
        for _ in 0..<length {
            self.sections.append(RoadSection(type: .plain))
        }
    }
    
    static func createRoadToSchool() -> Road {
        let road = Road(length: 0)
        for i in 0..<30 {
            if i%7 == 1 {
                road.sections.append(HomeRoadSection(children: 2))
            } else {
                road.sections.append(RoadSection(type: .plain))
            }
        }
        road.sections.append(SchoolRoadSection())
        return road
    }
}

class SchoolBus: Bus {
    var schoolName = ""
    
    override func drive(road: Road) {
        for section in road.sections {
            switch section.type {
            case .plain:
                moveForward()
            case .home:
                if shouldPickChildren() {
                    pickChildren(from: section)
                    stop()
                }
                moveForward()
            case .school:
                dropChildren()
                stop()
            }
        }
    }
    
    func shouldPickChildren() -> Bool {
        return occupiedSeats < seats
    }
    
    func pickChildren(from roadSection: RoadSection) {
        if let section = roadSection as? HomeRoadSection {
            occupiedSeats += section.children
        }
    }
    
    func dropChildren() {
        occupiedSeats = 0
    }
}

var road = Road(length: 45) // Vous devriez voir une route de 20 sections se dessiner sur le canevas.

var unBus = Bus(driverName: "Jean")
unBus.drive(road: road) // Le bus avance jusqu'au bout de la route

//Road.createStraightRoad() // Le canevas affiche une ligne droite

/*var unBusScolaire = SchoolBus(driverName: "Joe")
unBusScolaire.seats = 50
unBusScolaire.drive(road: road)*/

/*RoadSection(type: .plain)
RoadSection(type: .home)
RoadSection(type: .school)*/




Road.createRoadToSchool()


