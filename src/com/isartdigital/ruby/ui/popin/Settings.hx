package com.isartdigital.ruby.ui.popin;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.services.monetization.Ads;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import howler.Howler;

	
/**
 * ...
 * @author Michael Wilkins
 */
class Settings extends SmartScreen 
{
	
	/**
	 * instance unique de la classe Settings
	 */
	private static var instance: Settings;
	private var close_btn:SmartButton;
	private var moreGame_btn:SmartButton;
	private var audioOn:SmartComponent;
	private var audioOff:SmartComponent;
	private static inline var CLOSE_BTN:String = "btn_Close";
	private static inline var MOREGAME_BTN:String = "btn_MoreGames";
	private static inline var BTN_AUDIO_ON:String = "btn_AudioOn";
	private static inline var BTN_AUDIO_OFF:String = "btn_AudioOff";
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Settings {
		if (instance == null) instance = new Settings();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = true;
		
		audioOff = cast(getChildByName(BTN_AUDIO_OFF), SmartComponent);
		audioOn = cast(getChildByName(BTN_AUDIO_ON), SmartComponent);
		
		audioOff.interactive = true;
		audioOn.interactive = true;
		
		audioOff.on(MouseEventType.CLICK, onAudioOff);
		audioOff.on(TouchEventType.TAP, onAudioOff);
		audioOn.on(MouseEventType.CLICK, onAudioOn);
		audioOn.on(TouchEventType.TAP, onAudioOn);
		
		close_btn = cast(getChildByName(CLOSE_BTN), SmartButton);
		close_btn.on(MouseEventType.CLICK, onClose);
		close_btn.on(TouchEventType.TAP, onClose);
		
		moreGame_btn = cast(getChildByName(MOREGAME_BTN), SmartButton);
	}
	
	
	private function onClose():Void{
		UIManager.getInstance().openScreen(Hud.getInstance());
		Hud.getInstance().update();
	}
	
	private function onAudioOn():Void
	{
		Howler.mute(false);
	}
	
	private function onAudioOff():Void
	{
		Howler.mute(true);
	}
	
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}