package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;

/**
 * ...
 * @author Jordan Dachicourt
 */
class XenoSocialSwitchItem extends SwitchItem
{

	public function new(pID:String=null) 
	{
		super(pID);
		interactive = true;
	}
	
	override function monClick():Void 
	{
		super.monClick();
		CentreForage.getInstance().switchXenosSocial();
	}
	
}