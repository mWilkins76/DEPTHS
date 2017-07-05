package com.isartdigital.ruby.ui.popin.incubator;

import com.isartdigital.ruby.ui.items.switchItems.SwitchGroupItem;
import com.isartdigital.ruby.ui.popin.incubator.Incubator;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import haxe.ds.ArraySort;
import pixi.flump.Sprite;

/**
 * ...
 * @author Guillaume Zegoudia
 */
class GeneSpot extends SwitchGroupItem
{
	private var NAME:String = "ItemName";
	private var textSpot(default, null):TextSprite;
	private var assetGene:UISprite;
	public var geneId:Int;
	public var geneQuant:Int;
	public var isSelected:Bool = false;
	public var inseminator:Inseminator;
	
	public function new(pID:String=null) 
	{
		super(pID);
	}
	
	function updateTextChild() {
		textSpot = cast(getChildByName(NAME), TextSprite);
	}
	
	override public function setNormal() 
	{
		super.setNormal();
		updateTextChild();
		update();
	}

	
	override public function setDisabled() 
	{
		super.setNormal();
		updateTextChild();
		update();
	}
	
	override public function setSelected() 
	{
		super.setNormal();
		updateTextChild();
		update(true);
	}
	
	public function initGene(pGene:Int):Void
	{
		geneId = pGene;
		setNormal();
		textSpot.text = "";
	}
	
	override function onOver():Void 
	{
		super.onOver();
		updateTextChild();
		update();
	}
	
	override function onOut():Void 
	{
		super.onOut();
		updateTextChild();
		update();
	}
	
	public function update(?isSelected = false) {
		if (geneId == null) return;
		if (geneQuant != null) textSpot.text = Std.string(geneQuant);
		if (assetGene != null && !isSelected) currentState.addChild(assetGene);
	}
	
	override function monClick():Void 
	{
		super.monClick();		
		if (Incubator.getInstance().geneSelected == geneId && Incubator.getInstance().quantityMax >= geneQuant)
		{
			isSelected = true;
			setSelected();
		}
		else 
		{
			for (gene in inseminator.listGenoSpot) {
			    setNormal();
				gene.isSelected = false;
				
			}
			
		}
		
		update();
	}
	
	public function setInfoGene(pId:Int, pQuant:Int):Void
	{
		geneId = pId;
		geneQuant = pQuant;
		assetGene = new UISprite("IncubatorGene" + pId);
		isSelected = true;
		update();
	}
	
	public function unsetInfoGene():Void
	{
		geneId = null;
		geneQuant = null;
		isSelected = false;
		update();
	}
	
}