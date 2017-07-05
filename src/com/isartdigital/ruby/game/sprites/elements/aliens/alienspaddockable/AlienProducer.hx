package com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable;
import com.greensock.TweenMax;
import com.greensock.easing.Quart;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienPaddockable;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.utils.RessourcesEffectManager;
import com.isartdigital.ruby.utils.RessourcesEffectManager.RessourcesEffectParams;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.save.AlienTypes.AlienProducerType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Adrien Bourdon
 */
class AlienProducer extends AlienPaddockable
{
	//valeurs de production de ressources 
	public var maxProduction(default, null):Int = 10000;
	public var productionSpeedCoef(default, null):Int = 1;
	public var productionPerCycle(default, null):Int = 1000;
	public var cycleTimeInMin(default, null):Int = 1;
	public var ressources(default, null):Int = 0;
	
	//variables de temps
	private var startTime:Date;
	private var endTime:Date;
	
	//list des types
	public static var prodTypes:Array<AlienProducerType> = new Array<AlienProducerType>();
	
	//l'alien est-il a son max de ressource recolté
	public var isFilled:Bool = false;
	
	public function new(?pAsset:String) 
	{
		super(pAsset);	
	}
	
	override public function start():Void 
	{
		super.start();
		if (aElem.startTime != null && aElem.endTime != null)
		{
			startTime = Date.fromString(aElem.startTime);
			endTime = Date.fromString(aElem.endTime);
		}
		if (FTUEManager.isFTUEon()) 
		{
			ressources = maxProduction;
			setModeFilled();
		}
		else if (endTime != null)
		{
			if (Date.now().getTime() >= endTime.getTime()) 
			{
				ressources = maxProduction;
				setModeFilled();
			}
			else setModeProduction();
		}	
		else setModeProduction();
	}
	public static function loadTypes(pTypes:Dynamic):Void 
	{
		prodTypes = pTypes;
	}
	
		//machine à état
	public	 function setModeProduction():Void
	{
		if (ressources == 0) 
		{
			calculateEndProductionTime();
		}
		doAction = doActionProduction;
	}
	
	private function doActionProduction():Void
	{
		loopanim();
		ressources = Math.round((TimeManager.getInstance().getPercentage(startTime, endTime) * maxProduction) / 100);
		if (TimeManager.getInstance().getTimeInSecondsToFinishBuilding(endTime) >= 0 || isFilled) setModeFilled();
		
	}
	
	var gold:UISprite;
	public function setModeFilled():Void 
	{
		isFilled = true;
		ressources = maxProduction;
		doAction = doActionFilled;
		gold = new UISprite("Building_Harvest");
		addChild(gold);
		gold.position.y -= 70;
		var bump:TweenMax = new TweenMax(
			gold.scale,
			0.5,
			{
				repeatDelay:0.3,
				x:0.95,
				y:0.95,
				repeat:-1,
				ease:Quart.easeIn,
				yoyo:true
			}
			
		);
		on(MouseEventType.CLICK, onHarve);
		on(TouchEventType.TAP, onHarve);
		
	}
	
	private function doActionFilled():Void 
	{
		loopanim();
		if (!isFilled) {
			ressources = 0;
			setModeProduction();
		}
		
	}
	
	//methodes
	
	/**
	 * calcule le temps de production de ressource d'un alien en fonction de :
	 * maxProduction : maximum de ressources qu'il peut avoir
	 * cyleTimeInMin & productionPerCycle : le temps d'un cycle et la quantité de ressource produite pour un cycle
	 * productionSpeedCoef : un facteur d'accélération 
	 */
	private function calculateEndProductionTime():Void
	{
		startTime = Date.now();
		var lStartTimeStamps:Float = startTime.getTime();
		
		var time:Float = Math.fround((maxProduction / productionPerCycle) * (cycleTimeInMin * productionSpeedCoef) * 60000);
		
		var lEndtimeStamps:Float = lStartTimeStamps + time;		
		
		endTime = Date.fromTime(lEndtimeStamps);
		aElem.startTime = startTime.toString();
		aElem.endTime = endTime.toString();
	}	
	
	private function onHarve():Void
	{
		off(MouseEventType.CLICK, onHarve);
		off(TouchEventType.TAP, onHarve);
		removeChild(gold);
		SoundManager.getSound("soundPlayerHarvest").play();
		ressourceCollectAnimation();
		Player.getInstance().changePlayerValue(ressources, Player.TYPE_SOFTCURRENCY);
		ressources = 0;
		isFilled = false;
		setModeProduction();
	}
	
	private function ressourceCollectAnimation() {
		var ressourceSCgoToHud : RessourcesEffectParams = 
			{
				originalPosition: GameStage.getInstance().getHudContainer().toLocal(parent.toGlobal(position.clone())),
				destinationPosition : GameStage.getInstance().getHudContainer().toLocal(Hud.getInstance().scAddButton.parent.toGlobal(Hud.getInstance().scAddButton.position.clone())),
				whereToAddchild: GameStage.getInstance().getHudContainer(),
				numObjectsToInstanciate: 20,
				duration:1,
				secondsBtwnaddchilds:1,
				speed:0.2,
				animationType:"dispersionToCurve",
				ressource: RessourceType.SoftCurrency,
			}

		RessourcesEffectManager.getInstance().SetEffect(ressourceSCgoToHud);
	}
	
	override public function destroy():Void 
	{
		if (gold != null) removeChild(gold);
		off(MouseEventType.CLICK, onHarve);
		off(TouchEventType.TAP, onHarve);
		super.destroy();
	}
}