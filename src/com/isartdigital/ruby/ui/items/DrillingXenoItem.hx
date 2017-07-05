package com.isartdigital.ruby.ui.items;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author Jordan Dachicourt
 */
class DrillingXenoItem extends SwitchGroupItem
{
	
	static inline var CONTENT_TIMER:String = "txt_XenoCooldownDisplay";
	static inline var CONTENT_STAMINA:String = "txt_CentreForageStaminaDisplay";
	static inline var CONTENT_NAME:String = "txt_centreForageXenoName";
	static inline var CONTENT_CLASS:String = "txt_CentreForageXenoClass";
	static inline var CONTENT_AVATAR:String = "CentreForage_spriteStaminaAvatar";
	
	var nameTxt:TextSprite;
	var classTxt:TextSprite;
	var staminaTxt:TextSprite;
	//var timerTxt:TextSprite;
	var alien:AlienElement;
	
	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	override public function init() 
	{
		super.init();
	}
	function updateTextChild() {
		nameTxt = cast(currentState.getChildByName(CONTENT_NAME), TextSprite);
		classTxt = cast(currentState.getChildByName(CONTENT_CLASS), TextSprite);
		staminaTxt = cast(currentState.getChildByName(CONTENT_STAMINA), TextSprite);
		//timerTxt = cast(currentState.getChildByName(CONTENT_TIMER), TextSprite);
	}
	
	override public function setNormal() 
	{
		super.setNormal();
		
		updateTextChild();
		update();
	}

	
	override public function setDisabled() 
	{
		super.setNormal();
		
		updateTextChild();
		update();
	}
	
	override public function setSelected() 
	{
		super.setNormal();
		
		updateTextChild();
		update();
	}
	
	public function initAlien(pAlien:AlienElement):Void
	{
		alien = pAlien;
		prefix = "XenosThumbnail_";
		assetName = pAlien.name+"_Normal";
		setNormal();
	}
	
	override function onOver():Void 
	{
		super.onOver();
		updateTextChild();
		update();
	}
	
	override function onOut():Void 
	{
		super.onOut();
		updateTextChild();
		update();
	}
	
	public function update() {
		if (alien == null) return;
		nameTxt.text = alien.name;
		classTxt.text = alien.carac.power;
		staminaTxt.text = Std.string(alien.stamina);	
	}
	
	override function monClick():Void 
	{
		super.monClick();
		CentreForage.getInstance().alienSelected = alien;
	}
	
}