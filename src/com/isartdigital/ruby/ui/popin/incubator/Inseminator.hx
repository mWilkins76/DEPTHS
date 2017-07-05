package com.isartdigital.ruby.ui.popin.incubator;
import com.isartdigital.ruby.game.player.Player;
import com.isartdigital.ruby.game.sprites.elements.aliens.AlienElement;
import com.isartdigital.ruby.ui.popin.building.datas.IncubatorSchema;
import com.isartdigital.ruby.utils.TimeManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.sprites.Sprite;

/**
 * ...
 * @author Jordan Dachicourt
 */
class Inseminator extends SmartComponent
{
	
	public static var list:Array<Inseminator> = new Array<Inseminator>();
	
	private var SPOT_CONTAINER:String = "spotContainer";
	private var RESULTAT:String = "resultat";
	private var XENO_NAME:String = "xenoName";
	private var XENO_TEXTNAME:String = "txt_xenoNameUpgrading";
	private var INSEMINATE_BUTTON:String = "inseminateBtn";
	private var INSEMINATE_TIME_TEXT:String = "txt_timer";
	private var SKIP_BUTTON:String = "skipBtn";
	private var MANAGE_BUTTON:String = "manageBtn";
	
	private var result:UISprite;
	private var spotContainer:SmartComponent;
	private var manageBtn:SmartButton;
	private var skipBtn:SmartButton;
	private var inseminateBtn:TimerIncubator;
	private var inseminateTimeText:TextSprite;
	private var xenoName:SmartComponent;
	private var xenoTextName:TextSprite;
	private var xenoSprite:UISprite;
	
	public var listGenoSpot:Array<GeneSpot>;
	public var isBusy:Bool = false;
	public var geneInfo:IncubatorSchema;
	public var endTime:String;
	
	private var alien:AlienElement;

	public function new(pID:String=null) 
	{
		super(pID);
	}
	
	public function init():Void {
		list.push(this);
		result = cast(getChildByName(RESULTAT), UISprite);
		spotContainer = cast(getChildByName(SPOT_CONTAINER), SmartComponent);
		xenoName = cast(getChildByName(XENO_NAME), SmartComponent);
		xenoTextName = cast(xenoName.getChildByName(XENO_TEXTNAME), TextSprite);
		inseminateBtn = cast(getChildByName(INSEMINATE_BUTTON), TimerIncubator);
		inseminateTimeText = cast(inseminateBtn.getChildByName(INSEMINATE_TIME_TEXT), TextSprite);
		skipBtn = cast(getChildByName(SKIP_BUTTON), SmartButton);
		manageBtn = cast(getChildByName(MANAGE_BUTTON), SmartButton);	
		
		stockGeneSpot();
		if (!isBusy)
		{
			manageBtn.visible = false;
			skipBtn.visible = false;
			inseminateTimeText.textField.text = "";
			//inseminateTimeText.visible = false;
			xenoTextName.text = "";
			inseminateBtn.on(MouseEventType.CLICK, onInseminate);
			inseminateBtn.on(TouchEventType.TAP, onInseminate);
		}		
	}
	
	private function stockGeneSpot():Void
	{
		listGenoSpot = new Array<GeneSpot>();
		for (i in 0...spotContainer.children.length) 
		{
			listGenoSpot.push(cast(spotContainer.children[i], GeneSpot));
			listGenoSpot[i].inseminator = this;
		}
	}
	
	private function isGenesFilled():Bool
	{
		for (spot in listGenoSpot) if (!spot.isSelected) return false;
		return true;
	}
	
	private function lockGeneSpot():Void
	{
		for (spot in listGenoSpot) spot.visible = false;
	}

	private function onInseminate():Void
	{
		if (!isGenesFilled()) return;
		lockGeneSpot();
		isBusy = true;
		updatePlayerGene();
		Incubator.getInstance().createAlien(geneInfo, this);
	}
	
	private function updatePlayerGene():Void
	{
		var lGene:Int;
		for (gene in listGenoSpot) 
		{
			lGene = Std.int(Reflect.getProperty(Player.getInstance(), "gene" + gene.geneId)) - gene.geneQuant;
			Reflect.setProperty(Player.getInstance(), "gene" + gene.geneId, lGene);
		}
		DataBaseAction.getInstance().updateGene();
		for (geneBtn in Incubator.getInstance().listGeneBtn) geneBtn.updateQuantityGene();
	}
	
	public function setInfo(pInfo:IncubatorSchema):Void
	{
		var lString:String;
		geneInfo = pInfo;
		listGenoSpot[0].setInfoGene(pInfo.gene1, pInfo.gene1quant);
		listGenoSpot[1].setInfoGene(pInfo.gene2, pInfo.gene2quant);
		listGenoSpot[2].setInfoGene(pInfo.gene3, pInfo.gene3quant);	
		
		xenoTextName.text = pInfo.xenoName; // a changer, pas les bons noms
		if (xenoSprite != null) result.removeChild(xenoSprite);
		
		xenoSprite = new UISprite("XenoPage_" + pInfo.type + (pInfo.tableXenos == "SpecialFeatureAliens" ? "" :"_1"));
		result.addChild(xenoSprite);
		
	}
	
	public function isSkiped():Void
	{
		endTime = null;
		alien.endTime = Date.now().toString();
		DataBaseAction.getInstance().releaseAlienMode(alien.idAlien, "Wait", Date.now());
	}
	
	public function isTransfered():Void
	{	
		result.removeChild(xenoSprite);
		xenoTextName.text = "";
		endTime = null;
		for (gene in listGenoSpot)
		{
			gene.unsetInfoGene();
			gene.visible = true;
		}
		isBusy = false;
		trace(alien);
		alien.idBuilding = "";
		alien.endTime = Date.now().toString();
		inseminateBtn.on(MouseEventType.CLICK, onInseminate);
		inseminateBtn.on(TouchEventType.TAP, onInseminate);
	}
	
	public function setAlien(pAlien:AlienElement):Void
	{
		isBusy = true;
		alien = pAlien;
		lockGeneSpot();
		xenoTextName.textField.text = pAlien.nomPropre;
		trace(pAlien);
		xenoSprite = new UISprite("XenoPage_" + pAlien.name + (pAlien.type == "AlienForeur" ? "" :"_1"));
		result.addChild(xenoSprite);
		if (Date.fromString(pAlien.endTime).getTime() < Date.now().getTime()) 
		{
			inseminateBtn.visible = false;
			manageBtn.visible = true;
		}
		else setTime(pAlien.endTime, pAlien);
	}

	public function setTime(pTime:String, pAlien:AlienElement):Void
	{
		alien = pAlien;
		endTime = pTime;
		inseminateBtn.off(MouseEventType.CLICK, onInseminate);
		inseminateBtn.off(TouchEventType.TAP, onInseminate);
		//inseminateTimeText.visible = true;
		var lTime:String = TimeManager.getInstance().getTimeToFinishBuildingStringFormat(Date.fromString(pTime));
		//inseminateTimeText.textField.text = lTime;
		inseminateBtn.currentText = lTime;
		inseminateBtn.initText(this);
	}
	
	public function doAction():Void
	{
		if (endTime == null || inseminateTimeText == null) return;
		inseminateBtn.currentText = TimeManager.getInstance().getTimeToFinishBuildingStringFormat(Date.fromString(endTime));
		inseminateBtn.updateText();
		//inseminateTimeText.textField.text = TimeManager.getInstance().getTimeToFinishBuildingStringFormat(Date.fromString(endTime));
	}
	
	override public function destroy():Void 
	{
		list.remove(this);
		super.destroy();
		inseminateBtn.off(MouseEventType.CLICK, onInseminate);
		inseminateBtn.off(TouchEventType.TAP, onInseminate);
	}
	
}