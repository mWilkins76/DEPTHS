package com.isartdigital.ruby.ui.popin.incubator;

import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.specialFeature.managers.SpecialFeatureAliens;
import com.isartdigital.ruby.game.sprites.elements.alienbuilding.AlienIncubator;
import com.isartdigital.ruby.game.sprites.elements.aliens.Alien;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienEsthetique;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienBuffer;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienProducer;
import com.isartdigital.ruby.game.sprites.elements.urbanbuilding.translationClass.Schemas;
import com.isartdigital.ruby.game.world.MapInteractor;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.popin.incubator.GeneButton;
import com.isartdigital.ruby.ui.popin.incubator.GeneSpot;
import com.isartdigital.ruby.ui.popin.Menu;
import com.isartdigital.ruby.ui.popin.building.datas.IncubatorSchema;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.ds.ArraySort;
import haxe.ds.Vector;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.sprites.Sprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Guillaume Zegoudia
 */

typedef CurrentAlienIncubator=
{
	var alienIncubator:AlienIncubator;
	var alienIncubatorId:String;
	var alienIncubatorLevel:Int;
	var alienIncubatorCurrentAlien1:AlienCarac;
	var alienIncubatorCurrentAlien2:AlienCarac;
}
class Incubator extends Menu
{
	
	/****** REWORK DES VARIABLES ******/
	
	/** STRING **/
	
	//CONTAINERS
	private static var GENE_CONTAINER:String = "GeneContainer";
	private var INSEMINATE_CONTAINER:String = "Incubator";
	private static var SCHEMA_CONTAINER:String = "SchemaContainer";
	private static var FILTER_CONTAINER:String = "TabContainer";
	private var FILTER_BUTTON:String = "TabSwitch2";
	private var SCHEMA_BUTTON:String = "Incubator_clipSwitchSchema";
	
	private var TXT_GENE:String = "txt_Genes";

	public static var listSchema:Map<String, IncubatorSchema> = new Map<String, IncubatorSchema>();	
	private var geneContainer:SmartComponent;
	private var currentBuilding:AlienIncubator;
	private var schemaContainer:SmartComponent;
	private var offsetSchemaItem:Point;
	private var availableSchema:Array<SchemaSwitchItem>;
	
	private var inseminator1:Inseminator;
	private var inseminator2:Inseminator;
	
	public var geneSelected:Int;
	public var quantityMax:Int;
	
	public var listGeneBtn:Array<GeneButton>;

	/**
	 * instance unique de la classe Incubator
	 */
	private static var instance: Incubator;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Incubator
	{
		if (instance == null) instance = new Incubator();
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

	override function init()
	{
		super.init();
		
		availableSchema = new Array<SchemaSwitchItem>();
		geneContainer = cast(getChildByName(GENE_CONTAINER), SmartComponent);
		schemaContainer = cast(getChildByName(SCHEMA_CONTAINER), SmartComponent);
		
		initSchemaList();
		listGeneBtn = new Array<GeneButton>();
		var currentGene : GeneButton;
		for (i in 0 ... geneContainer.children.length) {
			if (geneContainer.children[i].name.substr(0, 4) == "Gene")
			{
				currentGene = cast(geneContainer.children[i], GeneButton);
				currentGene.init();
				currentGene.idGene = i + 1;
				currentGene.initSup();
				listGeneBtn.push(currentGene);
			}
		}
		
		initInseminators();
	}
	private function initSchemaButtons():Void
	{
		var currentGene : GeneButton;
		for (i in 0 ... schemaContainer.children.length) {
			currentGene = cast(geneContainer.children[i], GeneButton);
			currentGene.id = i+1;
			currentGene.init();
		}
	}
	private function newSchemaButton(pContainer:SmartComponent, pSchema:IncubatorSchema, pID:Int, pFirstOffSet:Point):Void
	{
		availableSchema.push(Type.createInstance(SchemaSwitchItem, []));
		availableSchema[pID].x = pFirstOffSet.x + pID * offsetSchemaItem.x;
		availableSchema[pID].y = pFirstOffSet.y + pID * offsetSchemaItem.y;
		availableSchema[pID].setInfo(pSchema);
		availableSchema[pID].name = "IncubatorSchema" + pID;
		schemaContainer.addChild(availableSchema[pID]);
		FTUEManager.register(availableSchema[pID]);
	}
	private function initSchemaList():Void
	{	
		offsetSchemaItem = new Point(schemaContainer.children[0].x - schemaContainer.children[1].x, schemaContainer.children[0].y - schemaContainer.children[1].y);
		var lFirstItemPosition:Point =  schemaContainer.getChildByName("Schema #0").position;
		destroyAllChildInContainer(schemaContainer);
		
		var lList:Array<Schemas> = DataManager.getInstance().getUnlockedSchemas();
		var lSchema:IncubatorSchema;
		for (i in 0...lList.length) 
		{
			if(i > 4) break;
			lSchema = listSchema.get(Std.string(lList[i].idSchema));
			newSchemaButton(schemaContainer, lSchema, i, lFirstItemPosition);
			//var lSprite:UISprite = 
		}
	}
	
	private function initInseminators():Void
	{
		inseminator1 = cast(getChildByName("Incubator #0"), Inseminator);
		inseminator2 = cast(getChildByName("Incubator #1"), Inseminator);
		inseminator1.init();
		inseminator2.init();
	}

	public function initializationCurrentBuildingIncubator(pAlienIncubator:AlienIncubator):Void
	{
		currentBuilding = pAlienIncubator;
		initAlienInIncubator();
	}
	
	public function onClickSchema(pInfo:IncubatorSchema)
	{
		if (!inseminator1.isBusy) inseminator1.setInfo(pInfo);
		else if (!inseminator2.isBusy) inseminator2.setInfo(pInfo);
		else return;
	}

	private function checkQuantity(pKey:IncubatorSchema):Bool
	{
		var quantity1:Int= Reflect.getProperty(Player.getInstance(), "gene" + pKey.gene1);
		var quantity2:Int= Reflect.getProperty(Player.getInstance(), "gene" + pKey.gene2);
		var quantity3:Int= Reflect.getProperty(Player.getInstance(), "gene" + pKey.gene2);
		if (quantity1 >= 100 && quantity2 >= 100 && quantity3 >= 100 )
		{
			quantity1 -= 100;
			quantity2 -= 100;
			quantity3 -= 100;
			Reflect.setProperty(Player.getInstance(), "gene" + pKey.gene1, quantity1);
			Reflect.setProperty(Player.getInstance(), "gene" + pKey.gene2, quantity2);
			Reflect.setProperty(Player.getInstance(), "gene" + pKey.gene3, quantity3);

			var txtNumberGene:TextSprite = cast(getChildByName("txt_gene" +  pKey.gene1 + "Quantity"), TextSprite);
			txtNumberGene.text = Std.string(quantity1);

			var txtNumberGene:TextSprite = cast(getChildByName("txt_gene" +  pKey.gene2+ "Quantity"), TextSprite);
			txtNumberGene.text = Std.string(quantity2);

			var txtNumberGene:TextSprite = cast(getChildByName("txt_gene" +  pKey.gene3 + "Quantity"), TextSprite);
			txtNumberGene.text = Std.string(quantity3);

			DataBaseAction.getInstance().updateGene();
			return true;
		}
		return false;
	}

	public function createAlien(pInfo:IncubatorSchema, pInsemitaor:Inseminator):Void
	{
		var lString:String = pInfo.tableXenos == "SpecialFeatureAliens"? "AlienForeur":pInfo.tableXenos;
		var lType:Dynamic = Alien.getAlienType(pInfo.type, DataManager.getInstance().getAlienArray(lString));
		var alienID:String = pInfo.type+Date.now().getTime();
		var lDate:Date = Date.fromString(lType.time);
		var lTimeStamp:Float = TimeManager.getInstance().convertInStamp(lDate.getSeconds(), lDate.getMinutes(), lDate.getHours()-1);
		var lDelta:Date = DateTools.delta(Date.now(), lTimeStamp);
		var lAlien:AlienElement =
		{
			idAlien:alienID,
			idBuilding:currentBuilding.instanceID,
			mode:"Constructing",
			name:pInfo.type,
			type:lString,
			nomPropre:pInfo.xenoName,
			stamina:6,
			level:1,
			startTime:Date.now().toString(),
			endTime:lDelta.toString(),
			carac:lType,
			idPlayer:Player.getInstance().id
		}
		Alien.alienElementList.push(lAlien);
		DataBaseAction.getInstance().addAlien(lAlien.idAlien, lAlien.idBuilding, lAlien.type, lAlien.name, lAlien.nomPropre, lAlien.stamina, lType.time);		
		pInsemitaor.setTime(lAlien.endTime, lAlien);
		
	}
	
	private function initAlienInIncubator():Void
	{
		var counter:Int = 0;
		var lInseminator:Inseminator;
		for (alien in Alien.alienElementList) 
		{
			if (counter >= 2) break;
			if (alien.idBuilding == currentBuilding.instanceID) 
			{
				lInseminator = counter == 0? inseminator1:inseminator2;
				lInseminator.setAlien(alien);
				counter++;
			}
		}
	}
	
	override public function close():Void 
	{
		super.close();
		MapInteractor.getInstance().modalPopinOpened = false;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		instance = null;
	}

}