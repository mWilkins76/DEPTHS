package com.isartdigital.ruby.ui.items.switchItems;
import com.isartdigital.ruby.ui.popin.building.datas.Missions;
import com.isartdigital.ruby.ui.popin.centreForage.CentreForage;
import com.isartdigital.utils.ui.smart.TextSprite;

/**
 * ...
 * @author Jordan Dachicourt
 */
class MissionSwitchItem extends SwitchGroupItem
{
	
	private static var NAME = "txt_CentreForagemissionName";
	private static var COULDOWN_DISPLAY = "txt_CentreForagedrillCooldownDisplayV2";
	
	private var nameText:TextSprite;
	//private var couldownDisplayText:TextSprite;
	
	private var missionParams:Missions;
	private var rewardParams:Reward;
	
	
	

	public function new(pID:String=null) {
		super(pID);
	}
	
	
	
	public function setInfo(pParams:Missions):Void {
	
		missionParams = pParams;
		//couldownDisplayText.visible = false;
		setNormal();
	}
	
	private function updateInfo() {
		if (missionParams == null) return;
		nameText.text = missionParams.name;
		
	}
	override public function setNormal() 
	{
		super.setNormal();
		
		updateTextChild();
		updateInfo();
	}
	
	override public function setDisabled() 
	{
		super.setDisabled();
		
		updateTextChild();
		updateInfo();
	}
	
	override public function setSelected() 
	{
		super.setNormal();
		CentreForage.getInstance().onClickMission(missionParams);
		updateTextChild();
		updateInfo();
	}
	
	override function onOver():Void 
	{
		super.onOver();
		updateTextChild();
		updateInfo();
	}
	
	override function onOut():Void 
	{
		super.onOut();
		updateTextChild();
		updateInfo();
	}
	function updateTextChild() {
		nameText = cast(currentState.getChildByName(NAME), TextSprite);
		//couldownDisplayText = cast(currentState.getChildByName(COULDOWN_DISPLAY), TextSprite);
	}
	
}