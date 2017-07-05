package com.isartdigital.utils.save;

/**
 * @author Guillaume Zegoudia
 */

//var VILLA:String = "Villa";

enum ConstructionType
{
	Villa;
	Tree;
	House;
	Factory;
	Turbine;
}

enum State
{
	Constructing;
	Collecting;
	Upgrading;
	Waiting;
}

enum EvolveState
{
	Level1;
	Level2;
	Level3;
	//Level4;
}

typedef ElementSave =
{
	var type : String;
	var x:Int;
	var y : Int;
	@:optional var worldX:Float;
	@:optional var worldY:Float;
	@:optional var width:Float;
	@:optional var height:Float;
	@:optional var mode : String;
	@:optional var evolveState : Int;
	@:optional var timeForNextState: Float;
	@:optional var elapsedTime : Float;
}