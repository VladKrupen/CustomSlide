//
//  SliderView.swift
//  CustomSlider
//
//  Created by Vlad on 9.08.24.
//

import UIKit

class SliderView: UIView {
    
    //MARK: - Property
    private let sliderData: [SliderItem] = [
        SliderItem(color: "#964b00FF", title: "Slide1", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", animationName: "Space1"),
        SliderItem(color: "#FFA500FF", title: "Slide2", text: "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo.", animationName: "Space2"),
        SliderItem(color: "#808080FF", title: "Slide3", text: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", animationName: "Space3")
    ]
    
    private var pagerViewArray: [UIView] = []
    private var currentSlide: Int = 0
    
    private var widthAnc: NSLayoutConstraint?
    
    private var currentPageIndex: CGFloat = 0
    private var fromValue: CGFloat = 0
    
    //MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(SliderCell.self, forCellWithReuseIdentifier: String(describing: SliderCell.self))
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let pagerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nextButton: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped))
        
        let nextImage = UIImageView()
        nextImage.image = UIImage(systemName: "chevron.right.circle.fill")
        nextImage.tintColor = .white
        nextImage.contentMode = .scaleAspectFit
        nextImage.translatesAutoresizingMaskIntoConstraints = false
        nextImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        nextImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        let nextButton = UIView()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.addSubview(nextImage)
        nextButton.isUserInteractionEnabled = true
        nextButton.addGestureRecognizer(tapGesture)
        
        nextImage.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).isActive = true
        nextImage.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).isActive = true
        
        return nextButton
    }()
    
    //MARK: - Layer
    private let shape = CAShapeLayer()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutElements()
        createPagersView()
        createStack()
        setupShape()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: frame.width, height: frame.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Animation
    private func getAnimation(toValue: CGFloat, fromValue: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 0.5
        return animation
    }
    
    //MARK: - Setup
    private func setupPagerStack(indexPath: IndexPath) {
        pagerViewArray.forEach { pager in
            
            pager.constraints.forEach { constraint in
                pager.removeConstraint(constraint)
            }
            
            let slideTag = indexPath.item + 1
           
            if slideTag == pager.tag {
                pager.layer.opacity = 1
                widthAnc = pager.widthAnchor.constraint(equalToConstant: 20)
            } else {
                pager.layer.opacity = 0.5
                widthAnc = pager.widthAnchor.constraint(equalToConstant: 10)
            }
            
            widthAnc?.isActive = true
            pager.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
        let curentIndex = currentPageIndex * CGFloat(indexPath.item + 1)
        let animation = getAnimation(toValue: curentIndex, fromValue: fromValue)
        shape.add(animation, forKey: "animation")
        
        fromValue = curentIndex
    }
    
    private func setupShape() {
        
        currentPageIndex = CGFloat(1) / CGFloat(sliderData.count)
        
        let nextStroke = UIBezierPath(arcCenter: CGPoint(x: 25, y: 25), radius: 23, startAngle: -(.pi/2), endAngle: 4.8, clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = nextStroke.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 3
        trackShape.strokeColor = UIColor.white.cgColor
        trackShape.opacity = 0.1
        nextButton.layer.addSublayer(trackShape)
        
        shape.path = nextStroke.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 3
        shape.lineCap = .round
        shape.strokeStart = 0
        shape.strokeEnd = 0
        
        nextButton.layer.addSublayer(shape)
    }
    
    //MARK: - Create
    private func createPagersView() {
        for tag in 1...sliderData.count {
            let pager = UIView()
            pager.tag = tag
            pager.backgroundColor = .white
            pager.layer.cornerRadius = 5
            pager.translatesAutoresizingMaskIntoConstraints = false
//            pager.heightAnchor.constraint(equalToConstant: 10).isActive = true
//            pager.widthAnchor.constraint(equalToConstant: 10).isActive = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollToSlide))
            pager.addGestureRecognizer(tapGesture)
            self.pagerViewArray.append(pager)
            self.pagerStack.addArrangedSubview(pager)
        }
    }
    
    private func createStack() {
        addSubview(hStack)
        vStack.addArrangedSubview(pagerStack)
        vStack.addArrangedSubview(skipButton)
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
        ])
    }
    
    //MARK: - Layout
    private func layoutElements() {
        layoutCollection()
    }
    
    private func layoutCollection() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}

//MARK: - UICollectionViewDataSource
extension SliderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SliderCell.self), for: indexPath) as? SliderCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(sliderItem: sliderData[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentSlide = indexPath.item
        setupPagerStack(indexPath: indexPath)
    }
}

//MARK: - UICollectionViewDelegate
extension SliderView: UICollectionViewDelegate {
    
}

//MARK: - OBJC
extension SliderView {
    @objc private func nextButtonTapped() {
        let maxSlide = sliderData.count
        
        if currentSlide < maxSlide - 1 {
            currentSlide += 1
            collectionView.scrollToItem(at: IndexPath(item: currentSlide, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc private func scrollToSlide(sender: UIGestureRecognizer) {
        if let index = sender.view?.tag {
            collectionView.scrollToItem(at: IndexPath(item: index - 1, section: 0), at: .centeredHorizontally, animated: true)
            currentSlide = index - 1
        }
    }
}
