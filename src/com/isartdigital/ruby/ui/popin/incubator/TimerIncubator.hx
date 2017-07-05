package com.isartdigital.ruby.ui.popin.incubator;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Adrien Bourdon
 */
class TimerIncubator extends SmartButton
{
	private var INSEMINATE_TIME_TEXT:String = "txt_timer";
	private var INSEMINATE_TEXT:String = "txt_inseminate";
	private var inseminateTimeText:TextSprite;
	private var inseminateText:TextSprite;
	private var hardToSkipTimer:Int = 3;
	private var inseminator:Inseminator;
	
	public var currentName:String;
	public var currentText:String;

	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	public function initText(pIns:Inseminator):Void
	{
		inseminator = pIns;
		currentName = "Passer";
		on(MouseEventType.CLICK, onSkip);
		on(TouchEventType.TAP, onSkip);	
		updateText();
	}
	
	override function _mouseOver(pEvent:EventTarget = null):Void 
	{
		super._mouseOver(pEvent);
		updateText();
	} 
	
	override function _mouseDown(pEvent:EventTarget = null):Void 
	{
		super._mouseDown(pEvent);
		updateText();
	}
	
	override function _mouseOut(pEvent:EventTarget = null):Void 
	{
		super._mouseOut(pEvent);
		updateText();
	}
	
	public function updateText():Void
	{
		inseminateTimeText = cast(getChildByName(INSEMINATE_TIME_TEXT), TextSprite);
		inseminateText = cast(getChildByName(INSEMINATE_TEXT), TextSprite);
		if (currentText != null) inseminateTimeText.textField.text = currentText;
		else inseminateTimeText.textField.text = "";
		inseminateText.textField.text = currentName == null?"Inseminate":currentName;
	}
	
	override function _click(pEvent:EventTarget = null):Void 
	{
		super._click(pEvent);
		updateText();
	}
	
	private function onSkip():Void
	{
		SoundManager.getSound("soundPlayerSkiptime").play();
		UIManager.getInstance().openPopin(DynamicPopin.getInstance());
		if (!FTUEManager.isFTUEon()) DynamicPopin.getInstance().init("Accélerer le temps en dépensant " + hardToSkipTimer + " cristaux ?", onSkiped);
		else DynamicPopin.getInstance().init("Gratuit pour cette fois", onSkiped);
	}
	
	private function onSkiped():Void
	{
		if (Player.getInstance().hasEnoughQuantity(hardToSkipTimer, Player.getInstance().hardCurrency))
		{
			currentName = "Transferer";
			currentText = "Terminer";
			updateText();
			off(MouseEventType.CLICK, onSkip);
			off(TouchEventType.TAP, onSkip);
			if (!FTUEManager.isFTUEon()) Player.getInstance().changePlayerValue( -hardToSkipTimer, Player.TYPE_HARDCURRENCY);
			on(MouseEventType.CLICK, onTransfert);
			on(TouchEventType.TAP, onTransfert);
			inseminator.isSkiped();
		}
		else Hud.getInstance().noHCAnimation();
	}
	
	private function onTransfert():Void
	{
		currentName = "Inseminate";
		currentText = "Terminer";
		updateText();
		inseminator.isTransfered();
		off(MouseEventType.CLICK, onTransfert);
		off(TouchEventType.TAP, onTransfert);
	}
	override public function destroy():Void 
	{
		super.destroy();
		off(MouseEventType.CLICK, onSkip);
		off(TouchEventType.TAP, onSkip);		
	}   
	
}