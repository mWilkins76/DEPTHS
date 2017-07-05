package com.isartdigital.ruby.game.player;
import com.isartdigital.ruby.ui.popin.building.datas.Missions;

/**
 * ...
 * @author Adrien Bourdon
 */
class MissionsManager
{

	/**
	 * instance unique de la classe MissionsManager
	 */
	private static var instance: MissionsManager;

	public var missions:Array<Missions>;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): MissionsManager
	{
		if (instance == null) instance = new MissionsManager();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new()
	{

	}

	public function init (pMission: Dynamic): Void
	{
		missions = new Array<Missions>();
		missions = pMission.missions;	
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

}