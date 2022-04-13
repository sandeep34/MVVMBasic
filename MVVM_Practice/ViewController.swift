//
//  ViewController.swift
//  MVVM_Practice
//
//  Created by Sandeep Tomar on 29/01/22.
//

import UIKit
import Combine

class Sandeep<T> {
    
    private var listerner: ((T?) -> Void)?
    var value: T? {
        didSet {
            self.listerner?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    
    func bindData(_ listern: @escaping(T?) -> Void) {
        listern(value)
        self.listerner = listern
    }
    
    
}

class ViewController: UIViewController {

    private var cancellable = Set<AnyCancellable>()
    
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.width - 10, height: self.view.frame.height)
        self.view.addSubview(tableView)
        self.tableView.register(TableCell.self, forCellReuseIdentifier: "Cell")
        setupTable()

        viewModel.movieObs.bindData { [weak self] _ in
          
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.getDataFromServer()
    }
    
    private func setupTable() {
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .red
    }
    
  /*  private func demo() {
        var a = 1, b = 1, c = 2
        lazy var abc: Int = {
            return a + b + c
        }()
        
        var bcd: Int = {
            
                return a + b + c
            
        }()
        
        var ddd: Int = 0 {
            didSet {
                didSetPropery = a + b + c
            }
        }
        
        var didSetPropery = 0
        print(abc)
        print(bcd)
        print(ddd = 4)
        c = 3
        print(abc)
        print(bcd)
        print(ddd =  6)
    }*/
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieObs.value?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableCell else {
            fatalError()
        }
        cell.movieTitle.text = viewModel.movieObs.value?[indexPath.row].original_title
        cell.detailLabel.text = viewModel.movieObs.value?[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        debugPrint(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

class TableCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "Cell")
    }
    
    override func layoutSubviews() {
        self.contentView.addSubview(bgView)
        self.bgView.addSubview(movieImage)
        self.bgView.addSubview(movieTitle)
        self.bgView.addSubview(detailLabel)
        self.bgView.frame =  CGRect(x: 10, y: 5, width: self.contentView.frame.width - 10, height: self.contentView.frame.height - 10)
        self.movieImage.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
        self.movieTitle.frame = CGRect(x: self.movieImage.frame.maxX + 20, y: 10, width: self.bgView.frame.width - 30, height: 30)
        self.detailLabel.frame = CGRect(x: self.movieImage.frame.maxX + 20, y: self.movieTitle.frame.maxY + 10, width: self.bgView.frame.width - 30, height: 30)
        self.movieImage.image = .add
        setupConstraint()
    }
    
    private func setupConstraint() {
        self.bgView.translatesAutoresizingMaskIntoConstraints = false
        self.movieImage.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            self.bgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20.0 ),
            self.bgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10.0),
            self.bgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20.0),
            self.bgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0),
            
            self.movieImage.leadingAnchor.constraint(equalTo: self.bgView.leadingAnchor, constant: 10.0 ),
            self.movieImage.topAnchor.constraint(equalTo: self.bgView.topAnchor, constant: 60.0),
            self.movieImage.heightAnchor.constraint(equalToConstant: 60),
            self.movieImage.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    var movieImage: UIImageView = {
        let image = UIImageView()
        return image
     }()
    
    var movieTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
}

