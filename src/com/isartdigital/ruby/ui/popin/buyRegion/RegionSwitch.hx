package com.isartdigital.ruby.ui.popin.buyRegion;

import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author Michael Wilkins
 */
class RegionSwitch extends Item
{
	private var container:SmartComponent;
	public var text:TextSprite;
	private var popin:BuyRegion;
	
	private var counter:Int = 0;
	
	private var isDisplaying:Bool = false;
	
	public function new(pID:String=null) 
	{
		super(pID);
		container = cast(getChildByName("ConfirmationPose_clipPriceHCInfos"), SmartComponent);
		text = cast(container.getChildByName("txt_SCPrice"), TextSprite);
	}
	
	public function setText(pCost:Int):Void {
		
		text.text = Std.string(pCost);
	}
	
	public function setOwnPopin(pPopin:BuyRegion):Void {
	
		popin = pPopin;
	}
	
	override function monClick():Void 
	{
		super.monClick();
		isDisplaying ? hide() : display();
	}
	
	private function display():Void {
	
		isDisplaying = true;
		popin.displayConfirmButtons();
	}
	
	private function hide():Void {
	
		isDisplaying = false;
		counter = 0;
		popin.hideConfirmButtons();
	}
	
	public function count():Void {
	
		if (isDisplaying) {
			
			if (++counter >= 180) hide();
		}
		
		
	}
	
}