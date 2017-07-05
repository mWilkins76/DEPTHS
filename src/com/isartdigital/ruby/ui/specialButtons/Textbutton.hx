package com.isartdigital.ruby.ui.specialButtons;

import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.ruby.ui.popin.ConfirmationPose;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Michael Wilkins
 */
class Textbutton extends Item
{

	
	private static inline var HC_TEXT_CNTNER:String = "ConfirmationPose_clipPriceHCInfos";
	private static inline var SCMN_TEXT_CNTNER:String = "ConfirmationPose_clipPriceSCInfos";
	private static inline var SC_TEXT:String = "txt_SCPrice";
	private static inline var HC_TEXT:String = "txt_HCPrice";
	private static inline var MN_TEXT:String = "txt_MNPrice";
	private static inline var PAY_BTN:String = "pay_btn";
	
	private var scmnInfoContainerNormal:SmartComponent;
	private var hcInfoContainerNormal:SmartComponent;
	
	private var scTextNormal:TextSprite;
	private var hcTextNormal:TextSprite;
	private var mnTextNormal:TextSprite;
	private var payBtn:SmartButton;
	
	public var scValue:String;
	public var mnValue:String;
	public var hcValue:String;
	
	private var isInHCMode:Bool = false;
	
	public function new(pID:String=null) 
	{
		super(pID);
		scmnInfoContainerNormal = cast(getChildByName(SCMN_TEXT_CNTNER), SmartComponent);
		hcInfoContainerNormal = cast(getChildByName(HC_TEXT_CNTNER), SmartComponent);
		scTextNormal = cast(scmnInfoContainerNormal.getChildByName(SC_TEXT), TextSprite);
		mnTextNormal = cast(scmnInfoContainerNormal.getChildByName(MN_TEXT), TextSprite);
		hcTextNormal = cast(hcInfoContainerNormal.getChildByName(HC_TEXT), TextSprite);
		payBtn = cast(getChildByName(PAY_BTN), SmartButton);
	}
	
	public function HCMode():Void {
	
		isInHCMode = true;
		scmnInfoContainerNormal.visible = false;
	}
	
	public function SCMNMode():Void {
	
		hcInfoContainerNormal.visible = false;
	}
	
	override function onOver():Void 
	{
		payBtn.overBuild(1);
	}
	
	override function onOut():Void 
	{
		payBtn.overBuild(0);
	}
	
	override function onDown():Void 
	{
		payBtn.overBuild(2);
	}
	//override function _mouseOver(pEvent:EventTarget = null):Void 
	//{
		//super._mouseOver(pEvent);
		//isInHCMode ? displayTextHC():displayTextSCMN();
		//
	//}
	//
	//override function _mouseOut(pEvent:EventTarget = null):Void 
	//{
		//super._mouseOut(pEvent);
		////isInHCMode ? displayTextHC():displayTextSCMN();
	//}
	
	public function displayTextHC():Void {
		
		HCMode();
		hcTextNormal.text = ConfirmationPose.getInstance().hcValue;
		
	}
	
	public function displayTextSCMN():Void {
	
		SCMNMode();
		scTextNormal.text = ConfirmationPose.getInstance().scValue;
		mnTextNormal.text = ConfirmationPose.getInstance().mnValue;
	}
	
}