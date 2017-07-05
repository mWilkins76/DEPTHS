package com.isartdigital.ruby.ui.popin;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartPopin;

	
/**
 * ...
 * @author Julien Fournier
 */
class TutoSpecialFeature extends MenuClosable 
{
	
	/**
	 * instance unique de la classe TutoSpecialFeature
	 */
	private static var instance: TutoSpecialFeature;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TutoSpecialFeature {
		if (instance == null) instance = new TutoSpecialFeature();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		init();
		width += 650;
		height += 500;
		
	}
	
	override function onClose():Void 
	{
		super.onClose();

	}
	

	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}