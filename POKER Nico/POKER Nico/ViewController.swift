//
//  GamePokerViewController.swift
//  POKER Nico
//
//  Created by Bootcamp on 2025-03-07.
//

import UIKit

class ViewController: UIViewController {

    // Cartas de Jugador 1
    @IBOutlet weak var carta1Jugador1: UILabel!
    @IBOutlet weak var carta2Jugador1: UILabel!
    @IBOutlet weak var carta3Jugador1: UILabel!
    @IBOutlet weak var carta4Jugador1: UILabel!
    @IBOutlet weak var carta5Jugador1: UILabel!

    // Cartas de Jugador 2
    @IBOutlet weak var carta1Jugador2: UILabel!
    @IBOutlet weak var carta2Jugador2: UILabel!
    @IBOutlet weak var carta3Jugador2: UILabel!
    @IBOutlet weak var carta4Jugador2: UILabel!
    @IBOutlet weak var carta5Jugador2: UILabel!

    @IBOutlet weak var resultadosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repartirCartas()
    }

    @IBAction func cambiarCartas(_ sender: UIButton) {
        repartirCartas()
        evaluarManos()
    }

    // Reparte cartas aleatorias a cada jugador
    func repartirCartas() {
        let manoJugador1 = generarManoAleatoria()
        let manoJugador2 = generarManoAleatoria()
        
        mostrarCartas(mano: manoJugador1, labels: [carta1Jugador1, carta2Jugador1, carta3Jugador1, carta4Jugador1, carta5Jugador1])
        mostrarCartas(mano: manoJugador2, labels: [carta1Jugador2, carta2Jugador2, carta3Jugador2, carta4Jugador2, carta5Jugador2])
        
        print("Mano Jugador 1: \(manoJugador1)")
        print("Mano Jugador 2: \(manoJugador2)")
    }

    // Asigna las cartas a los UILabels
    func mostrarCartas(mano: [String], labels: [UILabel]) {
        for (index, carta) in mano.enumerated() {
            labels[index].text = carta
        }
    }

    // Genera una mano de 5 cartas únicas
    func generarManoAleatoria() -> [String] {
        let valores = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
        let palos = ["♥", "♣", "♠", "♦"]
        var mano: Set<String> = []
        
        while mano.count < 5 {
            mano.insert("\(valores.randomElement()!)\(palos.randomElement()!)")
        }
        
        return Array(mano)
    }

    // Evalúa las manos y muestra el resultado
    func evaluarManos() {
        let cartasJugador1 = obtenerCartas([carta1Jugador1, carta2Jugador1, carta3Jugador1, carta4Jugador1, carta5Jugador1])
        let cartasJugador2 = obtenerCartas([carta1Jugador2, carta2Jugador2, carta3Jugador2, carta4Jugador2, carta5Jugador2])
        
        let resultadoJugador1 = evaluarMano(cartasJugador1)
        let resultadoJugador2 = evaluarMano(cartasJugador2)

        if resultadoJugador1.rank > resultadoJugador2.rank {
            resultadosLabel.text = "¡Jugador 1 gana con \(resultadoJugador1.combinacion)!"
        } else if resultadoJugador1.rank < resultadoJugador2.rank {
            resultadosLabel.text = "¡Jugador 2 gana con \(resultadoJugador2.combinacion)!"
        } else {
            let cartaAlta1 = cartaAlta(resultadoJugador1.valores)
            let cartaAlta2 = cartaAlta(resultadoJugador2.valores)
            let ganador = cartaAlta1 > cartaAlta2 ? "Jugador 1" : "Jugador 2"
            let cartaGanadora = convertirValorIntAString(max(cartaAlta1, cartaAlta2))
            
            resultadosLabel.text = "¡\(ganador) gana con \(resultadoJugador1.combinacion) y carta alta \(cartaGanadora)!"
        }
    }

    // Obtiene los valores de los UILabels de las cartas
    func obtenerCartas(_ labels: [UILabel]) -> [String] {
        return labels.compactMap { $0.text }
    }

    // Evalúa una mano de poker y devuelve su combinación y ranking
    func evaluarMano(_ cartas: [String]) -> (combinacion: String, rank: Int, valores: [Int]) {
        let valores = cartas.map { String($0.dropLast()) }
        let palos = cartas.map { String($0.last!) }
        let valoresNumericos = valores.map { convertirValorAInt($0) }

        if esEscaleraColor(valores, palos) { return ("Escalera de Color", 9, valoresNumericos) }
        if esPoker(valores) { return ("Póker", 8, valoresNumericos) }
        if esFullHouse(valores) { return ("Full House", 7, valoresNumericos) }
        if esColor(palos) { return ("Color", 6, valoresNumericos) }
        if esEscalera(valores) { return ("Escalera", 5, valoresNumericos) }
        if esTrio(valores) { return ("Trío", 4, valoresNumericos) }
        if esDoblePar(valores) { return ("Doble Par", 3, valoresNumericos) }
        if esPar(valores) { return ("Par", 2, valoresNumericos) }

        return ("Carta Alta", 1, valoresNumericos)
    }

    // Funciones para detectar combinaciones de poker
    func esEscaleraColor(_ valores: [String], _ palos: [String]) -> Bool {
        return esEscalera(valores) && esColor(palos)
    }

    func esPoker(_ valores: [String]) -> Bool {
        return contarValores(valores).values.contains(4)
    }

    func esFullHouse(_ valores: [String]) -> Bool {
        let conteo = contarValores(valores)
        return conteo.values.contains(3) && conteo.values.contains(2)
    }

    func esColor(_ palos: [String]) -> Bool {
        return Set(palos).count == 1
    }

    func esEscalera(_ valores: [String]) -> Bool {
        let valoresOrdenados = valores.map { convertirValorAInt($0) }.sorted()
        return valoresOrdenados.last! - valoresOrdenados.first! == 4 && Set(valoresOrdenados).count == 5
    }

    func contarValores(_ valores: [String]) -> [String: Int] {
        return valores.reduce(into: [:]) { $0[$1, default: 0] += 1 }
    }

    func convertirValorAInt(_ valor: String) -> Int {
        let valores = ["A": 14, "K": 13, "Q": 12, "J": 11, "10": 10]
        return valores[valor] ?? Int(valor) ?? 0
    }

    func convertirValorIntAString(_ valor: Int) -> String {
        let valores = [14: "A", 13: "K", 12: "Q", 11: "J", 10: "10"]
        return valores[valor] ?? "\(valor)"
    }

    func cartaAlta(_ valores: [Int]) -> Int {
        return valores.max() ?? 0
    }

    // Funciones de combinaciones de Poker

    func esPar(_ valores: [String]) -> Bool {
        let conteo = contarValores(valores)
        return conteo.values.contains(2)
    }

    func esTrio(_ valores: [String]) -> Bool {
        let conteo = contarValores(valores)
        return conteo.values.contains(3)
    }

    func esDoblePar(_ valores: [String]) -> Bool {
        let conteo = contarValores(valores)
        let pares = conteo.values.filter { $0 == 2 }
        return pares.count == 2
    }
}
