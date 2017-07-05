package com.isartdigital.ruby.game.world;

import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.utils.game.BoxType;
import pixi.filters.color.ColorMatrixFilter;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class Background extends GameElement
{
	
	

	public function new(pAsset:String=null) 
	{
		super(pAsset);
		boxType = BoxType.SELF;
	}
	

}