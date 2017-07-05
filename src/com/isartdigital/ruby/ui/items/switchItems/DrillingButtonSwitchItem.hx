package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureScreen;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;
import com.isartdigital.ruby.ui.popin.contextual.BuildingContextualMenu;

/**
 * ...
 * @author Jordan Dachicourt
 */
class DrillingButtonSwitchItem extends SwitchItem
{

	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	
	override private function monClick():Void
	{
		//CentreForage.getInstance().startDrillingFeature();
	}
}