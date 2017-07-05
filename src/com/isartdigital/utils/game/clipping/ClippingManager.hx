package com.isartdigital.utils.game.clipping;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.ElementSave;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;

	
/**
 * Initialisation de la grille de clipping par rapport a une liste d'Element
 * Gestion des Element a clipper en fonction de la position de l'écran
 * @author Adrien Bourdon
 */

class ClippingManager 
{	
	/**
	 * instance unique de la classe ClippingManager
	 */
	private static var instance: ClippingManager;

	// Dimension Cellules de la grille de clipping
	public static inline var CELL_WIDTH:Int = 400;
	public static inline var CELL_HEIGHT:Int = 400;
	
	// Marge de la limite de clipping en nombre de cellules
	private static inline var MARGIN_X:Int = 4;
	private static inline var MARGIN_Y:Int = 4;
	
	// Dimension et position de l'ecran
	private var screen:Rectangle;
	
    // Sauvegarde de la derniere position de la zone de clipping sur la grille
	private var oldColLeft:Int;
	private var oldColRight:Int;
	private var oldRowTop:Int;
	private var oldRowBot:Int;
	
	// Stock les cellules en fonction des instances
	private var instances:Map<String, Array<Cell>>;
	
	// Stock les instance remove
	private var saveInstances:Map<String, Array<Cell>> = new Map<String, Array<Cell>>();
	
	// Element a afficher
	private var toAdd:Map<String, Bool>;
	
	// Element a retirer
	private var toRemove:Map<String, Bool>;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ClippingManager {
		if (instance == null) instance = new ClippingManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * initialisation du clipping
	 * @param	pScreen : Game Container
	 */
	public function init(pScreen:Rectangle) 
	{
		screen = pScreen;
		CellManager.getInstance().initGrid(screen);
		setLevel(getData());
		initClippingArea(screen);
	}
	
	/**
	 * initialise la position de la de la zone de clipping dans la grille
	 * @param	pScreen : Game Container
	 */
	private function initClippingArea(pScreen:Rectangle) 
	{
		toAdd = new Map<String, Bool>();
		var i:Int = PoolObject.activeObjectList.length -1;
		while (i >= 0) 
		{
			PoolObject.activeObjectList[i].dispose();
			i--;
		}
		
		var lHeight:Float = pScreen.height;
		var lWidth:Float = pScreen.width;		
		oldColLeft  = (Math.floor(pScreen.x / CELL_WIDTH)) - MARGIN_X; 
		oldColRight = (Math.ceil((pScreen.x + lWidth) / CELL_WIDTH)) + MARGIN_X; 
		oldRowTop   = (Math.floor(pScreen.y / CELL_HEIGHT)) - MARGIN_Y; 
		oldRowBot   = (Math.ceil((pScreen.y + lHeight) / CELL_HEIGHT)) + MARGIN_Y;
		
		setToAddInGrid(oldColLeft, oldColRight, oldRowTop, oldRowBot);
		displayToAdd();
	}
	
	/**
	 * ajoute les elements du jeu a la grille de clipping
	 * @param	pArray : tableau contenant les elements de jeux
	 */
	private function setLevel(pArray:Array<Element>) :Void
	{
		if (pArray.length <= 0) return;	
		for (i in 0...pArray.length) 
		{
			CellManager.getInstance().setCell(pArray[i]);
		}
	}
	
	/**
	 * recupère la liste des elements du jeu
	 * @return liste des elements du jeu
	 */
	private function getData():Array<Element> 
	{
	    var lArray:Array<Element> = new Array<Element>();
		for (elem in PoolObject.elementList) 
		{
			lArray.push(elem);
		}
		return lArray;
	}
	
	/**
	 * Ajoute ou retir les elements du jeu en fonction de la position de l'ecran 
	 * @param	pScreen : GameContainer
	 */
	public function clipping(pScreen:Rectangle):Void 
	{
		var lHeight:Float = pScreen.height;
		var lWidth:Float = pScreen.width;		
		var colLeft:Int  = (Math.floor(pScreen.x / CELL_WIDTH)) - MARGIN_X ;
		var colRight:Int = (Math.ceil((pScreen.x + lWidth) / CELL_WIDTH)) + MARGIN_X;
		var rowTop:Int   = (Math.floor(pScreen.y / CELL_HEIGHT)) - MARGIN_Y;
		var rowBot:Int   = (Math.ceil((pScreen.y + lHeight) / CELL_HEIGHT)) + MARGIN_Y;
		var direction:Int;
		if (colLeft < oldColLeft || colRight > oldColRight || rowTop < oldRowTop || rowBot > oldRowBot)
		{
			toAdd = new Map<String, Bool>();
			//entré col
			if (colLeft < oldColLeft) setToAddInGrid(colLeft, oldColLeft, rowTop, rowBot, -1);		
			if (colRight > oldColRight) setToAddInGrid(oldColRight, colRight, rowTop, rowBot, 1);			
			//entré ligne
			if (rowTop < oldRowTop) setToAddInGrid(colLeft, colRight, rowTop, oldRowTop, 0, -1);
			if (rowBot > oldRowBot) setToAddInGrid(colLeft, colRight, oldRowBot, rowBot, 0, 1);				
			oldColLeft = colLeft;
			oldColRight = colRight;			
			oldRowBot = rowBot;
			oldRowTop = rowTop;	
			
			displayToAdd();
			sortTilesInRegions();
		}
		
		if (colLeft > oldColLeft || colRight < oldColRight || rowTop > oldRowTop || rowBot < oldRowBot)
		{
			toRemove = new Map<String, Bool>();
			//sorti col
			if (colLeft > oldColLeft) setToAddInGrid(oldColLeft, colLeft, rowTop, rowBot, -1, 0, true);
			if (colRight < oldColRight) setToAddInGrid(colRight, oldColRight, rowTop, rowBot, 1 , 0, true);	
			//sorti ligne
			if (rowTop > oldRowTop) setToAddInGrid(colLeft, colRight, oldRowTop, rowTop,0, -1, true);
			if (rowBot < oldRowBot) setToAddInGrid(colLeft, colRight, rowBot, oldRowBot, 0, 1, true);			
			oldColLeft = colLeft;
			oldColRight = colRight;	
			oldRowBot = rowBot;
			oldRowTop = rowTop;
			
			removeToDisplay();
		}
	}
	
	/**
	 * fait un z-sorting sur les elements des regions actives 
	 */
	private function sortTilesInRegions():Void 
	{
			for (lMap in World.getInstance().worldMap) 
			{
				for (lRegion in lMap) 
				{
					if (lRegion.isActive) {
						lRegion.layers[1].container.children = IsoManager.sortTiles(lRegion.layers[1].container.children);
					}
				}
			}
	}
	
	/**
	 * ajoute des instance a la map toAdd a partir de ligne et colone de la grille level
	 * @param	pColLeft
	 * @param	pColRight
	 * @param	pRowBot
	 * @param   pDirectionI : 1 si droite, -1 si gauche et 0 si aucun des 2
	 * @param   pDirectionJ : 1 si bas, -1 si haut et 0 si aucun des 2
     * @param	pRemove : pour rajouter des element à la map toRemove au lieu de toAdd, mettre à true
     */	
	private function setToAddInGrid(pColLeft:UInt, pColRight:UInt, pRowTop:UInt, pRowBot:UInt, ?pDirectionI:Int = 0, ?pDirectionJ:Int = 0, ?pRemove:Bool = false):Void 
	{
		for (i in pColLeft...pColRight) 
		{
			if (CellManager.level[i] != null) 
			{
				for (j in pRowTop...pRowBot)
				{	
					if (CellManager.level[i][j] != null) 
					{
						if (i <= CellManager.getInstance().xMax && i >= CellManager.getInstance().xMin && j <= CellManager.getInstance().yMax && j >= CellManager.getInstance().yMin && CellManager.level[i][j].list.length > 0) 
						{
							for (instance in CellManager.level[i][j].list)
							{
								if (pRemove) 
								{
									toRemove.set(instance, true);

									if (CellManager.level[i -pDirectionI] != null)
									{
										if (CellManager.level[i - pDirectionI][j - pDirectionJ] != null) 
										{
											if (CellManager.level[i - pDirectionI][j - pDirectionJ].list.indexOf(instance) != -1) toRemove[instance] = false;
											else toRemove.set(instance, true);												
										}
									}
								}
								else
								{
									toAdd.set(instance, true);
									if (pDirectionI != 0 || pDirectionJ != 0) 
									{
										if (CellManager.level[i -pDirectionI] != null)
										{
											if (CellManager.level[i - pDirectionI][j - pDirectionJ] != null) 
											{
												if (CellManager.level[i - pDirectionI][j - pDirectionJ].list.indexOf(instance) != -1) toAdd[instance] = false;
												else toAdd.set(instance, true);									
											}
										}										
									}
									for (object in PoolObject.activeObjectList) if (instance == object.instanceID) toAdd[instance] = false;	
								}					
							}					
						}
					}
				}
			}
		}		
	}
		
	/**
	 * affiche les element contenu dans la map toAdd
	 */	
	private function displayToAdd():Void 
	{
		for (instance in toAdd.keys()) 
		{
			if (toAdd[instance]) 
			{
				DisplayManager.getInstance().displayElement(instance);
			}
		}
		toAdd = new Map<String, Bool>();
	}
	
	
	/**
	 * retire les element de l'affichage
	 */
	private function removeToDisplay():Void 
	{
		var lParent:Container;
		 
		for (instance in toRemove.keys())
		{
			if (toRemove[instance])
			{
				DisplayManager.getInstance().removeElement(instance);
			}
		}
		toRemove = new Map<String, Bool>();
	}
	
	/**
	 * vide le tableau saveInstances
	 */
	public static function clearSave():Void 
	{
		//saveInstances = new Map<String, Array<Cell>>();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}
}