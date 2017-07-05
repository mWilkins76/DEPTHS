package com.isartdigital.ruby.game.sprites;

import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;

/**
 * ...
 * @author Adrien Bourdon
 */
class FlumpStateGraphic extends StateGraphic
{

	public function new(pAsset:String=null) 
	{
		super();
		if (pAsset != null) assetName = pAsset;
		name = assetName;
	}
	
	override public function start():Void 
	{
		factory = new FlumpMovieAnimFactory();
		super.start();
		setState(DEFAULT_STATE);
		boxType = BoxType.SELF;
	}
	
}