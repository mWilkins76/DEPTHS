package com.isartdigital.ruby.ui.popin.shop;
import com.isartdigital.ruby.ui.popin.shop.datas.GainParams.Gain;
import com.isartdigital.ruby.ui.popin.shop.datas.ShopData;
import com.isartdigital.ruby.ui.popin.shop.datas.ShopItemParams;
import com.isartdigital.ruby.ui.items.switchItems.ShopSwitchTab;
import pixi.core.math.Point;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.ui.popin.Menu;

import com.isartdigital.ruby.ui.popin.shop.datas.ShopItemParams.Money;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
	class Shop extends Menu 
{
	
	private static inline var SHOP_TITLE:String = "txt_tabTitle";		
	
	/**
	 * instance unique de la classe Shop
	 */
	private static var instance: Shop;
	
	/**
	 * element de titre du wireframe
	 */
	private var title:TextSprite;
	/**
	 * tableau des titre correspondant à chaque onglet
	 */
	public var shopTitles:Array<String>;
	public var shopAssetTitles:Array<String>;
	private var itemPositions:Array<Point>;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Shop {
		if (instance == null) instance = new Shop();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = true;	
	}
	
		/**
	 * initialisation à l'ouverture de la popin
	 */
	override function init() 
	{
		super.init();
		shopTitles = ["Pack", "Pieces d'or", "Genes", "Pack Genes", "Cristaux"];
		shopAssetTitles = ["Pack", "SC", "Genes", "Pack Genes", "HC"];
		title = cast(getChildByName(SHOP_TITLE),TextSprite);
		
		initTab(ShopSwitchTab);
		initItems();
	}
	


	override private function initItems() {
		itemContainer = cast(getChildByName(ITEM_CONTAINER), SmartComponent);
		initPositionItem();
		updateItems();
	}
	

	
	private function initPositionItem() {
		itemPositions = new Array<Point>();
		
		for (i in 0 ... itemContainer.children.length) {
			itemPositions.push(itemContainer.getChildByName(ITEM+" #"+i).position.clone());
		}
		
	}
	
	public function updateItems() {
		title.text = shopTitles[currentIndex];
		destroyAllChildInContainer(itemContainer);
		var currentItem:ShopItem;
		for (i in 0 ...  itemPositions.length) {
			if(i>=ShopData.getInstance().datas[currentIndex].length)return;
			var currentItemInfo:ShopItemParams = ShopData.getInstance().datas[currentIndex][i];
		

			currentItem = new ShopItemMedium();
				
			itemContainer.addChild(currentItem);
			currentItem.position = itemPositions[i].clone();
			currentItem.setInfo(currentItemInfo);
		}
	}
	
	/**
	 * callBack appelé lors du click sur un onglet
	 * et initialise set propriété du popin en fonction
	 * @param	pTarget le bouton cliqué
	 */
	override function onTabSelected(pId:Int):Void {
		super.onTabSelected(pId);
		updateItems();
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}