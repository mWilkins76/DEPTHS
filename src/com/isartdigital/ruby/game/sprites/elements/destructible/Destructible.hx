package com.isartdigital.ruby.game.sprites.elements.destructible;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.ruby.game.world.Region;
import com.isartdigital.ruby.game.world.World;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.popin.DynamicPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.game.iso.IsoManager;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.save.DestructableType;
import com.isartdigital.utils.ui.SmartText;
import js.Lib;
import pixi.core.math.Point;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class Destructible extends GameElement
{

	public static var arrayConfigDestructible(default, null):Array<String> = [];
	public static var totalConfig(default, null) = 5;
	private var timerContainer:SmartText;
	private var percentageContainer:SmartText;

	public var timeToDestroy:Date;

	public var destructableType(default, null):DestructableType;

	public function new(pAsset:String=null)
	{
		super(pAsset);
	}

	override public function init(?pElem:Element=null):Void
	{
		var lDestructible:DestructableType = DataManager.getInstance().listDestructableTypes.get(pElem.assetName);
		localWidth = lDestructible.width;
		localHeight = lDestructible.height;
		super.init(pElem);
		assetName = elem.assetName;
		destructableType = DataManager.getInstance().listDestructableTypes.get(assetName);
		var timeString:String = DataManager.getInstance().listDestructableTypes.get(assetName).destructionTime;
		var arrayTime:Array<String> = timeString.split(":");
	}

	override public function start():Void
	{
		super.start(); changeState();
	}

	private function changeState():Void
	{
		if (elem.mode == "Destruction") setModeDestruction();
	}

	private function convertTimeStamp(pHour:Int, pMin:Int, pSec:Int):Float
	{
		var lMin:Float = pMin;
		var lHour:Float = pHour;

		lMin *= 60;
		lHour *= 3600;

		return DateTools.seconds(pSec + lMin + lHour);
	}

	public function setModeDestruction():Void
	{

		doAction = doActionDestruction;
		releaseElementList();

		timerContainer = new SmartText(GameStage.getInstance().getInfoBulleContainer(), 100, 100, 40, "Arial Black", "white", "left", false, "blue", 0.9, 30, 0, 0, 20, 20);
		GameStage.getInstance().getInfoBulleContainer().addChild(timerContainer);
		addChild(timerContainer);
		timerContainer.interactive = true;
		timerContainer.buttonMode = true;
		addBtnSkipCDTimer();

	}

	public function destructionDB():Void
	{
		var dataTime:String = DataManager.getInstance().listDestructableTypes.get(assetName).destructionTime;
		var arrayTime:Array<String> = dataTime.split(":");
		elem.dateStartBuilding = Date.now();
		dateStartBuilding = elem.dateStartBuilding;
		elem.dateEndBuilding = DateTools.delta(dateStartBuilding, convertTimeStamp(Std.parseInt(arrayTime[0]), Std.parseInt(arrayTime[1]), Std.parseInt(arrayTime[2])));
		dateEndBuilding = elem.dateEndBuilding;
		elem.mode = "Destruction";
		DataBaseAction.getInstance().releaseDestructibleMode(elem.assetName, elem.instanceID, elem.mode);
		setModeDestruction();
	}

	private function doActionDestruction():Void
	{
		if (TimeManager.getInstance().getTimeInSecondsToFinishBuilding(dateEndBuilding) >= 0)
		{
			createArtefact();
			timerContainer.destroyTimer();
			DataBaseAction.getInstance().destroyDestructible(elem.instanceID);
			World.getInstance().getRegion(cast(currentRegionCoor.x, Int), cast(currentRegionCoor.y, Int)).layers[1].remove(this);
			dispose(); // à bouger à la fin de l'anim destroy
			PoolObject.elementList.remove(instanceID);
		}

		else{
			timerContainer.refreshText(TimeManager.getInstance().getTimeToFinishBuildingStringFormat(elem.dateEndBuilding));
		}
	}

	private function addBtnSkipCDTimer():Void
	{
		timerContainer.on(MouseEventType.CLICK, onSkipCdTimer);
		timerContainer.on(TouchEventType.TAP, onSkipCdTimer);
	}

	/**
	 * ouvre la popin de confirmation et l'initialise
	 */
	private function onSkipCdTimer():Void
	{
		var cost:Int = DataManager.getInstance().listDestructableTypes.get(assetName).skipHCCost;
		UIManager.getInstance().openPopin(DynamicPopin.getInstance());
		if (!FTUEManager.isFTUEon()) DynamicPopin.getInstance().init("skip cooldown with " + cost + " hard currency ?", cdTimerSkiped);
		else DynamicPopin.getInstance().init("FTUE gratuit", cdTimerSkiped);
	}

	private function cdTimerSkiped():Void
	{
		var cost:Int = DataManager.getInstance().listDestructableTypes.get(assetName).skipHCCost;
		if (Player.getInstance().hasEnoughQuantity(cost, Player.getInstance().hardCurrency) || Spawner.getInstance().godMode)
		{
			timerContainer.off(MouseEventType.CLICK, onSkipCdTimer);
			dateEndBuilding = Date.now();
			if (!FTUEManager.isFTUEon()) Player.getInstance().changePlayerValue(-cost, Player.TYPE_HARDCURRENCY);
		}
	}

	private function createArtefact():Void
	{
		var random:Int = Math.round(Math.random() +1);

		var elemToSpawn:String = "DestructiblePebbles" + random;
		var lDestructible:Destructible = new Destructible(elemToSpawn);
		var lElement:Element =
		{
			instanceID:elemToSpawn + Date.now().getTime(),
			type:elemToSpawn,
			width:DataManager.getInstance().listDestructableTypes.get(elemToSpawn).width,
			height:DataManager.getInstance().listDestructableTypes.get(elemToSpawn).height,
			x:elem.x,
			y:elem.y,
			globalX:elem.globalX,
			globalY:elem.globalY,
			regionX:elem.regionX,
			regionY:elem.regionY,
			layer:0,
			assetName: elemToSpawn,
			mode:"Waiting"
			//dateEndBuilding:Date.now(),
			//dateStartBuilding:Date.now(),
			//softCurrency:DataManager.getInstance().listDestructableTypes.get(destructible.type).softCurrencyCost
		}
		lDestructible.init(lElement);
		lDestructible.start();

		World.getInstance().getRegion(elem.regionX, elem.regionY).layers[0].add(lDestructible);
		World.getInstance().getRegion(elem.regionX, elem.regionY).layers[0].container.addChild(lDestructible);

		lDestructible.position = IsoManager.modelToIsoView(new Point(lElement.x, lElement.y));

		PoolObject.elementList.set(lElement.instanceID, lElement);
		DataBaseAction.getInstance().addDestructible(lElement.assetName, lElement.instanceID, lElement.regionX, lElement.regionY, lElement.x, lElement.y, lElement.layer);
	}

	public static function createDestructibles(pRegion:Region):Void
	{

		var random:Int = Math.round(Math.random() * (arrayConfigDestructible.length-1));
		var currentConfig:Dynamic = GameLoader.getContent(arrayConfigDestructible[random]);

		for (instance in Reflect.fields(currentConfig))
		{
			var destructible:Dynamic = Reflect.field(currentConfig, instance);

			var lDestructible:Destructible = new Destructible(destructible.type);

			var lElement:Element =
			{
				instanceID:destructible.type + Std.string(Date.now().getTime()),
				type:destructible.type,
				width:DataManager.getInstance().listDestructableTypes.get(destructible.type).width,
				height:DataManager.getInstance().listDestructableTypes.get(destructible.type).height,
				x:Std.parseInt(destructible.x),
				y:Std.parseInt(destructible.y),
				globalX:Std.parseInt(destructible.globalX),
				globalY:Std.parseInt(destructible.globalY),
				regionX:pRegion.x,
				regionY:pRegion.y,
				layer:1,
				assetName: destructible.type,
				mode:"Waiting",
				//dateEndBuilding:Date.now(),
				dateStartBuilding:Date.now(),
				softCurrency:DataManager.getInstance().listDestructableTypes.get(destructible.type).softCurrencyCost
			}
			lDestructible.init(lElement);
			lDestructible.start();

			pRegion.layers[1].add(lDestructible);
			pRegion.layers[1].container.addChild(lDestructible);

			lDestructible.position = IsoManager.modelToIsoView(new Point(lElement.x, lElement.y));

			PoolObject.elementList.set(lElement.instanceID, lElement);
			DataBaseAction.getInstance().addDestructible(lElement.assetName, lElement.instanceID, lElement.regionX, lElement.regionY, lElement.x, lElement.y, lElement.layer);
		}
	}

	public static function createFirstDestructible(pAsset:String, pX:Int, pY:Int):Void
	{
		var lDestructible:Destructible = new Destructible(pAsset);
		
		var lType:DestructableType = DataManager.getInstance().listDestructableTypes.get(pAsset);
		

		var lElement:Element =
		{
			instanceID:pAsset + Std.string(Date.now().getTime()),
			type:pAsset,
			width:DataManager.getInstance().listDestructableTypes.get(pAsset).width,
			height:DataManager.getInstance().listDestructableTypes.get(pAsset).height,
			x:pX,
			y:pY,
			globalX:0,
			globalY:0,
			regionX:pX,
			regionY:pY,
			layer:1,
			assetName: pAsset,
			mode:"Waiting",
			//dateEndBuilding:Date.now(),
			dateStartBuilding:Date.now(),
			softCurrency:DataManager.getInstance().listDestructableTypes.get(pAsset).softCurrencyCost
		}
		lDestructible.init(lElement);
		lDestructible.start();

		World.getInstance().getRegion(0,0).layers[1].add(lDestructible);
		World.getInstance().getRegion(0,0).layers[1].container.addChild(lDestructible);

		lDestructible.position = IsoManager.modelToIsoView(new Point(lElement.x, lElement.y));

		PoolObject.elementList.set(lElement.instanceID, lElement);
		DataBaseAction.getInstance().addDestructible(lElement.assetName, lElement.instanceID, lElement.regionX, lElement.regionY, lElement.x, lElement.y, lElement.layer);
	}

}