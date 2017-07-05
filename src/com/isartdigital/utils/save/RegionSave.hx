package com.isartdigital.utils.save;

/**
 * ...
 * @author Guillaume Zegoudia
 */

typedef RegionSave =
{
	var posX:Int;
	var posY:Int;
	var width:Int;
	var height:Int;
	var layerSave:Array<LayerSave>;
	var isActive : Bool;
}