//
//  SliderCell.swift
//  CustomSlider
//
//  Created by Vlad on 9.08.24.
//

import UIKit
import Lottie

class SliderCell: UICollectionViewCell {
    
    //MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lottieView: LottieAnimationView = {
        let lottieView = LottieAnimationView()
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        return lottieView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup cell
    func setupCell(sliderItem: SliderItem) {
        guard let color = UIColor(hex: sliderItem.color) else {
            return
        }
        contentView.backgroundColor = color
        titleLabel.text = sliderItem.title
        textLabel.text = sliderItem.text
        lottieView.animation = LottieAnimation.named(sliderItem.animationName)
        setupLottie()
    }
    
    private func setupLottie() {
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFit
        lottieView.play()
    }
    
    //MARK: - Layout
    private func layoutElements() {
        layoutLabel()
        layoutLottieAnimationView()
    }
    
    private func layoutLabel() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutLottieAnimationView() {
        contentView.addSubview(lottieView)
        
        NSLayoutConstraint.activate([
            lottieView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lottieView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lottieView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lottieView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}
