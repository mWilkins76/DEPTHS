package com.isartdigital.ruby.game.sprites.elements.drillingbuilding;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author Julien Fournier
 */
class DrillingCenter extends DrillingBuilding
{

	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Drilling Center";
		description = "Permet de lancer des missions de forage dans la région.";
		localWidth = 6;
		localHeight = 4;
		maxLevel = 4;
		sellingCost = 3750;
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(0, 0, 1, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);
		FTUEManager.register(this);
		on(MouseEventType.CLICK, onClickFtue);
		on(TouchEventType.TAP, onClickFtue);
	}
	
	
	private function onClickFtue():Void
	{
		off(MouseEventType.CLICK, onClickFtue);
		off(TouchEventType.TAP, onClickFtue);		
	}
	
}