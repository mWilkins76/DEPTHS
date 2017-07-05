package com.isartdigital.ruby.game.specialFeature.tiles;

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
class Tile extends PoolObject
{
	public var positionInGrid:Point;
	public var type:String;
	public var index:Int;
	
		
	
	public function new(?pAsset:String) 
	{
		super(pAsset);
		
	}
	
	public function getRandomNumber(pMaxValue:Int):Int
	{
		return Math.floor(Math.random() * pMaxValue);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
	}
	

	
	
	
	

}