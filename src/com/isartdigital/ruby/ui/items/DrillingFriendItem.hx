package com.isartdigital.ruby.ui.items;

import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Jordan Dachicourt
 */
class DrillingFriendItem extends Item
{
	static inline var XENO_LEVEL:String = "txt_CentreForageLevel";
	static inline var PLAYER_NAME:String = "txt_CentreForageplayerName";
	static inline var BTN:String = "btn_Friend";
	
	private var btn:SmartButton;
	private var playerName:TextSprite;
	private var xenoLevel:TextSprite;
	
	
	
	public var alien:AlienElement;

	public function new(pID:String=null) 
	{
		super(pID);
		btn = cast(getChildByName(BTN), SmartButton);
		playerName = cast(btn.getChildByName(PLAYER_NAME), TextSprite);
		xenoLevel = cast(btn.getChildByName(XENO_LEVEL), TextSprite);
	}
	
	public function setAlienElem(pAlien:AlienElement):Void {
	
		alien = pAlien;
		var btn:SmartButton = cast(getChildByName("btn_Friend"), SmartButton);
		
		cast(btn.getChildByName("asset"), UISprite).visible = false;
		var assetsItem:UISprite = new UISprite("XenosThumbnail_"+ pAlien.name+"_Normal");
		assetsItem.position = cast(btn.getChildByName("asset"), UISprite).position;
		addChild(assetsItem);
		
		update();
	}
	
	override function onOver():Void 
	{
		super.onOver();
		update();
	}
	
	override function onOut():Void 
	{
		super.onOut();
		update();
	}
	
	override function monClick():Void 
	{
		super.monClick();
		update();
	}
	
	private function update():Void {
	
		for (friend in DataManager.getInstance().friendsList) if (friend.id == alien.idPlayer) {
		
			playerName.text = friend.nameFb;
		}
		xenoLevel.text = Std.string(alien.level);
	}
	
	
	
}