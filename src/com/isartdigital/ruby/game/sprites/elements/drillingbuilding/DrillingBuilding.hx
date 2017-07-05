package com.isartdigital.ruby.game.sprites.elements.drillingbuilding;

import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author Adrien Bourdon
 */
class DrillingBuilding extends Building
{

	//nombre de drillingBuilding
	public static var drillingBuildingCount(default, null):Int;
	public static var drillingBuildingList(default, null):Array<Element> = new Array<Element>();
	
	public function new(pAsset:String=null) 
	{
		super(pAsset);		
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);	
		if (drillingBuildingList.indexOf(this.elem) == -1) drillingBuildingList.push(this.elem);
		drillingBuildingCount = drillingBuildingList.length;
	}
	
}