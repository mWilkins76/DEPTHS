package com.isartdigital.ruby.game.specialFeature.aliens;

import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;

/**
 * ...
 * @author Julien Fournier
 */
class Driller extends SpecialFeatureAliens
{


	public function new(?pAsset:String) 
	{
		super(pAsset);
		maxStamina = 10;
		stamina = maxStamina;
	}
	
}