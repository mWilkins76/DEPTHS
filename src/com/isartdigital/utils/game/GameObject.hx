package com.isartdigital.utils.game;

import com.isartdigital.utils.events.EventType;
import pixi.core.display.Container;
import pixi.filters.color.ColorMatrixFilter;

/**
 * Classe de base des objets interactifs dans le jeu
 * Met à jour automatiquement ses données internes de position et transformation
 * 
 * @author Mathieu ANTHOINE
 */
class GameObject extends Container
{
	public var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
	
	

	public function new() 
	{
		super();
		// Force la mise à jour de la matrices de transformation des éléments constituant le GameObject
		on(EventType.ADDED, updateTransform);
		buttonMode = true;
		interactive = true;
		defaultCursor = "url(assets/Curseur.png), auto";
		
	}
	
	/**
	 * nettoie et détruit l'instance
	 */
	override public function destroy (): Void {
		off(EventType.ADDED, updateTransform);
		super.destroy(true);
	}
	
}