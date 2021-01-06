 //
//  GraphViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 06.01.2021.
//

import UIKit
import Charts

class BarChartViewController: UIViewController, BackButtonDelegate {
    // MARK: - Properties
    private var header: HeaderView?
    private var headerTitle: String?
    private var headerSubView = SubTitleView()
    private let chart = BarChartView()

    
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
    
    override func viewDidLayoutSubviews() {
        if let htitle = headerTitle{
            header?.setTitle(htitle)
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func updateView(with data: Any?){
        guard let graph = data as? Graph else {return}
        headerSubView.data = graph.name
        if let header = header{
            header.setTitle(graph.Patient.fullName)
        } else {
            self.headerTitle = graph.Patient.fullName
        }
        
        var entries = [BarChartDataEntry]()
        for (index, value) in graph.data.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index), y: value))
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: graph.name)
        dataSet.colors = ChartColorTemplates.material()
        let data = BarChartData(dataSets: [dataSet])
        chart.data = data
        chart.chartDescription?.text = graph.description
        
        chart.notifyDataSetChanged()
    }
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        prepareHeaderStyle()
        prepareChartStyle()
    }
    
    private func prepareHeaderStyle(){
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
        let backButton = BackButton()
        backButton.delegate = self
        header = HeaderView(frame: frame, leftButton: backButton, title: "Graf", bottomView: headerSubView, bottomViewAlign: .center)
        guard let header = header else {return}
        view.addSubview(header)
    }
    
    private func prepareChartStyle(){
        
        chart.backgroundColor = .backgroundLight
        chart.legend.font = UIFont.italicSystemFont(ofSize: 12)
        
        view.addSubview(chart)
        chart.snp.makeConstraints { (make) in
            make.top.equalTo(headerHeight + 5)
            make.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(10)
        }
    }

}
