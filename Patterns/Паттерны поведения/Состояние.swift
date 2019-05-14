//
//  Состояние.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 26/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Состояние (State) - шаблон проектирования, который позволяет объекту изменять свое поведение в зависимости от внутреннего состояния.
 
 Когда применяется данный паттерн?
 
 1) Когда поведение объекта должно зависеть от его состояния и может изменяться динамически во время выполнения
 2) Когда в коде методов объекта используются многочисленные условные конструкции, выбор которых зависит от текущего состояния объекта*/

//Context: представляет объект, поведение которого должно динамически изменяться в соответствии с состоянием. Выполнение же конкретных действий делегируется объекту состояния
fileprivate class Context {
    var state: State

    init(state: State) {
        self.state = state
    }

    func request() {
        self.state.handle(context: self)
    }
}

//State: определяет интерфейс состояния
fileprivate protocol State {
    func handle(context: Context)
}

//Классы StateA и StateB - конкретные реализации состояний
fileprivate struct StateA: State {
    func handle(context: Context) {
        context.state = StateB()
    }
}

fileprivate struct StateB: State {
    func handle(context: Context) {
        context.state = StateA()
    }
}

fileprivate func main() {
    let context = Context(state: StateA())
    context.request()
}

/*Например, вода может находиться в ряде состояний: твердое, жидкое, парообразное. Допустим, нам надо определить класс Вода, у которого бы имелись методы для нагревания и заморозки воды. Без использования паттерна Состояние мы могли бы написать следующую программу:*/

fileprivate enum WaterState {
    case solid
    case liquid
    case gas
}

fileprivate class Water {
    var state: WaterState

    init(state: WaterState) {
        self.state = state
    }

    func heat() {
        switch self.state {
        case .solid:
            print("Превращаем лед в жидкость")
            self.state = .liquid
        case .liquid:
            print("Превращаем жидкость в пар")
            self.state = .gas
        case .gas:
            print("Повышаем температуру водяного пара")
        }
    }

    func frost() {
        switch self.state {
        case .liquid:
            print("Превращаем жидкость в лед")
            self.state = .solid
        case .gas:
            print("Превращаем водяной пар в жидкость")
            self.state = .liquid
        case .solid: break
        }
    }
}

/*Вода имеет три состояния, и в каждом методе нам надо смотреть на текущее состояние, чтобы произвести действия. В итоге с трех состояний уже получается нагромождение условных конструкций. Да и самим методов в классе Вода может также быть множество, где также надо будет действовать в зависимости от состояния. Поэтому, чтобы сделать программу более гибкой, в данном случае мы можем применить паттерн Состояние:*/

fileprivate class WaterTemplate {
    var state: WState

    init(state: WState) {
        self.state = state
    }

    func heat() {
        self.state.heat(self)
    }

    func frost() {
        self.state.frost(self)
    }
}

fileprivate protocol WState {
    func heat(_ water: WaterTemplate)
    func frost(_ water: WaterTemplate)
}


fileprivate struct SolidWaterState: WState {
    func heat(_ water: WaterTemplate) {
        print("Превращаем лед в жидкость");
        water.state = LiquidWaterState()
    }

    func frost(_ water: WaterTemplate) {
        print("Продолжаем заморозку льда")
    }
}

fileprivate struct LiquidWaterState: WState {
    func heat(_ water: WaterTemplate) {
        print("Превращаем жидкость в пар");
        water.state = GasWaterState()
    }

    func frost(_ water: WaterTemplate) {
        print("Превращаем жидкость в лед")
        water.state = SolidWaterState()
    }
}

fileprivate struct GasWaterState: WState {
    func heat(_ water: WaterTemplate) {
        print("Повышаем температуру водяного пара");
    }

    func frost(_ water: WaterTemplate) {
        print("Превращаем водяной пар в жидкость")
        water.state = LiquidWaterState()
    }
}

fileprivate func testTemplate() {
    let water = WaterTemplate(state: LiquidWaterState())
    water.heat()
    water.frost()
    water.frost()
}
