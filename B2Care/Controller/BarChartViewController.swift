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
        guard let headline = data as? String else {return}
        
        if let header = header{
            header.setTitle(headline)
        } else {
            self.headerTitle = headline
        }
        
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
        header = HeaderView(frame: frame, leftButton: backButton, title: "Graf")
        guard let header = header else {return}
        view.addSubview(header)
    }
    
    private func prepareChartStyle(){
        
       // chart.backgroundColor = .backgroundLight
        chart.legend.font = UIFont.italicSystemFont(ofSize: 12)
        
        view.addSubview(chart)
        chart.snp.makeConstraints { (make) in
            make.top.equalTo(headerHeight)
            make.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(10)
        }
        
        let entry1 = BarChartDataEntry(x: 1.0, y: 20.0)
        let entry2 = BarChartDataEntry(x: 2.0, y: 30.0)
        let entry3 = BarChartDataEntry(x: 3.0, y: 52.0)
        let entry4 = BarChartDataEntry(x: 4.0, y: 2.0)
        let entry5 = BarChartDataEntry(x: 5.0, y: 3.0)
        let entry6 = BarChartDataEntry(x: 6.0, y: 5.0)
        let entry7 = BarChartDataEntry(x: 7.0, y: 21.0)
        let entry8 = BarChartDataEntry(x: 8.0, y: 33.0)
        let entry9 = BarChartDataEntry(x: 9.0, y: 5.0)
        let entry10 = BarChartDataEntry(x: 10.0, y: 28.0)
        let entry11 = BarChartDataEntry(x: 11.0, y: 31.0)
        let entry12 = BarChartDataEntry(x: 12.0, y: 11.0)
        let dataSet = BarChartDataSet(entries: [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12], label: "2020")
        dataSet.colors = ChartColorTemplates.material()
        let data = BarChartData(dataSets: [dataSet])
        chart.data = data
        chart.chartDescription?.text = "Vývoj nemoci po měsících"
        
        chart.notifyDataSetChanged()
    }

}
