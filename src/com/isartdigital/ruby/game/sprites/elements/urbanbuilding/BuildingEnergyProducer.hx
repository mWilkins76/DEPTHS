package com.isartdigital.ruby.game.sprites.elements.urbanbuilding;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.Building;

/**
 * ...
 * @author qPk
 */
class BuildingEnergyProducer extends Building
{
	private var energyProduced:Int;
	
	public function new(pAsset:String=null) 
	{
		super(pAsset);
		
	}
	
	public function increasePlayerMaxEnergy(?pEnergy:Int):Void
	{
		var lEnergy:Int = pEnergy == null? energyProduced: pEnergy;
		Player.getInstance().increaseMaxEnergy(lEnergy);
	}
	
	public function Buff(pCoef:Float, ?isAdded:Bool = true):Void
	{
		var lEnergy:Int = Math.round(energyProduced * pCoef - energyProduced);
		var lSign:Int = isAdded? 1: -1;
		increasePlayerMaxEnergy(lEnergy * lSign);
	}
	
	override public function setModeDestroy():Void 
	{
		super.setModeDestroy();
		increasePlayerMaxEnergy(-energyProduced);
	}
}