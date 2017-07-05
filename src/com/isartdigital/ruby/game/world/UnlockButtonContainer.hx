package com.isartdigital.ruby.game.world;

import com.isartdigital.utils.game.GameStage;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;

	
/**
 * ...
 * @author Guillaume Zegoudia
 */
class UnlockButtonContainer extends Container 
{
	
	/**
	 * instance unique de la classe UnlockButtonContainer
	 */
	private static var instance: UnlockButtonContainer;
	public static var  arrayButton:Array<Sprite> = [];
	
	private var unlockContainer:Container;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): UnlockButtonContainer {
		if (instance == null) instance = new UnlockButtonContainer();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		unlockContainer = new Container();
		name = "unlockContainer";
		//GameStage.getInstance().getGameContainer().addChild(unlockContainer);
		unlockContainer.name = "unlockContainer";
		unlockContainer.interactive = false;
		unlockContainer.buttonMode = false;
		
	}
	
	public function getUnlockContainer():Container
	{
		return unlockContainer;
	}
	
	public function positionning():Void
	{
		position = GameStage.getInstance().getGameContainer().position;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}