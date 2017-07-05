package com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks;

import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.utils.game.iso.IsoManager;
import pixi.core.math.Point;

/**
 * ...
 * @author Michael Wilkins
 */
class AlienPaddockSmall extends AlienPaddock
{

	public function new(pAsset:String=null) 
	{
		localWidth = 3;
		localHeight = 1;
		super(pAsset);
		description = "Placez-y jusqu'à 3 xenos produisant de l'or";
		room = 3;
		sellingCost = 2000;
	}
	
	
	override function setPosition(pIndex:Int):Point 
	{
		var lPos:Point;
		
		switch(pIndex) {
		
			case 0:
				return new Point(elem.globalX, elem.globalY);
			case 1:
				return new Point(elem.globalX+100, elem.globalY+50);
			case 2:
				return new Point(elem.globalX+200, elem.globalY+100);
		}
		
		return new Point(0, 0);
	}
	
}