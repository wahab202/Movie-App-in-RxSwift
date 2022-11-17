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

class MovieListController: UIViewController {
    
    private var cv: UICollectionView!
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
        view.backgroundColor = .systemBackground
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .orange
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
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
    }
    
    private func bindViewModel() {
        let input = MovieListViewModel.Input()

        let output = vm.transform(input: input)

        let dataSource = RxCollectionViewSectionedReloadDataSource<MovieListSection>(
            configureCell: { dataSource, collectionView, indexPath, model in
                let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
                return cell.bind(model: model)
        })
            

        let disposables = [
            output.sections.drive(cv.rx.items(dataSource: dataSource))
        ]

        disposables.forEach { $0.disposed(by: bag) }
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
}
