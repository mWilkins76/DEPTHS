package com.isartdigital.ruby.game.sprites.elements.drillingbuilding;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;

/**
 * ...
 * @author Julien Fournier
 */
class DrillingAutoOutPost extends DrillingBuilding
{

	private static inline var MN_PROD:Int = 25; 
	public function new(pAsset:String=null) 
	{
		
		super(pAsset);
		
		buildingName = "AutoDrill Outpost";
		description = "Lance les missions de forage automatiques : elle produisent de la MATIÈRE NOIRE en petite quantité.";
		localWidth = 2;
		localHeight = 2;
		sellingCost = 1875;
		
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(0, 0, 1, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);

	}
	
	public function production():Void
	{
		
		
	}
	
}