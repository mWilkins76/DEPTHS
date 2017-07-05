package com.isartdigital.ruby.ui.ftue;

import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;

/**
 * ...
 * @author Adrien Bourdon
 */
class BouleHighlight extends FlumpStateGraphic
{

	public function new(pAsset:String=null) 
	{
		super("Boule_Highlight");
		
	}
	override public function start():Void 
	{
		super.start();
		setState(DEFAULT_STATE,true);
	}
	
}