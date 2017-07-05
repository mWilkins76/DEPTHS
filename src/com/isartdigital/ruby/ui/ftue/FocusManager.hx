package com.isartdigital.ruby.ui.ftue;

import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.ui.ftue.Arrow;
import com.isartdigital.ruby.ui.popin.RewardNotifications;
import com.isartdigital.ruby.ui.popin.building.BuildingMenu;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIComponent;
import com.isartdigital.utils.ui.UIPositionable;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.interaction.EventTarget;

	
/**
 * Classe Exemple destinée à gérer l'accès/verrouillage des élements du jeu pour la FTUE
 * Permet de pointer facilement un élement de jeu et desactiver le comportement des autres
 * @author Mathieu Anthoine
 */
class FocusManager extends Screen 
{
	
	/**
	 * instance unique de la classe FTUE
	 */
	private static var instance: FocusManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): FocusManager {
		if (instance == null) instance = new FocusManager();
		return instance;
	}
	
	private var arrow:Arrow;
	private var boule:BouleHighlight;
	private var arrowRotation:Float;
	private var target:DisplayObject;
	private var shadow:Container;
	private var currentStep:FTUEStep;
	private var lastStep:FTUEStep;
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pID:String=null) 
	{
		super(pID);
		modalImage = "assets/ftue_bg.png";
		
		shadow = new Container();
		shadow.name = "shadow";
	}
	
	public function setCurrentStep(pStep:FTUEStep):Void {
		if (pStep == null) return;
		if (currentStep != null) lastStep = currentStep;
		currentStep = pStep;	
	}

	/**
	 * Définit l'objet graphique à pointer
	 * @param	pTarget objet ciblé
	 * @param	pRotation rotation de la flèche qui pointe sur l'objet exprimé en degrés
	 */
	public function setFocus (pTarget:DisplayObject, ?pRotation:Float = 0): Void {
		if (!FTUEManager.isFTUEon()) return;
		if (target != null && target.parent == this) swap(shadow, target);
		target = pTarget;
		swap(target, shadow);
		arrowRotation = pRotation; 
		onResize();
	}
	
	/**
	 * Ferme le screen FTUE et replace les objets graphique comme il convient
	 */
	override public function close():Void 
	{
		if (target != null && target.parent == this) swap(shadow, target);
		super.close();
	}
	
	/**
	 * Echange l'objets graphique pointé avec un objet graphique "shadow"
	 * Dans le cas ou l'objet pointé est à sa place d'origine, il le met dans le Screen FTUE et place un repère (shadow) à sa place dans le conteneur d'origine
	 * Dans le cas ou l'objet pointé est dans le Screen FTUE, il le remet à sa place d'origine
	 * @param	pTarget objet dans le conteneur d'origine de l'objet ciblé
	 * @param	pFTUE objet dans le Screen FTUE
	 */
	private function swap (pTarget:DisplayObject, pFTUE: DisplayObject): Void {
		if (pTarget == null || pFTUE == null) return;
		if( pTarget.parent == null ) return;
		var lParent:Container = pTarget.parent;
		if (pTarget.name == "shadow" && lastStep != null)
		{
			addChildOnContainer(pTarget, pFTUE);
			if (Reflect.getProperty(pFTUE, "focusInFTUE") != null) 
			{
				if(Reflect.getProperty(pFTUE, "focusInFTUE")) Reflect.setProperty(pFTUE, "focusInFTUE", false);
			}
		}
		else 
		{
			lParent.addChildAt(pFTUE,lParent.getChildIndex(pTarget));
			pFTUE.position = pTarget.position;
			if (BuildingMenu.getInstance().isOpened) 
			{
				var lNextStepName:String = FTUEManager.steps[FTUEManager.currentStep + 1].name;	
				if (DataManager.getInstance().listBuildingTypes[lNextStepName] != null)
				{
					BuildingMenu.getInstance().panel.setInfo(DataManager.getInstance().listBuildingTypes[lNextStepName]);		
				}
				else if (FTUEManager.steps[FTUEManager.currentStep].text == "LABEL_FTUE_NOT_ENOUGH_MONEY")
				{
					BuildingMenu.getInstance().panel.setInfo(DataManager.getInstance().listBuildingTypes["AlienPaddockTiny"]);
				}
			}
		}
		addChildAt(pTarget, 0);
		if (Reflect.getProperty(pTarget, "focusInFTUE") != null) 
		{
			if(!Reflect.getProperty(pTarget, "focusInFTUE")) Reflect.setProperty(pTarget, "focusInFTUE", true);
		}
		
		if (Std.is (lParent, UIComponent)) {
			var lPositionnables:Array<UIPositionable> = untyped lParent.positionables;
			for (i in 0...lPositionnables.length) {
				if (lPositionnables[i].item == pTarget) {
					lPositionnables[i].item = cast(pFTUE,Container);
					break;
				}
			}
		}
	}
	
	private function addChildOnContainer(pObject:DisplayObject, pTarget:DisplayObject ):Void
	{
		if (pObject == null ) return;
		var lGrandParent:Container;
		if (lastStep.arGrandParentName != "") {
			var lArGparent:Container = pObject.parent.parent.parent;
			lGrandParent = pObject.parent.parent;
			cast(cast(lArGparent.getChildByName(lGrandParent.name), Container).getChildByName(pObject.parent.name), Container).addChildAt(pTarget,pObject.parent.getChildIndex(pTarget));			
		}
		else if (currentStep.grandParentName != "") 
		{
			lGrandParent = pObject.parent.parent;
			cast(lGrandParent.getChildByName(pObject.parent.name), Container).addChildAt(pTarget,pObject.parent.getChildIndex(pObject));
		}
		else pObject.parent.addChildAt(pTarget,pObject.parent.getChildIndex(pObject));		
	}
	
	var lTest:Int  = 500;
	override function onResize(pEvent:EventTarget = null):Void 
	{
		if (target == null) return;
		target.position = toLocal(shadow.position, shadow.parent);
		var lStep:FTUEStep = FTUEManager.steps[FTUEManager.currentStep];
		
		if (arrowRotation != 999) 
		{	
			if (lStep.arrowTarget != "")
			{
				if (boule == null) 
				{ 
					boule = new BouleHighlight();
					addChild(boule);
					boule.start();
				}
				var lPoint:Point = toLocal(lStep.itemTarget.position, lStep.itemTarget.parent);
				boule.position = lPoint;
				boule.rotation = lStep.arrowRot * Pixi.DEG_TO_RAD;
				if (lStep.arrowRecule != null)
				{
					boule.position.x = boule.position.x + lStep.arrowRecule * Math.cos(boule.rotation);
					boule.position.y = boule.position.y - lStep.arrowRecule * Math.sin(boule.rotation);
				}
			}
			else 
			{
				if (arrow == null) 
				{ 
					arrow = new Arrow();
					addChild(arrow);
					arrow.start();
				}
				arrow.rotation = arrowRotation * Pixi.DEG_TO_RAD;
				arrow.position = toLocal(shadow.position, shadow.parent);
			}
			if (lStep.arrowRecule != null && lStep.arrowTarget == "")
			{
				arrow.position.x = arrow.position.x + lStep.arrowRecule * Math.cos(arrow.rotation);
				arrow.position.y = arrow.position.y - lStep.arrowRecule * Math.sin(arrow.rotation);
			}
			//arrow.position = target.position;	
		}
		super.onResize(pEvent);	
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}