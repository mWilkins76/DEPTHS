package com.isartdigital.ruby.game.specialFeature.managers;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.specialFeature.aliens.AlienType;
import com.isartdigital.ruby.game.specialFeature.managers.SFAliensEventManager;
import com.isartdigital.ruby.game.specialFeature.managers.SFAliensManager;
import com.isartdigital.ruby.game.specialFeature.managers.SFEventsManager;
import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.game.specialFeature.managers.SFTilesManager;
import com.isartdigital.ruby.game.sprites.elements.ElementType;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.ruby.ui.items.switchItems.SpecialFeatureSwitchSkill;
import com.isartdigital.ruby.ui.popin.TutoSpecialFeature;

import com.isartdigital.ruby.ui.popin.Confirm;
import com.isartdigital.ruby.ui.popin.DynamicPopin;
import com.isartdigital.ruby.ui.popin.Menu;
import com.isartdigital.ruby.ui.popin.SmartPopinRegister;
import com.isartdigital.ruby.ui.screens.SmartScreenRegister;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.Constraints.Function;
import haxe.Json;
import js.Browser;
import js.Lib;
import js.html.Event;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.renderers.Detector;
import pixi.core.renderers.Detector.RenderingOptions;


typedef AlienHudInfo = {
	var skillBtn:SmartComponent;
	var moveBtn:SmartComponent;
	var staminaBar:UISprite;
	var xenoName:TextSprite;
}
	
/**
 * ...
 * @author Julien Fournier
 */
class SpecialFeatureScreen extends SmartScreenRegister
{
	
	private static inline var BTN_CLOSE:String = "btn_Close";
	
	private static inline var HC_CONTAINER:String = "HCContainer";	
	private static inline var SC_CONTAINER:String = "SCContainer";
	private static inline var MN_CONTAINER:String = "MNContainer";
	private static inline var SCHEMAS_CONTAINER:String = "ArchivesContainer";
		private static inline var TXT_REWARDS:String = "txt_Reward";
	
	private static inline var GENES_CONTAINER:String = "GeneContainer";
		private static inline var GENES_1:String = "Gene #0";
		private static inline var GENES_2:String = "Gene #1";
		private static inline var GENES_3:String = "Gene #2";
		private static inline var GENES_4:String = "Gene #3";
		private static inline var GENES_5:String = "Gene #4";

	
	private static inline var ALIENS_CONTAINER:String = "ItemContainer";
		private static inline var ALIEN_SUFFIXE:String = "item #";
			private static inline var SKILL_BTN:String = "SwitchSkill";
				private static inline var NORMAL:String = "Normal";
				private static inline var SELECTED:String = "Selected";
			private static inline var MOVE_BTN:String = "SwitchMove";
			private static inline var STAMINA_BAR:String = "XenoBarCharging";
			private static inline var XENO_NAME:String = "txt_XenoName";	
			private static inline var BACKGROUND_XENO_BAR:String = "SpecialFeature_spriteXenoBarBG";
	
	private static inline var TILES_CONTAINER:String = "CaseContainer";	
	private static inline var BACKGROUND_SF:String = "SpecialFeature_spriteBackgroundLevel";
	private static inline var BACKGROUND_TILE_CONTAINER:String = "SpecialFeature_spriteBackgroundLevel";
	
	private static inline var BTN_INFO:String = "SpecialFeature_btn_Info";
	
	private var alienHudInfoList:Array<AlienHudInfo> = [];
	private static inline var MAX_SF_ALIENS_NUMBER:Int = 3;
	private var alienSpawnersInCurrentMap:Int;
	
	public var hcContainer:SmartComponent;
	private var scContainer:SmartComponent;
	private var mnContainer:SmartComponent;
	private var schemasContainer:SmartComponent;

	
	private var genesContainer:SmartComponent;
		private var geneContainer1:SmartComponent;
		private var geneContainer2:SmartComponent;
		private var geneContainer3:SmartComponent;
		private var geneContainer4:SmartComponent;
		private var geneContainer5:SmartComponent;

	
	private var aliensContainer:SmartComponent;
	private var staminaBarMaxWidth:Float;
	private var staminaBarWidth:Float;	
	
	public var tilesContainer:SmartComponent;

	private var backgroundSF:SmartComponent;
	private var backgroundTileContainer:SmartComponent;
	private var backgroundXenoBar:SmartComponent;

	public var btnInfo:SmartButton;
	
	public var btnClose:SmartButton;
	
	private var btnSkill:SmartComponent;
		private var normal:SmartComponent;
		private var selected:SmartComponent;
	
	private var btnMove:SmartComponent;
	
	//rewards
	private var rewardHardCurrency:Int;
	private var rewardSoftCurrency:Int;
	private var rewardMN:Int;
	private var rewardSchema:Int;
	private var rewardGene1:Int;
	private var rewardGene2:Int;
	private var rewardGene3:Int;
	private var rewardGene4:Int;
	private var rewardGene5:Int;

	
	private var alienCurrentStamina:Int;
	private var alienOldStamina:Int;
	
	private var alienHudList:Array<AlienHudInfo> =[];
	private var alienSuffixe:SmartComponent;

	private var activatedAlienList:Array<SpecialFeatureAliens>;

	public var closeFlag:Bool = false;
	
	public var playerSchema : Int = 0;
	/**
	 * instance unique de la classe SpecialFeaturePoppin
	 */
	private static var instance: SpecialFeatureScreen;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): SpecialFeatureScreen {
		if (instance == null) instance = new SpecialFeatureScreen();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		
		super(pID);
		modalImage = "assets/sft.png";

	}
	
	public function initContainers():Void
	{
		aliensContainer = cast(getChildByName(ALIENS_CONTAINER), SmartComponent);
		tilesContainer = cast(getChildByName(TILES_CONTAINER), SmartComponent);
		hcContainer = cast(getChildByName(HC_CONTAINER), SmartComponent);
		scContainer = cast(getChildByName(SC_CONTAINER), SmartComponent);
		mnContainer = cast(getChildByName(MN_CONTAINER), SmartComponent);
		schemasContainer = cast(getChildByName(SCHEMAS_CONTAINER), SmartComponent);
		genesContainer = cast(getChildByName(GENES_CONTAINER), SmartComponent);
		
		geneContainer1 = cast(genesContainer.getChildByName(GENES_1), SmartComponent);
		geneContainer2 = cast(genesContainer.getChildByName(GENES_2), SmartComponent);
		geneContainer3 = cast(genesContainer.getChildByName(GENES_3), SmartComponent);
		geneContainer4 = cast(genesContainer.getChildByName(GENES_4), SmartComponent);
		geneContainer5 = cast(genesContainer.getChildByName(GENES_5), SmartComponent);
		for (j in 0...MAX_SF_ALIENS_NUMBER) 
		{
			alienSuffixe = cast(aliensContainer.getChildByName(ALIEN_SUFFIXE+j), SmartComponent);
			alienSuffixe.visible = false;
		}
	}
	
	/**
	 * initialise le hud Aliens
	 */
	public function initHud():Void
	{	
		activatedAlienList = SFAliensManager.getInstance().activatedAlienList;
		initAlienHud();
		updateRessourceHud();
		updateAlienHud();
			
		alienSelection(0, SFEventsManager.MODE_MOVE)();
		
		btnInfo = cast(getChildByName(BTN_INFO), SmartButton);
		btnInfo.on(MouseEventType.CLICK, onInfo);
		btnInfo.on(TouchEventType.TAP, onInfo);		
		
		btnClose = cast(getChildByName(BTN_CLOSE), SmartButton);
		btnClose.on(MouseEventType.CLICK, onClose);
		btnClose.on(TouchEventType.TAP, onClose);

	}
	
	
	private function onInfo():Void
	{
		UIManager.getInstance().openPopin(TutoSpecialFeature.getInstance());
	}
	
	/**
	 * Callback de sélection d'alien et initialisation du son mode
	 * @param	pAlienIndex
	 * @param	pMode
	 */
	public  function alienSelection(pAlienIndex:Int, pMode:String):Void->Void
	{
		return function(){ 
			SFEventsManager.getInstance().selectAlienOnHud(pAlienIndex, pMode);
		};
	}
	
	public function updateRessourceHud():Void
	{
		cast(hcContainer.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(Player.getInstance().hardCurrency);
		cast(scContainer.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(Player.getInstance().softCurrency);
		cast(mnContainer.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(Player.getInstance().ressource);
		cast(schemasContainer.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(playerSchema);
		
		cast(geneContainer1.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(Player.getInstance().gene1);
		cast(geneContainer2.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(Player.getInstance().gene2);
		cast(geneContainer3.getChildByName(TXT_REWARDS), TextSprite).text	= Std.string(Player.getInstance().gene3);
		cast(geneContainer4.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(Player.getInstance().gene4);
		cast(geneContainer5.getChildByName(TXT_REWARDS), TextSprite).text = Std.string(Player.getInstance().gene5);
	}
	
	public function updateAlienHud():Void
	{
		var index:Int = 0;
		for (alien in activatedAlienList) 
		{
			staminaBarWidth = alien.stamina * staminaBarMaxWidth / alien.maxStamina;

			if (staminaBarWidth >= staminaBarMaxWidth) staminaBarWidth = staminaBarMaxWidth;
			if (staminaBarWidth <= 0) staminaBarWidth = 0;

			alienHudList[index].staminaBar.width = staminaBarWidth;
			index++;
		}
		
	}
	
	public function initAlienHud():Void
	{
		var alienHud:AlienHudInfo;
		var index:Int = 0;
		
		for (alien in activatedAlienList) 
		{
			alienSuffixe = cast(aliensContainer.getChildByName(ALIEN_SUFFIXE+index), SmartComponent);
			alienSuffixe.visible = true;
			
			alienHud = {
				skillBtn: cast(alienSuffixe.getChildByName(SKILL_BTN), SmartComponent),
				moveBtn: cast(alienSuffixe.getChildByName(MOVE_BTN), SmartComponent),
				staminaBar: cast(alienSuffixe.getChildByName(STAMINA_BAR), UISprite),
				xenoName: cast(alienSuffixe.getChildByName(XENO_NAME), TextSprite)
			}
			alienHud.xenoName.text = alien.alienType;
			
			cast(alienSuffixe.getChildByName(SKILL_BTN), SpecialFeatureSwitchSkill).init();
			cast(alienSuffixe.getChildByName(SKILL_BTN), SpecialFeatureSwitchSkill).initAlien(alien);
			
			staminaBarMaxWidth = alienHud.staminaBar.width;
		
			staminaBarWidth = alien.stamina * staminaBarMaxWidth / alien.maxStamina;

			alienHud.staminaBar.width = staminaBarWidth;

			alienHud.moveBtn.interactive = true;
			alienHud.skillBtn.interactive = true;
			
			alienHud.moveBtn.on(MouseEventType.CLICK, alienSelection(index,"Move"));
			alienHud.moveBtn.on(TouchEventType.TAP, alienSelection(index, "Move"));
			
			alienHud.skillBtn.on(MouseEventType.CLICK, alienSelection(index,"Skill"));
			alienHud.skillBtn.on(TouchEventType.TAP, alienSelection(index, "Skill"));
			
			alienHudList.push(alienHud);
			index++;
		}

	}
	
	


	/**
	 * Donne des ressources au player et update le hud
	 * @param	pRewardType
	 */
	public function getRessourceHudPosition(pRewardType:String):Point
	{
		if (pRewardType == ElementType.ITEM_GENEONE) return genesContainer.toGlobal(geneContainer1.position);
		if (pRewardType == ElementType.ITEM_GENETWO) return  genesContainer.toGlobal(geneContainer2.position);
		if (pRewardType == ElementType.ITEM_GENETHREE) return  genesContainer.toGlobal(geneContainer3.position);
		if (pRewardType == ElementType.ITEM_GENEFOUR) return  genesContainer.toGlobal(geneContainer4.position);
		if (pRewardType == ElementType.ITEM_GENEFIVE) return  genesContainer.toGlobal(geneContainer5.position);
		
		if (pRewardType == ElementType.ITEM_DARKMATTER) return toGlobal(mnContainer.position);
		if (pRewardType == ElementType.ITEM_BLUEPRINT) return toGlobal(schemasContainer.position);
		if (pRewardType == ElementType.ITEM_HC) return toGlobal(hcContainer.position);
		if (pRewardType == ElementType.ITEM_SC) return toGlobal(scContainer.position);

		else return toGlobal(btnClose.position);
	}
	/**
	 * fermeture du hud
	 */
	public function onClose():Void
	{
		//if (closeFlag) SFGameManager.getInstance().openEndMissionPoppin();
		
		removeAllListeners();
		GameManager.getInstance().setModeNormal();
		SFGameManager.getInstance().destroy();
		SFAliensManager.getInstance().destroy();
		SFEventsManager.getInstance().destroy();
		SFAliensEventManager.getInstance().destroy();
		SFGameManager.getInstance().destroy();
		SFTilesManager.getInstance().destroy();
		SoundManager.getSound("soundMusicSpecialFeature").stop();
		UIManager.getInstance().closeScreens();
		UIManager.getInstance().openHud();
		Hud.getInstance().update();
		SmartPopinRegister.event.emit("onClose");
		
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		
		//suppression de l'écouteur de clic
	}

}