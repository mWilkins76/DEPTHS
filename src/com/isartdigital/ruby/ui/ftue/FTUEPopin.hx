package com.isartdigital.ruby.ui.ftue;

import com.greensock.TweenMax;
import com.greensock.easing.Quart;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.system.Localization;
import com.isartdigital.utils.ui.UIPositionable;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import flump.IFlumpMovie;
import haxe.Constraints.Function;
import js.html.svg.PointList;
import pixi.core.math.Point;
import pixi.extras.MovieClip;
import pixi.flump.Sprite;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Adrien Bourdon
 */
class FTUEPopin extends SmartPopinRegister 
{
	
	/**
	 * instance unique de la classe FTUEPopin
	 */
	private static var instance: FTUEPopin;
	private static inline var TEXT:String = "txt_FTUEInstructions";
	private static inline var NEXT_BTN:String = "btn_Close";
	private static inline var FTUE_CONTAINER:String = "FTUE_popinContainer";
	private var ftuePos:Point;
	
	private var nextButton:SmartButton;
	private var noButton:SmartButton;
	
	private var text:TextSprite;
	private var ftueContainer:SmartComponent;
	
	private var validationFunction:Function;
	private var mascotte:UIMovie;
	private var margin:Int = 100;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): FTUEPopin {
		if (instance == null) instance = new FTUEPopin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super("FTUE");
		componentName = "FTUEpopin";
		name = "FTUEpopin";
		ftueContainer = cast(getChildByName(FTUE_CONTAINER), SmartComponent);
		nextButton = cast(ftueContainer.getChildByName(NEXT_BTN), SmartButton);
		mascotte = cast(ftueContainer.getChildByName("FTUE_spriteMascot"), UIMovie);
		interactive = true;
		scale = new Point(0.7, 0.7);
		ftueRegister();
	}
	
	/**
	 * initialise la popin de confirmation 
	 * @param	pQuestion : question à confirmer
	 * @param	pFunction : fonction à executer si confirmation
	 */
	public function init(pText:String, pFunction:Function, ?pPos:String, ?pState:Int = 0):Void 
	{
		text = cast(ftueContainer.getChildByName(TEXT), TextSprite);
		changeText(pText);
		
		mascotte.setBehavior(false, false, pState);
		if (pFunction != null) 
		{
			validationFunction = pFunction;
			nextButton.on(MouseEventType.CLICK, onNext);
			nextButton.on(TouchEventType.TAP, onNext);
			on(MouseEventType.CLICK, onNext);
			on(TouchEventType.TAP, onNext);
			
			var bump:TweenMax = new TweenMax(
				nextButton.scale,
				0.5,
				{
					repeatDelay:0.5,
					x:0.2,
					y:0.2,
					repeat:-1,
					ease:Quart.easeIn,
					yoyo:true
				}
				
			);
		}
		else 
		{
			validationFunction = null;
			nextButton.visible = false;
		}
		
		if (pPos != null) 
		{
			setUIPosition(pPos);
		}
		FTUEManager.register(nextButton);
	}
	//font: 50 + "px " + "Arial", 
	public function changeText(pText):Void 
	{
		text.text = Localization.getLabel(pText);
		text.textField.anchor.y = 0; 
		/*text.textField.style = { 
								fill:0xFFFFFF, 
								font: 50 + "px " + "Alegreya Sans",
								//align: "left",
								wordWrap: true,
								wordWrapWidth:text.textField.width,
		};*/
	}
	
	private function setUIPosition(pPos:String):Void
	{

		var lPositionnables:Array<UIPositionable> = untyped positionables;
		for (i in 0...lPositionnables.length)
		{
			if (lPositionnables[i].item.name == FTUE_CONTAINER)
			{
				lPositionnables[i].align = pPos;
				lPositionnables[i].offsetX = 800;
				lPositionnables[i].offsetY = 700;
			}
			if (i == 0) lPositionnables[i].item.alpha = 0;
		}
		onResize();
	}

	private function onNext()
	{
		//SmartPopinRegister.event.emit("onNext");
		if (validationFunction != null) validationFunction();
		nextButton.off(MouseEventType.CLICK, onNext);
		nextButton.off(TouchEventType.TAP, onNext);
		off(MouseEventType.CLICK, onNext);
		off(TouchEventType.TAP, onNext);
	}
	
	override function onResize(pEvent:EventTarget = null):Void 
	{
		//GameStage.getInstance().getPopinsContainer
		super.onResize(pEvent);
	}


	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		nextButton.off(MouseEventType.CLICK, onNext);
		nextButton.off(TouchEventType.TAP, onNext);
		off(MouseEventType.CLICK, onNext);
		off(TouchEventType.TAP, onNext);

		instance = null;
		super.destroy();
	}
	
}