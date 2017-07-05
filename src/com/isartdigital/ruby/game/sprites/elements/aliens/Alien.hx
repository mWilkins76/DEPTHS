package com.isartdigital.ruby.game.sprites.elements.aliens;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.pooling.PoolObject;

/**
 * ...
 * @author Adrien Bourdon
 */
class Alien extends PoolObject
{
	public static var alienList:Array<Alien> = new Array<Alien>();

	public static var alienElementList:Array<AlienElement> = new Array<AlienElement>();
	
	public var level(default, null):Int;
	public var mode(default, null):String;
	public var nomPropre(default, null):String;
	public var idBuilding(default, null):String;
	public var type:Dynamic;

	public function new(?pAsset:String)
	{
		super(pAsset);
	}
	

	public static function getAlienType(pType:String, pTypes:Array<Dynamic>):Dynamic
	{
		if (pTypes == null) return null;
		var data:Dynamic;
		for (alien in pTypes)
		{
			if (alien.name == pType)
			{
				data = alien;
				return data;
			}
		}
		return null;
	}

	
	public static function countAliensByName(pName:String):Int
	{
		var counter:Int = 0;
		for (alien in alienElementList) 
		{
			if (alien.name == pName) counter++;
		}
		return counter;
	}
}