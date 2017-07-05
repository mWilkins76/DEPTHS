package com.isartdigital.utils.save;
import js.html.SpeechRecognitionAlternative;

/**
 * ...
 * @author Adrien Bourdon
 */
typedef AlienBuffersType =
{
	var id:Float;
	var name:String;
	var type:String;
	var time:String;
	var nbUpgrade:Int;
	var levelReqUp1:Int;
	var levelReqUp2:Int;
	var levelReqUp3:Int;
	var upgradeTime1:Date;
	var upgradeTime2:Date;
	var upgradeTime3:Date;
	var upgradeCost1:Int;
	var upgradeCost2:Int;
	var upgradeCost3:Int;
	var buffCoef1:Float;
	var buffCoef2:Float;
	var buffCoef3:Float;
	var buffCoef4:Float;
	var buffType:String;
	var nomenclature:String;
}

typedef AlienProducerType =
{
	var id:Float;
	var name:String;
	var type:String;
	var time:String;
	var nbUpgrade:Int;
	var levelReqUp1:Int;
	var levelReqUp2:Int;
	var levelReqUp3:Int;
	var upgradeTime1:Date;
	var upgradeTime2:Date;
	var upgradeTime3:Date;
	var upgradeCost1:Int;
	var upgradeCost2:Int;
	var upgradeCost3:Int;
	var prodByCycle:Int;
	var prodSpeed:Int;
	var prodTime:Int;
	var maxProd:Int;
	var nomenclature:String;
}

typedef AlienForeurTypes =
{
	var id:Float;
	var name:String;
	var category:String;
	var nomenclature:String;
	var power:String;
	var stamina:Int;
	var time:String;
}

typedef AlienEsthetiqueTypes =
{
	var id:Float;
	var name:String;
	var category:String;
	var nomenclature:String;
	var time:String;	
}