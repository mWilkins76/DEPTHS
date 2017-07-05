package com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks;

import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import pixi.core.math.Point;

/**
 * ...
 * @author Michael Wilkins
 */
class AlienPaddockBig extends AlienPaddock
{

	public function new(pAsset:String=null) 
	{
		localWidth = 3;
		localHeight = 2;
		super(pAsset);
		room = 6;
		sellingCost = 3750;
		description = "Placez-y jusqu'à 6 xenos produisant de l'or";
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
			case 3:
				return new Point(elem.globalX-100, elem.globalY+50);
			case 4:
				return new Point(elem.globalX, elem.globalY+100);
			case 5:
				return new Point(elem.globalX+100, elem.globalY+150);
		}
		
		return new Point(0, 0);
	}
}