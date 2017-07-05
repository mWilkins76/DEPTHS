package com.isartdigital.ruby.game.specialFeature.tiles.classes;
import com.isartdigital.ruby.game.specialFeature.tiles.Tile;



/**
 * ...
 * @author Julien Fournier
 */
class Lava extends Tile
{

	public function new(?pAsset:String) 
	{
		super(pAsset);
		assetName = pAsset + getRandomNumber(3);

	}
	
}