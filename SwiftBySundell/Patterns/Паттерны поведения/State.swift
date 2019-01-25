//
//  State.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*
 Состояние (State) - шаблон проектирования, который позволяет объекту изменять свое поведение в зависимости от внутреннего состояния.
 
 Когда применяется данный паттерн?
    1) Когда поведение объекта должно зависеть от его состояния и может изменяться динамически во время выполнения
    2) Когда в коде методов объекта используются многочисленные условные конструкции, выбор которых зависит от текущего состояния объекта
 */
//Формальное представление:

//Определяет интерфейс состояния
fileprivate protocol State {
    func handle(context: Context)
}

//конкретные реализации состояний
fileprivate struct StateA: State {
    func handle(context: Context) {
        context.state = StateB()
    }
}

//конкретные реализации состояний
fileprivate struct StateB: State {
    func handle(context: Context) {
        context.state = StateA()
    }
}

//представляет объект, поведение которого должно динамически изменяться в соответствии с состоянием. Выполнение же конкретных действий делегируется объекту состояния
fileprivate class Context {
    var state: State
    init(state: State) {
        self.state = state
    }

    func request() {
        state.handle(context: self)
    }
}

fileprivate class Program {
    func main() {
        let context = Context(state: StateA())
        context.request()
        context.request()
    }
}

/*
 Например, вода может находиться в ряде состояний: твердое, жидкое, парообразное. Допустим, нам надо определить класс Вода, у которого бы имелись методы для нагревания и заморозки воды. Без использования паттерна Состояние мы могли бы написать следующую программу:
 */

fileprivate class Program1 {
    func main() {
        let water = Water(state: .liquid)
        water.heat()
        water.frost()
        water.frost()
    }
}

fileprivate enum WaterState {
    case solid, liquid, gas
}

fileprivate class Water {
    private var state: WaterState
    init(state: WaterState) {
        self.state = state
    }

    //Нагреваем
    func heat() {
        switch self.state {
        case .gas:
            print("Повышаем температуру водяного пара")
        case .liquid:
            print("Превращаем жидкость в пар")
            self.state = .gas
        case .solid:
            print("Превращаем лед в жидкость")
            self.state = .liquid
        }
    }

    //Охлаждаем
    func frost() {
        switch self.state {
        case .gas:
            print("Превращаем водяной пар в жидкость")
            self.state = .liquid
        case .liquid:
            print("Превращаем жидкость в лев")
            self.state = .solid
        default: break
        }
    }
}

/*Вода имеет три состояния, и в каждом методе нам надо смотреть на текущее состояние, чтобы произвести действия. В итоге с трех состояний уже получается нагромождение условных конструкций. Да и самим методов в классе Вода может также быть множество, где также надо будет действовать в зависимости от состояния. Поэтому, чтобы сделать программу более гибкой, в данном случае мы можем применить паттерн Состояние:*/

fileprivate class Program2 {
    func main() {
        let water = WaterWithPattern(state: LiquidWaterState())
        water.heat()
        water.frost()
        water.frost()
    }
}

fileprivate protocol IWaterState {
    func heat(_ water: WaterWithPattern)
    func frost(_ water: WaterWithPattern)
}

fileprivate class WaterWithPattern {
    var state: IWaterState

    init(state: IWaterState) {
        self.state = state
    }

    func heat() {
        state.heat(self)
    }

    func frost() {
        state.frost(self)
    }
}

fileprivate class SolidWaterState: IWaterState {
    func heat(_ water: WaterWithPattern) {
        print("Превращаем лед в жидкость")
        water.state = LiquidWaterState()
    }

    func frost(_ water: WaterWithPattern) {
        print("Продолжаем заморозку льда")
    }
}

fileprivate class LiquidWaterState: IWaterState {
    func heat(_ water: WaterWithPattern) {
        print("Превращаем жидкость в пар")
        water.state = GasWaterState()
    }

    func frost(_ water: WaterWithPattern) {
        print("Продолжаем жидкость в лед")
        water.state = SolidWaterState()
    }
}

fileprivate class GasWaterState: IWaterState {
    func heat(_ water: WaterWithPattern) {
        print("Повышаем темпиратут водяного пара")
    }

    func frost(_ water: WaterWithPattern) {
        print("Превращаем водяной пар в жидкость")
        water.state = LiquidWaterState()
    }
}

/*Таким образом, реализация паттерна Состояние позволяет вынести поведение, зависящее от текущего состояния объекта, в отдельные классы, и избежать перегруженности методов объекта условными конструкциями, как if..else или switch. Кроме того, при необходимости мы можем ввести в систему новые классы состояний, а имеющиеся классы состояний использовать в других объектах.*/
