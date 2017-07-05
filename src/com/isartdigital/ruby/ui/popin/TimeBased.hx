package com.isartdigital.ruby.ui.popin;

import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Constraints.Function;
import js.Lib;

	
/**
 * ...
 * @author Michael Wilkins
 */
class TimeBased extends MenuClosable 
{
	
	/**
	 * instance unique de la classe TimeBased
	 */
	private static var instance: TimeBased;
	
	private var btnSkip:SmartButton;
	private var buikdingName:TextSprite;
	private var time:TextSprite;
	private var price:TextSprite;
	private var hcSprite:UISprite;
	private var skipText:TextSprite;
	
	private var currentBuilding:Building;
	
	private var validationFunction:Function;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TimeBased {
		if (instance == null) instance = new TimeBased();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		btnSkip = cast(getChildByName("btn_Skip"), SmartButton);
		buikdingName = cast(getChildByName("Title_Txt"), TextSprite);
		time = cast(getChildByName("RemainingTime_Txt"), TextSprite);
		price = cast(getChildByName("TimeBased_txt_HCDisplay"), TextSprite);
		skipText = cast(getChildByName("SkipPrice_Txt"), TextSprite);
		hcSprite = cast(getChildByName("HCsprite"), UISprite);
		
		init();
	}
	
	override public function open():Void 
	{
		super.open();
		SoundManager.getSound("soundPlayerSkiptime").play();
	}
	
	public function setText(pbuilding:Building):Void 
	{
		currentBuilding = pbuilding;
		buikdingName.text = currentBuilding.name;
		validationFunction = pbuilding.cdTimerSkiped;
		
		if(FTUEManager.isFTUEon()) {
			price.text = "Gratuit";
			hcSprite.visible = false;
			skipText.visible = false;
			
		}
		else price.text = "3";
		
		btnSkip.on(MouseEventType.CLICK, onYes);

		btnSkip.on(TouchEventType.TAP, onYes);
	}
	
	
	private function onYes()
	{
		if(validationFunction != null)validationFunction();
		UIManager.getInstance().closePopin(this);
		MapInteractor.getInstance().closeInfoPanel();
	}
	
	public function refreshText():Void {
	
		if (currentBuilding != null) {
			//Lib.debug();
			if(currentBuilding.timeConstruction != null) time.text = currentBuilding.timeConstruction;
			
		}
		
	}


	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}