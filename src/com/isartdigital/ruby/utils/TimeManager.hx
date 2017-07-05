package com.isartdigital.ruby.utils;
import com.isartdigital.ruby.game.sprites.elements.Building;
import com.isartdigital.ruby.game.sprites.elements.GameElement;

	
/**
 * ...
 * @author Julien Fournier
 */
class TimeManager 
{
	
	/**
	 * instance unique de la classe TimeManager
	 */
	private static var instance: TimeManager;
	private var dateNow:Date;
	private var timer: Date;
	private var startTime:Float;
	
	public var timeServer(default, set):Date;
	
	function set_timeServer(pDate:Date)
	{
		return timeServer = pDate;
	}

	
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TimeManager {
		if (instance == null) instance = new TimeManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		
	}
	
	/**
	 * Initialise le TimeManager avec les infos de l'élément.
	 * @param	pElement
	 */
	public function init(pElement:GameElement)
	{
		dateNow = Date.now();
		
		pElement.dateEndBuilding = DateTools.delta(
			dateNow,
			convertInStamp(
				pElement.timeToBuild.seconds,
				pElement.timeToBuild.minutes,
				pElement.timeToBuild.hours,
				pElement.timeToBuild.days));
	}

	/**
	 * Retourne la date de fin de construction
	 * @return
	 */
	public function getEndOfBuildDate(pElement:GameElement):Date
	{
		return pElement.dateEndBuilding;	
	}
	
	/**
	 * Prend les infos de temps (secondes, minutes, heures, jours), les convertis en secondes, 
	 * puis additionne le tout et convertis le total en timeStanp
	 * @param	seconds
	 * @param	minutes
	 * @param	hours
	 * @param	days
	 * @return TimeStamp (Float)
	 */
	public function convertInStamp(seconds : Int, ?minutes : Int=0, ?hours : Int=0, ?days : Int=0):Float
	{
		var lMin:Float = minutes;
		var lHour:Float = hours;
		var lDay:Float = days;

		lMin *= 60;
		lHour *= 3600;
		lDay *= (24 * 3600);
				
		return DateTools.seconds(seconds + lMin + lHour + lDay);
	}
	
	/**
	 * Calcule le temps restant (en secondes) d'une construction en fonction de sa date de fin prévue
	 * @param	pDateEnd
	 * @return temps restant en secondes
	 */
	public function getTimeInSecondsToFinishBuilding(pDateEnd:Date):Float
	{
		var difference:Float= Date.now().getTime() - pDateEnd.getTime();
		return difference/1000;
	}
	
	public function getTimeToFinishBuildingStringFormat(pDateEnd:Date):String
    {
        var time:Float = pDateEnd.getTime() - Date.now().getTime();
        time /= 1000;

        var days:Int=0;
        var hours:Int=0;
        var minutes:Int=0;
        var seconds:Int = 0;
		
        days = Math.floor(time / 86400);
        hours = Math.floor(time % 86400 / 3600);
        minutes = Math.floor(time % 3600 / 60);
        seconds = Math.floor(time % 60);
        
        if(days!=0) return days+"d:"+hours+"h:"+minutes+"m:"+seconds+"s";  
        if(days ==0 && hours!=0) return hours+"h:"+minutes+"m:"+seconds+"s";  
        if(days ==0 && hours ==0 && minutes != 0) return minutes+"m:"+seconds+"s";  
        else return Std.string(seconds+"s");  
    }

	public function getPercentage(pDateStart:Date, pDateEnd:Date):Int
	{
		var percentage:Int = Math.round((Date.now().getTime() - pDateStart.getTime()) / (pDateEnd.getTime() - pDateStart.getTime()) * 100);
		return percentage;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}