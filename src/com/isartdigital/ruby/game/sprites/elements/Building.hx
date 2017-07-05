package com.isartdigital.ruby.game.sprites.elements;


import com.greensock.TweenMax;
import com.greensock.easing.Quart;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.player.XpToLevel;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienPaddock;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienTrainingCenter;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.BuildingEnergyProducer;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.UrbanHeadQuarter;
import com.isartdigital.ruby.juicy.bullesxp.BullesManager;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.DynamicPopin;
import com.isartdigital.ruby.ui.popin.TimeBased;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.save.BuildingTypes.BuildingType;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.SmartText;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.save.ElementSave.EvolveState;
import com.isartdigital.utils.save.ElementSave.State;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import eventemitter3.EventEmitter;
import haxe.Timer;
import haxe.rtti.CType.Typedef;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.text.Text;
import pixi.filters.color.ColorMatrixFilter;

/**
 * ...
 * @author Michael Wilkins / fournier Julien / Zegoudia Guillaume / Bourdon Adrien / Jordan Dachicourt
 */

//enum State {}
//enum EvolveState {}


class Building extends GameElement
{
	public var buildingName:String;

	public var buildingType(default, null):BuildingType;
	
	
	public var timeForNextState:Float; //faire getter setter
	public var elapsedTime:Float;
	public var description:String;

	public var constructTime:String = "ConstructTime";
	public var upgradeTime:String = "UpgradingTimeLevel";
	public var collectTime:String = "CollectingTimeLevel";
	public static inline var WAIT_VALIDATION:String = "WaitValidation";
	
	public var buffType(default, null):String;
	public var buffCoef(default, null):Float;
	
	public var costSC:Int;
	public var costHC:Int;
	public var costMN:Int;
	public var energyCost(default, null):Int;
	
	public var costUpgradeSC:Int;
	public var costUpgradeMN:Int;
	public var costUpgradeEnergy:Int;
	private var energyAdded:Int;
	
	//private var sablier:UIMovie;
	
	public var canReceiveAliens:Bool = false;
	public var canReceiveDrillers:Bool = false;

	public var stateTest:String;

	private var allowedFilter:ColorMatrixFilter = new ColorMatrixFilter();
	
	public static var HQinstance:UrbanHeadQuarter;
	
	public var timerContainer:UISprite;
	private var percentageContainer:SmartText;
	
	private var hardToSkipTimer:Int = 3;
	
	private var sellingCost:Int;
	
	public var timeConstruction:String;
	
	public static var event:EventEmitter = new EventEmitter();
	

	public function new(?pAsset:String=null)
	{
		super(pAsset);
		margin = 1;
		buildingType = DataManager.getInstance().listBuildingTypes.get(className);
		energyCost = buildingType.energyCost;
		costSC = buildingType.softCurrencyCost;
		costHC = cast(buildingType.hardCurrencyCost);
		costMN = buildingType.ressourcesCost;
		allowedFilter.matrix = [1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		
		
	}

	override public function init(?pElem:Element=null):Void
	{
		super.init(pElem);
		//name = pElem.type;
		
		if (pElem.levelUpGrade != null) level = pElem.levelUpGrade;
		currentState = pElem.mode;
		
		if (pElem.dateStartBuilding != null) dateStartBuilding = pElem.dateStartBuilding;
		
		globalPosition = new Point(elem.globalX, elem.globalY);
		
		if (level != maxLevel && !Std.is(this, AlienTrainingCenter))
		{
			setUpgradeCost();
		}
		
		changeState();
		
	}
	
	public static function updateBuildingsCarac():Void 
	{
		for (paddock in AlienPaddock.alienPaddockList) cast(paddock.instance, AlienPaddock).getBuildingOnAera();
	}

	override public function start():Void
	{
		boxType = BoxType.SIMPLE;
		factory = new FlumpMovieAnimFactory();
		
		if (elem == null) currentState = SPAWNING_STATE;
		else
		{
			switch (elem.mode)
			{
				case "Constructing":
					setModeConstruct();
				case "Recolting":
					setModeCollect();
				case "Wait":
					setModeNormal();
				case "Upgrading":
					setModeConstruct(true);
				case "WaitValidation":
					setModeValidationConstruct();
				
			}		
		}
		changeAsset(currentState);
    }
	
	private function changeState():Void
	{
		
		if (elem.mode == CONSTRUCTING_STATE) currentState = CONSTRUCTING_STATE;
		if (elem.mode == COLLECTING_STATE) currentState = COLLECTING_STATE;
		if (elem.mode == WAITING_STATE) currentState = WAITING_STATE;
		if (elem.mode == UPGRADING_STATE) currentState = UPGRADING_STATE;
		if (elem.mode == WAIT_VALIDATION) currentState = WAITING_STATE;
	}

	// Machine à état : 
	public function setModeConstruct(?isUpgrading:Bool = false):Void
	{			
		if (dateEndBuilding == null || isUpgrading)
		{
			isUpgrading ? newTimeToUpgrade() : newTimeToBuild();
			TimeManager.getInstance().init(this);
			elem.dateStartBuilding = Date.now(); 
		}
		
		isUpgrading ? currentState = UPGRADING_STATE : currentState = CONSTRUCTING_STATE;
		changeAsset(currentState);
		
		doAction = doActionConstruct;
		elem.dateEndBuilding = dateEndBuilding;
		elem.mode = currentState;
		if (isUpgrading) DataBaseAction.getInstance().releaseBuildingMode(elem.instanceID, elem.mode);
		releaseElementList();

		//timerContainer = new SmartText(GameStage.getInstance().getInfoBulleContainer(), 100, 100, 40, "Arial Black", "white", "left", false, "blue", 0.9, 30, 0, 0, 20, 20);
		timerContainer = new UISprite("Building_WaitingTime");
		GameStage.getInstance().getInfoBulleContainer().addChild(timerContainer);
		var lPoint:Point = new Point(0, 0);
		lPoint.x = elem.regionX * Region.WIDTH + elem.x;
		lPoint.y = elem.regionY * Region.HEIGHT + elem.y;
		timerContainer.position = IsoManager.modelToIsoView(lPoint);
		timerContainer.position.y -= 100;
		timerContainer.interactive = true;
		timerContainer.buttonMode = true;
		addBtnSkipCDTimer();
		timerContainer.name = "timerContainer" + name;
		FTUEManager.register(timerContainer);
		var bump:TweenMax = new TweenMax(
			timerContainer.scale,
			0.5,
			{
				repeatDelay:0.3,
				x:0.9,
				y:0.9,
				repeat:-1,
				ease:Quart.easeIn,
				yoyo:true
			}
			
		);
	}
	
	private function doActionConstruct():Void
	{    
		if(smartTime != null) smartTime.refreshText(TimeManager.getInstance().getTimeToFinishBuildingStringFormat(dateEndBuilding));
		if (TimeManager.getInstance().getTimeInSecondsToFinishBuilding(dateEndBuilding) >= 0)
		{	
			//timerContainer.destroyTimer();
			//timerContainer = null;
			if (currentState == UPGRADING_STATE) upgrade();
			if (timerContainer != null) 
			{
				timerContainer.off(MouseEventType.CLICK, onSkipCdTimer);
				timerContainer.on(MouseEventType.MOUSE_OVER, onDisplayTime);
				timerContainer.on(MouseEventType.MOUSE_OUT, offDisplayTime);
				GameStage.getInstance().getInfoBulleContainer().removeChild(timerContainer);
			}
			setModeValidationConstruct();

			//dateEndBuilding = null;
			//elem.dateEndBuilding = dateEndBuilding;
			//releaseElementList();		
		}
		
		else  timeConstruction = TimeManager.getInstance().getTimeToFinishBuildingStringFormat(elem.dateEndBuilding);
	}
	
	private function setModeValidationConstruct():Void
	{
		stateTest = DEFAULT_STATE;
		currentState = WAITING_STATE;
		changeAsset(WAITING_STATE);
		filters = null;
		elem.mode = WAIT_VALIDATION;
		releaseElementList();
		DataManager.getInstance().save(PoolObject.elementList);
		DataBaseAction.getInstance().releaseBuildingMode(elem.instanceID, elem.mode);
		if (!BullesManager.getInstance().isBuildingHasBulles(instanceID)) BullesManager.getInstance().initBulles(100, this);
		SoundManager.getSound("soundPlayerFinishCreateBuilding").play();
		doAction = doActionValidationConstruct;
	}

	private function doActionValidationConstruct():Void
	{
		
	}
	
	override private function setModeNormal():Void
	{
		stateTest = DEFAULT_STATE;
		currentState = WAITING_STATE;
		changeAsset(currentState);
		filters = null;
		elem.mode = currentState;
		releaseElementList();
		DataManager.getInstance().save(PoolObject.elementList);
		DataBaseAction.getInstance().releaseBuildingMode(elem.instanceID, elem.mode);
		super.setModeNormal();
		/*var graph:Graphics = new Graphics();
		graph.beginFill();
		graph.drawRect(x - 100, y - 200, width, height);
		graph.endFill();
		addChild(graph);
		graph.alpha = 0.3;*/
	}

	override private function doActionNormal():Void
	{
		super.doActionNormal();
	}
	
	private function setModeCollect():Void {
		
		
		currentState = COLLECTING_STATE;
		changeAsset(currentState);
		elem.mode = currentState;
		releaseElementList();
		DataManager.getInstance().save(PoolObject.elementList);
		DataBaseAction.getInstance().releaseBuildingMode(elem.instanceID, elem.mode);
		
		doAction = doActionCollecting;
	}
	
	private function doActionCollecting():Void {
	
		
	}
	
	
	
	
	
	public function setModeMove():Void
	{

		World.getInstance().getRegion(cast(currentRegionCoor.x, Int), cast(currentRegionCoor.y, Int)).layers[1].remove(this);
		World.getInstance().getRegion(cast(currentRegionCoor.x, Int), cast(currentRegionCoor.y, Int)).layers[1].container.removeChild(this);
		Spawner.getInstance().moveBuilding(this);
	}
	
	// Methodes : 
	//
	public function onBulleExplose():Void
	{
	    Timer.delay(onTime, 1500);
		//var lXp:Int = FTUEManager.isFTUEon()? XpToLevel.xpToNextLevel[Player.getInstance().level]:20;
		//Player.getInstance().addExp(lXp);
		setModeNormal();
	}
	
	private function onTime():Void
	{
		var lXp:Int = FTUEManager.isFTUEon()? Math.round(XpToLevel.xpToNextLevel[Player.getInstance().level] / Player.getInstance().level):20;
		if (Player.getInstance().level == 2) lXp = 20; 
		Player.getInstance().addExp(lXp);
		event.emit("onBulle");
	}
	
	//Upgrade :
	
	public function startUpgrading():Void {
	
		if (level < maxLevel) {
			payForUpgrade();
			setModeConstruct(true);
			SoundManager.getSound("soundBuildingUpgrade").play();
			UIManager.getInstance().closeCurrentPopin();
		}
	}
	
	public function upgrade():Void
	{
		if (level < maxLevel)
		{
			energyCost = costUpgradeEnergy;
			elem.levelUpGrade = ++level;
			changeAsset(currentState);
			releaseElementList();
			DataManager.getInstance().save(PoolObject.elementList);
			DataBaseAction.getInstance().changeBuildingLevel(elem.instanceID, level);
			if (level != maxLevel) setUpgradeCost();
			changeBehavior();
			Player.getInstance().addExp(35);
			
		}
	}
	
	private function changeBehavior():Void {
	
		switch (level) {
		
			case 2:
				changeBehaviorLevel2();
			case 3:
				changeBehaviorLevel3();
			case 4:
				changeBehaviorLevel4();
		}
	}
	
	private function changeBehaviorLevel2():Void {
	
		
	}
	private function changeBehaviorLevel3():Void {
	
		
	}
	private function changeBehaviorLevel4():Void {
	
		
	}
	
	public function canAffordUpgrade():Bool {
		
		energyAdded = (costUpgradeEnergy - energyCost);
		
		if (GameManager.getInstance().godMode) return true;
	
		var lHasEnoughSC:Bool = Player.getInstance().hasEnoughQuantity(costUpgradeSC, Player.getInstance().softCurrency);
		var lHasEnoughMN:Bool = Player.getInstance().hasEnoughQuantity(costUpgradeMN, Player.getInstance().ressource);
		var lHasEnoughNRJ:Bool = Player.getInstance().hasEnoughEnergy(energyAdded);
		
		if (lHasEnoughSC && lHasEnoughMN && lHasEnoughNRJ) return true;
		else {
		
			if (!lHasEnoughMN) Hud.getInstance().noMaterialAnimation();
	 		if (!lHasEnoughSC) Hud.getInstance().noSCAnimation();
	 		if (!lHasEnoughNRJ) Hud.getInstance().noEnergyAnimation();
			return false;
		}
		
		return false;
	}
	
	private function setUpgradeCost():Void {
	
		
		var JSON_CONFIG:Dynamic = GameElement.JSON_CONFIG;
		var lTimeToUpgrade : String = upgradeTime+Std.string(level + 1);
		costUpgradeSC = Reflect.field(Reflect.field(JSON_CONFIG, className), lTimeToUpgrade).costSC;
		costUpgradeMN = Reflect.field(Reflect.field(JSON_CONFIG, className), lTimeToUpgrade).costMN;
		costUpgradeEnergy = Reflect.field(Reflect.field(JSON_CONFIG, className), lTimeToUpgrade).costEnergy;
	}
	
	private function payForUpgrade():Void {
	
		if (!GameManager.getInstance().godMode) {
			Player.getInstance().changePlayerValue(-costUpgradeSC, Player.TYPE_SOFTCURRENCY, false);
			Player.getInstance().changePlayerValue( -costUpgradeMN, Player.TYPE_RESSOURCE, false);
			Player.getInstance().increaseEnergyConsumed(energyAdded);
		}
		
	}
	
	//Timer && button :
	public function newTimeToBuild():Void
	{
		var JSON_CONFIG:Dynamic = GameElement.JSON_CONFIG;
		timeToBuild =
		{
			seconds:Reflect.field(Reflect.field(JSON_CONFIG, className), constructTime).seconds,
			minutes:Reflect.field(Reflect.field(JSON_CONFIG, className), constructTime).minutes,
			hours:Reflect.field(Reflect.field(JSON_CONFIG, className), constructTime).hours,
			days:Reflect.field(Reflect.field(JSON_CONFIG, className), constructTime).days
		};
	}
	
	public function newTimeToUpgrade():Void
	{
		var JSON_CONFIG:Dynamic = GameElement.JSON_CONFIG;
		
		var lTimeToUpgrade : String = upgradeTime+Std.string(level + 1);
		
		timeToBuild =
		{
			seconds:Reflect.field(Reflect.field(JSON_CONFIG, className), lTimeToUpgrade).seconds,
			minutes:Reflect.field(Reflect.field(JSON_CONFIG, className), lTimeToUpgrade).minutes,
			hours:Reflect.field(Reflect.field(JSON_CONFIG, className), lTimeToUpgrade).hours,
			days:Reflect.field(Reflect.field(JSON_CONFIG, className), lTimeToUpgrade).days
		};
	}
	
	private function addBtnSkipCDTimer():Void
	{
		timerContainer.on(MouseEventType.CLICK, onSkipCdTimer);
		timerContainer.on(MouseEventType.MOUSE_OVER, onDisplayTime);
		timerContainer.on(MouseEventType.MOUSE_OUT, offDisplayTime);
	}
	
	private var smartTime:SmartText;
	private function onDisplayTime():Void
	{
		smartTime = new SmartText(GameStage.getInstance().getInfoBulleContainer(), 100, 100, 40, "Arial Black", "white", "left", false, "blue", 0, 30, 0, 0, 20, 20);
		smartTime.refreshText(TimeManager.getInstance().getTimeToFinishBuildingStringFormat(dateEndBuilding));
		timerContainer.addChild(smartTime);
		smartTime.position.x -= 100;
		smartTime.position.y -= 150;
	}
	
	private function offDisplayTime():Void
	{
		if (smartTime != null) timerContainer.removeChild(smartTime);
		smartTime = null;
	}

	/**
	 * ouvre la popin de confirmation et l'initialise
	 */
	private function onSkipCdTimer():Void
	{
		
		UIManager.getInstance().openPopin(TimeBased.getInstance());
		//if (!FTUEManager.isFTUEon()) DynamicPopin.getInstance().init("Accélerer le temps en dépensant " + hardToSkipTimer + " cristaux ?", cdTimerSkiped);
		//else DynamicPopin.getInstance().init("Gratuit pour cette fois", cdTimerSkiped);
		TimeBased.getInstance().setText(this);
	}
	
	/**
	 * skip le cooldown et retire la hardCurrency si le joueur en a assez
	 */
	public function cdTimerSkiped():Void 
	{
		if (Player.getInstance().hasEnoughQuantity(hardToSkipTimer, Player.getInstance().hardCurrency) || Spawner.getInstance().godMode)
		{
			if (timerContainer != null) {
				timerContainer.off(MouseEventType.CLICK, onSkipCdTimer);
				timerContainer.off(MouseEventType.MOUSE_OVER, onDisplayTime);
				timerContainer.off(MouseEventType.MOUSE_OUT, offDisplayTime);
			}
			dateEndBuilding = Date.now();
			if (FTUEManager.currentStep >= FTUEManager.steps.length) Player.getInstance().changePlayerValue( -hardToSkipTimer, Player.TYPE_HARDCURRENCY);
			GameStage.getInstance().getInfoBulleContainer().removeChild(timerContainer);
			//timerContainer.destroyTimer();
			//timerContainer = null;
			if (currentState == UPGRADING_STATE) upgrade();
			setModeValidationConstruct();
			//dateEndBuilding = null;
			elem.dateEndBuilding = dateEndBuilding;
			releaseElementList();
		}
		else Hud.getInstance().noHCAnimation();
	}

	//Position & Move
	override public function changePosition(pX:Int, pY:Int)
	{
		super.changePosition(pX, pY);
		colMax = colMin + localWidth - 1;
		rowMax = rowMin + localHeight - 1;
	}

	

	public function saveNewPosition(pX:Int, pY:Int, ?pRegionX:Int=null, ?pRegionY:Int=null):Void
	{
		var lRegion:Region = Spawner.getInstance().currentRegion;
		elem.x = cast(pX);
		elem.y = cast(pY);
		position = IsoManager.modelToIsoView(new Point(pX, pY));
		var lGlobalPoint = new Point(0, 0);
		lGlobalPoint.x = lRegion.x * Region.WIDTH + pX;
		lGlobalPoint.y = lRegion.y * Region.HEIGHT + pY;
		lGlobalPoint = IsoManager.modelToIsoView(lGlobalPoint);
		elem.globalX = lGlobalPoint.x;
		elem.globalY = lGlobalPoint.y;
		initColAndRow();
		globalPosition = new Point(elem.globalX, elem.globalY);
		elem.regionX = (pRegionX == null ? lRegion.x : pRegionX);
		elem.regionY = (pRegionY == null ? lRegion.y : pRegionY);
		currentRegionCoor = new Point(elem.regionX, elem.regionY);
		World.getInstance().getRegion(cast(currentRegionCoor.x, Int), cast(currentRegionCoor.y, Int)).layers[1].add(this);
		World.getInstance().getRegion(cast(currentRegionCoor.x, Int), cast(currentRegionCoor.y, Int)).layers[1].container.addChild(this);

		DataBaseAction.getInstance().releaseBuildingPosition(elem.instanceID, elem.regionX, elem.regionY, elem.x, elem.y);
	}
	
	
	
	//Energy
	/**
	 * lors de l'ajout d'un batiment ajoute l'energie qu'il consomme au player
	 */
	public function addEnergyToPlayer():Void
	{
		Player.getInstance().increaseEnergyConsumed(energyCost);
	}
	
	
	
	override public function setModeDestroy():Void 
	{
		super.setModeDestroy();
		Player.getInstance().changePlayerValue(sellingCost, Player.TYPE_SOFTCURRENCY, false);
		Player.getInstance().increaseEnergyConsumed( -energyCost);
		Building.updateBuildingsCarac();
	}
	
	//Filtre
	public function applyAllowedFilter():Void 
	{	
		if (filters == null) filters = [allowedFilter];
	}
	
	public function removeAllowedFilter():Void 
	{	
		if (filters != null) filters = null;
	}
	
	
	
	override public function dispose():Void 
	{
		if (BullesManager.getInstance().isBuildingHasBulles(instanceID)) BullesManager.getInstance().destroyGroupOfBulles(instanceID, true);
		if (timerContainer != null) 
		{
			timerContainer.off(MouseEventType.CLICK, onSkipCdTimer);
			timerContainer.off(MouseEventType.MOUSE_OVER, onDisplayTime);
			timerContainer.off(MouseEventType.MOUSE_OUT, offDisplayTime);
			GameStage.getInstance().getInfoBulleContainer().removeChild(timerContainer);
			timerContainer = null;
		}
		super.dispose();
	}

}