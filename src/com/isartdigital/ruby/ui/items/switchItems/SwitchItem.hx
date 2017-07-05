package com.isartdigital.ruby.ui.items.switchItems;

import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.Button;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Lib;

/**
 * C
 * @author Jordan Dachicourt
 */
class SwitchItem extends Item
{
	public static var list:Array<SwitchItem> = new Array<SwitchItem>();
	public var NORMAL(default, never):String = "Normal";
	public var DISABLED(default, never):String = "Disabled";
	
	private var listStates:Array<SmartComponent>;
	private var btnNormal:SmartButton;
	private var btnDisabled:SmartComponent;
	private var currentState:SmartComponent;
	public var id:Int;
	private var prefix:String;
	private var assetName:String;
	private var addStateSuffix:Bool = false;
	
	public function new(pID:String=null) 
	{
		super(pID);
		
		list.push(this);
	
	}
	
	override public function init() {
		super.init();
		listStates = new Array<SmartComponent>();
		btnNormal = cast(getChildByName(NORMAL), SmartButton);
		btnDisabled = cast(getChildByName(DISABLED), SmartComponent);
		
		/*btnNormal.on(MouseEventType.MOUSE_OVER, onOver);
		btnDisabled.on(MouseEventType.MOUSE_OVER, onOver);
		
		btnNormal.on(MouseEventType.CLICK, monClick);
		btnDisabled.on(MouseEventType.CLICK, monClick);*/
		listStates.push(btnNormal);
		listStates.push(btnDisabled);
		setAsset();
		setNormal();
	}
	
	public function setAsset() {
		if (prefix == null || currentState == null || assetName == null || currentState.children == null) return;
		var lAsset:UISprite;
		var lSpawnAsset:UISprite;
		
		
		
	
		lSpawnAsset = cast(currentState.getChildByName("asset"), UISprite);
		lAsset = new UISprite(prefix + assetName + (addStateSuffix?("_" + currentState.name):""));
		
		lAsset.name = "mainAsset";
		lAsset.position = lSpawnAsset.position.clone();
		
		if (currentState.getChildByName(lAsset.name) != null)
			currentState.removeChild(currentState.getChildByName(lAsset.name));
			
		currentState.addChild(lAsset);
		
		invisibleAsset();
	}
	
	
	private function reset() {
		for (state in listStates) {
			state.visible = false;
		}
	}
	
	private function invisibleAsset() {
		for (state in listStates) {
			if(state.getChildByName("asset") != null)
				state.getChildByName("asset").visible = false;
		}
	}
	
	public function setNormal() {
		reset();
		currentState = btnNormal;
		currentState.visible = true;
	}
	
	public function setDisabled() {
		reset();
		currentState = btnDisabled;
		currentState.visible = true;
	}
	
	public static function destroyAll() {
		for (elem in list)
			elem.destroy();
		
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		list.remove(this);
	}
}