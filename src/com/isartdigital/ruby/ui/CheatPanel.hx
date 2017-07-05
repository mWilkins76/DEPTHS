package com.isartdigital.ruby.ui;
import com.isartdigital.ruby.game.GameManager;
import com.isartdigital.ruby.game.Spawner;
import com.isartdigital.ruby.game.controller.MouseController;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.ftue.FocusManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.save.DataBaseAction;
import dat.controllers.Controller;
import dat.gui.GUI;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;

	
/**
 * Classe permettant de manipuler des parametres du projet au runtime
 * Si la propriété Config.debug et à false ou que la propriété Config.data.cheat est à false, aucun code n'est executé.
 * Il n'est pas nécessaire de retirer ou commenter le code du CheatPanel dans la version "release" du jeu
 * @author Mathieu ANTHOINE
 */
class CheatPanel 
{
	
		
	private var startFTUEButton:Controller;
	private var bgFTUEButton:Controller;
	private var resetFTUEButton:Controller;
	private var godModeBtn:Controller;
	
	private var startFTUE:Bool=false;
	private var _FTUE:Bool = false;
	private var _resetFTUE:Bool = false;
	private var _killFTUE:Bool = false;
	private var _godMode:Bool = GameManager.getInstance().godMode;
	
	/**
	 * instance unique de la classe CheatPanel
	 */
	private static var instance: CheatPanel;
	
	/**
	 * instance de dat.GUI composée par le CheatPanel
	 */
	private var gui:GUI;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CheatPanel {
		if (instance == null) instance = new CheatPanel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		init();
	}

	
	private function init():Void {
		if (Config.debug && Config.data.cheat && !DeviceCapabilities.isCanvasPlus) gui = new GUI();
	}
	
	// exemple de méthode configurant le panneau de cheat suivant le contexte
	public function ingame (): Void {
		// ATTENTION: toujours intégrer cette ligne dans chacune de vos méthodes pour ignorer le reste du code si le CheatPanel doit être désactivé
		if (gui == null) return;
		//startFTUEButton = gui.add(this, "startFTUE");
		//startFTUEButton.onChange(cbFTUE);
		
		bgFTUEButton = gui.add(this, "_killFTUE");
		bgFTUEButton.onChange(killFTUE);	
		
		resetFTUEButton = gui.add(this, "_resetFTUE");
		resetFTUEButton.onChange(resetFTUE);
		
		godModeBtn = gui.add(this, "_godMode");
		godModeBtn.onChange(godMode);
		
	}
	

	/**
	 * vide le CheatPanel
	 */
	public function clear ():Void {
		if (gui == null) return;
		gui.destroy();
		init();
	}
	
	private function godMode(pValue:Bool): Void {
		GameManager.getInstance().godMode =  Spawner.getInstance().godMode =  pValue;
	}
	
	private function cbFTUE (pValue:Bool): Void {
		//FTUEManager.currentStep = 0;
		if (pValue) FTUEManager.nextStep();
		startFTUE = false;
	}
	
	private function cbBgFTUE (pValue:Bool): Void {
		FocusManager.getInstance().modalImage = pValue ? "assets/ftue2_bg.png" : "assets/ftue_bg.png";
	}	
	
	private function resetFTUE(pValue:Bool)
	{
		if (pValue) {
			DataBaseAction.getInstance().changeFtueStep(Player.getInstance().id, 0);
			_resetFTUE = false;
			Browser.window.location.reload();
		}
	}
	
	private function killFTUE(pValue:Bool)
	{
		if (pValue) {
			DataBaseAction.getInstance().changeFtueStep(Player.getInstance().id, 100);
			_killFTUE = false;
			Browser.window.location.reload();
			
		}
		
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}