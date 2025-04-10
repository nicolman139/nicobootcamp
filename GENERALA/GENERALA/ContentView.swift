//
//  ContentView.swift
//  GENERALA
//
//  Created by Bootcamp on 2025-03-17.
//

import SwiftUI

struct ContentView: View {
    @State private var diceValues: [Int] = [1, 1, 1, 1, 1] // Valores iniciales de los dados
    @State private var resultMessage: String = "Presiona 'Lanzar Dados' para jugar"

    var body: some View {
        VStack(spacing: 20) {
            Text("Generala")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Mostrar los valores de los dados
            HStack {
                ForEach(0..<5, id: \.self) { index in
                    Text("\(diceValues[index])")
                        .font(.system(size: 40))
                        .fontWeight(.heavy)
                        .frame(width: 60, height: 60)
                        .background(Color.purple)
                        .foregroundColor(.yellow)
                        .cornerRadius(10)
                }
            }

            // Mensaje de resultado
            Text(resultMessage)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()

            // Botón para lanzar los dados
            Button(action: {
                rollDice()
                checkCombination()
            }) {
                Text("Lanzar Dados")
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }

    // Función para lanzar los dados
    func rollDice() {
        diceValues = diceValues.map { _ in Int.random(in: 1...6) }
    }

    // Función para verificar la jugada
    func checkCombination() {
        let sortedValues = diceValues.sorted()

        // Verificar Generala
        if Set(sortedValues).count == 1 {
            resultMessage = "¡Generala!"
            return
        }

        // Verificar Poker
        let counts = Dictionary(sortedValues.map { ($0, 1) }, uniquingKeysWith: +)
        if counts.values.contains(4) {
            resultMessage = "¡Poker!"
            return
        }

        // Verificar Full
        if counts.values.contains(3) && counts.values.contains(2) {
            resultMessage = "¡Full!"
            return
        }

        // Verificar Escalera
        let uniqueSorted = Array(Set(sortedValues)).sorted()
        if uniqueSorted == [1, 2, 3, 4, 5] || uniqueSorted == [2, 3, 4, 5, 6] || uniqueSorted == [1, 3, 4, 5, 6] {
            resultMessage = "¡Escalera!"
            return
        }

        resultMessage = "NADA"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
