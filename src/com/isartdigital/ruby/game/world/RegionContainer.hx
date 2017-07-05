package com.isartdigital.ruby.game.world;

import com.isartdigital.utils.game.iso.IZSortable;
import pixi.core.display.Container;
import pixi.core.graphics.Graphics;
import pixi.core.math.Point;

/**
 * ...
 * @author Michael Wilkins
 */
class RegionContainer extends Container implements IZSortable
{
	

	public var colMin:Int;
	public var colMax:Int;
	
	public var rowMin:Int;
	public var rowMax:Int;
	
	public var behind:Array<IZSortable>;
	
	public var inFront:Array<IZSortable>;

	public function new(pX:Int, pY:Int) 
	{
		super();
		//colMax = colMin = pX;
		//rowMax = rowMin = pY;
		colMin = pX * Region.WIDTH;
		colMax = pX + Region.WIDTH +(colMin -1);
		
		rowMin =  pY * Region.HEIGHT;
		rowMax =  pY + Region.HEIGHT + (rowMin -1);

	}
	
}