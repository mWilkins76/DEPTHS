package com.isartdigital.ruby.preloadgame;

import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.UIMovie;

	
/**
 * ...
 * @author Michael Wilkins
 */
class LoadingBar extends SmartScreen 
{
	private var container:SmartComponent;
	private var helix:Helix;
	private var helixEmpty:UIMovie;
	/**
	 * instance unique de la classe LoadingBar
	 */
	private static var instance: LoadingBar;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LoadingBar {
		if (instance == null) instance = new LoadingBar();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(?pAsset:String) 
	{
		super(pAsset);
		
		container = cast(getChildByName("loader_container"), SmartComponent);
		helix = cast(container.getChildByName("helix_turn"), Helix);
		helixEmpty = cast(container.getChildByName("helix_turn_empty"), UIMovie);
		helixEmpty.visible = false;
		
	}
	
	
	/**
	 * mise à jour de la barre de chargement
	 * @param	pProgress
	 */
	public function update (pProgress:Float): Void {
		helix.update(pProgress);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}