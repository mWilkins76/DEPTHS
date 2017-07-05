package com.isartdigital.utils.game.pooling;
import com.isartdigital.ruby.game.specialFeature.aliens.Bomber;
import com.isartdigital.ruby.game.specialFeature.aliens.Driller;
import com.isartdigital.ruby.game.specialFeature.aliens.Healer;
import com.isartdigital.ruby.game.specialFeature.aliens.Tank;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.AlienSpawn;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Clue;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.HardBrick;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Lava;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.SpecialFeatureItem;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.Walls;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienCryoCenter;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienIncubator;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienResearchCenter;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienTrainingCenter;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks.AlienPaddockBig;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks.AlienPaddockMedium;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks.AlienPaddockSmall;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.paddocks.AlienPaddockTiny;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.CosmeticBuilding;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticCapsule1;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticCapsule2;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticCapsule3;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticPlant1;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticPlant2;
import com.isartdigital.ruby.game.sprites.elements.cosmeticbuilding.cosmetictype.BuildingCosmeticPlant3;
import com.isartdigital.ruby.game.sprites.elements.destructible.Destructible;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingAutoOutPost;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingCenter;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingOutPost;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanAntenna;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanCommunication;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanHeadQuarter;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanPowerStation;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanTranslation;
import com.isartdigital.ruby.game.sprites.ressources.Bubble;
import com.isartdigital.ruby.game.sprites.ressources.RessourceHardCurrency;
import com.isartdigital.ruby.game.sprites.ressources.RessourceSoftCurrency;
import com.isartdigital.utils.game.pooling.PoolObject;
import haxe.Json;




/**
 * Gere le pooling, l'ajout et la sortie du pool et son initialisation
 * @author dachicourt jordan
 */
class PoolManager
{
	public static var pool: Map<String, Array<PoolObject>> = new Map<String, Array<PoolObject>>();

	private function new()
	{

	}

	/**
	 * Initialise le pooling en fonction du fichier json en parametre
	 * @param	pPool json contenant les pool de depart
	 */
	static public function init(pPool:Json)
	{

		for (lClassName in Reflect.fields(pPool))
		{
			pool.set(lClassName, new Array<PoolObject>());

			var numberOfInstance:Int = Reflect.field(pPool, lClassName);

			for (i in 0 ... numberOfInstance)
			{
				addToPool(lClassName, getInstance(lClassName));
			}

		}
	}

	/**
	 * Ajoute une instance dansle pool
	 * @param	pType asset du l'objet
	 * @param	pInstance instance de l'objet
	 */
	public static function addToPool(pType:String, pInstance:PoolObject):Void
	{
		if (pType == null || pInstance == null)
			return null;

		if (!pool.exists(pType))
			pool.set(pType,  new Array<PoolObject>());

		pool.get(pType).push(pInstance);
	}

	/**
	 * Prend une instance dans la piscine
	 * @param	pType asset voulu
	 * @return instance correspondant à l'asset
	 */
	public static function getFromPool(pType:String):PoolObject
	{
		if (pType == null) return null;
		if (!pool.exists(pType) ||  pool.get(pType).length == 0)
			addToPool(pType, getInstance(pType));

		return pool.get(pType).pop();
	}

	/**
	 * Retourne l'instance correspondant au type
	 * @param	pType asset voulu
	 * @return l'instance voulu
	 */
	private static function getInstance(pType:String):PoolObject
	{

		if (pType == ElementType.POWERSTATION) return new UrbanPowerStation();
		else if (pType == ElementType.ANTENNA) return new UrbanAntenna();
		else if (pType == ElementType.HQ) return new UrbanHeadQuarter();
		else if (pType == ElementType.COMMUNICATION) return new UrbanCommunication();
		else if (pType == ElementType.TRANSLATION) return new UrbanTranslation();

		else if (pType == ElementType.DRILLING_CENTER) return new DrillingCenter();
		else if (pType == ElementType.DRILLING_AUTO_OUTPOST) return new DrillingAutoOutPost();
		else if (pType == ElementType.DRILLING_OUTPOST) return new DrillingOutPost();

		else if (pType == ElementType.INCUBATOR) return new AlienIncubator();
		else if (pType == ElementType.PADDOCK_TINY) return new AlienPaddockTiny();
		else if (pType == ElementType.PADDOCK_SMALL) return new AlienPaddockSmall();
		else if (pType == ElementType.PADDOCK_MEDIUM) return new AlienPaddockMedium();
		else if (pType == ElementType.PADDOCK_BIG) return new AlienPaddockBig();
		else if (pType == ElementType.RESEARCH_CENTER) return new AlienResearchCenter();
		else if (pType == ElementType.TRAINING_CENTER) return new AlienTrainingCenter();
		else if (pType == ElementType.CRYO_CENTER) return new AlienCryoCenter();
		else if (pType == ElementType.COSMETIC) return new CosmeticBuilding();

		else if (pType == ElementType.COSMETIC_CASPULE1) return new BuildingCosmeticCapsule1();
		else if (pType == ElementType.COSMETIC_CASPULE2) return new BuildingCosmeticCapsule2();
		else if (pType == ElementType.COSMETIC_CASPULE3) return new BuildingCosmeticCapsule3();

		else if (pType == ElementType.COSMETIC_PLANT1) return new BuildingCosmeticPlant1();
		else if (pType == ElementType.COSMETIC_PLANT2) return new BuildingCosmeticPlant2();
		else if (pType == ElementType.COSMETIC_PLANT3) return new BuildingCosmeticPlant3();

		else if (pType == ElementType.DESTRUCTIBLE) return new Destructible();

		else if (pType == ElementType.RESSOURCE_BUBBLE) return new Bubble();
		else if (pType == ElementType.RESSOURCE_SC) return new RessourceSoftCurrency();
		else if (pType == ElementType.RESSOURCE_HC) return new RessourceHardCurrency();

		else if (pType == ElementType.ALIEN_1) return new AlienSpawn(ElementType.ALIEN_1);
		else if (pType == ElementType.ALIEN_2) return new AlienSpawn(ElementType.ALIEN_2);
		else if (pType == ElementType.ALIEN_3) return new AlienSpawn(ElementType.ALIEN_3);

		else if (pType == ElementType.WALL_TOP) return new Walls(ElementType.WALL_TOP);
		else if (pType == ElementType.WALL_BOT) return new Walls(ElementType.WALL_BOT);
		else if (pType == ElementType.WALL_LEFT) return new Walls(ElementType.WALL_LEFT);
		else if (pType == ElementType.WALL_RIGHT) return new Walls(ElementType.WALL_RIGHT);

		else if (pType == ElementType.CLUE_RESSOURCE) return new Clue(ElementType.CLUE_RESSOURCE);
		else if (pType == ElementType.CLUE_BLUEPRINT) return new Clue(ElementType.CLUE_BLUEPRINT);
		else if (pType == ElementType.CLUE_EMPTY) return new Clue(ElementType.CLUE_EMPTY);

		else if (pType == ElementType.CLUE_EMPTY_ORANGE) return new Clue(ElementType.CLUE_EMPTY_ORANGE);
		else if (pType == ElementType.CLUE_EMPTY_BLUE) return new Clue(ElementType.CLUE_EMPTY_BLUE);
		else if (pType == ElementType.CLUE_EMPTY_GREEN) return new Clue(ElementType.CLUE_EMPTY_GREEN);

		else if (pType == ElementType.HARDBRICK) return new HardBrick(ElementType.HARDBRICK);

		else if (pType == ElementType.LAVA) return new Lava(ElementType.LAVA);

		else if (pType == ElementType.ITEM_GENEFIVE) return new SpecialFeatureItem(ElementType.ITEM_GENEFIVE);
		else if (pType == ElementType.ITEM_GENEFOUR) return new SpecialFeatureItem(ElementType.ITEM_GENEFOUR);
		else if (pType == ElementType.ITEM_GENETHREE) return new SpecialFeatureItem(ElementType.ITEM_GENETHREE);
		else if (pType == ElementType.ITEM_GENETWO) return new SpecialFeatureItem(ElementType.ITEM_GENETWO);
		else if (pType == ElementType.ITEM_GENEONE) return new SpecialFeatureItem(ElementType.ITEM_GENEONE);

		else if (pType == ElementType.ITEM_DARKMATTER) return new SpecialFeatureItem(ElementType.ITEM_DARKMATTER);
		//else if (pType == ElementType.ITEM_BLUEPRINT_PART_0) return new Item(ElementType.ITEM_BLUEPRINT_PART_0);
		else if (pType == ElementType.ITEM_BLUEPRINT) return new SpecialFeatureItem(ElementType.ITEM_BLUEPRINT);

		else if (pType == ElementType.ITEM_HC) return new SpecialFeatureItem(ElementType.ITEM_HC);
		else if (pType == ElementType.ITEM_SC) return new SpecialFeatureItem(ElementType.ITEM_SC);

		else if (pType == ElementType.ALIEN_DRILLER1) return new Driller(ElementType.ALIEN_DRILLER1);
		else if (pType == ElementType.ALIEN_DRILLER2) return new Driller(ElementType.ALIEN_DRILLER2);
		else if (pType == ElementType.ALIEN_DRILLER3) return new Driller(ElementType.ALIEN_DRILLER3);

		else if (pType == ElementType.ALIEN_BOMBER1) return new Bomber(ElementType.ALIEN_BOMBER1);
		else if (pType == ElementType.ALIEN_BOMBER2) return new Bomber(ElementType.ALIEN_BOMBER2);
		else if (pType == ElementType.ALIEN_BOMBER3) return new Bomber(ElementType.ALIEN_BOMBER3);

		else if (pType == ElementType.ALIEN_HEALER1) return new Healer(ElementType.ALIEN_HEALER1);
		else if (pType == ElementType.ALIEN_HEALER2) return new Healer(ElementType.ALIEN_HEALER2);
		else if (pType == ElementType.ALIEN_HEALER3) return new Healer(ElementType.ALIEN_HEALER3);

		else if (pType == ElementType.ALIEN_TANK1) return new Tank(ElementType.ALIEN_TANK1);
		else if (pType == ElementType.ALIEN_TANK2) return new Tank(ElementType.ALIEN_TANK2);
		else if (pType == ElementType.ALIEN_TANK3) return new Tank(ElementType.ALIEN_TANK3);

		else return null;
	}

	/**
	 * efface ce qu'il y a dans le tableau de pool, si un type est passé en parametre il efface seulement les instance correspondante.
	 * @param	pType
	 */
	public static function clear(?pType:String = null):Void
	{

		/*si le type est defini on ne supprime qu'un type du pool*/
		if (pType != null)
		{
			pool.remove(pType);
			return;
		}

		/*supression du tableau de tout le tableau de pool*/
		var it : Iterator<String> = pool.keys();
		while (it.hasNext()) pool.remove(it.next());
	}

}