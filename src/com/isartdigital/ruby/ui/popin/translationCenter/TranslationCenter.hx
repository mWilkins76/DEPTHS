package com.isartdigital.ruby.ui.popin.translationCenter;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.translationClass.SchemaType;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.translationClass.Schemas;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.MenuClosable;
import com.isartdigital.ruby.ui.popin.building.datas.IncubatorSchema;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.system.Localization;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import js.html.MouseEvent;

	
/**
 * ...
 * @author Julien Fournier
 */
class TranslationCenter extends MenuClosable 
{
	
	/**
	 * instance unique de la classe TranslationCenter
	 */
	private static var instance: TranslationCenter;
	
	//private var PlayerSchemas:Array<>
	
	private static inline var TXT_TRAD:String = "LABEL_TRANSLATION_CENTER_NO_SCHEMA";

	private static inline var TXT_TITLE:String = "TranslationCenter_txt_TranslationCenter";
	
	private static inline var PARCHEMIN:String = "TranslationCenter_clipSwitchParchment";
		private static inline var TXT_PARCH_COUNT:String = "TranslationCenter_txt_parchmentCount";
		private static inline var TXT_PARCH_NAME:String = "TranslationCenter_txt_ParchmentName";

		
	private static inline var BTN_SKIPTIME:String = "TranslationCenter_btn_SkipTime";
	
	private static inline var TIMER_WINDOW:String = "TranslationCenter_TimerWindow";
		private static inline var TXT_TIMER:String = "TranslationCenter_txt_timerWindowtimer";
	
	private static inline var BTN_TRANSLATE:String = "TranslationCenter_btn_Translate";
	
	private var lockedSchema:Int;

	
	private var txtTitle:TextSprite;
	private var parchemin:SmartComponent;		
		private var txtParcheminCount:TextSprite;
		private var txtParcheminName:TextSprite;

	private var btnSkipTimer:SmartButton;
	
	private var timer:SmartComponent;
		private var txtTimer:TextSprite;
	
	private var btnTranslate:SmartButton;
	
	private var schema:Schemas;
	
	public var schemaInDecryptMode:Array<Schemas> = [];
	public var currentSchema:Schemas;
		
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TranslationCenter {
		if (instance == null) instance = new TranslationCenter();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		init();
	}
	
	override public function init():Void
	{
		super.init();

		
		txtTitle = cast(getChildByName(TXT_TITLE), TextSprite);
		
		parchemin = cast(getChildByName(PARCHEMIN), SmartComponent); 	
				txtParcheminCount = cast(parchemin.getChildByName(TXT_PARCH_COUNT), TextSprite); 
				txtParcheminName = cast(parchemin.getChildByName(TXT_PARCH_NAME), TextSprite);
		
		btnSkipTimer = cast(getChildByName(BTN_SKIPTIME), SmartButton);
		
		timer = cast(getChildByName(TIMER_WINDOW), SmartComponent);
			txtTimer = cast(timer.getChildByName(TXT_TIMER), TextSprite);
		
		btnTranslate = cast(getChildByName(BTN_TRANSLATE), SmartButton);
		
		updatePoppin();
		var lockedSchemaList:Array<Schemas> = DataManager.getInstance().getLockedSchemas();
		for (schema in lockedSchemaList)
		{
			if (schema.isLocked == 1 && (schema.startDecrypt) != Date.fromString("0000-00-00 00:00:00"))
			{
				//translate();
				currentSchema = schema;
			}
		}

	}
	
	public function updatePoppin():Void
	{
		lockedSchema = DataManager.getInstance().getPlayerSchemaCount(true);
		
		txtParcheminCount.text = Std.string("x "+lockedSchema);
		
		if (lockedSchema == 0)
		{
			btnSkipTimer.visible = false;
			timer.visible = false;
			btnTranslate.visible = false;
			txtParcheminCount.visible = false;
			txtParcheminName.text = Localization.getLabel(TXT_TRAD);
		}
		else
		{
			btnTranslate.on(MouseEventType.CLICK, translate);
			btnTranslate.on(TouchEventType.TAP, translate);
			btnTranslate.visible = true;
			btnSkipTimer.visible = false;
			timer.visible = false;
		}
	}
	
	
	public function translate():Void
	{
		btnTranslate.visible = false;
		btnSkipTimer.visible = true;
		timer.visible = true;
		decryptSchema();
	}
	
	public function decryptSchema():Void
	{
		btnTranslate.off(MouseEventType.CLICK, translate);
		btnTranslate.off(TouchEventType.TAP, translate);
		
		btnSkipTimer.on(MouseEventType.CLICK, skipTime);
		btnSkipTimer.on(TouchEventType.TAP, skipTime);
		
		var lockedSchemaList:Array<Schemas> = DataManager.getInstance().getLockedSchemas();
		schema = lockedSchemaList[lockedSchemaList.length - 1];

		var lShemaType:IncubatorSchema = Incubator.listSchema.get("" + schema.idSchema);
		var decryptTime:String = lShemaType.decryptTime;
		
		schema.startDecrypt = Date.now();
		schema.endDecrypt = Date.fromTime(schema.startDecrypt.getTime() + Date.fromString(decryptTime).getTime());

		//DataBaseAction.getInstance().startUnlockSchema(schema.idSchema, schema.startDecrypt, schema.endDecrypt);
		schemaInDecryptMode.push(schema);
		currentSchema = schemaInDecryptMode[0];
	}

	
	public function doAction():Void
	{
		if (currentSchema == null || checkDecryptTime(currentSchema)) return;
		
		txtTimer.text = TimeManager.getInstance().getTimeToFinishBuildingStringFormat(currentSchema.endDecrypt);
		
	}
	
	public function checkDecryptTime(pSchema:Schemas):Bool
	{	
		if (Date.now().getTime() > pSchema.endDecrypt.getTime())
		{
			DataBaseAction.getInstance().unlockSchema(pSchema.idSchema);
			var lIndex:Int = DataManager.getInstance().schemasList.indexOf(pSchema);
			pSchema.isLocked = 0;
			DataManager.getInstance().schemasList[lIndex] = pSchema;
			schemaInDecryptMode.pop();
			updatePoppin();
			return true;
		}
		return false;
	}
	
	public function skipTime():Void
	{
		var HCCost:Int = 5;
		
		UIManager.getInstance().openPopin(DynamicPopin.getInstance());
		DynamicPopin.getInstance().init("Accélerer le temps en dépensant " + HCCost + " cristaux ?", timerSkipped);
	}
	
	public function timerSkipped():Void
	{
		var HCCost:Int = 5;
		if (Player.getInstance().hasEnoughQuantity(HCCost, Player.getInstance().hardCurrency))
		{
			Player.getInstance().changePlayerValue(-HCCost,"hardCurrency");
			btnSkipTimer.off(MouseEventType.CLICK, skipTime);
			btnSkipTimer.off(TouchEventType.TAP, skipTime);
			currentSchema.isLocked = 0;
			schemaInDecryptMode.pop();
			//currentSchema.startDecrypt = Date.fromTime(currentSchema.endDecrypt);
			DataBaseAction.getInstance().unlockSchema(currentSchema.idSchema);
			updatePoppin();
		}
		else Hud.getInstance().noHCAnimation();
	}
	
	override public function close():Void 
	{
		super.close();
		MapInteractor.getInstance().modalPopinOpened = false;
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}