package com.isartdigital.ruby.ui.popin.incubator;

import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.ruby.ui.popin.building.datas.IncubatorSchema;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Adrien Bourdon
 */
class SchemaSwitchItem extends SwitchGroupItem
{
	private static var NAME = "txt_xenoName";
	private static var ASSET = "asset";
	
	private var nameText:TextSprite;
	private var assetSchema:UISprite;
	
	private var schemaInfo:IncubatorSchema;
	
	

	public function new(pID:String=null) {
		super(pID);
	}
	
	
	override public function init() 
	{
		super.init();
		
		/*assetSchema = cast(getChildByName(ASSET),UISprite);
		assetSchema.visible = false;*/
	}
	public function setInfo(pParams:IncubatorSchema):Void {
	
		schemaInfo = pParams;
		setNormal();
	}
	
	private function updateInfo() {
		if (schemaInfo == null) return;
		nameText.text = schemaInfo.type;
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
		//CentreForage.getInstance().onClickMission(missionParams);
		Incubator.getInstance().onClickSchema(schemaInfo);
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
	}
	
}