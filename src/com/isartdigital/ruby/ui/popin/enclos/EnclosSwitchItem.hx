package com.isartdigital.ruby.ui.popin.enclos;

import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Michael Wilkins
 */
class EnclosSwitchItem extends SwitchGroupItem
{
	public var alien: AlienElement;
	private var asset:UISprite;

	public function new(pID:String=null) 
	{
		super(pID);
	}
	
	override public function init() 
	{
		super.init();
		onOff();
		prefix = "XenosThumbnail_";
		asset = cast(currentState.getChildByName("asset"), UISprite);
		asset.visible = false;
		btnNormal.interactive = false;
		addStateSuffix = true;
	}
	
	override public function setSelected() 
	{
		
		
		super.setSelected();
		Enclos.getInstance().alienSelected = alien;
		Enclos.getInstance().positionContextualMenu(position);
	}
	
	override function onOver():Void 
	{
		super.onOver();
		setAsset();
	}
	
	override function onOut():Void 
	{
		super.onOut();
		setAsset();
	}
	
	override function onDown():Void 
	{
		super.onDown();
		setAsset();
	}
	
	
	
	public function setAlien(pAlienElem):Void {
	
		alien = pAlienElem;
		assetName = alien.name;
		setAsset();
		//asset.visible = true;
		btnNormal.interactive = true;
		onListen();
	}
}