//
//  ViewController.swift
//  CustomSlider
//
//  Created by Vlad on 9.08.24.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Dependecies
    private let sliderView = SliderView()
    
    override func loadView() {
        super.loadView()
        view = sliderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

