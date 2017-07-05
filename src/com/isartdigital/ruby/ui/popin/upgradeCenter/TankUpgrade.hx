package com.isartdigital.ruby.ui.popin.upgradeCenter;

import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.UpgradeCenterSwitchItem;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import js.Lib;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class TankUpgrade extends SmartComponent
{

	public var tankXenos:SmartComponent;
	public var cartouche:SmartComponent;
	private var xenoName:TextSprite;
	private var time:TextSprite;
	private var costMN:TextSprite;
	
	
	
	private var isEmpty:Bool;
	
	private var level:TextSprite;
	private var btnUpgrade:SmartButton;
	private var btnManage:SmartButton;
	private var btnSkip:SmartButton;
	
	
	public var alien:AlienElement;
	
	private static var XENO_SLOT:String = "SwitchSlotXeno";
	private static var CARTOUCHE:String = "UpgradeCenter_clipIntituleXenos";
	public function new(pID:String=null) 
	{
		super(pID);
		initTank();
	}
	
	private function initTank():Void
	{
		tankXenos =  cast(getChildByName(XENO_SLOT), SmartComponent) ;
		
		cartouche =  cast(getChildByName(CARTOUCHE), SmartComponent) ;
		xenoName = cast(cartouche.getChildByName("txt_xenoNameUpgrading"), TextSprite) ;
		time = cast(cartouche.getChildByName("txt_UpgradeDelayDisplay"), TextSprite) ;
		time.visible = false;
		costMN = cast(cartouche.getChildByName("txt_CostUpgradeDisplay"), TextSprite) ;
		
		level = cast(getChildByName("txt_level"), TextSprite) ;
		
		btnManage =  cast(getChildByName("btn_Manage"), SmartButton) ;
		btnManage.visible = false;
		btnUpgrade =  cast(getChildByName("btn_Upgrade"), SmartButton) ;
		btnSkip =  cast(getChildByName("btn_Skip"), SmartButton) ;
		btnSkip.visible = false;
		xenoName.text = "tutui tiu";
		
		costMN.text = "1000";
		
		if (!isEmpty)
		{
			tankXenos.getChildByName("Disabled").visible = false;
			tankXenos.getChildByName("Selected").visible = false;
		}
		
		
	}
	
	public function setAlien(pAlien:AlienElement):Void
	{
		alien = pAlien;
		xenoName.visible = false;
		
		
		
	}
	
}