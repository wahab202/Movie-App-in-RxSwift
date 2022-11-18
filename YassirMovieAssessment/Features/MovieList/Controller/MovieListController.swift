//
//  ViewController.swift
//  YassirMovieAssessment
//
//  Created by Abdul Wahab on 15/11/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MovieListController: UIViewController, MovieListCoordinator {
    
    var root: UIViewController {
        return self
    }
    
    private unowned var cv: UICollectionView!
    private unowned var indicator: UIActivityIndicatorView!
    private let bag: DisposeBag
    private let vm: MovieListViewModel
    
    init(vm: MovieListViewModel = MovieListViewModel()) {
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
        setNavbarAppearance()
        view.backgroundColor = .systemBackground
        title = "Movies"
                
        let layout = createLayout()
        
        cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout).also {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.allowsMultipleSelection = false
            $0.allowsSelection = true
            
            $0.register(MovieListCell.self, forCellWithReuseIdentifier: "MovieListCell")

            view.addSubview($0)
            
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        let input = MovieListViewModel.Input(
            selection: cv.rx.itemSelected.asDriver()
        )

        let output = vm.transform(input: input)

        let dataSource = RxCollectionViewSectionedReloadDataSource<MovieListSection>(
            configureCell: { dataSource, collectionView, indexPath, model in
                let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
                return cell.bind(model: model)
        })
            

        let disposables = [
            output.sections.drive(cv.rx.items(dataSource: dataSource)),
            output.navigation.drive(navigationBinder),
            output.error.drive(errorBinder),
            output.loading.drive(indicator.rx.isAnimating)
        ]

        disposables.forEach { $0.disposed(by: bag) }
    }
    
    private var navigationBinder: Binder<MovieListViewModel.Route> {
        return Binder(self) { host, route in
            host.navigate(to: route)
            
            // deselecting items in collectionCiew
            if let selectedItems = host.cv.indexPathsForSelectedItems {
                for indexPath in selectedItems { host.cv.deselectItem(at: indexPath, animated: true) }
            }
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

private extension MovieListController {
    func createLayout() -> UICollectionViewLayout {
        let height: CGFloat = 80
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(height)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(height)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setNavbarAppearance() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .orange
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
}
