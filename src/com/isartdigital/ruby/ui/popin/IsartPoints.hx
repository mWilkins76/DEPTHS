package com.isartdigital.ruby.ui.popin;

	
/**
 * ...
 * @author Adrien Bourdon
 */
class IsartPoints extends MenuClosable 
{
	
	/**
	 * instance unique de la classe IsartPoints
	 */
	private static var instance: IsartPoints;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): IsartPoints {
		if (instance == null) instance = new IsartPoints();
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
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}