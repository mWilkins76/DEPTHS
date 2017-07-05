package com.isartdigital.utils.game.pooling;
import com.isartdigital.ruby.game.sprites.FlumpStateGraphic;
import com.isartdigital.utils.game.clipping.IClippable;

/**
 * ...
 * @author dachicourt jordan
 */
class PoolObject extends FlumpStateGraphic implements IClippable
{
	public static var activeObjectList:Array<PoolObject> = new Array<PoolObject>();
	public static var elementList:Map<String, Element> = new Map<String, Element>();
	
	public var elem(default, default):Element;	
	public var instanceID:String;
	
	public function new(?pAsset:String) 
	{
		super();
		assetName = pAsset;	
	}
	
	public function init(?pElem:Element=null):Void 
	{
		if (pElem != null)
		{
			elem = pElem;
			elem.instance = this;
			instanceID = pElem.instanceID;
		}
		
		activeObjectList.push(this);
	}
	
	private function releaseElementList():Void 
	{
		if(elementList.get(instanceID) != null) elementList.set(instanceID, elem);
	}
	
	/**
	 * Gere l'enlevement graphique et d'ecoute, l'arret, de l'objet de pooling
	 */
	public function dispose():Void {
		//var lClassName:String = Type.getClassName(Type.getClass(this));
		//PoolManager.addToPool(lClassName.split(".").pop(), this);
		releaseElementList();
		removeAllListeners();
		setModeVoid();
		if(parent != null) parent.removeChild(this);
		activeObjectList.remove(this);
	}
	
	override public function destroy():Void 
	{
		dispose();
		super.destroy();
	}
	
}