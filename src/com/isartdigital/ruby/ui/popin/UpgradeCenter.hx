package com.isartdigital.ruby.ui.popin;

import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;

	
/**
 * ...
 * @author Michael Wilkins
 */
class UpgradeCenter extends SmartPopinRegister 
{
	
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
		
	}
	
	override public function close():Void 
	{
		super.close();
		
		MapInteractor.getInstance().modalPopinOpened = false;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}