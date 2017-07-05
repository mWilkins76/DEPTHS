package com.isartdigital.ruby.game.specialFeature;

import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import pixi.core.math.Point;

/**
 * ...
 * @author Julien Fournier
 */
class Cell extends PoolObject
{
	public var positionInGrid:Point;
	public var type:String;
	
		
	
	public function new(?pAsset:String) 
	{
		super(pAsset);
		
	}
	
	override public function dispose():Void 
	{
		super.dispose();
	}
	

	
	
	
	

}