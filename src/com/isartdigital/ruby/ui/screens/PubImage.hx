package com.isartdigital.ruby.ui.screens;

	
/**
 * ...
 * @author Michael Wilkins
 */
class PubImage extends SmartScreenRegister 
{
	
	/**
	 * instance unique de la classe PubImage
	 */
	private static var instance: PubImage;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): PubImage {
		if (instance == null) instance = new PubImage();
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