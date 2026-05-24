package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var MainMenuSpin:Int = 0;
	var timer:Float = 0;
	var secretmusic:FlxSound;
	var secretguy:FlxSprite;
	var isguydancing:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "bob";
	public static var kadeEngineVer:String = "bob" + nightly;
	public static var gameVer:String = "BOB";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	#if mobile
	var touchStartY:Float = 0;
	var touchMoved:Bool = false;
	var backButton:FlxText;
	#end

	override function create()
	{
		#if windows
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		if (FlxG.random.bool(10))
			MainMenuSpin = FlxG.random.int(1, 3);

		if (FlxG.random.bool(10))
		{
			isguydancing = true;
			GuyAppears(FlxG.random.int(1, 4));
		}

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer + " FNF - " + kadeEngineVer + " Kade Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		#if mobile
		backButton = new FlxText(FlxG.width - 100, FlxG.height - 60, 0, "B", 40);
		backButton.setFormat("VCR OSD Mono", 40, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		backButton.scrollFactor.set();
		backButton.alpha = 0.75;
		add(backButton);
		#end

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		timer += 0.01;

		for (str in menuItems)
		{
			var thisX:Float = Math.sin(timer * (timer / 10)) / 5;
			var thisY:Float = Math.sin(timer * (timer / 20)) / 5;

			if (str.ID == 1 && MainMenuSpin == 1)
				str.angle = str.angle + timer;

			if (str.ID == 0 && MainMenuSpin == 2)
			{
				str.scale.x = 1 + thisX;
				str.scale.y = 1 - thisY;
			}
		}

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
				FlxG.switchState(new TitleState());

			if (controls.ACCEPT)
				handleSelect();

			#if mobile
			handleTouch();
			#end

			#if android
			if (FlxG.keys.justReleased.BACK)
				FlxG.switchState(new TitleState());
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	#if mobile
	function handleTouch():Void
	{
		if (FlxG.touches.count() == 0)
		{
			touchMoved = false;
			return;
		}

		var touch = FlxG.touches.getFirst();

		if (touch.justPressed)
		{
			touchStartY = touch.screenY;
			touchMoved = false;
		}

		if (touch.pressed)
		{
			var deltaY = touch.screenY - touchStartY;
			if (Math.abs(deltaY) > 30)
				touchMoved = true;

			if (touchMoved)
			{
				if (deltaY < -30)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
					touchStartY = touch.screenY;
				}
				else if (deltaY > 30)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
					touchStartY = touch.screenY;
				}
			}
		}

		if (touch.justReleased && !touchMoved)
		{
			if (backButton != null
				&& touch.screenX >= backButton.x
				&& touch.screenX <= backButton.x + backButton.width
				&& touch.screenY >= backButton.y
				&& touch.screenY <= backButton.y + backButton.height)
			{
				FlxG.switchState(new TitleState());
				return;
			}

			handleSelect();
		}
	}
	#end

	function handleSelect():Void
	{
		if (optionShit[curSelected] == 'donate')
		{
			FlxG.sound.play(Paths.sound('fartsoundlol'));
			FlxFlicker.flicker(magenta, 1.1, 0.15, false);
		}
		else
		{
			selectedSomethin = true;

			if (isguydancing)
				secretmusic.stop();

			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxFlicker.flicker(magenta, 1.1, 0.15, false);

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0}, 1.3, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween) { spr.kill(); }
					});
				}
				else
				{
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'story mode': FlxG.switchState(new StoryMenuState());
							case 'freeplay':   FlxG.switchState(new FreeplayState());
							case 'options':    FlxG.switchState(new OptionsMenu());
						}
					});
				}
			});
		}
	}

	function GuyAppears(rando:Int):Void
	{
		switch (rando)
		{
			case 1:
				secretmusic = new FlxSound().loadEmbedded(Paths.sound('GuyDancing'));
				secretmusic.looped = true;
				secretmusic.volume = 0.3;
				secretguy = new FlxSprite(0, 0);
				secretguy.frames = Paths.getSparrowAtlas('CoolDance');
				secretguy.animation.addByPrefix('idle', 'CoolGuy', 24);
				secretguy.updateHitbox();
				secretguy.scrollFactor.set();
				add(secretguy);
				secretmusic.play();
				secretguy.animation.play('idle');
			case 2:
				secretmusic = new FlxSound().loadEmbedded(Paths.sound('SortingAlgorithm'));
				secretmusic.looped = true;
				secretmusic.volume = 0.3;
				secretguy = new FlxSprite(0, 0);
				secretguy.frames = Paths.getSparrowAtlas('Sorting');
				secretguy.animation.addByPrefix('idle', 'Sorting', 24);
				secretguy.updateHitbox();
				secretguy.scrollFactor.set();
				add(secretguy);
				secretmusic.play();
				secretguy.animation.play('idle');
			case 3:
				secretmusic = new FlxSound().loadEmbedded(Paths.sound('SpongSound'));
				secretmusic.looped = true;
				secretmusic.volume = 0.3;
				secretguy = new FlxSprite(0, 0);
				secretguy.frames = Paths.getSparrowAtlas('Spong');
				secretguy.animation.addByPrefix('idle', 'Dad idle dance', 24);
				secretguy.updateHitbox();
				secretguy.scrollFactor.set();
				add(secretguy);
				secretmusic.play();
				secretguy.animation.play('idle');
			case 4:
				secretmusic = new FlxSound().loadEmbedded(Paths.sound('crazy_little_guy'));
				secretmusic.looped = true;
				secretmusic.volume = 0.5;
				secretguy = new FlxSprite(0, 0);
				secretguy.frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');
				secretguy.animation.addByPrefix('idle', 'BOBBY BOBINO BOBBLE menu asset', 60);
				secretguy.updateHitbox();
				secretguy.scrollFactor.set();
				add(secretguy);
				secretmusic.play();
				secretguy.animation.play('idle');
		}
	}

	function changeItem(huh:Int = 0):Void
	{
		for (str in menuItems)
		{
			if (str.ID == 3 && MainMenuSpin == 3)
				str.scale.x = str.scale.x + 0.1;
		}

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}