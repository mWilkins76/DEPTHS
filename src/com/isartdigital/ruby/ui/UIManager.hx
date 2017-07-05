package com.isartdigital.ruby.ui;


import com.isartdigital.ruby.ui.ftue.FocusManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.Popin;
import com.isartdigital.utils.ui.Screen;
import pixi.core.display.Container;

/**
 * Manager (Singleton) en charge de gérer les écrans d'interface
 * @author Mathieu ANTHOINE
 */
class UIManager 
{
	
	/**
	 * instance unique de la classe UIManager
	 */
	private static var instance: UIManager;
	
	
	/**
	 * tableau des popins ouverts
	 */
	private var popins:Array<Popin>;
	public var regionPopins:Array<Popin>;

	public function new() 
	{
		popins = [];
		regionPopins = [];
	}
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): UIManager {
		if (instance == null) instance = new UIManager();
		return instance;
	}
	
	/**
	 * Ajoute un écran dans le conteneur de Screens en s'assurant qu'il n'y en a pas d'autres
	 * @param	pScreen Screen à ouvrir
	 */
	public function openScreen (pScreen: Screen): Void {
		closeScreens();
		GameStage.getInstance().getScreensContainer().addChild(pScreen);
		pScreen.open();
	}
	
	/**
	 * Supprime les écrans dans le conteneur de Screens
	 */
	public function closeScreens (): Void {
		var lContainer:Container = GameStage.getInstance().getScreensContainer();
		while (lContainer.children.length > 0) {
			var lCurrent:Screen = cast(lContainer.getChildAt(lContainer.children.length - 1), Screen);
			lCurrent.interactive = false;
			lContainer.removeChild(lCurrent);
			lCurrent.close();
		}
	}
	
	/**
	 * Ajoute un popin dans le conteneur de Popin
	 * @param	pPopin Popin à ouvrir
	 */
	public function openPopin (pPopin: Popin): Void {
		popins.push(pPopin);
		GameStage.getInstance().getPopinsContainer().addChild(pPopin);
		pPopin.open();
		SoundManager.getSound("in").play();

	}
	
	public function openRegionPopin (pPopin: Popin): Void {
		regionPopins.push(pPopin);
		pPopin.open();

	}
	
	public function closeRegionPopin (pPopin: Popin): Void {
		if(pPopin == null)
			regionPopins.remove(pPopin);
			
		pPopin.close();
		
		SoundManager.getSound("soundPlayerValidate").play();

	}
	
	public function closePopin (pPopin: Popin): Void {
		
		if(pPopin == null)
			popins.remove(pPopin);
			
		GameStage.getInstance().getPopinsContainer().removeChild(pPopin);
		pPopin.close();
		
		SoundManager.getSound("soundPlayerValidate").play();

	}
	/**
	 * Supprime le popin dans le conteneur de Screens
	 */
	public function closeCurrentPopin (): Void {
		if (popins.length == 0) return;
		var lCurrent:Popin = popins.pop();
		lCurrent.interactive = false;
		GameStage.getInstance().getPopinsContainer().removeChild(lCurrent);
		lCurrent.close();
		SoundManager.getSound("soundPlayerValidate").play();

		
	}
	
	public function  closeAllPopins():Void {
		
		if (popins.length == 0) return;
		var lindex:Int;
		for (i in 0...popins.length) {
			var lCurrent:Popin = popins.pop();
			closePopin(lCurrent);
		}
	}

	
	/**
	 * Ajoute le hud dans le conteneur de Hud
	 */
	public function openHud (): Void {
		GameStage.getInstance().getHudContainer().addChild(Hud.getInstance());
		Hud.getInstance().open();

	}
	
	/**
	 * Retire le hud du conteneur de Hud
	 */
	public function closeHud (): Void {
		GameStage.getInstance().getHudContainer().removeChild(Hud.getInstance());
		Hud.getInstance().close();

	}
	
	/**
	 * Ajoute le hud dans le conteneur de Hud
	 */
	public function openFTUE (): Void {
		GameStage.getInstance().getFtueContainer().addChild(FocusManager.getInstance());
		FocusManager.getInstance().open();
	}
	
	/**
	 * Retire le hud du conteneur de Hud
	 */
	public function closeFTUE (): Void {
		GameStage.getInstance().getFtueContainer().removeChild(FocusManager.getInstance());
		FocusManager.getInstance().close();
	}
	
	/**
	 * met l'interface en mode jeu
	 */
	 public function startGame (): Void {
		closeScreens();
		openHud();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}