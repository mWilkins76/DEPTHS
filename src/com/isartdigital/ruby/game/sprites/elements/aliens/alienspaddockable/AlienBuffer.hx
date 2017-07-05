package com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable;
import com.isartdigital.ruby.game.sprites.elements.aliens.alienspaddockable.AlienPaddockable;
import com.isartdigital.utils.game.clipping.IClippable.Element;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.save.AlienTypes.AlienBuffersType;

/**
 * ...
 * @author Adrien Bourdon
 */
class AlienBuffer extends AlienPaddockable
{
	public static var buffTypes:Array<AlienBufferType>;
	private var carac:AlienBufferType;
	public var buffType(default, null):String;
	public var buffCoef(default, null):Float;
	
	public static var bufferTypes:Array<AlienBuffersType> = new Array<AlienBuffersType>();
	

	public function new(?pAsset:String) 
	{
		super(pAsset);
		name = pAsset;
		buffTypes = GameLoader.getContent("../balance/alienBalance.json").buffers;		
	}
	
	
	
	public static function loadTypes(pTypes:Dynamic):Void 
	{
		bufferTypes = pTypes;
	}
	
	override public function start():Void 
	{
		super.start();
		setModeBuff();
	}
	
	
	
	/**
	 * initalise les type et le coef de buff de cet alien
	 */
	public function initBuff():Void
	{
		for (alienType in buffTypes)
		{
			if (alienType.name == name) carac = alienType;
		}
		if (carac == null) return;
		buffType = carac.buffType;
		buffCoef = Reflect.getProperty(carac, "coef" + level); 
	}
	
	private function setModeBuff():Void {
		doAction = doActionBuff;
	}
	
	private function doActionBuff():Void {
		loopanim();
		
	}
	
}