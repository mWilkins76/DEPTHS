package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.ruby.ui.popin.XenosPanel;

/**
 * ...
 * @author Jordan Dachicourt
 */
class XenosPanelSwitchItem extends SwitchGroupItem
{

	private var alien:AlienElement;
	
	public function new(pID:String=null) 
	{
		super(pID);
		init();
		
	}
	
	
	override public function init() 
	{
		super.init();
		addStateSuffix = true;
	}
	public function setInfo(pAlienElem:AlienElement) 
	{
		alien = pAlienElem;
		interactive = true;
		prefix = "XenosThumbnail_";
		assetName = alien.name;
		setAsset();
		name = assetName;
		FTUEManager.register(this);
		//image
		//setNormal();
		
	}
	
	override function monClick():Void 
	{
		super.monClick();
		//XenosPanel.getInstance().alienSelected = alien;
		//MapInteractor.getInstance().alienSelected = alien;
		//XenosPanel.getInstance().appearContextualMenuItemAt(x  - width);	
		
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
	
	override public function setSelected() 
	{
		super.setSelected();
		setAsset();
		//XenosPanel.getInstance().appearContextualMenuItemAt(position.x);
		XenosPanel.getInstance().alienSelected = alien;
		XenosPanel.getInstance().onMove();
	}
	
	override public function setNormal() 
	{
		super.setNormal();
		setAsset();
	}
}