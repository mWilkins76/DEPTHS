package com.isartdigital.ruby.ui.popin;

	
/**
 * ...
 * @author Michael Wilkins
 */
class DailyReward extends SmartPopinRegister 
{
	
	/**
	 * instance unique de la classe DailyReward
	 */
	private static var instance: DailyReward;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DailyReward {
		if (instance == null) instance = new DailyReward();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}