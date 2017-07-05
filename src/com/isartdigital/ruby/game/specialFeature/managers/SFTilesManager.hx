package com.isartdigital.ruby.game.specialFeature.managers;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.specialFeature.tiles.Tile;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.DataBaseAction.TempoBuildingInfo;
import pixi.core.math.Point;

	
/**
 * ...
 * @author Julien Fournier
 */
class SFTilesManager 
{
	public var tileList:Array<Tile> = new Array<Tile>();  
	public var skillTilesList:Array<Tile> = new Array<Tile>();  
	
	private static inline var CLUE_CLASSNAME:String = ElementType.CLUE;
	public static inline var LAVA_CLASSNAME:String = ElementType.LAVA;
	public static inline var HARDBRICK_CLASSNAME:String = ElementType.HARDBRICK;
	public static inline var ITEM_CLASSNAME:String = ElementType.ITEM;
	
	/**
	 * instance unique de la classe TilesManager
	 */
	private static var instance: SFTilesManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SFTilesManager {
		if (instance == null) instance = new SFTilesManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * Enlève une Tile (graphiquement) de l'écran
	 * @param	pType
	 */
	public function removeInTileList(pJsonObject:Dynamic):Void
	{
		var gridMousePos:Point = SFGridManager.getInstance().gridMousePos;
		for (i in 0...tileList.length) 
		{
			
			if (tileList[i].positionInGrid.x == gridMousePos.x &&
			tileList[i].positionInGrid.y == gridMousePos.y && 
			tileList[i].type == pJsonObject.type)
			{
				if (pJsonObject.type.substring(0, 4) == ElementType.ITEM )
				{
					SFGameManager.getInstance().ressourcesContainer.removeChild(tileList[i]);
				}
				if (pJsonObject.type.substring(0, 4) == CLUE_CLASSNAME ||  pJsonObject.type.substring(0, 9) == ElementType.HARDBRICK)
				{
					SFGameManager.getInstance().blocsContainer.removeChild(tileList[i]);
				}
				if (pJsonObject.type.substring(0, 4) != "Wall")
				{
					pJsonObject.type = "destroyed";
				}
				return;
			}	
		}
	}	
	
	
	public function addSpecialTile(pTileType:String, pTarget:Point):Void
	{
		var lTile:Tile = null;
		if (pTileType == "dig")
		{
			lTile = cast(PoolManager.getFromPool(ElementType.CLUE_EMPTY_GREEN),Tile);
		}
		else if (pTileType == "move")
		{
			lTile = cast(PoolManager.getFromPool(ElementType.CLUE_EMPTY_BLUE),Tile);
		}
		else if (pTileType == "skill")
		{
			lTile = cast(PoolManager.getFromPool(ElementType.CLUE_EMPTY_ORANGE),Tile);
		}
		else return;
		SFGameManager.getInstance().skillContainer.addChild(lTile);
		lTile.position = pTarget;
		lTile.start();
	}
	
	public function removeSpecialTile():Void
	{
		var length:Int = SFGameManager.getInstance().skillContainer.children.length;
		var child:PoolObject;
		for (i in 0...length) 
		{
			child = cast(SFGameManager.getInstance().skillContainer.children[length-1-i],PoolObject);
			child.dispose();
		}
	}

	/**
	 * Vérifie si la Tile pTarget est dans la range d'action de l'alien sélectionné
	 * @param	pTarget
	 * @return
	 */
	public function isTileInRange(pTarget:Point):Bool
	{
		var lAlien:SpecialFeatureAliens = SFAliensManager.getInstance().selectedAlien;
		var lAlienPos:Point = SFGridManager.getInstance().getGridCoords(lAlien.position);
		var distance:Int;

		distance =Math.floor(Math.abs(lAlienPos.x - pTarget.x) + Math.abs(lAlienPos.y - pTarget.y));
		return distance <= lAlien.powerRange;
		
	}


	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}