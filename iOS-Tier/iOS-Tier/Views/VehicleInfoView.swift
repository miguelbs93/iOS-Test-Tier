//
//  VehicleInfoView.swift
//  iOS-Tier
//
//  Created by Miguel Bou Sleiman on 26.10.22.
//

import UIKit

final class VehicleInfoView: UIViewController {
    
    private lazy var handleArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var handlerLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont.bold(withSize: 20)
        return label
    }()
    
    private lazy var batteryLevelLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont.normal(withSize: 15)
        return label
    }()
    
    private lazy var maxSpeedLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont.normal(withSize: 15)
        return label
    }()
    
    private lazy var hasHelmetBoxLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFont.normal(withSize: 15)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [batteryLevelLbl, maxSpeedLbl, hasHelmetBoxLbl])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let horizontalPadding = 20.0
    private let verticalPadding = 15.0
    
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        handleArea.addSubview(handlerLine)
        view.addSubview(handleArea)
        view.addSubview(titleLbl)
        view.addSubview(infoStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            handleArea.topAnchor.constraint(equalTo: view.topAnchor),
            handleArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            handleArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            handleArea.heightAnchor.constraint(equalToConstant: 25),
            
            handlerLine.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor),
            handlerLine.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor),
            handlerLine.widthAnchor.constraint(equalToConstant: 100),
            handlerLine.heightAnchor.constraint(equalToConstant: 5),
            
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            titleLbl.topAnchor.constraint(equalTo: handleArea.bottomAnchor, constant: 15),
            titleLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            infoStackView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 15),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -verticalPadding)
        ])
    }
    
    func populate(title: String, batteryLevel: String, maxSpeed: String, hasHelmetBox: Bool) {
        titleLbl.text = "Scooter \(title)"
        batteryLevelLbl.text = "Battery Level: \(batteryLevel)"
        maxSpeedLbl.text = "Max Speed: \(maxSpeed)"
        hasHelmetBoxLbl.text = "Has Helmet: \(hasHelmetBox ? "YES" : "NO")"
    }
    
}
