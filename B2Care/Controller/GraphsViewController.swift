//
//  GraphsViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 06.01.2021.
//

import UIKit

class GraphsViewController: UIViewController {
    // MARK: - Properties
    private let table = UITableView()
    private let refreshControl = UIRefreshControl()
    private let cellId = "CellID"
    private var graphs: [Graph] = []
    
    public var data: Any?{
        didSet{
            updateView(with: data)
        }
    }
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: - Actions
    
    @objc private func refresh(_ sender: AnyObject){
        refreshControl.endRefreshing()
    }
    
    // MARK: - Helpers
    
    private func updateView(with data: Any?){
        guard let patient = data as? Patient else {return}
        
        var values: [Double] = []
        for _ in 1...12 {
            values.append(Double.random(in: 0...50))
        }
        let graphs = [Graph(id: 1, name: "Průběh nemoci 2020", created: "1.1.2020 ve 13:00", updated: "", description: "Vývoj podle měsíců", Patient: patient, data: values)]
        self.graphs = graphs
        table.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        prepareRefreshControlStyle()
        prepareTableStyle()
    }
    
    private func prepareRefreshControlStyle(){
        //  refreshControl.attributedTitle = NSAttributedString(string: "Potažením zaktualizujete data")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        table.addSubview(refreshControl)
    }
    
    private func prepareTableStyle(){
        let headerHeight = (view.frame.height / 10) + 35
        let tabbarHeight: CGFloat = 50
        let buttonsHeight: CGFloat = 50
        let padding: CGFloat = 45
        let offset: CGFloat = view.frame.height - (headerHeight + tabbarHeight + buttonsHeight + padding) - 5
        
        table.register(DocumentCell.self, forCellReuseIdentifier: cellId)
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 10
        table.separatorInset = .zero
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(view.snp.top).offset(offset)
            make.left.right.equalToSuperview().inset(5)
        }
    }
}

extension GraphsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graphs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let cell = cell as? DocumentCell{
            let graph = graphs[indexPath.row]
            cell.data = Document(id: 1, name: graph.name, created: graph.created, updated: "", value: "")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = BarChartViewController()
        controller.data = graphs[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
