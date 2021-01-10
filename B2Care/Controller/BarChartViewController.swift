 //
//  GraphViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 06.01.2021.
//

import UIKit
import Charts

class BarChartViewController: BaseViewController {
    // MARK: - Properties
    private let titleView = SubTitleView()
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
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func updateView(with data: Any?){
        guard let graph = data as? Graph else {return}
 
        titleView.setTitle(graph.Patient.fullName)
        titleView.setSubTitle(graph.name)
        
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
        prepareTitleViewStyle()
        prepareChartStyle()
    }
    
    private func prepareTitleViewStyle(){
        navigationItem.titleView = titleView
    }
    private func prepareChartStyle(){
        
        chart.backgroundColor = .backgroundLight
        chart.legend.font = UIFont.italicSystemFont(ofSize: 12)
        
        view.addSubview(chart)
        chart.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(10)
        }
    }

}
