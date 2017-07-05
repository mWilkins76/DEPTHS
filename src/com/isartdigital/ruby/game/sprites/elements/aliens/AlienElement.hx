package com.isartdigital.ruby.game.sprites.elements.aliens;

/**
 * ...
 * @author Adrien Bourdon
 */

typedef AlienElement = {
	var idAlien:String;
	var idBuilding:String;
	var mode:String;
	var name:String;
	var type:String;
	var nomPropre:String;
	var stamina:Int;
	var level:Int;
	var startTime:String;
	var endTime:String;
	@optional var carac:Dynamic;
	@optional var idPlayer:Int;
}

typedef CaracBuffer = 
{
	var buffType:String;
	var buffCoef1:Float;
	var buffCoef2:Float;
	var buffCoef3:Float;
	var buffCoef4:Float;
}

typedef CaracProducer = 
{
	var prodByCycle:Int;
	var prodSpeed:Int;
	var prodTime:Int;
	var maxProd:Int;
}