package com.isartdigital.ruby.ui.popin.buyRegion;
import com.isartdigital.ruby.game.GameManager;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.contextual.ContextualPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author Michael Wilkins
 */
class BuyRegion extends ContextualPopin
{
	public var tooltip:RegionSwitch;
	public var yesBtn:SmartButton;
	private var noBtn:SmartButton;
	
	private var ownRegion:Region;
	

	public function new(pID:String=null) 
	{
		super(pID);
		modal = false;
		
		tooltip = cast(getChildByName("RegionSwitch"), RegionSwitch);
		yesBtn = cast(getChildByName("btn_YesBuySC"), SmartButton);
		noBtn = cast(getChildByName("btn_NoBuySC"), SmartButton);
		tooltip.setOwnPopin(this);
		hideConfirmButtons();
		
		yesBtn.on(MouseEventType.CLICK, buyRegion);
		yesBtn.on(TouchEventType.TAP, buyRegion);
		
		//setCost();
	}
	
	public function setOwnRegion(pRegion:Region) {
	
		ownRegion = pRegion;
	}
	
	
	public function displayCost():Void {
	
		tooltip.setText(World.getInstance().unlockRegionCost);
	}
	
	public function displayConfirmButtons():Void {
	
		yesBtn.visible = true;
		//noBtn.visible = true;
	}
	
	public function hideConfirmButtons():Void {
	
		yesBtn.visible = false;
		noBtn.visible = false;
	}
	
	private function unlock():Void {
	
		if (ownRegion == null) return;
		
		ownRegion.unlock();
	}
	
	private function pay():Void {
	
		if (!GameManager.getInstance().godMode) {
			Player.getInstance().changePlayerValue(-World.getInstance().unlockRegionCost, Player.TYPE_SOFTCURRENCY, false);
		}
	}
	
	private function canAffortIt():Bool {
	
		if (GameManager.getInstance().godMode) return true;
		else {
		
			var lHasEnoughSC:Bool = Player.getInstance().hasEnoughQuantity(World.getInstance().unlockRegionCost, Player.getInstance().softCurrency);
			if (lHasEnoughSC) return true;
			else {
				Hud.getInstance().noSCAnimation();
				return false;
			}
		}
	}
	
	private function buyRegion():Void {
	
		if (canAffortIt()) {
		
			pay();
			unlock();
		}
	}
}