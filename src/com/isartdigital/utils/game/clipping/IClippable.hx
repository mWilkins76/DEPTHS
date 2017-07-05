package com.isartdigital.utils.game.clipping;
import com.isartdigital.utils.game.pooling.PoolObject;
import com.isartdigital.utils.save.ElementSave.State;

/**
 * interface pour les objets a clipper avec le pooling
 * les Element seront passés en paramètre a l'initialisation des poolObject
 * pour les utiliser dans le clipping ils ont besoin d'un Id, d'une position relative au GameContainer
 * et de dimensions (width et height)
 * @author Adrien Bourdon
 */

typedef Element =
{
	var instanceID:String;
	var type:String;
	var width:Float;
	var height:Float;
	var x:Int;
	var y:Int;
	var globalX:Float;
	var globalY:Float;
	@:optional var regionX:Int;
	@:optional var regionY:Int;
	@:optional var layer:Int;
	@:optional var mode:String;
	@:optional var softCurrency:UInt;
	@:optional var levelUpGrade:Int;
	@:optional var dateEndBuilding:Date;
	@:optional var dateStartBuilding:Date;
	@:optional var assetName:String;
	@:optional var index:Int;
	@:optional var modelWidth:Int;
	@:optional var modelHeight:Int;
	@:optional var instance:PoolObject;
	@:optional var isDigged:Bool;
}

interface IClippable
{
	private var elem:Element;	
	public var instanceID:String;
}