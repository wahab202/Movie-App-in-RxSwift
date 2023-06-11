//
//  MovieDetailController.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 17/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SDWebImage

class MovieDetailController: UIViewController {
    
    private let bag: DisposeBag
    private let vm: MovieDetailViewModel
    private unowned var posterImageView: UIImageView!
    private unowned var movieTitleLabel: UILabel!
    private unowned var movieDescriptionLabel: UILabel!
    private unowned var indicator: UIActivityIndicatorView!
    
    init(vm: MovieDetailViewModel) {
        self.vm = vm
        self.bag = DisposeBag()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        let scrollView = UIScrollView().also {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.topAnchor),
                $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
        
        let container = UIStackView().also {
            $0.axis = .vertical
            $0.spacing = 16
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: scrollView.topAnchor),
                $0.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
            ])
        }
        
        posterImageView = UIImageView().also {
            $0.contentMode = .scaleToFill
            container.addArrangedSubview($0)
            
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 300),
                $0.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        }
        
        movieTitleLabel = UILabel().also {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 32)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            container.addArrangedSubview($0)
        }
        
        let descriptionHolder = UIView().also {
            container.addArrangedSubview($0)
        }
        
        movieDescriptionLabel = UILabel().also {
            $0.textColor = .gray
            $0.textAlignment = .justified
            $0.font = .systemFont(ofSize: 22)
            $0.numberOfLines = 0
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            descriptionHolder.addSubview($0)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: descriptionHolder.topAnchor),
                $0.leadingAnchor.constraint(equalTo: descriptionHolder.leadingAnchor, constant: 16),
                $0.trailingAnchor.constraint(equalTo: descriptionHolder.trailingAnchor, constant: -16),
                $0.bottomAnchor.constraint(equalTo: descriptionHolder.bottomAnchor)
            ])
        }
        
        indicator = UIActivityIndicatorView().also {
            $0.startAnimating()
            $0.hidesWhenStopped = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.topAnchor),
                $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
    
    private func bindViewModel() {
        let input = MovieDetailViewModel.Input()

        let output = vm.transform(input: input)
        let a = "hello"
        
        let disposables = [
            output.description.drive(movieDescriptionLabel.rx.text),
            output.title.drive(movieTitleLabel.rx.text),
            output.title.drive(rx.title),
            output.posterURL.drive(posterBinder),
            output.error.drive(errorBinder),
            output.loading.drive(indicator.rx.isAnimating)
        ]

        disposables.forEach { $0.disposed(by: bag) }
    }
    
    private var posterBinder: Binder<String> {
        return Binder(posterImageView) { imageView, url in
            imageView.sd_setImage(with: URL(string: url), placeholderImage: nil)
        }
    }
    
    private var errorBinder: Binder<String> {
        return Binder(self) { host, message in
            host.indicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            host.present(alert, animated: true, completion: nil)
        }
    }
}
