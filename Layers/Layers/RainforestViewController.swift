//
//  ViewController.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

// TODO: Lay out top row according to top layout guide.
class RainforestViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    let flowLayout = collectionView?.collectionViewLayout as UICollectionViewFlowLayout
    flowLayout.estimatedItemSize = CGSize(width: 320.0, height: 600.0)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 32
  }
  
  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as RainforestInfoCardCell
    
    if indexPath.item == 0 {
      cell.descriptionTextView.text = "漊煻獌 誙賗跿 藡覶譒 妶岯 蒮 瀤瀪璷 桏毢涒 翐脬 褅, 鑆驈 岋巠帎 胾臷菨 螏螉褩 儇 磝磢磭 蒠蓔蜳 椻楒 斠, 筩 鞮鞢 撖撱暲 譖貚趪 襛襡襙 摲 虙蛃 腠腶舝 玝甿虮, 濍燂犝 珝砯砨 犿玒 褅, 廙彯 滈溔滆 咍垀坽 鄻鎟霣 嗂 嗂 曏樴橉 薽薸蟛 瞵瞷矰 踛輣, 橁橖澭 縢羱聬 奫嫮嫳 漀 憃撊 蜸 墐墆墏 梴棆棎 烍烚珜 鵛嚪 雗雘雝 悊惀桷 甀 裧頖, 踆跾踄 蹸蹪鏂 誙 硻禂 讔雥 烢烒珛 瓥籪艭 鈁陾靰 儇 韎 棎棦 雈靮傿 寱懤擨, 絒翗 腠 痑祣筇 礂簅縭 氉燡磼 獧瞝瞣 蜬蝁蜠 瓂癚 瞂"
      cell.featureImageView.image = UIImage(named: "a01")
      cell.backgroundImageView.image = UIImage(named: "a01").applyLightEffect()
      cell.titleLabel.text = "Harpy Eagle"
    } else if indexPath.item == 1 {
      cell.descriptionTextView.text = "漊煻獌 誙賗跿 藡覶譒 妶岯 蒮 瀤瀪璷 桏毢涒 翐脬 褅, 鑆驈 岋巠帎 胾臷菨 螏螉褩 儇 磝磢磭 蒠蓔蜳 椻楒 斠, 筩 鞮鞢 撖撱暲 譖貚趪 襛襡襙 摲 虙蛃 腠腶舝 玝甿虮, 濍燂犝 珝砯砨 犿玒 褅, 廙彯 滈溔滆 咍垀坽 鄻鎟霣 嗂 嗂 曏樴橉 薽薸蟛 瞵瞷矰 踛輣, 橁橖澭 縢羱聬 奫嫮嫳 漀 憃撊 蜸 墐墆墏 梴棆棎 烍烚珜 鵛嚪 雗雘雝 悊惀桷 甀 裧頖, 踆跾踄 蹸蹪鏂 誙 硻禂 讔雥 烢烒珛 瓥籪艭 鈁陾靰 儇 韎 棎棦 雈靮傿 寱懤擨, 絒翗 腠 痑祣筇 礂簅縭 氉燡磼 獧瞝瞣 蜬蝁蜠 瓂癚 瞂"
      cell.featureImageView.image = UIImage(named: "a02")
      cell.backgroundImageView.image = UIImage(named: "a02").applyLightEffect()
      cell.titleLabel.text = "Chameleon"
    } else if indexPath.item < 10 {
      cell.descriptionTextView.text = "漊煻獌 誙賗跿 藡覶譒 妶岯 蒮 瀤瀪璷 桏毢涒 翐脬 褅, 鑆驈 岋巠帎 胾臷菨 螏螉褩 儇 磝磢磭 蒠蓔蜳 椻楒 斠, 筩 鞮鞢 撖撱暲 譖貚趪 襛襡襙 摲 虙蛃 腠腶舝 玝甿虮, 濍燂犝 珝砯砨 犿玒 褅, 廙彯 滈溔滆 咍垀坽 鄻鎟霣 嗂 嗂 曏樴橉 薽薸蟛 瞵瞷矰 踛輣, 橁橖澭 縢羱聬 奫嫮嫳 漀 憃撊 蜸 墐墆墏 梴棆棎 烍烚珜 鵛嚪 雗雘雝 悊惀桷 甀 裧頖, 踆跾踄 蹸蹪鏂 誙 硻禂 讔雥 烢烒珛 瓥籪艭 鈁陾靰 儇 韎 棎棦 雈靮傿 寱懤擨, 絒翗 腠 痑祣筇 礂簅縭 氉燡磼 獧瞝瞣 蜬蝁蜠 瓂癚 瞂"
      cell.featureImageView.image = UIImage(named: "a0\(indexPath.item)")
      cell.backgroundImageView.image = UIImage(named: "a0\(indexPath.item)").applyLightEffect()
      cell.titleLabel.text = "Blue Morpho"
    } else {
      cell.descriptionTextView.text = "漊煻獌 誙賗跿 藡覶譒 妶岯 蒮 瀤瀪璷 桏毢涒 翐脬 褅, 鑆驈 岋巠帎 胾臷菨 螏螉褩 儇 磝磢磭 蒠蓔蜳 椻楒 斠, 筩 鞮鞢 撖撱暲 譖貚趪 襛襡襙 摲 虙蛃 腠腶舝 玝甿虮, 濍燂犝 珝砯砨 犿玒 褅, 廙彯 滈溔滆 咍垀坽 鄻鎟霣 嗂 嗂 曏樴橉 薽薸蟛 瞵瞷矰 踛輣, 橁橖澭 縢羱聬 奫嫮嫳 漀 憃撊 蜸 墐墆墏 梴棆棎 烍烚珜 鵛嚪 雗雘雝 悊惀桷 甀 裧頖, 踆跾踄 蹸蹪鏂 誙 硻禂 讔雥 烢烒珛 瓥籪艭 鈁陾靰 儇 韎 棎棦 雈靮傿 寱懤擨, 絒翗 腠 痑祣筇 礂簅縭 氉燡磼 獧瞝瞣 蜬蝁蜠 瓂癚 瞂"
      cell.featureImageView.image = UIImage(named: "a\(indexPath.item)")
      cell.backgroundImageView.image = UIImage(named: "a\(indexPath.item)").applyLightEffect()
      cell.titleLabel.text = "Chameleon"
    }
    
    cell.setNeedsLayout()
    return cell
  }
  
}

