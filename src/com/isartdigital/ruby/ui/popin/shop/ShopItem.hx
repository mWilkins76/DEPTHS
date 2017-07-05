package com.isartdigital.ruby.ui.popin.shop;
import com.isartdigital.ruby.ui.ftue.FTUEManager;
import com.isartdigital.ruby.ui.hud.Hud;
import com.isartdigital.ruby.ui.items.Item;
import com.isartdigital.ruby.ui.items.ItemAsset;
import com.isartdigital.ruby.ui.popin.shop.datas.GainParams;
import com.isartdigital.ruby.ui.popin.shop.datas.ShopItemParams;
import com.isartdigital.services.monetization.Bank;
import com.isartdigital.services.monetization.Wallet;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.sprites.Sprite;

import com.isartdigital.ruby.game.player.Player;

import com.isartdigital.ruby.ui.popin.shop.datas.ShopItemParams.Money;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import com.isartdigital.utils.save.DataBaseAction;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Jordan Dachicourt
 */
class ShopItem extends Item
{

	public static var positions:Array<Point> = new Array<Point>();

	/*Constante de ciblage*/
	private static inline var ITEM_NAME:String = "txt_itemName";
	private static inline var PRICE_HC:String = "txt_priceHC";
	private static inline var PRICE_SC:String = "txt_priceSC";
	private static inline var PRICE:String = "txt_price";
	private static inline var PROMO:String = "promo";
	private static inline var TEXT_PROMO:String = "txt_promo";
	private static inline var ASSET_ITEM:String = "spriteItemAsset";
	private static inline var ASSET_CURRENCY:String = "spriteCurrencie";
	private static inline var ASSET_PREFIX:String = "Shop_spriteItemAsset_";
	private static inline var ASSET_CURRENCY_PREFIX:String = "Shop_spriteCurrencie_";

	/*Composents Graphiques*/
	private var itemName:TextSprite;
	private var textHC:TextSprite;
	private var textSC:TextSprite;
	private var textPrice:TextSprite;
	private var textQuantity:TextSprite;
	private var textPromo:TextSprite;
	private var promoCmp:SmartComponent;
	private var assetsItem:UISprite;
	/*Datas*/
	public var price:Float;
	public var money:Money;
	public var gains:Array<GainParams>;
	public var promo:Float;
	public var quantity:Int;

	public function new(pID:String=null)
	{
		super(pID);
	}

	/**
	 * Initialise le shopItem
	 * @param	pShopItemType
	 * le type def inférent toute les informations dont le ShopItem a besoin
	 */
	public function setInfo(pShopItemParams:ShopItemParams)
	{
		itemName = cast(getChildByName(ITEM_NAME), TextSprite);
		itemName.text = pShopItemParams.name;

		promo = pShopItemParams.promo;
		promoCmp = cast(getChildByName(PROMO), SmartComponent);

		
		
		
		//à retravailler
		cast(getChildByName(ASSET_ITEM), UISprite).visible = false;
		assetsItem = new UISprite(ASSET_PREFIX+StringTools.replace(Shop.getInstance().shopAssetTitles[Shop.getInstance().currentIndex], " ","_")+"_"+StringTools.replace(pShopItemParams.name, " ", "_"));
		assetsItem.position = cast(getChildByName(ASSET_ITEM), UISprite).position;
		addChild(assetsItem);

		if (promoCmp.getChildByName(TEXT_PROMO) != null)
		{
			textPromo = cast(promoCmp.getChildByName(TEXT_PROMO), TextSprite);
			textPromo.text = promo + " %\nFREE";
		}

		if (promo == 0) promoCmp.visible = false;

		price = round(pShopItemParams.price-(pShopItemParams.price * promo / 100), 2);
		textPrice = cast(getChildByName(PRICE), TextSprite);
		textPrice.text = price+"";
		gains = pShopItemParams.gains;
		money = pShopItemParams.typeMoney;
		
		var lStringMoney:String = money+"";
		switch (lStringMoney)
		{
			case "Money.HardCurrency":
				cast(getChildByName(ASSET_CURRENCY), UISprite).visible = false;
				assetsItem = new UISprite(ASSET_CURRENCY_PREFIX+"HC");
				assetsItem.position = cast(getChildByName(ASSET_CURRENCY), UISprite).position;
				addChild(assetsItem);
				
			case "Money.IsartPoint":
				cast(getChildByName(ASSET_CURRENCY), UISprite).visible = false;
				assetsItem = new UISprite(ASSET_CURRENCY_PREFIX+"IsartPoint");
				assetsItem.position = cast(getChildByName(ASSET_CURRENCY), UISprite).position;
				addChild(assetsItem);
				
		}
		
		interactive = true;
		name = itemName.text;
		FTUEManager.register(this);

	}

	private function Buy()
	{
		checkMoneyAndDecreasePrice();
	}

	private function checkMoneyAndDecreasePrice():Void
	{
		//en attendant de trouver comment recup un enum depuis un json.
		var lStringMoney:String = money+"";
		switch (lStringMoney)
		{
			case "Money.HardCurrency":

				if(!FTUEManager.isFTUEon()) Player.getInstance().changePlayerValue(-Std.int(price), Player.TYPE_HARDCURRENCY);
				giveAllTheGainsToPlayer();
			case "Money.SoftCurrency":
				Player.getInstance().changePlayerValue(-Std.int(price), Player.TYPE_SOFTCURRENCY);
				giveAllTheGainsToPlayer();
			case "Money.IsartPoint":
				Wallet.getMoney(Player.getInstance().email, callBackWallet);
				return;
		}
	}

	private function callBackWallet (pData:Dynamic):Void
	{

		if (pData == null) trace ("Erreur Service");

		else if (pData.error != null) trace (pData.error);

		else 
		{
			UIManager.getInstance().openPopin(DynamicPopin.getInstance());
			DynamicPopin.getInstance().init("Voulez-vous acheter cet objet pour "+price + " IsartPoints ? Il vous reste actuellement : "+Reflect.field(pData,"money"), checkWalletPlayer);
		}

	}

	private function checkWalletPlayer():Void
	{
		if (Player.getInstance().currentIsartPoint >= price) 
		{
			Wallet.buy(Player.getInstance().email, price, callBackBuy);
			Player.getInstance().currentIsartPoint -= price;
		}
		
		else
		{
			UIManager.getInstance().openPopin(DynamicPopin.getInstance());
			DynamicPopin.getInstance().init("Désolé, vous n'avez plus assez d'IsartPoints :(", null);
		}
		
	}
	
	private function callBackBuy(pData:Dynamic):Void
	{
		if (pData == null) trace ("Erreur Service");

		else if (pData.error != null) trace (pData.error);

		else
		{
			giveAllTheGainsToPlayer();
		}
	}

	private function giveAllTheGainsToPlayer()
	{
		for (gain in gains)
		{
			//en attendant de trouver comment recup un enum depuis un json.
			var lStringGain:String = gain.type+"";
			switch (lStringGain)
			{
				case "Gain.SoftCurrency":
					SoundManager.getSound("soundPlayerBuyScpack").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), Player.TYPE_SOFTCURRENCY);
				case "Gain.HardCurrency":
					SoundManager.getSound("soundPlayerBuyHcpack").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), Player.TYPE_HARDCURRENCY);
				case "Gain.DarkMatter":
					SoundManager.getSound("soundPlayerBuyBundle").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), Player.TYPE_RESSOURCE);
				case "Gain.GeneBeta":
					SoundManager.getSound("soundPlayBuyGenepack").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), "gene1");
				case "Gain.GeneIota":
					SoundManager.getSound("soundPlayBuyGenepack").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), "gene2");
				case "Gain.GeneRho":
					SoundManager.getSound("soundPlayBuyGenepack").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), "gene2");
				case "Gain.GeneSigma":
					SoundManager.getSound("soundPlayBuyGenepack").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), "gene3");
				case "Gain.GeneUpsilon":
					SoundManager.getSound("soundPlayBuyGenepack").play();
					Player.getInstance().changePlayerValue(Std.int(gain.quantity), "gene4");
				case "Gain.GeneMultiple":
					SoundManager.getSound("soundPlayBuyGenepack").play();
					for (i in 0 ... 6)
					{
						Player.getInstance().changePlayerValue(Std.int(gain.quantity), "gene"+i);
					}
				default:
					trace("pas encore géré");
			}
		}
		Hud.getInstance().update();
	}

	override function monClick():Void
	{
		Buy();
	}

	
	public static function round(number:Float, ?precision=2): Float
	{
		number *= Math.pow(10, precision);
		return Math.round(number) / Math.pow(10, precision);
	}

	override public function destroy():Void
	{
		off(MouseEventType.CLICK, Buy);

		if (parent!=null)
			parent.removeChild(this);
		super.destroy();
	}

}