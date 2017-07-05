package com.isartdigital.ruby.utils;

import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.popin.contextual.ContextualPopin;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.interaction.InteractionManager;

	
/**
 * ...
 * @author Jordan Dachicourt
 */
class Focus extends DisplayObject 
{
	
	private var oldPosition:Point;
	private var direction:Point;
	/**
	 * instance unique de la classe Focus
	 */
	private static var instance: Focus;
	private var graphic:Graphics;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Focus {
		if (instance == null) instance = new Focus();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		graphic = new Graphics();
		//GameStage.getInstance().getGameContainer().addChild(graphic);
		oldPosition = position;
	}
	
	
	
	/**
	 * fonction utilitaire si besoin de voir le point du focus
	 */
	public function draw() {
				
		//GameStage.getInstance().removeChild(graphic);
		graphic.clear();
		graphic.beginFill(0xFFFFFF);
		graphic.drawCircle(x, y, 10);
		graphic.endFill();
		//GameStage.getInstance().addChild(graphic);
		
	}
	
	/**
	 * fonction utilitaire permettant de savoir les coordonné de la region
	 * @return coordonné region
	 */
	public function getRegionOn():Point{
		var lPoint:Point = IsoManager.localToModel(position);
		
		lPoint.x /= Region.WIDTH;
		lPoint.y /= Region.HEIGHT;
		lPoint.x = Math.floor(lPoint.x);
		lPoint.y = Math.floor(lPoint.y);
		return lPoint;
	}
	
	/**
	 * Inform si la region sur laquelle se trouve le focus est active
	 * @return actif ?
	 */
	public function isOnActiveRegion():Bool{
		var lPoint = getRegionOn();
		if (World.getInstance().getRegion(cast(lPoint.x, Int), cast(lPoint.y, Int)) != null) 
		{
			return World.getInstance().getRegion(cast(lPoint.x,Int), cast(lPoint.y,Int)).isActive;	
		}
		else return false;
	}
	
	/**
	 * met à jour la position, ne la met pas à jour si la position future est sur une region inactive
	 */

	public function toMove(pToAdd:Point):Void {
		
		oldPosition = position.clone();
		position.x += pToAdd.x;
		position.y += pToAdd.y;	
		var lCooCurrentRegion:Point = getRegionOn();
		position = oldPosition.clone();
		
		if (World.getInstance().getRegion(cast(lCooCurrentRegion.x, Int), cast(lCooCurrentRegion.y, Int)) == null)
			return;
		
		
		move(pToAdd);
		
	}
	
	public function move(pToAdd:Point) {
		
		position.x += pToAdd.x;
		position.y += pToAdd.y;	
		
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}