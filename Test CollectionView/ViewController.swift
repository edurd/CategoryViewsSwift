//
//  ViewController.swift
//  Test CollectionView
//
//  Created by Eduardo Hoyos on 6/7/17.
//  Copyright © 2017 Jcodee SAC. All rights reserved.
//
//
//  CombosViewController.swift
//  Mediterraneo
//
//  Created by Eduardo Hoyos on 4/20/17.
//  Copyright © 2017 Retail Android. All rights reserved.
//

import UIKit
import Kingfisher
import ENMBadgedBarButtonItem

class CombosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var latMenu: UIBarButtonItem!
    
    private let cellId = "cellId"
    private let menuId = "menuId"
    
    
    var listMenu : [FoodCategory]?
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.red
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func viewDidLoad() {
        self.collectionView?.allowsSelection = true
        self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.backgroundView = imageView
        
        super.viewDidLoad()
        
        self.collectionView?.isUserInteractionEnabled = true
        
        navigationItem.title = "Test"
        
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        listMenu = FoodCategory.sampleAppCategories()

        collectionView?.contentMode = .scaleAspectFill
        
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(MenuCell.self, forCellWithReuseIdentifier: menuId)
        
        //creating badge
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "basket"), for: .normal)
        button.addTarget(self, action: #selector(CombosViewController.basketBarButtonItem), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: "0")
        newBarButton.badgeValue = "3"
        self.navigationItem.rightBarButtonItem = newBarButton
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = listMenu?.count {
            return count
        }
        return 0
    }
    func basketBarButtonItem() {
        let layout = UICollectionViewFlowLayout()
        let controller = UICollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! CategoryCell
            cell.combosList = listMenu?[indexPath.item]
            cell.foodCategoryController = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.menuId, for: indexPath) as! MenuCell
            cell.menuList = listMenu?[indexPath.item]
            cell.foodCategoryController = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width, height: 200)
        }
        return CGSize(width: view.frame.width, height: 250)
        
    }
    
    func showAppDetail(menu : Menu) {
        let layout = UICollectionViewFlowLayout()
        let controller = UICollectionViewController(collectionViewLayout: layout)
        //controller.menu = menu
        navigationController?.pushViewController(controller, animated: true)
    }
}

class CategoryCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var foodCategoryController : CombosViewController?
    
    private let comboId = "comboId"
    
    var combosList : FoodCategory? {
        didSet{
            if let name = combosList?.name {
                nameLabel.text = name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Combos"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let combosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    func setUpViews() {
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        
        addSubview(combosCollectionView)
        addSubview(nameLabel)
        
        combosCollectionView.dataSource = self
        combosCollectionView.delegate = self
        
        combosCollectionView.register(ComboCell.self, forCellWithReuseIdentifier: comboId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": combosCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(35)][v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": combosCollectionView, "nameLabel": nameLabel]))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.comboId, for: indexPath) as! ComboCell
        cell.menu = combosList?.menus?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = combosList?.menus?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: frame.height - 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let menu = combosList?.menus?[indexPath.item] {
            foodCategoryController?.showAppDetail(menu: menu)
        }
    }
}

class ComboCell : UICollectionViewCell {
    
    var menu : Menu? {
        didSet {
            nameLabel.text = menu?.name
            comboDescriptionLabel.text = menu?.dishDescription
            if let price = menu?.price {
                priceLabel.text = "S/\(price)"
            }
            if let id = menu?.id {
                let url = "URL_DE_LA_IMAGEN"
                backgroundImage.kf.setImage(with: URL(string: url))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImage : UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named:"papas_fritas")
        iv.backgroundColor = UIColor.cyan
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Mediterraneo 1"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = UIColor.darkGray
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "S/ 40.00"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = UIColor.darkGray
        return label
    }()
    
    let comboDescriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "La mejor combinación a disfrutar con unas papas riquis"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = UIColor.darkGray
        return label
    }()
    
    func setUpViews(){
        layer.cornerRadius = 5
        backgroundColor = UIColor.clear
        
        addSubview(backgroundImage)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(comboDescriptionLabel)
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        nameLabel.frame = CGRect(x: 10, y: 100, width: frame.width - 100, height: 30)
        priceLabel.frame = CGRect(x: 160, y: 100, width: 80, height: 30)
        comboDescriptionLabel.frame = CGRect(x: 10, y: 130, width: frame.width - 20, height: 30)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": priceLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v2]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": comboDescriptionLabel]))
    }
}

class MenuCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var foodCategoryController : CombosViewController?
    
    private let menuId = "menuId"
    
    var count : Int?
    var menuList : FoodCategory? {
        didSet {
            if let name = menuList?.name {
                nameLabel.text = name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Cartas"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setUpViews() {
        backgroundColor = UIColor.clear
        
        addSubview(menuCollectionView)
        addSubview(nameLabel)
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        
        
        menuCollectionView.register(CartaCell.self, forCellWithReuseIdentifier: menuId)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": menuCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(35)][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["nameLabel": nameLabel, "v1":menuCollectionView]))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.menuId, for: indexPath) as! CartaCell
        cell.menu = self.menuList?.menus?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = menuList?.menus?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 215, height: frame.height - 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let menu = menuList?.menus?[indexPath.item]{
            foodCategoryController?.showAppDetail(menu: menu)
        }
        
    }
}

class CartaCell : UICollectionViewCell {
    
    var menu : Menu? {
        didSet {
            nameLabel.text = menu?.name
            if let price = menu?.price {
                priceLabel.text = "S/\(price)"
            }
            if let id = menu?.id {
                let url = "URL_DE_LA_IMAGEN"
                
                backgroundImage.kf.setImage(with: URL(string: url))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundImage : UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named:"pollo_brasa")
        iv.backgroundColor = UIColor.brown
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Pollo a la brasa"
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "S/ 40.00"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = UIColor.darkGray
        return label
    }()
    
    func setUpViews(){
        isUserInteractionEnabled = true
        layer.cornerRadius = 5
        backgroundColor = UIColor.clear
        
        addSubview(backgroundImage)
        addSubview(nameLabel)
        addSubview(priceLabel)
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        nameLabel.frame = CGRect(x: 10, y: 150, width: 100, height: 60)
        priceLabel.frame = CGRect(x: 130, y: 150, width: 80, height: 40)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": priceLabel]))
    }
}

class Menu : NSObject {
    var id : String?
    var name : String?
    var dishDescription : String?
    var price : String?
    var quantity : String?
    var category : String?
    var status : String?
    var image : UIImage?
}

class FoodCategory : NSObject {
    var name : String?
    var menus : [Menu]?
    
    static func sampleAppCategories() -> [FoodCategory] {
        let menuList = FoodCategory()
        menuList.name = "Combos"
        
        var menu = [Menu]()
        
        let singleMenu = Menu()
        singleMenu.id = "1"
        singleMenu.name = "Ceviche"
        singleMenu.dishDescription = "Mezcla de pescado con limón"
        singleMenu.category = "Pollo"
        singleMenu.price = "100.00"
        singleMenu.quantity = "1"
        singleMenu.status = "1"
        
        menu.append(singleMenu)

        let s = Menu()
        s.id = "2"
        s.name = "Arroz con pollo"
        s.dishDescription = "Pollito con arroz verde"
        s.category = "Pollo"
        s.price = "19.00"
        s.quantity = "1"
        s.status = "1"
        
        menu.append(s)
        
        menuList.menus = menu
        
        let comboList = FoodCategory()
        comboList.name = "Cartas"
        var carta = [Menu]()
        
        let singleCarta = Menu()
        singleCarta.id = "1"
        singleCarta.name = "Pollo a la brasa"
        singleCarta.dishDescription = "pollito con papas"
        singleCarta.category = "Pollo"
        singleCarta.price = "10.00"
        singleCarta.quantity = "1"
        singleCarta.status = "1"
        
        carta.append(singleCarta)
        
        let v = Menu()
        v.id = "2"
        v.name = "Aji de gallina"
        v.dishDescription = "El plato mas rico del mundo"
        v.category = "Pollo"
        v.price = "30.00"
        v.quantity = "1"
        v.status = "1"
        
        carta.append(v)
        
        comboList.menus = carta
        
        return [menuList, comboList]
    }
}

