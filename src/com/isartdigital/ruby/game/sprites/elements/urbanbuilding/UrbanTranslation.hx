package com.isartdigital.ruby.game.sprites.elements.urbanbuilding;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author Julien Fournier
 */
class UrbanTranslation extends Building
{

	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Translation Center";
		description = "Permet de traduire les anciens textes xenos.";
		localWidth = 2;
		localHeight = 2;
		sellingCost = 4875;
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(1, 0, 0, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);
	}
}