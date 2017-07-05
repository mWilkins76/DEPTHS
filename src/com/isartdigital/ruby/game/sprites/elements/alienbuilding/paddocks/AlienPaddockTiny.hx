package com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks;

import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;

/**
 * ...
 * @author Michael Wilkins
 */
class AlienPaddockTiny extends AlienPaddock
{

	public function new(pAsset:String=null) 
	{
		localWidth = 1;
		localHeight = 1;
		description = "Placez-y jusqu'à 1 xenos produisant de l'or";
		super(pAsset);
		room = 1;
		sellingCost = 1000;
	}
	
}