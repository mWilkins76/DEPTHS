package com.isartdigital.ruby.game.world;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.save.ElementSave;
import pixi.core.display.Container;
import pixi.interaction.EventEmitter;

/**
 * les layers ont une grille et definisse les niveaux en Z d'une region
 * @author Adrien Bourdon
 */

class Layer
{

	//grille du layer
	public var grid:Array<Array<GameElement>>;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var region:Region;
	public var container:RegionContainer;
	//private var arrayToSave:Array<GameElement>;

	
	//écouteur
	private var onSpawnerMove:EventEmitter;

	public function new(pWidth:Int, pHeight:Int)
	{
		width = pWidth;
		height = pHeight;
		
	}

	public function init() {
		initGrid();
	}

	
	private function initGrid()
	{
		grid = new Array<Array<GameElement>>();
		var lArray:Array<GameElement>;
		for (i in 0...width)
		{
			lArray = new Array<GameElement>();
			for (j in 0...height)
			{
				lArray[j] = null;
			}
			grid[i] = lArray;
		}
	}

	/**
	 * ajoute un GameElement a la grille si c'est possible
	 * @param	pElem : GameElement
	 */
	public function add(pElem:GameElement):Void
	{
		if (pElem == null) return;
		if (!canAdd(pElem)) return;
		
		for (i in pElem.rowMin...(pElem.rowMax + 1))
		{
			for (j in pElem.colMin...(pElem.colMax + 1))
			{
				setCell(i, j, pElem);
			}
		}
		
		
	}

	/**
	 * retire un GameElement de la grille
	 * @param	pElem : GameElement
	 */
	public function remove(pElem:GameElement):Void
	{
		if (pElem == null) return;

		for (i in pElem.rowMin...(pElem.rowMax + 1))
		{
			for (j in pElem.colMin...(pElem.colMax + 1))
			{
				setCell(i, j, null);
			}
		}

	}

	/**
	 * verifie si le GameElement rentre dans la grille de la region
	 * @param	pElem : GameElement
	 * @return true s'il rentre
	 */
	public function isIn(pElem:GameElement):Bool
	{
		if (pElem == null) return false;
		return (((pElem.colMin >= 0) && (pElem.rowMin >= 0)) && ((pElem.colMax <= width-1) && (pElem.rowMax <= height-1)));
	}

	/**
	 * verifie si on peut poser le GameElement dans la grille
	 * @param	pElem : GameElement
	 * @return true si on peut
	 */
	public function canAdd(pElem:GameElement):Bool
	{
		if (pElem == null) return false;
		if (!isIn(pElem)) return false;
		
		for (i in (pElem.rowMin - pElem.margin) ... (pElem.rowMax + 1 + pElem.margin))
		{
			for (j in (pElem.colMin - pElem.margin) ...(pElem.colMax + 1 + pElem.margin))
			{
				if (getCell(i, j) != null) return false;
				else if (i == Region.WIDTH || j == Region.HEIGHT) return false;
			}
		}
		return true;
	}

	
	
	/**
	 * recupère le GameElment contenu dans une cellule de la grille
	 * @param	pX : premier index de la grille
	 * @param	pY : deuxieme index de la grille
	 * @return GameElement ou null
	 */
	public function getCell(pX:Int, pY:Int):GameElement
	{
		
		if (grid[pX] == null) return null;
		if (grid[pX][pY] == null) return null;
		return grid[pX][pY];
	}

	/**
	 * ajoute un gameElement a une cellule de la grille
	 * @param	pX : premier index de la grille
	 * @param	pY : deuxieme index de la grille
	 * @param	pElem : GameElement
	 */
	private function setCell(pX:Int, pY:Int, pElem:GameElement):Void
	{
		grid[pX][pY] = pElem;
	}

	/**
	 * recupere les doonées dans la grilles
	 * @return arrayToSave un array contenant tout les elements présent dans la grille
	 */
	public function getData():Array<ElementSave>
	{
		if (grid.length <= 0) return null;
		var arrayToSave:Array<ElementSave> = [];

		var toSave:ElementSave;
		for (i in 0...grid.length)
		{
			for (j in 0...grid[i].length)
			{

				var inGrid:GameElement = grid[i][j];

				if (inGrid != null)
				{
					if (Std.is(inGrid, Building))
					{
						var lBuilding:Building = cast(inGrid, Building);
						toSave =
						{
							type : lBuilding.className,
							x : lBuilding.colMin,
							y : lBuilding.rowMin,

							mode : lBuilding.currentState,
							evolveState : lBuilding.level,
							timeForNextState : lBuilding.timeForNextState,
							elapsedTime : lBuilding.elapsedTime,
							
							width : lBuilding.width,
							height : lBuilding.height,
							worldX : lBuilding.toGlobal(lBuilding.position).x,
							worldY : lBuilding.toGlobal(lBuilding.position).y
						};
					}

					else
					{
						toSave =
						{
							type : inGrid.className,
							x : inGrid.colMin,
							y : inGrid.rowMin,
							
							width : inGrid.width,
							height : inGrid.height,
							worldX : inGrid.toGlobal(inGrid.position).x,
							worldY : inGrid.toGlobal(inGrid.position).y
						};
					}
					arrayToSave.push(toSave);

				}

			}
		}

		return arrayToSave;
	}

}