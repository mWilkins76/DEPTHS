package com.isartdigital.ruby.ui.popin.building.datas;

/**
 * ...
 * @author Adrien Bourdon
 */
typedef Missions = {
	var name:String;
	var map:String;
	var time:String;
	var centerRequired:Int;
	var alienSpawner:Int;
	var rewards:Reward;
}

typedef Reward = {
	var hc:Int;
	var sc:Int;
	var gene1:Int;
	var gene2:Int;
	var gene3:Int;	
    var gene4:Int;
    var gene5:Int;
    var schema:Int;
    var darkMatter:Int;
}