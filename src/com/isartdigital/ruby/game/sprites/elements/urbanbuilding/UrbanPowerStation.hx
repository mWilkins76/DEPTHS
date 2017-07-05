package com.isartdigital.ruby.game.sprites.elements.urbanbuilding;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.sounds.SoundManager;

/**
 * ...
 * @author Julien Fournier
 */
class UrbanPowerStation extends BuildingEnergyProducer
{
	private static inline var ENERGY_PROD:Int = 50;
	public function new(pAsset:String=null) 
	{
		super(pAsset);
		buildingName = "Power Station";
		description = "Augmente beaucoup l'énergie et permet de poser des antennes.";
		localWidth = 4;
		localHeight = 2;
		energyProduced = ENERGY_PROD;
		maxLevel = 2;
		sellingCost = 2500;
		
		//setTimeToBuild : secondes/minutes/heures/jours
		//setTimeToBuild(5, 0, 0, 0);
	}
	
	override public function init(?pElem:Element=null):Void 
	{
		super.init(pElem);
		
		
	}	
	
	override function setModeNormal():Void 
	{
		
		super.setModeNormal();
		checkRegion();
		
		
	}
	
	override function setModeValidationConstruct():Void 
	{
		super.setModeValidationConstruct();
		SoundManager.getSound("soundPlayerHaveEnergy").play();
	}
	
	public function checkRegion():Void {
	
		if (World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.length == 0) {
		
			World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.push(this);
			Building.HQinstance.turnOn();
			return;
		}
		for (station in World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion) {
		
			if (station.elem.instanceID == elem.instanceID) return;
			
		}
		World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.push(this);
	}
	
	
	override public function saveNewPosition(pX:Int, pY:Int, ?pRegionX:Int = null, ?pRegionY:Int = null):Void 
	{
		World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.splice(World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.indexOf(this),1);
		super.saveNewPosition(pX, pY, pRegionX, pRegionY);
		checkRegion();
	}
	
	
	
	override function changeBehaviorLevel2():Void 
	{
		if (level <= maxLevel) {
			for (antenna in World.getInstance().getRegion(elem.regionX, elem.regionY).antennasInRegion) 
				antenna.upgrade();
		}
	}
	
	override public function setModeDestroy():Void 
	{
		super.setModeDestroy();
		World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.splice(World.getInstance().getRegion(elem.regionX, elem.regionY).powerStationsInRegion.indexOf(this),1);
	}
}