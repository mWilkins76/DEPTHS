package com.isartdigital.utils.ui;

import com.isartdigital.ruby.game.controller.Controller;
import com.isartdigital.ruby.game.sprites.elements.GameElement;
import com.isartdigital.utils.game.GameStage;
import pixi.core.math.Point;

import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.text.Text;

/**
 * Classe utils qui permet d'ajouter un Container et un Timer
 * @author Julien Fournier
 */
class TimerContainer extends Container
{

	
	private var timerBackground:Graphics;
	private var timerTxt:Text;
	private var element:GameElement;
	
	private var paramBackGrndOpacity:Float;
	private var paramRadius:Int;
	private var paramBackWidth:Float;
	private var widthFlag:Bool= true;
	private var paramBackHeight:Float;
	private var paramMargin:Int;
	
	private var backgroundColor:Int=0x000000;
	/**
	 * Ajoute un nouveau Timer
	 * @param	pParent : là ou le timer doit être addchild
	 * @param	pSize=40
	 * @param	pFont="Arial"
	 * @param	pBackgroundColor="white"
	 * @param	pAlign="left" (alignement du texte)
	 * @param	pShadow : état du drop Shadow
	 * @param	pBackGrndColor choisir une de ces couleurs (black,cyan,blue,green,orange,pink,yellow,red)
	 * @param	pBackGrndOpacity float entre 0 et 1
	 * @param	pRadius du background
	 * @param	pMargin : taille de la marge entre le bord du background et le texte
	 * @param	pBackWidth : par défault il s'adaptera à la largeur du texte
	 * @param	pBackHeight : 50 
	 */
	public function new(pParent:Dynamic,
						?pSize:Int = 40,
						?pFont:String = "Arial", 
						?pTxtColor:String = "white", 
						?pAlign:String = "left",
						?pShadow = false,
						?pBackGrndColor:String = "black",
						?pBackGrndOpacity:Float = 0.9, 
						?pRadius:Int = 30,
						?pMargin:Int = 40,
						?pBackWidth:Float,
						?pBackHeight:Float = 50,
						?pX:Float=0,
						?pY:Float=0,
						?pRotation:Float=0
						) 
	{
		super();
		
		element = pParent;
		castColor(pBackGrndColor);
		paramBackGrndOpacity = pBackGrndOpacity;
		paramRadius = pRadius;
		paramBackHeight = pBackHeight;
		paramMargin = pMargin;
		x = pX;
		y = pY;
		rotation = Math.PI * pRotation/180;
	
		

		timerBackground = new Graphics();
		timerTxt = new Text("", { font: pSize +"px "+ pFont, fill: pTxtColor, align: pAlign, dropShadow : pShadow } );		
		timerTxt.position = new Point(paramMargin, 0);	
		
		if (pBackWidth != null)
		{
			widthFlag = true;
			paramBackWidth = pBackWidth;
		}
		else widthFlag = false;
		
		
		
		element.addChild(this);
		
		
		addChild(timerBackground);
		addChild(timerTxt);
	}
	
	private function castColor(pBackGrndColor:String):Int
	{
		if (pBackGrndColor == "black") backgroundColor = 0x000000;
		if (pBackGrndColor == "cyan") backgroundColor = 0x00bfbf;
		if (pBackGrndColor == "blue") backgroundColor = 0x00486d;
		if (pBackGrndColor == "green") backgroundColor = 0x70bf48;
		if (pBackGrndColor == "orange") backgroundColor = 0xff751e;
		if (pBackGrndColor == "pink") backgroundColor = 0xff7584;
		if (pBackGrndColor == "yellow") backgroundColor = 0xffff00;
		if (pBackGrndColor == "red") backgroundColor = 0xff0000;
		return backgroundColor;
	}
	
	/**
	 * Rafraichissement du timer à mettre dans une boucle
	 * @param	timeToDisplay:String
	 */
	public function refreshTimer(timeToDisplay:String):Void
	{
		timerTxt.text = timeToDisplay;
		timerTxt.position.set(x+paramMargin, y+paramMargin);
		timerBackground.beginFill(backgroundColor, paramBackGrndOpacity);
		
		if (!widthFlag) paramBackWidth = timerTxt.width + paramMargin * 2;

		timerBackground.drawRoundedRect(x, y, paramBackWidth, paramBackHeight, paramRadius);
		timerBackground.endFill();
	}
	
	

	/**
	 * Destuction du Timer
	 */
	public function destroyTimer():Void
	{
		
		if(this != null) element.removeChild(this);
		if(timerBackground != null) removeChild(timerBackground);
		if(timerTxt != null) removeChild(timerTxt);
		
		timerBackground = null;
		timerTxt = null;
		element = null;

	}
	
}