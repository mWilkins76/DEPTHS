package com.isartdigital.ruby.ui.popin;

import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import eventemitter3.EventEmitter;
import haxe.Constraints.Function;

	
/**
 * ...
 * @author qPk
 */
class DynamicPopin extends SmartPopinRegister 
{
	
	/**
	 * instance unique de la classe DynamicPopin
	 */
	private static var instance: DynamicPopin;
	
	private static inline var TEXT:String = "txt_destroyBuildingConfirm";
	private static inline var YES_BTN:String = "btn_Yes";
	private static inline var NO_BTN:String = "btn_No";
	
	private var yesButton:SmartButton;
	private var noButton:SmartButton;
	
	private var validationFunction:Function;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DynamicPopin {
		if (instance == null) instance = new DynamicPopin();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */	
	private function new(pID:String=null)
	{
		super("Destruction");
		componentName = "DynamicPopin";
		yesButton = cast(getChildByName(YES_BTN),SmartButton);
		noButton = cast(getChildByName(NO_BTN), SmartButton);
	}
	
	/**
	 * initialise la popin de confirmation 
	 * @param	pQuestion : question à confirmer
	 * @param	pFunction : fonction à executer si confirmation
	 */
	public function init(pQuestion:String, pFunction:Function):Void 
	{
		var questionText:TextSprite = cast(getChildByName(TEXT), TextSprite);
		questionText.y -= 80;
		questionText.text = pQuestion;
		validationFunction = pFunction;
		
		
		yesButton.on(MouseEventType.CLICK, onYes);
		noButton.on(MouseEventType.CLICK, onNo);

		yesButton.on(TouchEventType.TAP, onYes);
		noButton.on(TouchEventType.TAP, onNo);		
	}

	private function onYes()
	{
		if(validationFunction != null)validationFunction();
		UIManager.getInstance().closePopin(this);
		MapInteractor.getInstance().closeInfoPanel();
	}

	private function onNo()
	{
		UIManager.getInstance().closeCurrentPopin();
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		yesButton.off(MouseEventType.CLICK, onYes);
		noButton.off(MouseEventType.CLICK, onNo);

		yesButton.off(TouchEventType.TAP, onYes);
		noButton.off(TouchEventType.TAP, onNo);

		instance = null;
		super.destroy();
	}
}