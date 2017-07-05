package com.isartdigital.ruby.game.sprites.elements.drillingbuilding;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author Julien Fournier
 */
class DrillingOutPost extends DrillingBuilding
{

	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Drill Outpost";
		description = "Découvre de nouvelles missions de forage.";
		localWidth = 4;
		localHeight = 2;
		maxLevel = 2;
		sellingCost = 1375;
		
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(0, 0, 1, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);
		

	}
	
}