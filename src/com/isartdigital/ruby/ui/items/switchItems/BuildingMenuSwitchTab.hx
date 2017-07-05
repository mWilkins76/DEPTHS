package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.ui.popin.building.BuildingMenu;

/**
 * ...
 * @author Jordan Dachicourt
 */
class BuildingMenuSwitchTab extends SwitchGroupItem
{
	static inline var PREFIX:String = "BuildingMenu_TabAsset_";

	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	override public function init() 
	{
		super.init();
		prefix = PREFIX;
		switch(id) {
			case 0:
				assetName = "Urbain";
			case 1:
				assetName = "Buffeur";
			case 2:
				assetName = "Forage";
			case 3:
				assetName = "Esthetique";
			default:
				assetName = "Urbain";
		}
	}
	
	override function monClick() 
	{
		super.monClick();
		BuildingMenu.getInstance().currentIndex = id;
		BuildingMenu.getInstance().updateItems();
	}
	
	
}