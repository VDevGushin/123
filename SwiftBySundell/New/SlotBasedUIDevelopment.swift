//
//  SlotBasedUIDevelopment.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 17/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

/*Давайте рассмотрим пример, в котором мы создаем подкласс UITableViewCell для приложения рецептов.
 В настоящее время всякий раз, когда мы отображаем рецепт в списке, мы также хотим включить список связанных рецептов,
 что достигается добавлением RelatedRecipesView внизу нашей ячейки, например, так:
 */

fileprivate class RelatedRecipesView: UIView {

}

fileprivate class SocialView: UIView {

}

fileprivate class RecipeCell: UITableViewCell {
    let relatedRecipesView = RelatedRecipesView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addRelatedRecipesView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addRelatedRecipesView() {
        self.contentView.addSubview(relatedRecipesView)
        relatedRecipesView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        relatedRecipesView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        relatedRecipesView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}

//Теперь попробуем сделать более универсальную cell
/*
 Это не идеально, поскольку, делая это, мы одновременно вносим двусмысленность и усложняем нашу ячейку, увеличивая количество состояний, в которых она может находиться.
 Кроме того, поскольку эта новая социальная функция - на данный момент - просто тест А / Б мы действительно должны постараться свести к минимуму осведомленность об этом по всей нашей кодовой базе, поэтому утечка информации об этом одному из наших основных компонентов пользовательского интерфейса может быть не очень хорошей идеей.
 */
fileprivate class RecipeCell1: UITableViewCell {
    var relatedRecipesView: RelatedRecipesView?
    var socialView: SocialView?
}

// MARK: - Opening up a slot
fileprivate class RecipeCell2: UITableViewCell {
    var bottomView: UIView? {
        didSet {
            self.bottomViewDidChange(from: oldValue)
        }
    }

    private func bottomViewDidChange(from oldView: UIView?) {
        guard bottomView !== oldView else { return }
        oldView?.removeFromSuperview()

        guard let newView = bottomView else { return }

        contentView.addSubview(newView)
        newView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        newView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        newView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

fileprivate class VC: UIViewController, UITableViewDataSource {
    enum FeatureFlags {
        case enableSocialRecommendations
        case noEnableSocialRecommendations
    }

    var featureFlags: FeatureFlags = .enableSocialRecommendations

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath) as! RecipeCell2

        switch featureFlags {
        case .enableSocialRecommendations:
            cell.bottomView = SocialView(frame: .zero)
        case .noEnableSocialRecommendations:
            cell.bottomView = RelatedRecipesView(frame: .zero)
        }

        return cell
    }
}

// MARK: - Retaining type safety

fileprivate class HeaderView: UIView {
    var topView: UIView? {
        didSet { topViewDidChange(from: oldValue) }
    }

    var bottomView: UIView? {
        didSet { bottomViewDidChange(from: oldValue) }
    }

    private func bottomViewDidChange(from oldView: UIView?) {
    }

    private func topViewDidChange(from oldView: UIView?) {
    }
}


fileprivate class HeaderView1<Top: UIView, Bottom: UIView>: UIView {
    var topView: Top? {
        didSet { topViewDidChange(from: oldValue) }
    }

    var bottomView: Bottom? {
        didSet { bottomViewDidChange(from: oldValue) }
    }

    private func bottomViewDidChange(from oldView: UIView?) {
    }

    private func topViewDidChange(from oldView: UIView?) {
    }
}

fileprivate func test() {
    let _ = HeaderView1<UIButton, UILabel>()
    let _ = HeaderView1<UIImageView, UIButton>()
    let _ = HeaderView1<UILabel, UISwitch>()
}

fileprivate class VC2: UIViewController {
    typealias MovieHeaderView = HeaderView1<UIButton, UILabel>
    typealias UserHeaderView = HeaderView1<UIImageView, UIButton>
    typealias SettingHeaderView = HeaderView1<UILabel, UISwitch>
    private lazy var headerView = MovieHeaderView()
}
