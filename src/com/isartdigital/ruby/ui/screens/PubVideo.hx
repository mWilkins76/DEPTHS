package com.isartdigital.ruby.ui.screens;

	
/**
 * ...
 * @author Michael Wilkins
 */
class PubVideo extends SmartScreenRegister 
{
	
	/**
	 * instance unique de la classe PubVideo
	 */
	private static var instance: PubVideo;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): PubVideo {
		if (instance == null) instance = new PubVideo();
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