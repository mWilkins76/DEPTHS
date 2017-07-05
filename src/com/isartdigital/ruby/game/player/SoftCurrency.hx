package com.isartdigital.ruby.game.player;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class SoftCurrency extends Currency 
{
	
	/**
	 * instance unique de la classe SoftCurrency
	 */
	private static var instance: SoftCurrency;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SoftCurrency {
		if (instance == null) instance = new SoftCurrency();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}