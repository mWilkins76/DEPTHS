package com.isartdigital.ruby.ui.ftue;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.popin.IsartPoints;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import eventemitter3.EventEmitter;
import haxe.Constraints.Function;
import haxe.Json;
import js.Browser;
import js.Lib;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;


/**
 * Gestion des changement d'etape de la ftue
 * @author Adrien Bourdon
 */ 
	class FTUEManager
{
	
	public static var steps(default, null):Array<FTUEStep>;
	public static var numberSteps(default, null):Int;
	//TODO: récupérer l'étape courante sur le serveur
	public static var currentStep(default, default):UInt = 0;
	private static var isRunning:Bool;
	
	private function new() {}
	
	public static function init (pFTUE: Dynamic): Void {
		steps = pFTUE.steps;
		numberSteps = steps.length;
	}
	
	public static function isFTUEon():Bool 
	{
		return (currentStep < numberSteps-1) && isRunning;
	}
	
	public static function register (pTarget:DisplayObject): Void {
		if (currentStep>=steps.length || pTarget.parent == null) return;
		for (i in 0...steps.length) {
			if (pTarget.name == steps[i].name && pTarget.parent.name == steps[i].parentName) {
				steps[i].item = pTarget;
			}
			if (pTarget.name == steps[i].arrowTarget) 
			{
				steps[i].itemTarget = pTarget;
			}
		}
	}
	
	public static function nextStep(pTarget:DisplayObject = null): Void {
		isRunning = true;
		if (!isFTUEon()) return;
		if (steps[currentStep].text != "") setText();
		FocusManager.getInstance().setCurrentStep(steps[currentStep]);

			if (steps[currentStep].isAction) 
			{
				if (Std.is(steps[currentStep].item, SmartButton)) cast(steps[currentStep].item, SmartButton).on(MouseEventType.CLICK, endOfStep);
				else if (Std.is(steps[currentStep].item, SmartComponent)) cast(steps[currentStep].item, SmartComponent).on(MouseEventType.CLICK, endOfStep);			
				else
				{
					if (steps[currentStep].parentName == "infoBulleContainer")
					{
						if(steps[currentStep].item.interactive) steps[currentStep].item.on(MouseEventType.CLICK, endOfStep);
					}
				}
			}
			UIManager.getInstance().openFTUE();	

		if (steps[currentStep].event != "")
		{
			if (steps[currentStep].event == "onBulle") Building.event.on(steps[currentStep].event, readyToNextStep);
			else if (steps[currentStep].event == "onAddAlien") AlienPaddock.event.on(steps[currentStep].event, readyToNextStep);
			else SmartPopinRegister.event.on(steps[currentStep].event, readyToNextStep);
		}
		
		if (steps[currentStep].gift != "") addGift(steps[currentStep].gift);
		if (steps[currentStep].ftueStop) isRunning = false;
		if (pTarget != null || steps[currentStep].name == "") return;
		FocusManager.getInstance().setFocus(steps[currentStep].item, steps[currentStep].arrowRot);
	}
	
	private static function endOfStep ():Void {	
		if (Std.is(steps[currentStep].item, SmartButton) && steps[currentStep].isAction) {
			cast(steps[currentStep].item, SmartButton).off(MouseEventType.CLICK, endOfStep);
			steps[currentStep].item = null;
		}
		else if (Std.is(steps[currentStep].item, SmartComponent) && steps[currentStep].isAction) {
			cast(steps[currentStep].item, SmartComponent).off(MouseEventType.CLICK, endOfStep);
			steps[currentStep].item = null;
	
		}
		UIManager.getInstance().closeFTUE();
		
		if (steps[currentStep].checkpoint) DataBaseAction.getInstance().changeFtueStep(Player.getInstance().id, currentStep);
		//TODO: ne pas oublier de donner la possibilité de réinitialiser la valeur dans le cheatPanel
		
		if (currentStep == steps.length - 1) UIManager.getInstance().closeCurrentPopin();
		currentStep++;
		if (FTUEPopin.getInstance() != null) UIManager.getInstance().closePopin(FTUEPopin.getInstance());
		if (!steps[currentStep - 1].ftueStop && isFTUEon()) nextStep();
	}
	
	/**
	 * call back des event de la ftue
	 * @param	pEvent
	 */
	private static function readyToNextStep (pEvent:EventTarget):Void
	{
		if (FTUEPopin.getInstance() != null) UIManager.getInstance().closePopin(FTUEPopin.getInstance());
		if (steps[currentStep].event == "onBulle") Building.event.off(steps[currentStep].event, readyToNextStep);
		else if (steps[currentStep].event == "onAddAlien") AlienPaddock.event.off(steps[currentStep].event, readyToNextStep);
		else SmartPopinRegister.event.off(steps[currentStep].event, readyToNextStep);
		endOfStep();
	}
	
	/**
	 * ouvre une popin de text explicatif
	 */
	private static function setText():Void 
	{
		if (steps[currentStep].text == "LABEL_FTUE_ISART_POINT_DISCLAIMER") 
		{
			UIManager.getInstance().openPopin(IsartPoints.getInstance());
		}
		else 
		{
			UIManager.getInstance().openPopin(FTUEPopin.getInstance());
			//FTUEPopin.getInstance().
			//GameStage.getInstance().getInfoBulleContainer.addChild(FTUEPopin.getInstance());
			
			var lCallBack:Function = steps[currentStep].isAction || steps[currentStep].event != "" ? null : nextText;
			var lEmot:Int = 0;
			if (steps[currentStep].emotion != null)
			{
				if (steps[currentStep].emotion == "joy") lEmot = 1;
				else if (steps[currentStep].emotion == "neutral") lEmot = 0;
				else if (steps[currentStep].emotion == "exclamation") lEmot = 3;	
				else if (steps[currentStep].emotion == "surprised") lEmot = 2;
			}
			
			FTUEPopin.getInstance().init(steps[currentStep].text, lCallBack, steps[currentStep].textPos, lEmot);	
			if (steps[currentStep].parentName != "FTUEpopin") 
			{
				//FTUEPopin.getInstance().position = steps[currentStep].item.position;
			}	
		}
	}
	
	private static function addGift(pGift:String):Void
	{
		if (pGift == "AlienForreur") 
		{
			var alienID:String = "Basic1"+Date.now().getTime();
			var lAlien:AlienElement =
			{
				idAlien:alienID,
				idBuilding:"",
				mode:"",
				name:"Basic1",
				type:"AlienForeur",
				nomPropre:"Bob",
				stamina:6,
				level:1,
				startTime:Std.string(Date.now()),
				endTime:Std.string(Date.now()),
				carac:Alien.getAlienType("Basic1", DataManager.getInstance().getAlienArray("AlienForeur")),
				idPlayer:Player.getInstance().id
			}
			Alien.alienElementList.push(lAlien);
			DataBaseAction.getInstance().addAlien(lAlien.idAlien, lAlien.idBuilding, lAlien.type, lAlien.name, lAlien.nomPropre, lAlien.stamina, lAlien.endTime);
		}
		if (pGift == "AlienProducer") 
		{
			var alienID:String = "Producer1"+Date.now().getTime();
			var lAlien:AlienElement =
			{
				idAlien:alienID,
				idBuilding:"",
				mode:"",
				name:"Producer1",
				type:"AlienProducer",
				nomPropre:"Mik",
				stamina:6,
				level:1,
				startTime:"00:00:00",
				endTime:"00:00:00",
				carac:Alien.getAlienType("Producer1", DataManager.getInstance().getAlienArray("AlienProducer")),
				idPlayer:Player.getInstance().id
			}
			Alien.alienElementList.push(lAlien);
			DataBaseAction.getInstance().addAlien(lAlien.idAlien, lAlien.idBuilding, lAlien.type, lAlien.name, lAlien.nomPropre, lAlien.stamina, lAlien.endTime);
		}
	}
	
	/**
	 * call back du bouton next des popin de texte explicatif
	 */
	private static function nextText():Void
	{
		endOfStep();
	}
}