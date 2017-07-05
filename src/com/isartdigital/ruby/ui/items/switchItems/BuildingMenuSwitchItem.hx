package com.isartdigital.ruby.ui.items.switchItems;

import com.isartdigital.ruby.game.GameManager;
import com.isartdigital.ruby.game.Spawner;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.ui.popin.building.BuildingMenu;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.popin.building.datas.BuildingMenuData;
import com.isartdigital.ruby.ui.popin.building.datas.BuildingMenuParams;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

/**
 * ...
 * @author Jordan Dachicourt
 */
class BuildingMenuSwitchItem extends SwitchGroupItem
{

	private static inline var NAME = "txt_Name";
	
	private static inline var ASSET_PREFIX:String = "BuildingMenu_spriteItemAsset_";
	
	private var isClicked = false;
	public var nameField:TextSprite;
	private var buildingSize:Point = new Point(3, 2);
	private var levelToBecomeEnable:Int;
	
	public function new(pID:String=null) 
	{
		interactive = true;
		super(pID);
		on(MouseEventType.MOUSE_UP, function() { isClicked = false; } );
		addStateSuffix = true;
	}
	

	public function setInfo(pParams:BuildingMenuParams) {
		nameField = cast(getChildByName(NAME), TextSprite);
		nameField.text = LocalizationByType.getInstance().translateFromType(pParams.name);
		assetName = pParams.name;
		name = assetName;
		prefix = ASSET_PREFIX;
		levelToBecomeEnable = GameManager.getInstance().godMode ? 0 : pParams.levelToBecomeEnable;
		
		Player.getInstance().level >= levelToBecomeEnable
		?	setNormal()
		:	setDisabled();
		setAsset();
		
	}
	

	private function getSpawner():Void {
		if (Spawner.getInstance().toSpawn != null && Spawner.getInstance().toSpawn.name == assetName) {	
				Spawner.getInstance().cancel();
		}
		else {
			Spawner.getInstance().setElementToSpawn(assetName);
		}
	}
	
	private function displayInfo():Void {
		BuildingMenu.getInstance().panel.setInfo(getDataAboutThisBuilding());
	}
	
	private function getDataAboutThisBuilding():Dynamic {
		return DataManager.getInstance().listBuildingTypes[name];
	}
	
	private function unDisplayInfo():Void {
		BuildingMenu.getInstance().panel.reset();
	}
	
	override function monClick():Void 
	{
		super.monClick();
	
		if(!isClicked && currentState != btnDisabled)
			getSpawner();
			
		isClicked = true;
	}
	
	override function onOver():Void 
	{
		super.onOver();
		displayInfo();
		setAsset();
	}
	
	override function onOut():Void 
	{
		super.onOut();
		unDisplayInfo();
		setAsset();
	}
}