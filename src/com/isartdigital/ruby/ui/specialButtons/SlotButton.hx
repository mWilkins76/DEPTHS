package com.isartdigital.ruby.ui.specialButtons;

import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Michael Wilkins
 */
class SlotButton extends SmartButton
{

	public static var list:Array<SlotButton> = new Array<SlotButton>();
	public var alien:AlienElement;
	private var prefix:String;
	private var assetName:String;
	static inline var PREFIX:String = "XenosThumbnail_";
	
	public function new(pID:String=null) 
	{
		super(pID);
		list.push(this);
	}
	
	override function _click(pEvent:EventTarget = null):Void 
	{
		super._click(pEvent);
		placeXeno(CentreForage.getInstance().alienSelected);
	}
	
	public function invisibleGreySquare() {
		getChildByName("asset").visible = false;
	}
	private function placeXeno(pAlien:AlienElement) {
		
		
		if (pAlien != alien)
			for (slot in CentreForage.getInstance().xenoSlotList) {
			
				if (slot.alien == pAlien) slot.removeXeno(pAlien);
			}
			alien = pAlien;
			if (alien != null) {
			assetName = alien.name+"_Normal";
			prefix = PREFIX;
			setAsset();
			CentreForage.getInstance().alienSelected = null;
			CentreForage.getInstance().checkIfMissionCanBeStarted();
		}
	}
	
	public function removeXeno(pAlien:AlienElement):Void {
	
		trace("remove");
		alien = null;
	}
	
	public function setAsset() {
		if (prefix == null  || children == null) return;
		
		if(alien == null && getChildByName("mainAsset") != null)removeChild(getChildByName("mainAsset"));
		var lAsset:UISprite;
		var lSpawnAsset:UISprite;
		
		
		
	
		lSpawnAsset = cast(getChildByName("asset"), UISprite);
		lAsset = new UISprite(prefix + assetName);
		
		lAsset.name = "mainAsset";
		lAsset.position = lSpawnAsset.position.clone();
		
		if (getChildByName(lAsset.name) != null)
			removeChild(getChildByName(lAsset.name));
			
		addChild(lAsset);
		
		lSpawnAsset.visible = false;
	}
	override public function destroy():Void 
	{
		super.destroy();
		list.remove(this);
	}
}