package com.isartdigital.ruby.game.specialFeature.managers;
import com.isartdigital.ruby.game.specialFeature.tiles.classes.AlienSpawn;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.utils.game.pooling.PoolManager;
import pixi.core.math.Point;

/**
 * ...
 * @author Julien Fournier
 */
class SFAliensManager
{

	
	public var inactiveAlienList:Array<SpecialFeatureAliens> = new Array<SpecialFeatureAliens>();
	public var activatedAlienList:Array<SpecialFeatureAliens> = new Array<SpecialFeatureAliens>();
	
	public var selectedAlien:SpecialFeatureAliens;
	
	public static inline var TANK_CLASSNAME:String = ElementType.ALIEN_TANK;
	public static inline var BOMBER_CLASSNAME:String = ElementType.ALIEN_BOMBER;
	public static inline var HEALER_CLASSNAME:String = ElementType.ALIEN_HEALER;
	public static inline var DRILLER_CLASSNAME:String = ElementType.ALIEN_DRILLER;
	
	
	private static var instance: SFAliensManager;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SFAliensManager {
		if (instance == null) instance = new SFAliensManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * fonction d'initialisation des aliens
	 * @param	pList liste d'alienElement
	 */
	public function initAliensList(pList:Array<AlienElement>):Void
	{

		var lAlien:SpecialFeatureAliens = null;
		var lAlienNameLength:Int;
		var lAlienId:Int;
		for (alien in pList)
		{
			if (alien != null)
			{
				lAlienNameLength = alien.name.length;	
				lAlienId = Std.parseInt(alien.name.substring(lAlienNameLength - 1));
				lAlien = cast(PoolManager.getFromPool(alien.carac.power+lAlienId), SpecialFeatureAliens);
				//lAlien.powerRange = alien.carac.range;
				lAlien.alienID = lAlienId;
				lAlien.alienType = alien.carac.power;
				lAlien.alienName = alien.carac.name;
				lAlien.stamina = alien.carac.stamina;
				lAlien.maxStamina = lAlien.stamina;
				inactiveAlienList.push(lAlien);
			}
		}
	}
	

	/**
	 * Initilaisation de l'alien
	 * @param	pX
	 * @param	pY
	 */
	public function instanciateAlien():Void
	{
		if (inactiveAlienList.length == 0) return;
		
		var lAlien:SpecialFeatureAliens=null;
		for (tile in SFTilesManager.getInstance().tileList)
		{
			if (Std.is(tile, AlienSpawn) && inactiveAlienList.length > 0)
			{
				lAlien = inactiveAlienList.shift();
				lAlien.x = tile.x;
				lAlien.y = tile.y;
				lAlien.positionInGrid = tile.positionInGrid;	
				
				activatedAlienList.push(lAlien);

				SFGameManager.getInstance().alienContainer.addChild(lAlien);
				lAlien.start();
			}
		}
	}
	
	/**
	 * Renvoie un string avec le Type d'alien
	 * @param	pIndex
	 * @return
	 */
	public function getAlienType(pIndex:Int):String
	{
		if (pIndex > activatedAlienList.length - 1)
		{
			return "NO TYPE";
		}
		return activatedAlienList[pIndex].alienType;
	}
	
	/**
	 * Renvoie un string avec le Nom d'un alien
	 * @param	pIndex
	 * @return
	 */
	public function getAlienName(pIndex:Int):String
	{
		if (pIndex > activatedAlienList.length - 1)
		{
			return "NO NAME";
		}
		return activatedAlienList[pIndex].nomPropre;
	}
	
	/**
	 * Renvoie la current stamina d'un alien
	 * @param	pIndex
	 * @return
	 */
	public function getStamina(pIndex:Int):Int
	{
		
		return activatedAlienList[pIndex].stamina;
	}

	public function getMaxStamina(pIndex:Int):Int
	{
		return activatedAlienList[pIndex].maxStamina;
	}

	
	/**
	 * Vérifie si l'alien se trouve sur une case à côté de la case qu'il veut creuser
	 * @param	pMousePos
	 * @return
	 */
	public function isAlienNextToTile(pMousePos:Point):Bool
	{
		var lAlienPos:Point = SFGridManager.getInstance().getGridCoords(selectedAlien.position);
		
		if (Math.abs(lAlienPos.x - pMousePos.x) + Math.abs(lAlienPos.y - pMousePos.y) == 1) return true;
		return false;
	}
	

	/**
	 * vérifie que l'alien dispose d'assez de stamina
	 * @return
	 */
	public function hasEnoughStamina():Bool
	{
		if (selectedAlien.stamina <= 0)
		{
			return false;
		}
		return true;
	}
	
	/**
	 * enlève un point de stamina pour l'alien en paramètre
	 * @param	pAlien
	 */
	public function decreaseStamina(pAlien:SpecialFeatureAliens):Void
	{
		pAlien.stamina--;
		SpecialFeatureScreen.getInstance().updateRessourceHud();

		if(!SFGameManager.getInstance().checkIfAliensStillHasStamina())
		{
			//SpecialFeatureScreen.getInstance().closeFlag = true;
			SFGameManager.getInstance().openEndMissionPoppin();
			SpecialFeatureScreen.getInstance().onClose();
			
		}
		
	}	
	
	/**
	 * ajoute pAmount de stamina 
	 * @param	pAmount
	 * @param	pAlien
	 */
	public function increaseStamina(pAmount:Int, pAlien:SpecialFeatureAliens):Void
	{
		pAlien.stamina += pAmount;
		pAlien.stamina = Math.floor(Math.min(pAlien.stamina, pAlien.maxStamina));
		SpecialFeatureScreen.getInstance().updateRessourceHud();
	}	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
		
		//suppression de l'écouteur de clic
	}
}