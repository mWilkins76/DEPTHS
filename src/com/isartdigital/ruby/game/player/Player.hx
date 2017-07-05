package com.isartdigital.ruby.game.player;
import com.isartdigital.ruby.ui.UIManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.popin.RewardNotifications;
import com.isartdigital.services.facebook.Facebook;
import com.isartdigital.services.monetization.Wallet;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.save.DataManager;
import com.isartdigital.utils.sounds.SoundManager;
import haxe.Json;
import haxe.macro.Expr.Unop;
import js.Browser;

typedef PlayerSave =
{
	var id:Int;
	var fbID:String;
	var level:UInt;
	var xp:UInt;
	var hardCurrency:UInt;
	var softCurrency:UInt;
	var currentEnergy:UInt;
	var ressource:UInt;
	var maxEnergy:UInt;
	var ftueSteps:Int;
	@:optional var gene1:UInt;
	@:optional var gene2:UInt;
	@:optional var gene3:UInt;
	@:optional var gene4:UInt;
	@:optional var gene5:UInt;
	@:optional var schemas:Int;
}
/**
 * Player : Gestion de l'xp, des resources et des information du player;
 * @author Adrien Bourdon
 */
class Player
{
	/**
	 * instance unique de la classe Player
	 */
	private static var instance: Player;

	//
	public var id(default, null):Int;
	public var idFb(default, null):String;
	
	public var email(default, set):String;
	
	function set_email(pEmail:String):String
	{
		return email = pEmail;
	}
	// Resources
	public static inline var TYPE_SOFTCURRENCY:String = "softCurrency";
	public static inline var TYPE_HARDCURRENCY:String = "hardCurrency";
	public static inline var TYPE_RESSOURCE:String = "ressource";

	public var hardCurrency(default, null):Int;
	public var softCurrency(default, null):Int;
	public var ressource(default, null):Int;
	public var currentEnergy(default, null):Int;
	public var maxEnergy(default, null):Int;
	public var ftueSteps(default, null):Int;

	// Experience
	public var experience(default, null):Int;
	public var level(default, null):Int;
	public var xpToLevel(default, null):Int;
	public var levelAdvance(default, null):Float;

	//cellules/genes

	public var gene1(default,null):UInt;
	public var gene2(default,null):UInt;
	public var gene3(default,null):UInt;
	public var gene4(default,null):UInt;
	public var gene5(default, null):UInt;
	
	public var schemas(default, null):UInt;
	public var geneArray:Array<UInt>;
	
	public var currentIsartPoint:Float;


	// Save
	private var save:PlayerSave;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Player
	{
		if (instance == null) instance = new Player();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new()
	{
		
	}

	/**
	 * initialisation du player par default ou du player sauvegardé
	 * @param	pSave : sauvegarde des données du player
	 */
	public function loadSave(?pSave:PlayerSave):Void
	{
		if (pSave != null)
		{
			id = pSave.id;
			idFb = pSave.fbID;
			save = pSave;
			level = pSave.level;
			experience = pSave.xp;
			xpToLevel = XpToLevel.ref[level];
			hardCurrency = pSave.hardCurrency;
			softCurrency = pSave.softCurrency;
			currentEnergy = pSave.currentEnergy;
			maxEnergy = pSave.maxEnergy;
			ressource = pSave.ressource;
			ftueSteps = pSave.ftueSteps;

			gene1 = pSave.gene1;
			gene2 = pSave.gene2;
			gene3 = pSave.gene3;
			gene4 = pSave.gene4;
			gene5 = pSave.gene5;
			schemas = pSave.schemas;

		}
		calculateLevelAdvance();
		Hud.getInstance().update();

		geneArray = [gene1, gene2, gene3, gene4, gene5];
		Wallet.getMoney(email, callBackWallet);
	}
	
	private function callBackWallet (pData:Dynamic):Void
	{

		if (pData == null) trace ("Erreur Service");

		else if (pData.error != null) trace (pData.error);

		else 
		{
			currentIsartPoint = Std.parseFloat(Reflect.field(pData, "money"));
		}

	}

	/**
	 * met la savegarde à jour ( a voir avec la bdd)
	 */
	private function releaseSave():Void
	{
		save.xp = experience;
		save.level = level;
		save.hardCurrency = hardCurrency;
		save.softCurrency = softCurrency;
		save.ressource = ressource;
		save.currentEnergy = currentEnergy;
		save.maxEnergy = maxEnergy;
		save.gene1;
		save.gene2;
		save.gene3;
		save.gene4;
		save.gene5;
		save.schemas;
		//save bdd a revoir
	}

	//// XP ////
	/**
	 * Ajoute de l'experience au joueur et modifie son level si besoin
	 * @param	pXp : expérience ajouté
	 */
	public function addExp(pXp:Int):Void
	{
		
		if (level == 20) {
			Browser.alert("Bravo ! Vous êtes arrivés au niveau max !");
			return;
		}
		if (experience + pXp < xpToLevel) experience += pXp;
		else
		{
			var numberLevel:UInt = Math.floor((experience + pXp)/ xpToLevel);
			level += numberLevel;
			xpToLevel = XpToLevel.ref[level];
			//experience = (experience + pXp) % xpToLevel;
			experience = experience + pXp;
			UIManager.getInstance().openPopin(RewardNotifications.getInstance());
			RewardNotifications.getInstance().initLevelUp(level);
			SoundManager.getSound("soundLevelUp").play();
		}
		
		calculateLevelAdvance();
		Hud.getInstance().update();
		DataBaseAction.getInstance().changeExperience(experience, level);
		releaseSave();
	}

	/**
	 * calcule le pourcentage d'avancement d'un niveau
	 * @return le pourcentage
	 */
	public function calculateLevelAdvance():Float
	{
		
		var lPercent:Float = ((experience - XpToLevel.ref[level - 1]) / XpToLevel.xpToNextLevel[level]) * 100;
		return lPercent;
	}

	/**
	 * test si la quantité d'une ressource est suffisante
	 * @param	pQuantity : quantité à tester
	 * @param	pType : ressources à tester
	 * @return true si il y a assez de ressources
	 */
	public function hasEnoughQuantity(pQuantity:Int, pType:Int):Bool
	{
		return pType >= pQuantity;
	}
	
	private function calculateXpToLevel(pLevel:Int):Int {
	
		return pLevel * 1000;
	}

	/**
	 * ajoute/retire une valeur de soft, hard ou ressource au player
	 * coté client et serveur
	 * @param	pValue : valeur à retirer ou ajouter
	 * @param	pValueType : type de la valeur (soft, hard ou ressource)
	 * @param	pIsAddingBuilding : si c'est lors de l'ajout d'un building passer à true
	 */
	public function changePlayerValue(pValue:Float, pValueType:String, ?pIsAddingBuilding:Bool = false):Void
	{

		if (Reflect.getProperty(this, pValueType) == null) return;
		if (pValue < 0)
		{
			if (!hasEnoughQuantity(cast(pValue, Int), Reflect.getProperty(this, pValueType))) return;
			//descrease hud
		}

		var oldValue:Int = Reflect.getProperty(this, pValueType);
		var newValue:Int = Reflect.getProperty(this, pValueType) + cast(pValue, Int);
		Reflect.setProperty(this, pValueType, newValue);
		if (!pIsAddingBuilding) DataBaseAction.getInstance().changeCurrency(id, pValueType, -cast(pValue, Int));

		releaseSave();
		Hud.getInstance().update();
		//var updatedValue:Int = oldValue + pValue;

		//increase Hud
		/*if(oldValue < updatedValue)
		{
			oldValue += 1;
			Hud.getInstance().update();
		}*/

	}

	//// ENERGY ////
	public function hasEnoughEnergy(pEnergy:Int):Bool
	{
		if ((pEnergy + currentEnergy) <= maxEnergy) return true;
		else return false;
	}

	public function increaseEnergyConsumed(pEnergy:Int):Void
	{
		if (hasEnoughEnergy(pEnergy))
		{
			currentEnergy += pEnergy;
			DataBaseAction.getInstance().changeEnergy(id, currentEnergy);
		}
		releaseSave();
		Hud.getInstance().update();
	}

	public function increaseMaxEnergy(pMaxEnergy:Int):Void
	{
		maxEnergy += pMaxEnergy;
		DataBaseAction.getInstance().changeMaxEnergy(id, maxEnergy);
		releaseSave();
		Hud.getInstance().update();
	}
	
	public function setSchema(pSchema:Int):Void
	{
		schemas = pSchema;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

}