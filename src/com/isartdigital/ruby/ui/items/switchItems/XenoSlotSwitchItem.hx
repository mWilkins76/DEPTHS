package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;

/**
 * ...
 * @author Jordan Dachicourt
 */
class XenoSlotSwitchItem extends SwitchGroupItem
{

	public var alien:AlienElement;
	static inline var PREFIX:String = "XenosThumbnail_";
	public function new(pID:String=null) 
	{
		super(pID);
	}
	
	override public function init() 
	{
		super.init();
		prefix = PREFIX;
	}
	override function monClick():Void 
	{
		super.monClick();
		placeXeno(CentreForage.getInstance().alienSelected);	
	}
	
	private function placeXeno(pAlien:AlienElement) {
		
		if (pAlien != alien)
		
			alien = pAlien;
			if (alien != null) {
			assetName = alien.name+"_Normal";
			CentreForage.getInstance().alienSelected = null;
			CentreForage.getInstance().checkIfMissionCanBeStarted();
		}
	}
	
	override public function setAsset() 
	{
		if (alien == null) return;
		trace("yolo");
		super.setAsset();
	}
	
	
}