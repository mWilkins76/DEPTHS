package com.isartdigital.ruby.game.specialFeature.aliens;

import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;

/**
 * ...
 * @author Julien Fournier
 */
class AlienType extends SpecialFeatureAliens
{


	public function new(?pAsset:String) 
	{
		super(pAsset);
		state = "1_Normal";
	}
	
}