package com.isartdigital.ruby.ui.popin;

import com.isartdigital.ruby.game.Spawner;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.contextual.ContextualPopin;
import com.isartdigital.ruby.ui.specialButtons.Textbutton;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import js.Lib;

	
/**
 * ...
 * @author Michael Wilkins
 */
class ConfirmationPose extends ContextualPopin 
{
	
	/**
	 * instance unique de la classe ConfirmationPose
	 */
	private static var instance: ConfirmationPose;
	
	private static inline var CANCEL_BTN:String = "btn_ConfirmReturn";
	
	
	//private static inline var SCMN_CNTNER:String = "ConfirmationPose_clipSwitchButtonSC";
	private static inline var SCMN_BTN_NORMAL:String = "ConfirmationPose_ButtonSC";
	//private static inline var SCMN_BTN_SELECTED:String = "btn_AchatSCSelected";
	private static inline var SCMN_YES_BTN:String = "btn_YesBuySC";
	private static inline var SCMN_NO_BTN:String = "btn_NoBuySC";
	
	//private static inline var HC_CNTNER:String = "ConfirmationPose_clipSwitchButtonHC";
	private static inline var HC_BTN_NORMAL:String = "ConfirmationPose_ButtonHC";
	//private static inline var HC_BTN_SELECTED:String = "btn_AchatHCSelected";
	private static inline var HC_YES_BTN:String = "btn_YesBuyHC";
	private static inline var HC_NO_BTN:String = "btn_NoBuyHC";
	
	
	private static inline var HC_TEXT_CNTNER:String = "ConfirmationPose_clipPriceHCInfos";
	private static inline var SCMN_TEXT_CNTNER:String = "ConfirmationPose_clipPriceSCInfos";
	private static inline var SC_TEXT:String = "txt_SCPrice";
	private static inline var HC_TEXT:String = "txt_HCPrice";
	private static inline var MN_TEXT:String = "txt_MNPrice";
	
	
	private var cancelButton:SmartButton;
	
	private var currentBuilding:GameElement;
	
	private var scmnButtonNormal:Textbutton;
	private var scmnYesButton:SmartButton;
	private var scmnNoButton:SmartButton;
	
	private var hcButtonNormal:Textbutton;
	private var hcYesButton:SmartButton;
	private var hcNoButton:SmartButton;
	
	
	//private var scmnInfoContainerNormal:SmartComponent;
	//private var hcInfoContainerNormal:SmartComponent;
	//private var scmnInfoInvisible:SmartComponent;
	//private var hcInfoInvisible:SmartComponent;
	
	//private var scTextNormal:TextSprite;
	//private var hcTextNormal:TextSprite;
	//private var mnTextNormal:TextSprite;
	
	public var noSC:Bool = false;
	public var noMN:Bool = false;
	public var noHC:Bool = false;
	
	public var scValue:String;
	public var mnValue:String;
	public var hcValue:String;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ConfirmationPose {
		if (instance == null) instance = new ConfirmationPose();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = false;
	}
	
	
	
	public function init(pBuiding:GameElement):Void
	{	
		currentBuilding = pBuiding;
		cancelButton = cast(getChildByName(CANCEL_BTN),SmartButton);
		scmnButtonNormal = cast(getChildByName(SCMN_BTN_NORMAL),Textbutton);
		
		//hcContainer = cast(getChildByName(HC_CNTNER),SmartComponent);
		hcButtonNormal = cast(getChildByName(HC_BTN_NORMAL),Textbutton);
		//hcButtonSelected = cast(hcContainer.getChildByName(HC_BTN_SELECTED), SmartButton);
		
		scmnYesButton = cast(getChildByName(SCMN_YES_BTN),SmartButton);
		scmnNoButton = cast(getChildByName(SCMN_NO_BTN),SmartButton);
		hcYesButton = cast(getChildByName(HC_YES_BTN),SmartButton);
		hcNoButton = cast(getChildByName(HC_NO_BTN), SmartButton);
		
		
		//scmnInfoContainerNormal = cast(scmnButtonNormal.getChildByName(SCMN_TEXT_CNTNER), SmartComponent);
		//hcInfoInvisible = cast(scmnButtonNormal.getChildByName(HC_TEXT_CNTNER), SmartComponent);
		//hcInfoInvisible.visible = false;
		//hcInfoContainerNormal = cast(hcButtonNormal.getChildByName(HC_TEXT_CNTNER), SmartComponent);
		//scmnInfoInvisible = cast(hcButtonNormal.getChildByName(SCMN_TEXT_CNTNER), SmartComponent);
		//scmnInfoInvisible.visible = false;
		
		//scTextNormal = cast(scmnInfoContainerNormal.getChildByName(SC_TEXT), TextSprite);
		//mnTextNormal = cast(scmnInfoContainerNormal.getChildByName(MN_TEXT), TextSprite);
		//hcTextNormal = cast(hcInfoContainerNormal.getChildByName(HC_TEXT), TextSprite);
		
		scmnButtonNormal.SCMNMode();
		hcButtonNormal.HCMode();
		
		cancelButton.on(MouseEventType.CLICK, onCancel);
		scmnYesButton.on(MouseEventType.CLICK, payWithSCMN);
		scmnNoButton.on(MouseEventType.CLICK, hideScmnConfirmButtons);
		hcYesButton.on(MouseEventType.CLICK, payWithHC);
		hcNoButton.on(MouseEventType.CLICK, hideHcConfirmButtons);
		scmnButtonNormal.on(MouseEventType.CLICK, displayScmnConfirmButtons);
		hcButtonNormal.on(MouseEventType.CLICK, displayHcConfirmButtons);
		
		//scmnButtonNormal.on(MouseEventType.MOUSE_OVER, DisplayCost);
		//hcButtonNormal.on(MouseEventType.MOUSE_OVER, DisplayCost);
		
		cancelButton.on(TouchEventType.TAP, onCancel);
		scmnYesButton.on(TouchEventType.TAP, payWithSCMN);
		scmnNoButton.on(TouchEventType.TAP, hideScmnConfirmButtons);
		hcYesButton.on(TouchEventType.TAP, payWithHC);
		hcNoButton.on(TouchEventType.TAP, hideHcConfirmButtons);
		scmnButtonNormal.on(TouchEventType.TAP, displayScmnConfirmButtons);
		hcButtonNormal.on(TouchEventType.TAP, displayHcConfirmButtons);
		
		

		scmnYesButton.visible = false;
		scmnNoButton.visible = false;
		hcYesButton.visible = false;
		hcNoButton.visible = false;	
		
		SmartPopinRegister.event.emit("onInit");
		
	}
	override public function close():Void 
	{
		hideHcConfirmButtons();
		hideScmnConfirmButtons();
		super.close();
	}
	
	public function updateValues(pSC:Int, pMN:Int, pHC:Int) {
	
		scValue = Std.string(pSC);
		mnValue = Std.string(pMN);
		hcValue = Std.string(pHC);
		DisplayCost();
	}
	public function DisplayCost():Void {
	
		if (scValue != null && mnValue != null && hcValue != null) {
			trace(scValue, mnValue);
			if (Std.parseInt(scValue) > 0 && Std.parseInt(mnValue) > 0 ) scmnButtonNormal.displayTextSCMN();
			else scmnButtonNormal.visible = false;
			hcButtonNormal.displayTextHC();
			
		}
		
	}
	
	private function displayScmnConfirmButtons():Void {
	
		scmnYesButton.visible = true;
		scmnNoButton.visible = true;
		hideHcConfirmButtons();
		cancelButton.visible = false;
		SoundManager.getSound("soundPlayerSwitchMode").play();
		scmnButtonNormal.on(MouseEventType.CLICK, hideScmnConfirmButtons);
		DisplayCost();
	}
	
	
	private function displayHcConfirmButtons():Void {
	
		hcYesButton.visible = true;
		hcNoButton.visible = true;
		hideScmnConfirmButtons();
		cancelButton.visible = false;
		SoundManager.getSound("soundPlayerSwitchMode").play();
		hcButtonNormal.on(MouseEventType.CLICK, hideHcConfirmButtons);
		
		DisplayCost();
	}
	
	private function hideScmnConfirmButtons():Void {
	
		scmnYesButton.visible = false;
		scmnNoButton.visible = false;
		cancelButton.visible = true;
		SoundManager.getSound("soundPlayerSwitchMode").play();
		scmnButtonNormal.on(MouseEventType.CLICK, displayScmnConfirmButtons);
		
	}
	
	
	private function hideHcConfirmButtons():Void {
	
		hcYesButton.visible = false;
		hcNoButton.visible = false;
		cancelButton.visible = true;
		SoundManager.getSound("soundPlayerSwitchMode").play();
		hcButtonNormal.on(MouseEventType.CLICK, displayHcConfirmButtons);
	}
	
	

	private function onCancel()
	{
		resetValues();
		UIManager.getInstance().closeCurrentPopin();
		SoundManager.getSound("soundPlayerSwitchMode").play();
		Spawner.getInstance().cancel();
	}
	
	private function payWithSCMN():Void {
		
		if (noSC || noMN) {
		
			if (noSC) Hud.getInstance().noSCAnimation();
			if (noMN) Hud.getInstance().noMaterialAnimation();
		}
		else {
			SmartPopinRegister.event.emit("onYes");
			SoundManager.getSound("soundPlayerValidate").play();
			Spawner.getInstance().onClick();
			resetValues();
			UIManager.getInstance().closeCurrentPopin();
		}
		
	}
	
	private function payWithHC():Void {
		
		if (noHC) Hud.getInstance().noHCAnimation();
		else {
			SmartPopinRegister.event.emit("onYes");
			SoundManager.getSound("soundPlayerValidate").play();
			Spawner.getInstance().isPayingWithHC = true;
			Spawner.getInstance().onClick();
			resetValues();
			UIManager.getInstance().closeCurrentPopin();
		}
	}
	
	
	private function resetValues():Void {
	
		noHC = false;
		noMN = false;
		noSC = false;
	}
	
	
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		//
		cancelButton.off(MouseEventType.CLICK, onCancel);
		scmnYesButton.off(MouseEventType.CLICK, payWithSCMN);
		scmnNoButton.off(MouseEventType.CLICK, hideScmnConfirmButtons);
		hcYesButton.off(MouseEventType.CLICK, payWithHC);
		hcNoButton.off(MouseEventType.CLICK, hideHcConfirmButtons);
		scmnButtonNormal.off(MouseEventType.CLICK, displayScmnConfirmButtons);
		//scmnButtonSelected.off(MouseEventType.CLICK, hideScmnConfirmButtons);
		hcButtonNormal.off(MouseEventType.CLICK, displayHcConfirmButtons);
		//hcButtonSelected.off(MouseEventType.CLICK, hideHcConfirmButtons);
		
		cancelButton.off(TouchEventType.TAP, onCancel);
		scmnYesButton.off(TouchEventType.TAP, payWithSCMN);
		scmnNoButton.off(TouchEventType.TAP, hideScmnConfirmButtons);
		hcYesButton.off(TouchEventType.TAP, payWithHC);
		hcNoButton.off(TouchEventType.TAP, hideHcConfirmButtons);
		scmnButtonNormal.off(TouchEventType.TAP, displayScmnConfirmButtons);
		//scmnButtonSelected.off(TouchEventType.TAP, hideScmnConfirmButtons);
		hcButtonNormal.off(TouchEventType.TAP, displayHcConfirmButtons);
		//hcButtonSelected.off(TouchEventType.TAP, hideHcConfirmButtons);
		instance = null;
		super.destroy();
		//parent.removeChild(this);
	}

}