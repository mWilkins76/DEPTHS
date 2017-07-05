package com.isartdigital.ruby.game.sprites.elements.aliens;
import com.isartdigital.utils.save.AlienTypes.AlienEsthetiqueTypes;

/**
 * ...
 * @author Adrien Bourdon
 */
class AlienEsthetique extends Alien
{

	public static var esthetiqueTypes:Array<AlienEsthetiqueTypes> = new Array<AlienEsthetiqueTypes>();
	
	public function new(?pAsset:String) 
	{
		super(pAsset);
		
	}
	
    public static function loadTypes(pTypes:Dynamic):Void 
	{
		esthetiqueTypes = pTypes;
	}
	
}