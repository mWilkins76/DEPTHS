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
class SmartText extends Container
{

	
	private var timerBackground:Graphics;
	private var timerTxt:Text;
	private var element:GameElement;

	private var paramMarginX:Float;
	private var paramMarginY:Float;
	
	private var backgroundColor:Int=0x000000;

	/**
	 * Crée un new SmarText (texte + background) entièrement paramétrable et qui s'adpate au texte qu'il contient
	 * @param	pParent : là ou le timer doit être addchild
	 * @param	pBackWidth : largeur du background
	 * @param	pBackHeight : hauteur du background
	 * @param	pTextSize : taille du texte
	 * @param	pFont : nom de la police à utiliser
	 * @param	pTxtColor : couleur du texte à utiliser (ex: white, black, ...)
	 * @param	pAlign : (left, right, center, ...)
	 * @param	pShadow = true : ombre en dessous du texte
	 * @param	pBackGrndColor : couleur du background
	 * @param	pBackGrndOpacity : opacité
	 * @param	pRadius : radius des bords arrondis
	 * @param	pBackGroundX
	 * @param	pBackGroundY
	 * @param	pTextPosX
	 * @param	pTextPosY
	 * @param	pRotation
	 */
	public function new(pParent:Dynamic,
						pBackWidth:Float,
						pBackHeight:Float,
						?pTextSize:Int = 40, 
						?pFont:String = "Arial", 
						?pTxtColor:String = "white", 
						?pAlign:String = "left",
						?pShadow = true,
						?pBackGrndColor:String = "black",
						?pBackGrndOpacity:Float = 0.9, 
						?pRadius:Int = 30,
						?pBackGroundX:Float=0,
						?pBackGroundY:Float = 0,
						?pTextPosX:Float = 5,
						?pTextPosY:Float = 5,
						?pRotation:Float=0
						) 
	{
		super();
		
		element = pParent;
		rotation = Math.PI * pRotation / 180;
		paramMarginX = pTextPosX;
		paramMarginY = pTextPosY;
		
		
		timerTxt = new Text("", { font: pTextSize +"px "+ pFont, fill: pTxtColor, align: pAlign, dropShadow : pShadow } );		
		timerTxt.position.set(pTextPosX, pTextPosY);	

		timerBackground = new Graphics();
		backgroundColor = castColor(pBackGrndColor);
		timerBackground.beginFill(backgroundColor, pBackGrndOpacity);
		timerBackground.drawRoundedRect(x, y, pBackWidth, pBackHeight, pRadius);			
		timerBackground.endFill();
		timerBackground.x = pBackGroundX;
		timerBackground.y = pBackGroundY;		
		
		addChild(timerBackground);
		addChild(timerTxt);			
	}
	
	/**
	 * cast de la couleur pour la transformer en code couleur
	 * @param	pBackGrndColor
	 * @return
	 */
	private function castColor(pBackGrndColor:String):Int
	{
		var lColor:Int=null;
		
		if (pBackGrndColor == "black") lColor = 0x000000;
		if (pBackGrndColor == "cyan") lColor = 0x00bfbf;
		if (pBackGrndColor == "blue") lColor = 0x00486d;
		if (pBackGrndColor == "green") lColor = 0x70bf48;
		if (pBackGrndColor == "orange") lColor = 0xff751e;
		if (pBackGrndColor == "pink") lColor = 0xff7584;
		if (pBackGrndColor == "yellow") lColor = 0xffff00;
		if (pBackGrndColor == "red") lColor = 0xff0000;
		return lColor;
	}
	
	/**
	 * Rafraichissement du timer à mettre dans une boucle
	 * @param	timeToDisplay:String
	 */
	public function refreshText(textToDisplay:String):Void
	{
		if (timerTxt.text  != textToDisplay)
		{
			timerTxt.text = textToDisplay;
			//timerTxt.position.set(x+paramMarginX, y+paramMarginY);
			
			timerBackground.width = timerTxt.width + paramMarginX * 2;
			timerBackground.height = timerTxt.height  + paramMarginY;
		}

	}


	/**
	 * Destuction du Timer
	 */
	public function destroyTimer():Void
	{
		if(timerBackground != null) removeChild(timerBackground);
		if (timerTxt != null) removeChild(timerTxt);
		if(this != null && element != null) element.removeChild(this);
		
		timerBackground = null;
		timerTxt = null;
		element = null;
	}
	
}