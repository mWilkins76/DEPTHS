package com.isartdigital.ruby.game.sprites.elements.urbanbuilding;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.LocalizationByType;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.system.Localization;

/**
 * ...
 * @author Julien Fournier
 */
class UrbanAntenna extends BuildingEnergyProducer
{
	private static inline var ENERGY_PROD:Int = 5;
	
	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Antenna";
		description = Localization.getLabel(LocalizationByType.DESC_ANTENNA);
		localWidth = 1;
		localHeight = 1;
		maxLevel = 2;
		
		sellingCost = 875;
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(1, 0, 0, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);
		World.getInstance().getRegion(elem.regionX, elem.regionY).antennasInRegion.push(this);
		energyProduced = level == 1 ? ENERGY_PROD : ENERGY_PROD*2;

	}
	
	override function changeBehaviorLevel2():Void 
	{
		Player.getInstance().increaseMaxEnergy(5);
	}
	
	override public function setModeDestroy():Void 
	{
		super.setModeDestroy();
		World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.splice(World.getInstance().getRegion(elem.regionX, elem.regionY).antennasInRegion.indexOf(this),1);
	}
	
}