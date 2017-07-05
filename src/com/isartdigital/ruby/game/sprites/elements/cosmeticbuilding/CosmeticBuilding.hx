package com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.utils.game.clipping.IClippable.Element;

/**
 * ...
 * @author qPk
 */
class CosmeticBuilding extends Building
{

	public function new(pAsset:String=null) 
	{
		//pAsset= "CosmeticFluoAlga";
		super(pAsset);
		buildingName = "Decorative";
		//setTimeToBuild(1, 0, 0, 0);
		margin = 0;
		localWidth = 1;
		localHeight = 1;
		
	}
	
	override public function init(?pElem:Element=null) 
	{
		super.init(pElem);
		
		
		colMin = pElem.x;
		rowMin = pElem.y;
		elem.mode = WAITING_STATE;
		sellingCost = Std.int(elem.softCurrency / 4);
	}
	
	override public function start():Void 
	{
		super.start();
	}
	override public function changeAsset(pState:String, ?pAutoPlay:Bool = true):Void 
	{
		//super.changeAsset(pState, pAutoPlay);
		setState("", true, pAutoPlay);
	}
	
	/*override public function start():Void 
	{
		super.start();
		//setModeNormal();
	}*/
	
}