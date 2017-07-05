package com.isartdigital.ruby.game.specialFeature.aliens;

import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;

/**
 * ...
 * @author Julien Fournier
 */
class Bomber extends SpecialFeatureAliens
{


	public function new(?pAsset:String) 
	{
		super(pAsset);
		maxStamina = 4;
		bombNumber = 4;
		stamina = maxStamina;
	}
	
}