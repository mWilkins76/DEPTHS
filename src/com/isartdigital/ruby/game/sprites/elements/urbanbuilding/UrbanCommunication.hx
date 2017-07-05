package com.isartdigital.ruby.game.sprites.elements.urbanbuilding;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author Julien Fournier
 */
class UrbanCommunication extends Building
{

	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Communication";
		description = "Permet de contacter vos amis, d'aller visiter leur planète ou d'échanger avec eux.";
		localWidth = 3;
		localHeight = 1;
		sellingCost = 4000;
		
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(1, 0, 0, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);

	}
	
}