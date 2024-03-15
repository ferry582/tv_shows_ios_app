//
//  ViewController.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 05/01/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Show>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Show>
    
    // MARK: -Variables
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private var dataSource: DataSource!
    private var searchText = PassthroughSubject<String, Never>()
    private var isSearchActive = false
    
    // MARK: -UI Components
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let loadingIndicator = LoadingIndicator()
    
    private let showColectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no show!"
        label.textColor = .primaryText
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: -Life Cycle
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupView()
        setupRefreshController()
        setupObserver()
        setUpDataSource()
        
        showColectionView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        viewModel.getShows(page: currentPage)
    }
    
    // MARK: -UI Setup
    private func setupRefreshController() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        showColectionView.refreshControl = refreshControl
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primary]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primary]
        navigationController?.navigationBar.tintColor = .primary
        navigationItem.title = "Shows"
        navigationItem.searchController = searchController
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.mainBg
        
        view.addSubview(showColectionView)
        view.addSubview(emptyLabel)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            showColectionView.topAnchor.constraint(equalTo: view.topAnchor),
            showColectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            showColectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showColectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupObserver() {
        viewModel.shows
            .sink { [weak self] shows in
                if shows.isEmpty {
                    self?.emptyLabel.isHidden = false
                    if self!.isSearchActive {
                        self?.showColectionView.isHidden = true
                    }
                } else {
                    self?.updateData(with: shows)
                    self?.emptyLabel.isHidden = true
                    self?.showColectionView.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    self.loadingIndicator.startLoading()
                } else {
                    self.loadingIndicator.stopLoading()
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.isSearchActive
            .receive(on: DispatchQueue.main)
            .sink { isActive in
                self.isSearchActive = isActive
            }
            .store(in: &cancellables)
        
        // Setup search text observer
        searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .dropFirst() // skip when searchbar active at first time
            .map { $0.lowercased() }
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.viewModel.searchShows(for: text)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: -Actions
    @objc private func didPullToRefresh() {
        if !isSearchActive {
            reloadShowsData()
        }
    }
    
    private func reloadShowsData() {
        currentPage = 0
        viewModel.removeAllShows()
        viewModel.getShows(page: 0)
    }
}

extension HomeViewController {
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: showColectionView, cellProvider: { collectionView, indexPath, shows in
            let cell = self.showColectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as! ShowCollectionViewCell
            cell.configure(with: shows)
            return cell
        })
    }
    
    func updateData(with shows: [Show]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(shows)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchText.send(searchController.searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if isSearchActive {
            self.reloadShowsData()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        let height = Int(Float(width) * 1.405 + 30)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = dataSource.itemIdentifier(for: indexPath)
        let vc = DetailViewController(viewModel: DetailViewModel(), show: show!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isSearchActive {
            let lastItemInSection = dataSource.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - 1
            if indexPath.item == lastItemInSection {
                print("fetch more data")
                currentPage += 1
                viewModel.getShows(page: currentPage)
            }
        }
    }
}
