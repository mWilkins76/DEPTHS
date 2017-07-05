package com.isartdigital.utils.game.clipping;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.utils.save.ElementSave;

/**
 * Cellule de la grille de clipping 
 * contenant une liste d'id (String)
 * @author Adrien Bourdon
 */
class Cell
{

	public var list:Array<String>;
	
	public function new() 
	{
		list = new Array<String>();
	}
	
	public function add(pInstance:String):Void 
	{
		if (list.indexOf(pInstance) == -1) {
			list.push(pInstance);
		}
	}
	
}