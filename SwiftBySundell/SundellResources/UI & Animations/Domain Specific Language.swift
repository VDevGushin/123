//
//  Domain Specific Language.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 12/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import SpriteKit
import WebKit
import MapKit
import MetalKit

/*На этой неделе мы поговорим о создании DSL в Swift. Давайте начнем с понимания аббревиатуры DSL. Специфичный для домена язык - это язык, размещенный на родительском языке для решения любой конкретной области. Отличным примером DSL может быть HTML, который является DSL для создания разметки веб-страницы.
 
 Существуют некоторые требования к языку, на котором вы хотите создать DSL. Хост-язык должен иметь первоклассные функции, замыкающие замыкания и перегрузку операторов, чтобы сделать возможным DSL. Хорошая новость заключается в том, что Swift обладает всеми этими функциями.
 
 Мы собираемся упростить разработку пользовательского интерфейса на iOS, создав специальный DSL для UIKit. У нас есть два способа создания пользовательского интерфейса в iOS. Первый - с помощью Interface Builder, а второй - с помощью кода. У них обоих есть свои плюсы и минусы. Например, создание пользовательского интерфейса с помощью Interface Builder - это высокоскоростной и визуальный процесс, но вам приходится иметь дело с проблемным процессом проверки кода из-за формата Xibs и раскадровки. В случае построения вашего пользовательского интерфейса с помощью кода вы получаете возможность повторного использования и очистки кода, но вы имеете дело с императивной и подверженной ошибкам кодовой базой без визуального понимания иерархии представлений.

Давайте установим наши цели в создании UIKit DSL в Swift:
1) Визуальная иерархия представлений
2) Декларативный, как HTML
3) Типобезопасность и гарантия правильности во время компиляции.
 */

public func view(apply closure: (UIView) -> Void) -> UIView {
    let view = UIView()
    closure(view)
    return view
}

protocol StylebleTest: class {

}

extension StylebleTest {
    func applyStyle(closure: (Self) -> Void) {
        closure(self)
    }
}

extension UIView: StylebleTest {

}

public func stack(apply closure: (UIStackView) -> Void) -> UIStackView {
    let stack = UIStackView()
    stack.applyStyle {
        $0.spacing = 16
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
    }
//    stack.applyStyle {
//        $0.
//    }
    closure(stack)
    return stack
}

extension UIView {
    func add(_ view: UIView) {
        if let stack = self as? UIStackView {
            stack.addArrangedSubview(view)
        } else {
            addSubview(view)
        }
    }
}

extension UIView {
    @discardableResult
    public func custom<View: UIView>(_ view: View, apply closure: (View) -> Void) -> View {
        add(view)
        closure(view)
        return view
    }
}

extension UIView {
    @discardableResult
    public func stack(apply closure: (UIStackView) -> Void) -> UIStackView {
        return custom(UIStackView(), apply: closure)
    }

    @discardableResult
    public func view(apply closure: (UIView) -> Void) -> UIView {
        return custom(UIView(), apply: closure)
    }

    @discardableResult
    public func button(with type: UIButton.ButtonType = .system,
                       apply closure: (UIButton) -> Void) -> UIButton {
        return custom(UIButton(type: type), apply: closure)
    }

    @discardableResult
    public func label(apply closure: (UILabel) -> Void) -> UILabel {
        return custom(UILabel(), apply: closure)
    }

    @discardableResult
    public func segmentedControl(with items: [Any]? = nil,
                                 apply closure: (UISegmentedControl) -> Void) -> UISegmentedControl {
        return custom(UISegmentedControl(items: items), apply: closure)
    }

    @discardableResult
    public func textField(apply closure: (UITextField) -> Void) -> UITextField {
        return custom(UITextField(), apply: closure)
    }

    @discardableResult
    public func slider(apply closure: (UISlider) -> Void) -> UISlider {
        return custom(UISlider(), apply: closure)
    }

    @discardableResult
    public func uiswitch(apply closure: (UISwitch) -> Void) -> UISwitch {
        return custom(UISwitch(), apply: closure)
    }

    @discardableResult
    public func activityIndicator(with style: UIActivityIndicatorView.Style = .white,
                                  apply closure: (UIActivityIndicatorView) -> Void) -> UIActivityIndicatorView {
        return custom(UIActivityIndicatorView(style: style), apply: closure)
    }

    @discardableResult
    public func progress(with style: UIProgressView.Style = .default,
                         apply closure: (UIProgressView) -> Void) -> UIProgressView {
        return custom(UIProgressView(progressViewStyle: style), apply: closure)
    }

    @discardableResult
    public func pageControl(apply closure: (UIPageControl) -> Void) -> UIPageControl {
        return custom(UIPageControl(), apply: closure)
    }

    @discardableResult
    public func stepper(apply closure: (UIStepper) -> Void) -> UIStepper {
        return custom(UIStepper(), apply: closure)
    }

    @discardableResult
    public func table(with style: UITableView.Style = .plain,
                      apply closure: (UITableView) -> Void) -> UITableView {
        return custom(UITableView(frame: .zero, style: style), apply: closure)
    }

    @discardableResult
    public func image(apply closure: (UIImageView) -> Void) -> UIImageView {
        return custom(UIImageView(), apply: closure)
    }

    @discardableResult
    public func collection(apply closure: (UICollectionView) -> Void) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        return custom(collectionView, apply: closure)
    }

    @discardableResult
    public func textView(apply closure: (UITextView) -> Void) -> UITextView {
        return custom(UITextView(), apply: closure)
    }

    @discardableResult
    public func datePicker(apply closure: (UIDatePicker) -> Void) -> UIDatePicker {
        return custom(UIDatePicker(), apply: closure)
    }

    @discardableResult
    public func scroll(apply closure: (UIScrollView) -> Void) -> UIScrollView {
        return custom(UIScrollView(), apply: closure)
    }

    @discardableResult
    public func picker(apply closure: (UIPickerView) -> Void) -> UIPickerView {
        return custom(UIPickerView(), apply: closure)
    }

    @discardableResult
    public func searchBar(apply closure: (UISearchBar) -> Void) -> UISearchBar {
        return custom(UISearchBar(), apply: closure)
    }

    @discardableResult
    public func toolbar(apply closure: (UIToolbar) -> Void) -> UIToolbar {
        return custom(UIToolbar(), apply: closure)
    }

    @discardableResult
    public func tabBar(apply closure: (UITabBar) -> Void) -> UITabBar {
        return custom(UITabBar(), apply: closure)
    }

    @discardableResult
    public func navigationBar(apply closure: (UINavigationBar) -> Void) -> UINavigationBar {
        return custom(UINavigationBar(), apply: closure)
    }

    @discardableResult
    public func webView(with config: WKWebViewConfiguration,
                        apply closure: (WKWebView) -> Void) -> WKWebView {
        return custom(WKWebView(frame: .zero, configuration: config), apply: closure)
    }

    @available(iOS 11.0, *)
    @discardableResult
    public func arSceneView(apply closure: (ARSCNView) -> Void) -> ARSCNView {
        return custom(ARSCNView(), apply: closure)
    }

    @available(iOS 11.0, *)
    @discardableResult
    public func arSpriteView(apply closure: (ARSKView) -> Void) -> ARSKView {
        return custom(ARSKView(), apply: closure)
    }

    @discardableResult
    public func sceneView(apply closure: (SCNView) -> Void) -> SCNView {
        return custom(SCNView(), apply: closure)
    }

    @discardableResult
    public func spriteView(apply closure: (SKView) -> Void) -> SKView {
        return custom(SKView(), apply: closure)
    }

    @discardableResult
    public func map(apply closure: (MKMapView) -> Void) -> MKMapView {
        return custom(MKMapView(), apply: closure)
    }

    @discardableResult
    public func metal(apply closure: (MTKView) -> Void) -> MTKView {
        return custom(MTKView(), apply: closure)
    }

    @discardableResult
    public func visualEffect(with effect: UIVisualEffect? = nil,
                             apply closure: (UIVisualEffectView) -> Void) -> UIVisualEffectView {
        return custom(UIVisualEffectView(effect: effect), apply: closure)
    }
}

//FOR custom
class CustomLabel: UILabel {
}

extension UIView {
    @discardableResult
    func customLabel(apply closure: (CustomLabel) -> Void) -> CustomLabel {
        return custom(CustomLabel(), apply: closure)
    }
}

fileprivate func TEST() {
    let _ = stack {
        $0.spacing = 16
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true

        $0.stack {
            $0.distribution = .fillEqually
            $0.axis = .horizontal

            $0.label {
                $0.textAlignment = .center
                $0.textColor = .white
                $0.text = "Hello"
            }

            $0.label {
                $0.textAlignment = .center
                $0.textColor = .white
                $0.text = "World"
            }

            $0.customLabel {
                $0.textAlignment = .center
                $0.textColor = .white
                $0.text = "!!!"
            }
        }

        let _ = $0.button {
            $0.tintColor = .white
            $0.setTitle("Say Hi!", for: .normal)
        }

        $0.view {
            $0.backgroundColor = .clear
        }
    }
}
