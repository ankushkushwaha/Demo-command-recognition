//
//  ViewController.swift
//  VoiceCommands
//
//  Created by Ankush 29/09/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    private let viewModel = HomeViewModel()
        
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupObservers()

        statusLabel.backgroundColor = UIColor(red: 0.98, green: 0.64, blue: 0.30, alpha: 0.5)
        
        viewModel.setupSpeech()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.requestSpeechAuthorization()
    }
    
    private func setupObservers() {
        viewModel.$cellViewModel.sink { [weak self] cellViewModel in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$statusLabelText.sink { [weak self] statusText in
            DispatchQueue.main.async {
                self?.statusLabel.text = statusText
            }
        }.store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(UINib(nibName: TableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier , for: indexPath) as? TableViewCell else { return UITableViewCell() }

        cell.viewModel = viewModel.cellViewModel
        return cell
    }
}
