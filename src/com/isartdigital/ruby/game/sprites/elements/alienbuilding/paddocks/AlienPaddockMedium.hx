package com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks;

import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import pixi.core.math.Point;

/**
 * ...
 * @author Michael Wilkins
 */
class AlienPaddockMedium extends AlienPaddock
{

	public function new(pAsset:String=null) 
	{
		
		localWidth = 2;
		localHeight = 2;
		super(pAsset);
		room = 4;
		description = "Placez-y jusqu'à 4 xenos produisant de l'or";
		sellingCost = 2500;
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
				return new Point(elem.globalX-100, elem.globalY+50);
			case 3:
				return new Point(elem.globalX, elem.globalY+100);
		}
		
		return new Point(0, 0);
	}
	
	
}