package com.isartdigital.ruby.game.specialFeature.tiles.classes;

import com.isartdigital.ruby.game.specialFeature.tiles.Tile;
import com.isartdigital.ruby.game.sprites.elements.ElementType;

/**
 * ...
 * @author Julien Fournier
 */
class Clue extends Tile
{
	public function new(?pAsset:String) 
	{
		if (pAsset != ElementType.CLUE_EMPTY_ORANGE && pAsset != ElementType.CLUE_EMPTY_GREEN && pAsset != ElementType.CLUE_EMPTY_BLUE)
		{
			pAsset = pAsset + getRandomNumber(3);
		}
		
		
		super(pAsset);
		
	}
	
}