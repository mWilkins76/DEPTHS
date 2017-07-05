package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author Jordan Dachicourt
 */
class SwitchGroupItem extends SwitchItem
{

	
	public var SELECTED(default, never):String = "Selected";
	
	private var btnSelected:SmartButton;
	public var focusInFTUE = false;
	private var inAGroup = true;
	
	public function new(pID:String=null) 
	{
		super(pID);
	}
	
	override public function init() 
	{
		
		super.init();
		onListen();
		btnSelected = cast(getChildByName(SELECTED), SmartButton);
		listStates.push(btnSelected);
	}
	
	public function setActive() {
		if (!focusInFTUE) {
			for (brother in parent.children) {
				if (brother != this)		
					cast(brother, SwitchItem).setNormal();
			}
		}	
		setSelected();
	}
	
	public function setSelected() {
		reset();
		currentState = btnSelected;
		currentState.visible = true;
	}
	
	override function monClick():Void 
	{
		super.monClick();
		if (currentState == btnNormal && inAGroup)
			setActive();
	}
	
}