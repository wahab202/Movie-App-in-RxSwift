//
//  MovieListCell.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MovieListCell: UICollectionViewCell {
    
    private enum Constants {
        static let logoSize: CGFloat = 48.0
        static let titleContainerMinHeight: CGFloat = 40.0
    }
    
    private unowned var titleLabel: UILabel!
    private unowned var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var isHighlighted: Bool {
        didSet {
            reflectState()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            reflectState()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    private func reflectState() {
        let isActive = self.isHighlighted || self.isSelected
        isActive ? fadeIn() : fadeOut()
    }
    
    private func setup() {
        contentView.also {
            $0.backgroundColor = .lightGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        
        let container = UIStackView().also {
            $0.axis = .vertical
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
            
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
        }
        
        titleLabel = UILabel().also {
            $0.font = .systemFont(ofSize: 18)
            $0.textColor = .black
            $0.numberOfLines = 2
            
            container.addArrangedSubview($0)
        }
        
        dateLabel = UILabel().also {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
            $0.numberOfLines = 2
            
            container.addArrangedSubview($0)
        }
        
    }
    
    func bind(model: MovieListCellModel) -> Self {
        titleLabel.text = model.title
        if let releaseDate = model.releaseDate {
            dateLabel.text = releaseDate.formatted(date: .omitted, time: .shortened)
        }
        
        return self
    }
    
    private func fadeIn(animated: Bool = true) {
        fade(alpha: 0.4, animated: animated)
    }
    
    private func fadeOut(animated: Bool = true) {
        fade(alpha: 1, animated: animated)
    }

    private func fade(alpha value: CGFloat, animated: Bool = true) {
        let actions = {
            self.alpha = value
        }
        
        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.2,
                options: [
                    .allowUserInteraction,
                        .curveEaseOut,
                        .beginFromCurrentState
                ],
                animations: actions,
                completion: nil
            )
        } else {
            actions()
        }
    }
}

