//
//  Operation.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 14/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: Операция
/*Простейшая операция Operation может быть представлена обычным замыканием, которое также может выполняться и на DispatchQueue. Но эту форму операции можно применять только при условии, что вы будете добавлять ее на OperationQueue с помощью метода addOperation:
*/

fileprivate func test1() {
    let operation = {
        print("Operation 1 started")
        print("Operation 1 finished")
    }

    let queue = OperationQueue()
    queue.addOperation(operation)
}

/*Полноценная операция Operation может быть сконструирована с помощью  BlockOperation инициализатора. Она запускается на выполнение с помощью своего собственного метода start ():*/

fileprivate func test2() {
    var result: String?
    let concatenationOperation = BlockOperation {
        result = "first" + "second"
    }
    concatenationOperation.start()
    dump(result)
}

/*Если вы хотите получить что-то повторно используемое типа асинхронной версии синхронной функции, вам необходимо создать пользовательский subclass класса Operation и получить его экземпляр:*/
fileprivate class FilterOperation: Operation {
    var inputImage: UIImage
    var outputImage: UIImage?

    init(inputImage: UIImage, completionBlock: @escaping () -> Void) {
        self.inputImage = inputImage
        super.init()
        self.completionBlock = completionBlock
    }

    override func main() {
        self.outputImage = self.filter(image: inputImage)
    }

    private func filter(image: UIImage?) -> UIImage? {
        return nil
    }
}

fileprivate func test3() {
    let image = UIImage(contentsOfFile: "test.png")!
    let filterOp = FilterOperation(inputImage: image) {
        print("done")
    }
    filterOp.start()
    dump(filterOp.outputImage)
}

/*Класс Operation позволяет вам создать некоторую задачу, которую вы в будущем можете запустить на очереди операций OperationQueue, а пока она может ожидать выполнения других Operations.
 
 У Operation есть машина состояний (state mashine), которая представляет собой «жизненный цикл» операции Operation:
 Возможные состояния операции Operation: pending (отложенная), ready (готова к выполнению), executing (выполняется), finished (закончена) и cancelled (уничтожена).
 
 Когда вы создаете операцию Operation и размещаете ее на OperationQueue, то устанавливаете операцию в состояние pending (отложенная). Спустя некоторое время она принимает состояние ready (готова к выполнению), и в любой момент может быть отправлена  на OperationQueue для выполнение, перейдя в состояние executing (выполняется), которое может длится от миллисекунд до нескольких минут или дольше. После завершения операция Operation переходит в финальное состояние finished (закончена).  В любой точке этого простого «жизненного» цикла операция Operation может быть уничтожена и перейдет в состояние cancelled (уничтожена).
 
 Мы можем запустить операцию Operation на выполнение с помощью метода start(), но чаще всего мы будем добавлять операцию на очередь операций  OperationQueue, и эта очередь автоматически будет запускать операцию. При этом надо помнить, что отдельная операция Operation, запущенная с помощью start(), выполняется СИНХРОННО на текущем потоке. Для того, чтобы ее запустить за пределами текущего потока нужно воспользоваться либо OperationQueue, либо DispatchQueue.
 
 Текущее состояние операции Operation в любой точке приложения можно отслеживать с помощью булевских свойств : isReady, isExecuting, isFinished, isCancelled c помощью механизмов KVO (key-value observation), так как сама операция может выполняться на любом потоке, а информация может нам понадобиться скорее всего на главном потоке (main thread) или на любом другом потоке, отличным от того, на котором выполняется сама операция.
 
 Если мы хотим добавить функциональности операции Operation, мы должны создать subclass Operation. В простейшем случае в этом subclass нам нужно переопределить метод main() класса Operation. Сам класс Operation автоматически управляет изменением состояния операции, но в более сложных случаях, представленных ниже, нам придется это делать вручную.
 
 Мы можем снабдить операцию завершающим замыкание completionBlock, которое выполняется после завершения операции, а также «качеством обслуживания» qualityOfService, которое влияет на приоритет выполнения операции на OperationQueue.
 
 Как мы видим, класс Operation имеет метод cancel(), однако использование этого метода только устанавливает свойство isCancelled в true, а что семантически означает «удаление» операции можно определить только при создании subclass Operation.  Например, в случае загрузки данных из сети можно определить cancel() как отключение операции от сетевого взаимодействия
 */

// MARK: - Основные понятия. OperationQueue

/*Вместо того, чтобы самостоятельно запускать операции, мы будем управлять ими с помощью очереди операций OperationQueue. Очередь операций OperationQueue можно рассматривать как высоко-приоритетную «обертку»  DispatchQueue, наделенную дополнительной функциональностью: возможностью уничтожения выполняемых операций, выполнения зависимых операций и т.д.
 
 Очень важное свойство maxConcurrentOperationCount задает количество одновременно выполняемых операции на этой очереди и, задавая его равным 1, мы устанавливаем последовательную (serial) очередь операций.
 По умолчанию значение свойства maxConcurrentOperationCount  устанавливается равным Default, что означает максимально возможное число одновременно выполняемых операций:
 
 Вы можете непосредственно добавить на очередь OperationQueue операцию Operation (или любой ее subclass), замыкание или целый массив операций с возможностью блокировки текущего потока до момента полного завершения всего массива операций.
 
 Очередь операций  OperationQueue выполняет размещенные на ней операции согласно их приоритету qualityOfService, «готовности» (свойство isReady установлено в true) и зависимостям ( dependencies) от других операций. Если все эти характеристики равны, то операции отправляются на «выполнение» в том порядке, в котором они были поставлены в очередь. Если какая-то операция размещена в какой-то очереди операций, то она не может быть поставлена еще раз в любую из этих очередей. Если операция была выполнена, она не может быть выполнена повторно ни на какой из очередей операции, операция — одноразовая вещь, поэтому имеет смысл создавать subclasses класса Operation и использовать их, если необходимо, для повторного получения экземпляра  этой операции.
 
 Вы можете послать сообщение cancel()  всем находящимся в очереди операциям с помощью метода cancellAllOperations (), например, если приложение «уходит» в фоновый (background) режим. С помощью метода waitUntilAllOperationsAreFinished() вы можете блокировать текущий поток до тех пор, пока не будут завершены все операции на этой очереди операций. Но НИКОГДА НЕ делайте этого на main queue. Если вам действительно нужно что-то сделать только после завершения всех операций, то создайте private последовательную очередь операций (serial queue) и ожидайте там завершения ваших операций.
 
 Очередь операций OperationQueue ведет себя как DispatchGroup. Вы можете добавлять на OperationQueue операции с различными qualityOfService, и они будут запускаться в соответствии с их приоритетом. Вы можете также установить qualityOfService на более высоком уровне — для очереди операций в целом, но это значение будет передопределено значением  qualityOfService для отдельной операции.
 
 По умолчанию qualityOfService для OperationQueue -это .background.
 
 Вы можете также остановить выполнение операций на OperationQueue путем задания свойства isSuspended в true. Выполняемые операции на этой очереди будут продолжаться, но вновь добавляемые не будут отправляться на выполнение до тех пор, пока вы не измените значение свойства isSuspended на false. По умолчанию значение свойства isSuspended - false.
 
 Давайте проведем некоторые эксперименты с операциями Operation и очередью операций OperationQueue на Playground.
*/
// MARK: Эксперимент 1. Создание OperationQueue и добавление замыканий

