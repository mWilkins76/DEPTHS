package com.isartdigital.ruby.ui.items.switchItems;

import com.isartdigital.ruby.ui.popin.shop.Shop;
import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Jordan Dachicourt
 */
class ShopSwitchTab extends SwitchGroupItem
{
	
	private static inline var ASSET_TAB_PREFIX:String = "Shop_TabAsset_";

	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	override public function init() {
		super.init();
		if (id == null) id = 0;
		prefix = ASSET_TAB_PREFIX;
		
		assetName =  StringTools.replace(Shop.getInstance().shopAssetTitles[id], " ", "_");
		setAsset();
	}
	
	override function monClick() {
		super.monClick();
		Shop.getInstance().currentIndex = id;
		Shop.getInstance().updateItems();
	}
	
	override public function setNormal() {
		super.setNormal();
		setAsset();
	}
	
	override function onOver():Void {
		super.onOver();
		setAsset();
	}
	
	override function onOut():Void {
		super.onOut();
		setAsset();
	}
}