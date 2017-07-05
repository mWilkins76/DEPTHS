package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;

/**
 * ...
 * @author Jordan Dachicourt
 */
class SpecialFeatureSwitchSkill extends SwitchGroupItem
{

	public var alien:SpecialFeatureAliens;
	
	public function new(pID:String=null) 
	{
		super(pID);
		inAGroup = false;
	}
	
	
	public function initAlien(pAlien:SpecialFeatureAliens) {
		/*prefix = "XenosThumbnail_";
		alien = pAlien;
		assetName = alien.alienName;
		addStateSuffix = true;*/
	}
	
	override public function setAsset() 
	{
		if (alien == null) return;
			super.setAsset();
	}
	
	override function monClick():Void 
	{
		super.monClick();
		setSelected();
	}
	
}