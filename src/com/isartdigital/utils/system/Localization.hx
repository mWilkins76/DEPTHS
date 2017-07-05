package com.isartdigital.utils.system;
import haxe.Json;

	
/**
 * ...
 * @author Adrien Bourdon
 */
class Localization 
{
	
	/**
	 * instance unique de la classe Localization
	 */
	private static var instance: Localization;
	
	private static var labels:Dynamic;
	private static var langue:String;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Localization {
		if (instance == null) instance = new Localization();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	public static function init(pLabel:Dynamic, pLanguage:String):Void
	{
		labels = pLabel;
		langue = pLanguage;
	}
	
	public static function setLangue(pLangue:String):Void
	{
		langue = pLangue;
	}
	
	/**
	 * recupère le texte correspondant au label en fonction de la langue
	 * @param	pText
	 * @return texte traduit
	 */
	public static function getLabel(pText:String):String 
	{
		var lLabel:Dynamic = Reflect.field(labels, pText);
		return Std.string(Reflect.field(lLabel, langue));
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}