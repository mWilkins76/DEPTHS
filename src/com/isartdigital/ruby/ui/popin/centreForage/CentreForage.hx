package com.isartdigital.ruby.ui.popin.centreForage;

import com.isartdigital.ruby.game.player.MissionsManager;
import com.isartdigital.ruby.game.specialFeature.managers.SFGameManager;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.sprites.elements.drillingbuilding.DrillingBuilding;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.items.DrillingFriendItem;
import com.isartdigital.ruby.ui.items.DrillingXenoItem;
import com.isartdigital.ruby.ui.items.switchItems.DrillingButtonSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.MissionSwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.SwitchItem;
import com.isartdigital.ruby.ui.items.switchItems.XenoSlotSwitchItem;
import com.isartdigital.ruby.ui.popin.Menu;
import com.isartdigital.ruby.ui.popin.contextual.BuildingContextualMenu;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureScreen;
import com.isartdigital.ruby.ui.popin.building.datas.BuildingMenuData;
import com.isartdigital.ruby.ui.popin.building.datas.Missions;
import com.isartdigital.ruby.ui.items.switchItems.BuildingMenuSwitchItem;
import com.isartdigital.ruby.ui.specialButtons.SlotButton;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Lib;
import js.html.MouseEvent;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.extras.MovieClip;

	
/**
 * ...
 * @author 
 */
class CentreForage extends Menu 
{
	
	/**
	 * instance unique de la classe CentreForage
	 */ 
	private static var instance: CentreForage;
	
	private static inline var SLIDER:String = "Slider";
	private static inline var VERTICAL_SLIDER:String = "VerticalSlider";
	private static inline var DOWN_ARROW:String = "btn_Fleche";
	private static inline var UP_ARROW:String = "btn_Fleche #1";
	private static inline var DRILL:String = "btn_Forage";
	private static inline var CHOOSE_TEAM_BTN:String = "";
	private static inline var FRIENDS_TAB:String = "ItemContainerFriendList";
	private static inline var ALIENS_TAB:String = "ItemContainerXenosList";
	private static inline var ALIEN_CLASS:String = "txt_CentreForageXenoClass";
	private static inline var ALIEN_NAME:String = " txt_CentreForageXenoName";
	private static inline var BTN_SWITCH_XENOS_FRIEND:String = "CentreForage_clipXenoSocial";
	
	private static inline var XENO_SLOT_CONTAINER:String = "XenoSlotContainer";
	
	private static inline var MISSIONS_PANEL:String = "CentreForage_clipMissionStats";
	private static inline var MISSION_REWARDS:String = "CentreForage_spriteReward";
	private static inline var MISSION_NAME:String = "txt_missionName";
	private static inline var MISSION_CONDITION_PANEL:String = "CentreForage_clipMissionConditions";
	private static inline var MISSION_CENTERCOUNT:String = "txt_neededCentersDisplay";
	private static inline var MISSION_TIMER:String = "txt_drillTimeDisplay";
	private static inline var XENO_SLOT:String = "Item #";
	private static inline var MISSION_CONTAINER:String = "MissionContainer";
	private static inline var MISSION:String = "Mission";
	private static inline var MISSION_THUMBNAIL = "CentreForage_spriteApercuMission";
	
	
	private var missionPanelContainer:SmartComponent;
	private var missionConditionContainer:SmartComponent;
	private var missionName:TextSprite;
	private var missionCountCenter:TextSprite;
	private var missionReward:SmartComponent;
	private var missionTimer:TextSprite;
	private var missionIndex:Int = 0;
	
	private var xenoSlots:Array<SlotButton>;
	private var mission:Missions;
	private var xenoList:Array<AlienElement>;
	
	public var xenoSlotList:Array<SlotButton>;
	private var xenoSlotContainer:SmartComponent;
	
	private var offsetXenoItem:Point;
	private var offsetFriendItem:Point;
	private var offsetMissionItem:Point;
	
	private var drillBtn:SwitchItem;
	
	private var friendsTab:SmartComponent;
	private var xenosTab:SmartComponent;
	private var btnSwitchXenosSocial:SmartComponent;
	private var sliderContainerHorizontal:SmartComponent;
	private var sliderContainerVertical:SmartComponent;
	private var sliderHorizontal:Slider;
	private var arrowUp:SmartComponent;
	private var arrowDown:SmartComponent;
	private var availableMissions:Array<MissionSwitchItem>;
	private var missionsContainer:SmartComponent;
	private var firstMissionPosition:Point;
	public var alienSelected:AlienElement;
	
	
	private var sablierContainer:SmartComponent;
	private var spriteSablier:UISprite;
	private var sablierText:TextSprite;
	private var outpostText:TextSprite;
	
	private var rewardContainer:SmartComponent;
	private var scSprite:UISprite;
	private var hcSprite:UISprite;
	private var gene1Sprite:UISprite;
	private var gene2Sprite:UISprite;
	private var gene3Sprite:UISprite;
	private var gene4Sprite:UISprite;
	private var gene5Sprite:UISprite;
	private var schemaSprite:UISprite;
	private var mnSprite:UISprite;
	private var missionThumbnail:UISprite;
	
	
	
	
	
	
	private var maxXenosForThisMission:Int;
	

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): CentreForage {
		if (instance == null) instance = new CentreForage();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modal = true;
	}
	
	override private function init():Void
	{
		super.init();
		availableMissions = new Array<MissionSwitchItem>();
		
		sliderContainerVertical = cast(getChildByName(VERTICAL_SLIDER), SmartComponent);
		missionsContainer =  cast(sliderContainerVertical.getChildByName(MISSION_CONTAINER), SmartComponent);
		xenoSlotList = new Array<SlotButton>();
		
		initSlider();
		initFriendsTab();
		initXenoItem();
		
		sliderHorizontal.init(sliderContainerHorizontal, xenosTab);
		drillBtn = cast(getChildByName(DRILL), SwitchItem);
		
		
		//si tous les slots sont remplis
		
		drillBtn.on(MouseEventType.CLICK, openDrillingFeature);
		drillBtn.on(TouchEventType.TAP, openDrillingFeature);
		drillBtn.visible = false;
		FTUEManager.register(drillBtn);
		
		xenoList = new Array<AlienElement>();
		
		
		initMissionTab();
		initInfoMissionPanel();
		arrowUp = cast(getChildByName(UP_ARROW), SmartComponent);
		arrowDown = cast(getChildByName(DOWN_ARROW), SmartComponent);
		
		arrowUp.on(MouseEventType.CLICK, upMission);
		arrowDown.on(MouseEventType.CLICK, downMission);
	
		activeXenos();
		updateItems();
		SmartPopinRegister.event.emit("onInit");
	}
	
	
	public function onClickMission(pParams:Missions):Void
	{
		hcSprite.visible = true;
		mission = pParams;
		missionName.text = mission.name;
		maxXenosForThisMission = mission.alienSpawner;
		
		if (missionPanelContainer.getChildByName("thumbnail") != null) missionPanelContainer.removeChild(missionPanelContainer.getChildByName("thumbnail"));
		missionThumbnail = cast(missionPanelContainer.getChildByName(MISSION_THUMBNAIL), UISprite);
		var assetThumbail:UISprite = new UISprite("Thumbnail_"+StringTools.replace(mission.name," ",""));
		assetThumbail.position = missionThumbnail.position.clone();
		assetThumbail.y -= 20;
		assetThumbail.name = "thumbnail";
		missionPanelContainer.addChild(assetThumbail);
		missionThumbnail.visible = false;
		
		drillBtn.visible = true;
		drillBtn.interactive = false;
		drillBtn.setDisabled();
		initXenoSlot();
		missionPanelContainer.visible = true;
		
		if(mission.name == "Mission 25") outpostText.text = "6 / 6";
		
		hcSprite.visible = true;
		scSprite.visible = true;
		schemaSprite.visible = true;
		mnSprite.visible = true;
		gene1Sprite.visible = true;
		gene2Sprite.visible = true;
		gene3Sprite.visible = true;
		gene4Sprite.visible = true;
		gene5Sprite.visible = true;
		
		if(mission.rewards.hc == 0) hcSprite.visible = false;
		if(mission.rewards.sc == 0) scSprite.visible = false;
		if(mission.rewards.darkMatter == 0) mnSprite.visible = false;
		if(mission.rewards.schema == 0) schemaSprite.visible = false;
		if(mission.rewards.gene1 == 0) gene1Sprite.visible = false;
		if(mission.rewards.gene2 == 0) gene2Sprite.visible = false;
		if(mission.rewards.gene3 == 0) gene3Sprite.visible = false;
		if(mission.rewards.gene4 == 0) gene4Sprite.visible = false;
		if(mission.rewards.gene5 == 0) gene5Sprite.visible = false;

		//missionCountCenter.text = "Drilling Centers : " + DrillingBuilding.drillingBuildingCount + " / " + lMission.centerRequired;
		//missionTimer.text = lMission.time;
		//missionReward * 6 boucle?*/
	}
	
	private function initXenoSlot() {
		while (xenoSlotList.length > 0) xenoSlotList.pop();
		
		xenoSlotContainer = cast(missionPanelContainer.getChildByName(XENO_SLOT_CONTAINER), SmartComponent);
		for (i in 0...3)
			xenoSlotList.push(cast(xenoSlotContainer.getChildByName(XENO_SLOT + i), SlotButton));
		for (i in 0...xenoSlotList.length) {
			xenoSlotList[i].visible = true;
			xenoSlotList[i].alien = null;
			if (i > maxXenosForThisMission - 1) xenoSlotList[i].visible = false;
			
		}
		FTUEManager.register(xenoSlotList[0]);
		maxXenosForThisMission++;
	}
	

	private function initFriendsTab() {
		friendsTab = cast(sliderContainerHorizontal.getChildByName(FRIENDS_TAB), SmartComponent);
		offsetFriendItem = new Point(friendsTab.children[0].x - friendsTab.children[1].x, friendsTab.children[0].y - friendsTab.children[1].y);
	}
	
	private function initXenoItem() {
		xenosTab =  cast(sliderContainerHorizontal.getChildByName(ALIENS_TAB), SmartComponent);
		offsetXenoItem = new Point(xenosTab.children[0].x - xenosTab.children[1].x, xenosTab.children[0].y - xenosTab.children[1].y);
		sliderHorizontal.init(sliderContainerHorizontal, xenosTab);
	}
	
	private function initSlider() {
		sliderContainerHorizontal = cast(getChildByName(SLIDER), SmartComponent);
		sliderHorizontal = new Slider();
	}
	
	private function initInfoMissionPanel():Void
	{
		missionPanelContainer = cast(getChildByName(MISSIONS_PANEL), SmartComponent);
		missionPanelContainer.visible = false;
		
		sablierContainer = cast(missionPanelContainer.getChildByName("CentreForage_clipMissionConditions"), SmartComponent);
		sablierText = cast(sablierContainer.getChildByName("txt_drillTimeDisplay"), TextSprite);
		outpostText = cast(sablierContainer.getChildByName("txt_neededCentersDisplay"), TextSprite);
		spriteSablier = cast(sablierContainer.getChildByName("CentreForage_spriteCooldown"), UISprite);
		spriteSablier.visible = false;
		sablierText.visible = false;
		outpostText.text = "1 / 1";
		
		rewardContainer = cast(missionPanelContainer.getChildByName("RewardContainer"), SmartComponent);
		scSprite = cast(rewardContainer.getChildByName("Calque 2"), UISprite);
		hcSprite = cast(rewardContainer.getChildByName("CentreForage_spriteReward #5"), UISprite);
		schemaSprite = cast(rewardContainer.getChildByName("Calque 3"), UISprite);
		mnSprite = cast(rewardContainer.getChildByName("Calque 4"), UISprite);
		gene1Sprite = cast(rewardContainer.getChildByName("CentreForage_spriteReward #2"), UISprite);
		gene2Sprite = cast(rewardContainer.getChildByName("CentreForage_spriteReward #4"), UISprite);
		gene3Sprite = cast(rewardContainer.getChildByName("CentreForage_spriteReward #0"), UISprite);
		gene4Sprite = cast(rewardContainer.getChildByName("CentreForage_spriteReward #1"), UISprite);
		gene5Sprite = cast(rewardContainer.getChildByName("CentreForage_spriteReward #3"), UISprite);
		
		missionName = cast(missionPanelContainer.getChildByName(MISSION_NAME), TextSprite);	
		
		
		//for (child in missionPanelContainer.children);
			
	}
	
	
	public function switchXenosSocial() {
		if (friendsTab.visible)
			activeXenos();
		else
			activeFriend();
			
		updateItems();
		sliderHorizontal.update();
		
	}
	
	private function activeFriend():Void 
	{
		friendsTab.visible = true;
		xenosTab.visible = false;
		sliderHorizontal.initContainer(sliderContainerHorizontal, friendsTab);
		
	}
	
	private function initMissionTab():Void 
	{
		offsetMissionItem = new Point(missionsContainer.children[0].x - missionsContainer.children[1].x, missionsContainer.children[0].y - missionsContainer.children[1].y);
		
		
		
			if(firstMissionPosition == null) firstMissionPosition =  missionsContainer.getChildByName(MISSION + " #0").position;	
			destroyAllChildInContainer(missionsContainer);
			
			
			updateMission();
		
	}
	
	private function updateMission() {
		for (i in 0...4) {
			
				availableMissions.push(Type.createInstance(MissionSwitchItem, []));
				availableMissions[i].x = firstMissionPosition.x + i * offsetMissionItem.x;
				availableMissions[i].y = firstMissionPosition.y + i * offsetMissionItem.y;
				availableMissions[i].setInfo(MissionsManager.getInstance().missions[missionIndex + i]);
				availableMissions[i].name = "centreForageMission" + missionIndex + i;
				missionsContainer.addChild(availableMissions[i]);
				FTUEManager.register(availableMissions[i]);
			}
	}
	private function activeXenos():Void
	{
		friendsTab.visible = false;
		xenosTab.visible = true;
		sliderHorizontal.initContainer(sliderContainerHorizontal, xenosTab);
	}
	
    public function updateItems() {
		if (sliderHorizontal == null) return;
		
		if (sliderHorizontal.itemContainer == xenosTab) {
			updateXenosItems();
		}else {
			updateFriendsItems();
		}
		
		sliderHorizontal.update();
	}
	
	
	
	private function updateXenosItems() {
		
		
		destroyAllChildInContainer(xenosTab);
			//reste à chercher les datas
			//faire une fonction d'initialisation pour init les objet créé via ces donnée
		var index:Int = 0;
		for (i in 0...Alien.alienElementList.length)
		{
			
			if (Alien.alienElementList[i].type == "AlienForeur")
			{
				var currentItem = new DrillingXenoItem();
				xenosTab.addChild(currentItem);
				currentItem.initAlien(Alien.alienElementList[i]);
				currentItem.x = offsetXenoItem.x * index;
				currentItem.id = index;
				currentItem.name = "xeno" + index;
				FTUEManager.register(currentItem);
				index++;
			}
		}
	}
	
	private function updateFriendsItems() {
		destroyAllChildInContainer(friendsTab);
		if (DataManager.getInstance().alienFriendsList.length == 0) return;	
		for (i in 0...DataManager.getInstance().alienFriendsList.length) {
			var currentItem = new DrillingFriendItem();
			currentItem.setAlienElem(DataManager.getInstance().alienFriendsList[i]);
			friendsTab.addChild(currentItem);
			currentItem.x = offsetFriendItem.x * i;
			FTUEManager.register(currentItem);
		}
	}
	
	function upMission() {
		missionIndex--;
		if (missionIndex < 0) missionIndex = 0;
		updateMission();
	}
	
	function downMission() {
		missionIndex++;
		trace((missionIndex+4) + " " + MissionsManager.getInstance().missions.length);
		if (missionIndex+4 > MissionsManager.getInstance().missions.length) missionIndex--;
		updateMission();
	}
/*	private function closeSpecialFeature():VoidMission
	{
		
	}*/
	
	public function checkIfMissionCanBeStarted():Void {
	
		for (slot in xenoSlotList)
			if (slot.alien != null) {
				
				drillBtn.setNormal();
				drillBtn.interactive = true;
			}
		
	}
	
	

	private function openDrillingFeature() {
		if (mission == null) return;
		SoundManager.getSound("soundPlayerLaunchMission").play();
		UIManager.getInstance().closeAllPopins();
		for (slot in xenoSlotList) {
			if (slot.visible) {
				xenoList.push(slot.alien);	
			}
			
		}
		SFGameManager.getInstance().init(mission, xenoList);		
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