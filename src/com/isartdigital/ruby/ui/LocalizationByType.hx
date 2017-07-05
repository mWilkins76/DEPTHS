package com.isartdigital.ruby.ui;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.utils.system.Localization;

/**
 * ...
 * @author Julien Fournier
 */
class LocalizationByType
{

	/**
	 * instance unique de la classe LocalizationByType
	 */
	private static var instance: LocalizationByType;

	public static var ANTENNA:String = 						"LABEL_BUILDING_ANTENNA";
	public static var COMMUNICATION:String = 				"LABEL_BUILDING_COMMUNICATION";
	public static var HQ:String = 							"LABEL_BUILDING_HQ";
	public static var POWERSTATION:String = 				"LABEL_BUILDING_POWERSTATION";
	public static var TRANSLATION:String = 					"LABEL_BUILDING_TRANSLATIONCENTER";
	public static var DRILLING_AUTO_OUTPOST:String = 		"LABEL_BUILDING_DRILLINGAUTO";
	public static var DRILLING_CENTER:String = 				"LABEL_BUILDING_DRILLINGCENTER";
	public static var DRILLING_OUTPOST:String = 			"LABEL_BUILDING_DRILLINGOUTPOST";
	public static var COSMETIC_CAPSULE1:String = 			"LABEL_BUILDING_CAPSULE1";
	public static var COSMETIC_CAPSULE2:String = 			"LABEL_BUILDING_CAPSULE2";
	public static var COSMETIC_CAPSULE3:String = 			"LABEL_BUILDING_CAPSULE3";
	public static var COSMETIC_PLANT1:String = 				"LABEL_BUILDING_PLANT1";
	public static var COSMETIC_PLANT2:String = 				"LABEL_BUILDING_PLANT2";
	public static var COSMETIC_PLANT3:String = 				"LABEL_BUILDING_PLANT3";
	public static var INCUBATOR:String = 					"LABEL_BUILDING_INCUBATOR";
	public static var PADDOCK_TINY:String = 				"LABEL_BUILDING_PADDOCKTINY";
	public static var PADDOCK_SMALL:String = 				"LABEL_BUILDING_PADDOCKSMALL";
	public static var PADDOCK_MEDIUM:String = 				"LABEL_BUILDING_PADDOCKMEDIUM";
	public static var PADDOCK_BIG:String = 					"LABEL_BUILDING_PADDOCKBIG";
	public static var RESEARCH_CENTER:String = 				"LABEL_BUILDING_RESEARCH";
	public static var TRAINING_CENTER:String = 				"LABEL_BUILDING_TRAININGCENTER";
	public static var CRYO_CENTER:String = 					"LABEL_BUILDING_CRYOCENTER";

	public static var DESC_ANTENNA:String = 				"LABEL_DESC_ANTENNA";
	public static var DESC_COMMUNICATION:String = 			"LABEL_DESC_COMMUNICATION";
	public static var DESC_HQ:String = 						"LABEL_DESC_HQ";
	public static var DESC_POWERSTATION:String = 			"LABEL_DESC_POWERSTATION";
	public static var DESC_TRANSLATION:String = 			"LABEL_DESC_TRANSLATIONCENTER";
	public static var DESC_DRILLING_AUTO_OUTPOST:String = 	"LABEL_DESC_DRILLINGAUTO";
	public static var DESC_DRILLING_CENTER:String = 		"LABEL_DESC_DRILLINGCENTER";
	public static var DESC_DRILLING_OUTPOST:String = 		"LABEL_DESC_DRILLINGOUTPOST";
	public static var DESC_COSMETIC_FLUOALGA:String = 		"LABEL_DESC_COSMETIC";
	public static var DESC_COSMETIC_FLUOALGA2:String = 		"LABEL_DESC_COSMETIC";
	public static var DESC_INCUBATOR:String = 				"LABEL_DESC_INCUBATOR";
	public static var DESC_PADDOCK_TINY:String = 			"LABEL_DESC_PADDOCKTINY";
	public static var DESC_PADDOCK_SMALL:String = 			"LABEL_DESC_PADDOCKSMALL";
	public static var DESC_PADDOCK_MEDIUM:String = 			"LABEL_DESC_PADDOCKMEDIUM";
	public static var DESC_PADDOCK_BIG:String = 			"LABEL_DESC_PADDOCKBIG";
	public static var DESC_RESEARCH_CENTER:String = 		"LABEL_DESC_RESEARCH";
	public static var DESC_TRAINING_CENTER:String = 		"LABEL_DESC_TRAININGCENTER";
	public static var DESC_CRYO_CENTER:String = 			"LABEL_DESC_CRYOCENTER";


	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LocalizationByType
	{
		if (instance == null) instance = new LocalizationByType();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new()
	{

	}

	public function translateFromType(pType:String):String
	{
		var lType:String = getLabelFromType(pType);
		return Localization.getLabel(lType);
	}

	private function getLabelFromType(pType:String):String
	{
		if (pType == ElementType.ANTENNA) return ANTENNA;
		else if (pType == ElementType.COMMUNICATION) return COMMUNICATION;
		else if (pType == ElementType.HQ) return HQ;
		else if (pType == ElementType.POWERSTATION) return POWERSTATION;
		else if (pType == ElementType.TRANSLATION) return TRANSLATION;
		else if (pType == ElementType.DRILLING_AUTO_OUTPOST) return DRILLING_AUTO_OUTPOST;
		else if (pType == ElementType.DRILLING_CENTER) return DRILLING_CENTER;
		else if (pType == ElementType.DRILLING_OUTPOST) return DRILLING_OUTPOST;
		else if (pType == ElementType.COSMETIC_CASPULE1) return COSMETIC_CAPSULE1;
		else if (pType == ElementType.COSMETIC_CASPULE2) return COSMETIC_CAPSULE2;
		else if (pType == ElementType.COSMETIC_CASPULE3) return COSMETIC_CAPSULE3;
		else if (pType == ElementType.COSMETIC_PLANT1) return COSMETIC_PLANT1;
		else if (pType == ElementType.COSMETIC_PLANT2) return COSMETIC_PLANT2;
		else if (pType == ElementType.COSMETIC_PLANT3) return COSMETIC_PLANT3;
		else if (pType == ElementType.INCUBATOR) return INCUBATOR;
		else if (pType == ElementType.PADDOCK_TINY) return PADDOCK_TINY;
		else if (pType == ElementType.PADDOCK_SMALL) return PADDOCK_SMALL;
		else if (pType == ElementType.PADDOCK_MEDIUM) return PADDOCK_MEDIUM;
		else if (pType == ElementType.PADDOCK_BIG) return PADDOCK_BIG;
		else if (pType == ElementType.RESEARCH_CENTER) return RESEARCH_CENTER;
		else if (pType == ElementType.TRAINING_CENTER) return TRAINING_CENTER;
		else if (pType == ElementType.CRYO_CENTER) return CRYO_CENTER;
		else return pType;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

}