package com.isartdigital.ruby.ui.items;

import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartComponent;

/**
 * ...
 * @author Jordan Dachicourt
 */
class Item extends SmartComponent
{

	public var isListening = false;
	
	public function new(pID:String=null) 
	{
		super(pID);
		init();
	}
	
	public function init() {
		
		onListen();
		
	}
	
	public function onListen():Void {
	
		if (!isListening) {
			interactive = true;
			on(MouseEventType.CLICK, monClick);
			on(MouseEventType.MOUSE_DOWN, onDown);
			on(MouseEventType.MOUSE_OVER, onOver);
			on(MouseEventType.MOUSE_OUT, onOut);
			
			isListening = true;
		}	
	}
	
	function monClick():Void {
		SoundManager.getSound("soundPlayerSwitchMode").play();
	}
	
	function onOver():Void {
	}
	
	function onOut():Void {
		
	}
	
	function onDown():Void {
		
	}
	
	public function onOff():Void {
		if (isListening) {
			interactive = false;
			off(MouseEventType.CLICK, monClick);
			off(TouchEventType.TOUCH_END, monClick);
		
			off(MouseEventType.MOUSE_OVER, onOver);
			off(MouseEventType.MOUSE_OUT, onOut);
			isListening = false;
		}
		
	}
	
	override public function destroy():Void 
	{
		onOff();
		super.destroy();
	}
	
}