package com.isartdigital.ruby.game.sprites.elements.urbanbuilding.translationClass;

import com.isartdigital.ruby.ui.popin.Destruction;

	
/**
 * ...
 * @author Julien Fournier
 */
class SkipPoppin extends Destruction 
{
	
	/**
	 * instance unique de la classe SkipPoppin
	 */
	private static var instance: SkipPoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SkipPoppin {
		if (instance == null) instance = new SkipPoppin();
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
	public function destroy (): Void {
		instance = null;
	}

}