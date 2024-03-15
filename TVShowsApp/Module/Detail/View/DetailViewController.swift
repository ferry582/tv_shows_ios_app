//
//  DetailViewController.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 08/01/24.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    // MARK: -Variables
    private let show: Show
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: -UI Components
    private let loadingIndicator = LoadingIndicator()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never // ignore the safe area
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailView: DetailView = {
        let view = DetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -Life Cycle
    init(viewModel: DetailViewModel, show: Show) {
        self.viewModel = viewModel
        self.show = show
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupObserver()
        setupCallback()
        
        detailView.delegate = self
        
        detailView.configureShowData(with: show)
        viewModel.getCastsAndEpisodes(showId: show.id)
    }
    
    // MARK: -UI Setup
    private func setupView() {
        view.backgroundColor = UIColor.mainBg
        
        view.addSubview(scrollView)
        scrollView.addSubview(detailView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            detailView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            detailView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupObserver() {
        viewModel.casts
            .sink { [weak self] casts in
                self?.detailView.configureCastData(with: casts)
            }
            .store(in: &cancellables)
        
        viewModel.seasons
            .sink { [weak self] seasons in
                self?.detailView.configureEpisodeData(with: seasons)
            }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    self.loadingIndicator.startLoading()
                } else {
                    self.loadingIndicator.stopLoading()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: -Actions
    private func setupCallback() {
        detailView.startLoading = {
            self.viewModel.startLoading()
        }
        detailView.stopLoading = {
            self.viewModel.stopLoading()
        }
    }
}

extension DetailViewController: DetailViewDelegate {
    func didCastItemSelected(person: Person) {
        let vc = CastDetailViewController(person: person)
        
        if #available(iOS 16.0, *) {
            let navVC = UINavigationController(rootViewController: vc)
            if let sheet = navVC.sheetPresentationController {
                sheet.detents = [.custom(resolver: { _ in
                    210
                })]
            }
            present(navVC, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
