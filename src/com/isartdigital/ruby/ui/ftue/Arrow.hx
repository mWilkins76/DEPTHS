package com.isartdigital.ruby.ui.ftue;

import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;

/**
 * ...
 * @author Mathieu Anthoine
 */
class Arrow extends FlumpStateGraphic
{

	public function new(pAsset:String=null) 
	{
		super("FTUE_arrow");
		
	}
	
	override public function start():Void 
	{
		super.start();
		setState(DEFAULT_STATE,true);
	}
	
}