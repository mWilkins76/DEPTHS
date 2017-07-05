package com.isartdigital.ruby.ui.popin;

import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienBuffer;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienProducer;
import com.isartdigital.ruby.ui.popin.MenuClosable;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.ruby.ui.popin.codex.Codex;
import com.isartdigital.ruby.ui.popin.codex.XenoCodexTypedef;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;

/**
 * ...
 * @author Michael Wilkins / Guillaume Zegoudia
 */
class XenoPage extends MenuClosable
{

	private var isDone:Bool;
	private  var return_btn:SmartButton;
	private var BTN_RETURN(default, null):String = "btn_Return";

	private var TXT_SPECIENAME(default, null):String="txt_SpecieName";
	private var TXT_STAMINA(default, null):String="txt_StaminaXenoDisplay";
	private var TXT_CLASSDISPLAY(default, null):String="txt_ClassDisplay";
	private var TXT_CLASSDESCRIPTIONDISPLAY(default, null):String="txt_ClassDescriptionDisplay";
	private var TXT_POWER(default, null):String="txt_Power";
	private var TXT_POWERDESCRIPTION(default, null):String="txt_PowerDescriptionDisplay";
	private var TXT_RANGE(default, null):String="txt_RangeDisplay";
	private var TXT_AREA(default, null):String = "txt_EffectiveAreaDisplay";

	private var CLIP_SCHEMA(default, null):String = "XenoPage_clipSchema";
	private var XENO_ACTUAL(default, null):String = "XenoEvolutionActual";
	private var XENO_EVOLUTION1(default, null):String = "XenoEvolution #1";
	private var XENO_EVOLUTION2(default, null):String = "XenoEvolution #2";

	private var specieName:TextSprite;
	private var stamina:TextSprite;
	private var classDisplay:TextSprite;
	private var classDescription:TextSprite;
	private var power:TextSprite;
	private var powerDescription:TextSprite;
	private var range:TextSprite;
	private var area:TextSprite;

	private var clipSchema:SmartComponent;
	private var xenoActual:SmartComponent;
	private var xenoEvolution1:SmartComponent;
	private var xenoEvolution2:SmartComponent;

	private var currentAlien:XenoCodexTypedef;
	private var currentAlienCarac:Dynamic;
	private var description:Dynamic;
	/**
	 * instance unique de la classe XenoPage
	 */
	private static var instance: XenoPage;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): XenoPage
	{
		if (instance == null) instance = new XenoPage();
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

	override function init():Void
	{
		description = GameLoader.getContent("descriptionAlien.json");
		super.init();
		return_btn = cast(getChildByName(BTN_RETURN), SmartButton);
		return_btn.on(MouseEventType.CLICK, onReturn);
		return_btn.on(TouchEventType.TAP, onReturn);

		specieName = cast(getChildByName(TXT_SPECIENAME), TextSprite);
		stamina = cast(getChildByName(TXT_STAMINA), TextSprite);
		classDisplay = cast(getChildByName(TXT_CLASSDISPLAY), TextSprite);
		classDescription = cast(getChildByName(TXT_CLASSDESCRIPTIONDISPLAY), TextSprite);
		power = cast(getChildByName(TXT_POWER), TextSprite);
		powerDescription = cast(getChildByName(TXT_POWERDESCRIPTION), TextSprite);
		range = cast(getChildByName(TXT_RANGE), TextSprite);
		area = cast(getChildByName(TXT_AREA), TextSprite);

		clipSchema		= cast(getChildByName(CLIP_SCHEMA), SmartComponent);
		xenoActual		= cast(getChildByName(XENO_ACTUAL), SmartComponent);
		xenoEvolution1	= cast(getChildByName(XENO_EVOLUTION1), SmartComponent);
		xenoEvolution2	= cast(getChildByName(XENO_EVOLUTION2), SmartComponent);

	}

	public function setAlienInfoToDisplay(pAlien:XenoCodexTypedef):Void
	{
		if (currentAlien == null && !isDone)
		{
			currentAlien = pAlien;
			for (alien in Alien.alienElementList)
			{
				if (alien.name == currentAlien.name)
				{

					currentAlienCarac = alien;
					alien.stamina != 0 ? stamina.text = Std.string(alien.stamina) : stamina.text = "";
					//alien.stamina != 0 ? stamina.text = "Stamina : " + alien.stamina : stamina.text = "";

					xenoActual.getChildByName("XenoSprite").visible = false;
					assignCorrectAsset();
					//xenoActual.getChildByName("XenoSprite").visible = false;

					specieName.text = currentAlien.nomenclature;
					classDisplay.text = StringTools.replace(currentAlien.type,"Alien","") + " : ";
					powerDescription.text = Reflect.field(description, currentAlien.name) != null ? Reflect.field(description, currentAlien.name) : { powerDescription.text =""; power.text = ""; range.text = ""; area.text = ""; };
					classDescription.text = Reflect.field(description, currentAlien.type);
					isDone = true;
				}
			}
		}
	}

	private function assignCorrectAsset():Void
	{
		
		var assetEvolution1:UISprite;
		var assetEvolution2:UISprite;
		var lAsset:UISprite;
		if (currentAlien.type == "AlienForeur")
		{
			for (child in xenoEvolution1.children) child.visible = false;
			for (child in xenoEvolution2.children) child.visible = false;
			
		 lAsset = new UISprite("XenoPage_"+currentAlien.name);
		}

		else
		{
			switch (Std.parseInt(currentAlienCarac.carac.nbUpgrade))
			{
				case 0:

				for (child in xenoEvolution1.children) child.visible = false;
				for (child in xenoEvolution2.children) child.visible = false;

				case 1:
				for (child in xenoEvolution2.children) child.visible = false;
				xenoEvolution1.getChildByName("XenoSprite").visible = false;
				assetEvolution1 = new UISprite("XenoPage_" + currentAlien.name + (currentAlienCarac.level == "2" ? "_1_Normal":"_2_Disabled")/* +  "_Normal"*/);
				assetEvolution1.position = xenoEvolution1.getChildByName("XenoSprite").position.clone();
				xenoEvolution1.addChild(assetEvolution1);
				
			default:
				xenoEvolution1.getChildByName("XenoSprite").visible = false;
				assetEvolution1 = new UISprite("XenoPage_" + currentAlien.name + (currentAlienCarac.level >= "2" ? "_1_Normal":"_2_Disabled")/* +  "_Normal"*/);
				assetEvolution1.position = xenoEvolution1.getChildByName("XenoSprite").position.clone();
				xenoEvolution1.addChild(assetEvolution1);
				
				xenoEvolution2.getChildByName("XenoSprite").visible = false;
				assetEvolution2 = new UISprite("XenoPage_" + currentAlien.name + (currentAlienCarac.level == "3" ? "_2_Normal":"_3_Disabled")/* + "_Normal" */);
				assetEvolution2.position = xenoEvolution2.getChildByName("XenoSprite").position.clone();
				xenoEvolution2.addChild(assetEvolution2);
			}
			
			lAsset = new UISprite("XenoPage_"+currentAlien.name+"_"+ currentAlienCarac.level);
		}
		
		lAsset.position = xenoActual.getChildByName("XenoSprite").position.clone();
		xenoActual.addChild(lAsset);
	}

	private function onReturn():Void
	{
		UIManager.getInstance().closePopin(this);
	}

	override function onClose():Void
	{
		onReturn();
		UIManager.getInstance().closeCurrentPopin();
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		instance = null;
		super.destroy();
	}

}