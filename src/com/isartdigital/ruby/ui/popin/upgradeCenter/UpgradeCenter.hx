package com.isartdigital.ruby.ui.popin.upgradeCenter;

import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienTrainingCenter;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.utils.ui.smart.SmartComponent;

	
/**
 * ...
 * @author Michael Wilkins / Guillaume Zegoudia
 */
class UpgradeCenter extends Menu 
{
	
	private var currentCenter:AlienTrainingCenter;
	
	private var container:SmartComponent;
	
	public var firstSlot:TankUpgrade;
	public var secondSlot:Dynamic;
	public var thirdSlot:Dynamic;
	
	public var array:Array<TankUpgrade> = [];
	
	/**
	 * instance unique de la classe UpgradeCenter
	 */
	private static var instance: UpgradeCenter;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): UpgradeCenter {
		if (instance == null) instance = new UpgradeCenter();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = true;
		
	}
	
	public function initializationCurrentBuildingTrainingCenter(pCenter:AlienTrainingCenter):Void
	{
		currentCenter = pCenter;
		
		container = cast(getChildByName("UpgradeCenter_clipXenoListUpgrading"), SmartComponent);
		firstSlot = cast(container.getChildByName("SlotUpgrade #1"), TankUpgrade);
		
		
		if (currentCenter.slot1Bought) getChildByName("btn_AddSlot #1").visible = false;
		else 
		{
			var lTankeur:SmartComponent = cast(getChildByName("UpgradeCenter_clipXenoListUpgrading"), SmartComponent);
			lTankeur.getChildByName("SlotUpgrade #1").visible = false;
		}
		if (currentCenter.slot2Bought) getChildByName("btn_AddSlot #2").visible = false;
		else 
		{
			var lTankeur:SmartComponent = cast(getChildByName("UpgradeCenter_clipXenoListUpgrading"), SmartComponent);
			lTankeur.getChildByName("SlotUpgrade #2").visible = false;
		}
	}
	
	public function setAlien():Void {
	
		firstSlot.setAlien(currentCenter.alien);
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}