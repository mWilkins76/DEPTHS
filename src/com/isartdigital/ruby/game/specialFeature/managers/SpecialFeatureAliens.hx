package com.isartdigital.ruby.game.specialFeature.managers;

import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.ui.popin.Confirm;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.AlienTypes.AlienForeurTypes;
import pixi.core.math.Point;

/**
 * ...
 * @author Julien Fournier
 */
class SpecialFeatureAliens extends Alien
{
	public var SELECTED_STATE(default, never):String = "Selected";
	public var NORMAL_STATE(default, never):String = "";
	
	public var positionInGrid:Point = new Point(0, 0);
	public var alienID:Int;
	public var alienName:String;
	public var alienType:String;
	public var stamina:Int;
	public var maxStamina:Int;
	public var bombNumber:Int = 0;
	public var powerRange:Int = 2;
	
	public static var speFeatTypes:Array<AlienForeurTypes> = new Array<AlienForeurTypes>();
	
	public function new(?pAsset:String) 
	{
		super(pAsset);	
	}
	
	public function getAssetName():String{
		return assetName;
	}
	
	public function changeAssetName(pName:String):Void
	{
		assetName = pName;
	}
	
	public function changeAsset(pState:String, ?pAutoPlay:Bool = true):Void 
	{	
		if (pState != SELECTED_STATE) pState = NORMAL_STATE;
		else pState == SELECTED_STATE;
		setState(pState, true, pAutoPlay);
	}
	
	public static function loadTypes(pTypes:Dynamic):Void 
	{
		speFeatTypes = pTypes;
	}

	
	override public function destroy():Void 
	{
		super.destroy();
		
	}
	
}