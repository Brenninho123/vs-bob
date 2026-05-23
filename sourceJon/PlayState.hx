package;

import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;

#if windows
import Discord.DiscordClient;
#end

#if mobile
import mobile.Hitbox;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;
	var songLength:Float = 0;

	#if windows
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	var shootBeats:Array<Int>        = [128, 192, 200, 204, 254, 256, 260, 264, 268, 272, 276, 280, 284, 336, 338, 340, 342, 344, 346, 348, 351];
	var shootBeatsPos:Array<Int>     = [0,   3,   0,   2,   3,   0,   3,   0,   3,   3,   2,   1,   1,   0,   0,   0,   3,   3,   0,   0,   3];
	var shootBeatsEasy:Array<Int>    = [128, 192, 200, 204, 254, 256, 260, 264, 268, 272, 276, 280, 284, 336, 340, 344, 346, 351];
	var shootBeatsPosEasy:Array<Int> = [0,   3,   0,   2,   3,   0,   3,   0,   3,   3,   2,   1,   1,   0,   0,   3,   0,   3];
	var DoIHit:Bool = true;
	var IsNoteSpinning:Bool = false;
	var SpinAmount:Float = 0;

	#if desktop
	var windowX:Float = Lib.application.window.x;
	var windowY:Float = Lib.application.window.y;
	#end

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var screenBudget:FlxSprite;

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var RonTurn:Bool = true;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	private var triggeredAlready:Bool = false;
	private var allowedToHeadbang:Bool = false;

	#if mobile
	var hitbox:Hitbox;
	var _prevLeft:Bool  = false;
	var _prevDown:Bool  = false;
	var _prevUp:Bool    = false;
	var _prevRight:Bool = false;
	#end

	inline function getCamFollowLerp():Float
	{
		#if mobile
		return 0.04;
		#else
		return 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS());
		#end
	}

	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;
		repPresses = 0;
		repReleases = 0;

		#if windows
		switch (storyDifficulty)
		{
			case 0: storyDifficultyText = "Easy";
			case 1: storyDifficultyText = "Normal";
			case 2: storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		switch (iconRPC)
		{
			case 'senpai-angry':    iconRPC = 'senpai';
			case 'monster-christmas': iconRPC = 'monster';
			case 'mom-car':         iconRPC = 'mom';
		}

		if (isStoryMode)
			detailsText = "Story Mode: Week " + storyWeek;
		else
			detailsText = "Freeplay";

		detailsPausedText = "Paused - " + detailsText;

		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),
			"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC
		);
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing              \nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", "pissed myself"];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':    dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':     dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':    dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'sunshine':  dialogue = CoolUtil.coolTextFile(Paths.txt('sunshine/DumbDialogPhloxMade'));
			case 'withered':  dialogue = CoolUtil.coolTextFile(Paths.txt('withered/DumbDialogPhloxMade'));
			case 'run':       dialogue = CoolUtil.coolTextFile(Paths.txt('run/DumbDialogPhloxMade'));
			case 'ron':       dialogue = CoolUtil.coolTextFile(Paths.txt('ron/ronDialogue'));
			case 'trouble':   dialogue = CoolUtil.coolTextFile(Paths.txt('trouble/assfart'));
			case 'onslaught': dialogue = CoolUtil.coolTextFile(Paths.txt('onslaught/help'));
		}

		switch (SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south':
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg');
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
				isHalloween = true;
			}
			case 'pico' | 'blammed' | 'philly':
			{
				curStage = 'philly';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
				add(street);
			}
			case 'milf' | 'satin-panties' | 'high':
			{
				curStage = 'limo';
				defaultCamZoom = 0.90;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var limoTex = Paths.getSparrowAtlas('limo/limoDrive');
				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
			}
			case 'cocoa' | 'eggnog':
			{
				curStage = 'mall';
				defaultCamZoom = 0.80;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('christmas/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			}
			case 'winter-horrorland':
			{
				curStage = 'mallEvil';

				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
				evilSnow.antialiasing = true;
				add(evilSnow);
			}
			case 'senpai' | 'roses':
			{
				curStage = 'school';

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);
				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (SONG.song.toLowerCase() == 'roses')
					bgGirls.getScared();

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			}
			case 'sunshine':
			{
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/happysky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/happyground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
			}
			case 'withered':
			{
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/slightlyannyoed_sky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/slightlyannyoed_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
			}
			case 'run' | 'run-remix-because-its-cool':
			{
				curStage = 'hellstage';

				if (FlxG.save.data.happybob)
				{
					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/happy/hell'));
					bg.updateHitbox();
					bg.active = false;
					bg.antialiasing = true;
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var thingidk:FlxSprite = new FlxSprite(-271).loadGraphic(Paths.image('bob/happy/middlething'));
					thingidk.updateHitbox();
					thingidk.active = false;
					thingidk.antialiasing = true;
					thingidk.scrollFactor.set(0.3, 0.3);
					add(thingidk);

					var dead:FlxSprite = new FlxSprite(-60, 50).loadGraphic(Paths.image('bob/happy/theydead'));
					dead.updateHitbox();
					dead.active = false;
					dead.antialiasing = true;
					dead.scrollFactor.set(0.8, 0.8);
					add(dead);

					var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/happy/ground'));
					ground.updateHitbox();
					ground.active = false;
					ground.antialiasing = true;
					add(ground);

					bobmadshake = new FlxSprite(-198, -118).loadGraphic(Paths.image('bob/happy/bobscreen'));
					bobmadshake.scrollFactor.set(0, 0);
					bobmadshake.visible = false;
				}
				else
				{
					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/hell'));
					bg.updateHitbox();
					bg.active = false;
					bg.antialiasing = true;
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var thingidk:FlxSprite = new FlxSprite(-271).loadGraphic(Paths.image('bob/middlething'));
					thingidk.updateHitbox();
					thingidk.active = false;
					thingidk.antialiasing = true;
					thingidk.scrollFactor.set(0.3, 0.3);
					add(thingidk);

					var dead:FlxSprite = new FlxSprite(-60, 50).loadGraphic(Paths.image('bob/theydead'));
					dead.updateHitbox();
					dead.active = false;
					dead.antialiasing = true;
					dead.scrollFactor.set(0.8, 0.8);
					add(dead);

					var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/ground'));
					ground.updateHitbox();
					ground.active = false;
					ground.antialiasing = true;
					add(ground);

					bobmadshake = new FlxSprite(-198, -118).loadGraphic(Paths.image('bob/bobscreen'));
					bobmadshake.scrollFactor.set(0, 0);
					bobmadshake.visible = false;
				}

				bobsound = new FlxSound().loadEmbedded(Paths.sound('bobscreen'));
			}
			case 'thorns':
			{
				curStage = 'schoolEvil';

				var posX = 400;
				var posY = 200;

				var bg:FlxSprite = new FlxSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
			}
			case 'onslaught':
			{
				defaultCamZoom = 0.9;
				curStage = 'slaught';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/scary_sky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/GlitchedGround'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
			}
			case 'trouble':
			{
				defaultCamZoom = 0.9;
				curStage = 'trouble';

				var bg:FlxSprite = new FlxSprite(-100, 10).loadGraphic(Paths.image('bob/nothappy_sky'));
				bg.updateHitbox();
				bg.scale.x = 1.2;
				bg.scale.y = 1.2;
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('bob/nothappy_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);

				var deadron:FlxSprite = new FlxSprite(-700, 600).loadGraphic(Paths.image('bob/GoodHeDied'));
				deadron.updateHitbox();
				deadron.active = false;
				deadron.scale.x = 0.8;
				deadron.scale.y = 0.8;
				deadron.antialiasing = true;
				add(deadron);
			}
			case 'ron' | 'little-man':
			{
				defaultCamZoom = 0.9;
				curStage = 'ron';

				var bg:FlxSprite = new FlxSprite(-100, 10).loadGraphic(Paths.image('bob/happyRon_sky'));
				bg.updateHitbox();
				bg.scale.x = 1.2;
				bg.scale.y = 1.2;
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('bob/happyRon_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				add(ground);
			}
			default:
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				add(stageCurtains);
			}
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':               gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':  gfVersion = 'gf-christmas';
			case 'school':             gfVersion = 'gf-pixel';
			case 'schoolEvil':         gfVersion = 'gf-pixel';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "spooky":        dad.y += 200;
			case "monster":       dad.y += 100;
			case 'monster-christmas': dad.y += 130;
			case 'dad':           camPos.x += 400;
			case 'pico':          camPos.x += 600; dad.y += 300;
			case 'bob':           camPos.x += 600; dad.y += 300;
			case 'gloop-bob':     camPos.x += 600; dad.y += 300;
			case 'angrybob':      camPos.x += 600; dad.y += 300;
			case 'hellbob':       camPos.x += 600; dad.y += 350;
			case 'glitched-bob':  camPos.x += 600; dad.y += 300;
			case 'ron':
				camPos.x -= 27;
				camPos.y += 268;
				dad.y += 268;
				dad.x -= 27;
			case 'little-man':
				camPos.x -= 124;
				camPos.y += 644;
				dad.x += 124;
				dad.y += 644;
			case 'parents-christmas': dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				resetFastCar();
				add(fastCar);
			case 'mall':
				boyfriend.x += 200;
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				add(evilTrail);
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);

		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();

		if (SONG.song.toLowerCase() == 'ron')
			doof.finishThing = RonIntro2;
		else
			doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, getCamFollowLerp());
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition)
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT,
				Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8),
				this, 'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20, songPosBG.y, 0, SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);
			songName.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT,
			Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8),
			this, 'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

		var kadeEngineWatermark = new FlxText(4, healthBarBG.y + 50, 0,
			SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy")
			+ " - KE " + MainMenuState.kadeEngineVer + " - "
			+ (FlxG.save.data.etternaMode ? "E.Mode" : "FNF"), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75,
			healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
			add(replayTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}

		kadeEngineWatermark.cameras = [camHUD];

		if (loadRep)
			replayTxt.cameras = [camHUD];

		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween) { startCountdown(); }
							});
						});
					});
				case 'senpai':    schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':    schoolIntro(doof);
				case 'sunshine':  schoolIntro(doof);
				case 'withered':  schoolIntro(doof);
				case 'onslaught':
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Bob_Appear'));
						camFollow.x = dad.getMidpoint().x;
						camFollow.y = dad.getMidpoint().y;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									var lol:DialogueBox = new DialogueBox(false, dialogue);
									lol.scrollFactor.set();
									lol.finishThing = startCountdown;
									add(lol);
									lol.cameras = [camHUD];
								}
							});
						});
					});
				case 'trouble': ONSLAUGHTIntro(doof);
				case 'run':     schoolIntro(doof);
				case 'ron':     RonIntro(doof);
				default:        startCountdown();
			}
		}
		else
		{
			startCountdown();
		}

		if (!loadRep)
			rep = new Replay("na");

		switch (curStage)
		{
			case 'hellstage': add(bobmadshake);
		}

		#if mobile
		hitbox = new Hitbox();
		hitbox.cameras = [camHUD];
		add(hitbox);
		#end

		super.create();
	}

	function RonIntro(?dialogueBox:DialogueBox):Void
	{
		boyfriend.visible = false;
		gf.visible = false;
		dad.visible = false;
		FlxG.camera.follow(camFollow, LOCKON, getCamFollowLerp());
		camFollow.x = boyfriend.getMidpoint().x;
		FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
		{
			new FlxTimer().start(0.5, function(swagTimer:FlxTimer)
			{
				boyfriend.visible = true;
				gf.visible = true;
				FlxG.sound.play(Paths.sound('pop'));
				new FlxTimer().start(1, function(swagTimer:FlxTimer)
				{
					add(dialogueBox);
				});
			});
		});
	}

	function RonIntro2():Void
	{
		FlxG.camera.follow(camFollow, LOCKON, getCamFollowLerp());
		FlxG.sound.music.fadeIn(1, 0.5, 0);
		camFollow.x = dad.getMidpoint().x;
		camFollow.y = dad.getMidpoint().y;
		new FlxTimer().start(1, function(swagTimer:FlxTimer)
		{
			dad.visible = true;
			FlxG.sound.play(Paths.sound('Ron_Appear'));
			new FlxTimer().start(1, function(swagTimer:FlxTimer)
			{
				FlxG.sound.playMusic(Paths.music('Ron_Dialog'), 0.5);
				dialogue = CoolUtil.coolTextFile(Paths.txt('ron/ronAfterDialogue'));
				var lol:DialogueBox = new DialogueBox(false, dialogue);
				lol.scrollFactor.set();
				lol.finishThing = startCountdown;
				add(lol);
				lol.cameras = [camHUD];
			});
		});
	}

	function ONSLAUGHTIntro(?dialogueBox:DialogueBox):Void
	{
		camHUD.visible = false;
		FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
		{
			camHUD.visible = true;
			add(dialogueBox);
		}, true);
	}

	function bobSpookyIntro():Void
	{
		camHUD.visible = false;
		FlxG.camera.fade(FlxColor.BLACK, 0.2, true);

		var bobTransforms:FlxSprite = new FlxSprite(600, 400);
		bobTransforms.frames = Paths.getSparrowAtlas('bob/cutscene/bobSpooky');
		bobTransforms.animation.addByPrefix('idle', 'BobTransforms', 24, false);
		bobTransforms.animation.play('idle');
		bobTransforms.scrollFactor.set();
		bobTransforms.updateHitbox();
		bobTransforms.screenCenter();
		bobTransforms.scale.x = 1.2;
		bobTransforms.scale.y = 1.2;
		add(bobTransforms);

		FlxG.sound.play(Paths.sound('bobSpooky'), 1, false, null, true, function()
		{
			remove(bobTransforms);
			FlxG.camera.fade(FlxColor.BLACK, 0.5, true, function()
			{
				camHUD.visible = true;
				startCountdown();
			}, true);
		});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		var bg:FlxSprite = new FlxSprite(-100);
		bg.frames = Paths.getSparrowAtlas('bob/cutscene/sky');
		bg.animation.addByPrefix('shake', 'sky shake', 24, false);
		bg.updateHitbox();
		bg.antialiasing = true;
		bg.scrollFactor.set(0.1, 0.1);

		var ground:FlxSprite = new FlxSprite(-537, -158);
		ground.frames = Paths.getSparrowAtlas('bob/cutscene/ground');
		ground.animation.addByPrefix('shake', 'ground shake', 24, false);
		ground.updateHitbox();
		ground.antialiasing = true;

		var bobCut:FlxSprite = new FlxSprite(126, 361);
		bobCut.frames = Paths.getSparrowAtlas('bob/cutscene/BobCutscene');
		bobCut.animation.addByPrefix('start', 'bob mad', 24, false);
		bobCut.updateHitbox();
		bobCut.antialiasing = true;

		var bfCut:FlxSprite = new FlxSprite(770, 450);
		bfCut.frames = Paths.getSparrowAtlas('BOYFRIEND');
		bfCut.animation.addByPrefix('idle', 'BF idle dance', 24, true);
		bfCut.updateHitbox();
		bfCut.antialiasing = true;

		var gfCut:FlxSprite = new FlxSprite(400, 130);
		gfCut.frames = Paths.getSparrowAtlas('GF_assets');
		gfCut.animation.addByIndices('idle', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfCut.updateHitbox();
		gfCut.antialiasing = true;

		screenBudget = new FlxSprite(0, 0).loadGraphic(Paths.image('bob/cutscene/screen'));
		screenBudget.screenCenter();
		screenBudget.antialiasing = true;
		screenBudget.scrollFactor.set(0, 0);

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns' || SONG.song.toLowerCase() == 'run')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
				add(red);

			if (SONG.song.toLowerCase() == 'run')
			{
				camHUD.visible = false;
				add(bg);
				add(ground);
				add(gfCut);
				add(bobCut);
				add(bfCut);
				bfCut.animation.play('idle');
				gfCut.animation.play('idle');
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function() { add(dialogueBox); }, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else if (SONG.song.toLowerCase() == 'run')
					{
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							camFollow.y = bobCut.getMidpoint().y;
							camFollow.x = bobCut.getMidpoint().x;
							FlxG.camera.follow(camFollow, LOCKON, getCamFollowLerp());
							FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5);
							FlxG.sound.play(Paths.sound('OhScary'));
							bobCut.animation.play('start');
							new FlxTimer().start(3.8, function(swagTimer:FlxTimer)
							{
								remove(bg);
								remove(ground);
								remove(gfCut);
								remove(bobCut);
								remove(bfCut);
								add(screenBudget);
								FlxG.sound.playMusic(Paths.music('NoBudgedSad'));
								new FlxTimer().start(5, function(swagTimer:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.BLACK, 0.01, true, function()
									{
										camHUD.visible = true;
										add(dialogueBox);
									}, true);
								});
							});
							new FlxTimer().start(2.7, function(swagTimer:FlxTimer)
							{
								bg.animation.play('shake');
								ground.animation.play('shake');
							});
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
				{
					startCountdown();
				}

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		if (SONG.song.toLowerCase() == 'run' && screenBudget != null)
		{
			FlxTween.tween(screenBudget, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween) { remove(screenBudget); }
			});
		}

		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (curSong.toLowerCase() == 'onslaught')
			{
				if (curBeat <= 500)
					dad.dance();
			}
			else
			{
				dad.dance();
			}

			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) { ready.destroy(); }
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));
					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) { set.destroy(); }
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));
					go.updateHitbox();
					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) { go.destroy(); }
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT,
				Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8),
				this, 'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20, songPosBG.y, 0, SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		switch (curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog':
				allowedToHeadbang = true;
			default:
				allowedToHeadbang = false;
		}

		#if windows
		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),
			"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC
		);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection> = songData.notes;

		var daBeats:Int = 0;

		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset;
				if (daStrumTime < 0)
					daStrumTime = 0;

				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
					gottaHitNote = !section.mustHitSection;

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;
					if (sustainNote.mustPress)
						sustainNote.x += FlxG.width / 2;

					sustainNote.health = sustainNote.x;
				}

				swagNote.mustPress = gottaHitNote;
				if (swagNote.mustPress)
					swagNote.x += FlxG.width / 2;

				swagNote.health = swagNote.angle;
			}

			daBeats += 1;
		}

		var beatStepTime = 600 * (100 / songData.bpm);

		if (curSong == 'Onslaught')
		{
			if (storyDifficulty == 1)
			{
				for (x in 0...shootBeatsEasy.length)
				{
					var warnNoteTime = shootBeatsEasy[x];
					var notethingidk:Float = warnNoteTime * beatStepTime;
					var warnNote:Note;

					if (DoIHit)
						warnNote = new Note(notethingidk, shootBeatsPosEasy[x], null, false, true);
					else
						warnNote = new Note(notethingidk, shootBeatsPosEasy[x], null, false, false, true);

					DoIHit = !DoIHit;
					warnNote.scrollFactor.set(0, 0);
					unspawnNotes.push(warnNote);
					warnNote.mustPress = true;
					warnNote.x += FlxG.width / 2;
				}
			}
			else if (storyDifficulty == 2)
			{
				for (x in 0...shootBeats.length)
				{
					var warnNoteTime = shootBeats[x];
					var notethingidk:Float = warnNoteTime * beatStepTime;
					var warnNote:Note;

					if (DoIHit)
						warnNote = new Note(notethingidk, shootBeatsPos[x], null, false, true);
					else
						warnNote = new Note(notethingidk, shootBeatsPos[x], null, false, false, true);

					DoIHit = !DoIHit;
					warnNote.scrollFactor.set(0, 0);
					unspawnNotes.push(warnNote);
					warnNote.mustPress = true;
					warnNote.x += FlxG.width / 2;
				}
			}
		}

		unspawnNotes.sort(sortByShit);
		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);
					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
				playerStrums.add(babyArrow);

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			babyArrow.health = babyArrow.angle;
			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence(
				"PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),
				"Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
				iconRPC
			);
			#end

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;

			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(
					detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),
					"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
					iconRPC, true, songLength - Conductor.songPosition
				);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),
			"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC
		);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0)
			ranking = "(MFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1)
			ranking = "(GFC)";
		else if (misses == 0)
			ranking = "(FC)";
		else if (misses < 10)
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935,
			accuracy >= 99.980,
			accuracy >= 99.970,
			accuracy >= 99.955,
			accuracy >= 99.90,
			accuracy >= 99.80,
			accuracy >= 99.70,
			accuracy >= 99,
			accuracy >= 96.50,
			accuracy >= 93,
			accuracy >= 90,
			accuracy >= 85,
			accuracy >= 80,
			accuracy >= 70,
			accuracy >= 60,
			accuracy < 60
		];

		for (i in 0...wifeConditions.length)
		{
			if (wifeConditions[i])
			{
				switch (i)
				{
					case 0:  ranking += " AAAAA";
					case 1:  ranking += " AAAA:";
					case 2:  ranking += " AAAA.";
					case 3:  ranking += " AAAA";
					case 4:  ranking += " AAA:";
					case 5:  ranking += " AAA.";
					case 6:  ranking += " AAA";
					case 7:  ranking += " AA:";
					case 8:  ranking += " AA.";
					case 9:  ranking += " AA";
					case 10: ranking += " A:";
					case 11: ranking += " A.";
					case 12: ranking += " A";
					case 13: ranking += " B";
					case 14: ranking += " C";
					case 15: ranking += " D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for (i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
		{
			currentFrames++;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;
					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
		}

		super.update(elapsed);

		if (SONG.song.toLowerCase() == 'onslaught' && IsNoteSpinning)
		{
			#if desktop
			var thisX:Float = Math.sin(SpinAmount * (SpinAmount / 2)) * 100;
			var thisY:Float = Math.sin(SpinAmount * (SpinAmount)) * 100;
			var yVal = Std.int(windowY + thisY);
			var xVal = Std.int(windowX + thisX);
			if (!FlxG.save.data.shakingscreen)
				Lib.application.window.move(xVal, yVal);
			#end
			for (str in playerStrums)
			{
				str.angle = str.angle + SpinAmount;
				SpinAmount = SpinAmount + 0.0003;
			}
		}
		else
		{
			for (str in playerStrums)
				str.angle = str.health;
		}

		if (!offsetTesting)
		{
			if (FlxG.save.data.accuracyDisplay)
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "")
					+ "Score:" + (Conductor.safeFrames != 10 ? songScore + " (" + songScoreDef + ")" : "" + songScore)
					+ " | Combo Breaks:" + misses
					+ " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
			}
			else
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + songScore;
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;
		}

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			if (FlxG.random.bool(0.1))
				FlxG.switchState(new GitarooPause());
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		#if android
		if (FlxG.keys.justReleased.BACK && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
		#end

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end

			if (SONG.song.toLowerCase() == 'run')
				FlxG.switchState(new CantRunState());
			else if (SONG.song.toLowerCase() == 'onslaught')
				FlxG.switchState(new FunState());
			else
				FlxG.switchState(new ChartingState());
		}

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (allowedToHeadbang)
			{
				if (gf.animation.curAnim.name == 'danceLeft'
					|| gf.animation.curAnim.name == 'danceRight'
					|| gf.animation.curAnim.name == 'idle')
				{
					switch (curSong)
					{
						case 'Philly':
							if (curBeat < 250)
							{
								if (curBeat != 184 && curBeat != 216)
								{
									if (curBeat % 16 == 8)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
									{
										triggeredAlready = false;
									}
								}
							}
						case 'Bopeebo':
							if (curBeat > 5 && curBeat < 130)
							{
								if (curBeat % 8 == 7)
								{
									if (!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}
								else
								{
									triggeredAlready = false;
								}
							}
						case 'Blammed':
							if (curBeat > 30 && curBeat < 190)
							{
								if (curBeat < 90 || curBeat > 128)
								{
									if (curBeat % 4 == 2)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
									{
										triggeredAlready = false;
									}
								}
							}
						case 'Cocoa':
							if (curBeat < 170)
							{
								if (curBeat < 65 || (curBeat > 130 && curBeat < 145))
								{
									if (curBeat % 16 == 15)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
									{
										triggeredAlready = false;
									}
								}
							}
						case 'Eggnog':
							if (curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if (curBeat % 8 == 7)
								{
									if (!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}
								else
								{
									triggeredAlready = false;
								}
							}
					}
				}
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
					tweenCamIn();
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses', repPresses);
			FlxG.watch.addQuick('rep releases', repReleases);
		}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:  camZooming = true; gfSpeed = 2;
				case 48:  gfSpeed = 1;
				case 80:  gfSpeed = 2;
				case 112: gfSpeed = 1;
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130: vocals.volume = 0;
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			DiscordClient.changePresence(
				"GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),
				"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
				iconRPC
			);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 2: dad.playAnim('singUP' + altAnim, true);
						case 3: dad.playAnim('singRIGHT' + altAnim, true);
						case 1: dad.playAnim('singDOWN' + altAnim, true);
						case 0: dad.playAnim('singLEFT' + altAnim, true);
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				daNote.angle = strumLine.angle;

				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));

				if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else if (daNote.mustHitNotes)
					{
						HealthDrain();
					}
					else if (!daNote.warning)
					{
						health -= 0.075;
						vocals.volume = 0;
						if (theFunne)
							noteMiss(daNote.noteData, daNote);
					}

					daNote.active = false;
					daNote.visible = false;
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay();

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);
				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					#if windows
					DiscordClient.changePresence("HELP HELP HELP HELP HELP HELP", null, null, true);
					#end

					if (curSong.toLowerCase() == "run")
					{
						FlxG.switchState(new EndingState());
					}
					else if (curSong.toLowerCase() == "onslaught")
					{
						FlxG.switchState(new OnslaughtEndingState());
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						transIn  = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;
						FlxG.switchState(new StoryMenuState());
					}

					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";
					if (storyDifficulty == 0) difficulty = '-easy';
					if (storyDifficulty == 2) difficulty = '-hard';

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(
							-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom
						).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;
						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn  = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					var tempSong:String = SONG.song.toLowerCase();
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if (tempSong == 'ron')
						LoadingState.loadAndSwitchState(new VideoState(Paths.video('ronEndCutscene'), new PlayState()));
					else
						LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	var endingSong:Bool = false;
	var hits:Array<Float> = [];
	var offsetTest:Float = 0;
	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
		var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		coolText.y -= 350;
		coolText.cameras = [camHUD];

		var rating:FlxSprite = new FlxSprite();
		var score:Float = 350;

		totalNotesHit += wife;

		var daRating = daNote.rating;

		switch (daRating)
		{
			case 'shit':
				score = -300;
				combo = 0;
				misses++;
				health -= 0.2;
				ss = false;
				shits++;
			case 'bad':
				daRating = 'bad';
				score = 0;
				health -= 0.06;
				ss = false;
				bads++;
			case 'good':
				daRating = 'good';
				score = 200;
				ss = false;
				goods++;
				if (health < 2) health += 0.04;
			case 'sick':
				if (health < 2) health += 0.1;
				sicks++;
		}

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore    += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}

			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var msTiming = truncateFloat(noteDiff, 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0, 0, 0, "0ms");
			timeShown = 0;

			switch (daRating)
			{
				case 'shit' | 'bad': currentTimingShown.color = FlxColor.RED;
				case 'good':         currentTimingShown.color = FlxColor.GREEN;
				case 'sick':         currentTimingShown.color = FlxColor.CYAN;
			}

			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;
				for (i in hits)
					total += i;

				offsetTest = truncateFloat(total / hits.length, 2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			add(currentTimingShown);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();

			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0);

			for (i in 0...comboSplit.length)
				seperatedScore.push(Std.parseInt(comboSplit[i]));

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}

				numScore.updateHitbox();
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween) { numScore.destroy(); },
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}

			coolText.text = Std.string(seperatedScore);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool    = false;
	var downHold:Bool  = false;
	var rightHold:Bool = false;
	var leftHold:Bool  = false;

	private function keyShit():Void
	{
		var up    = controls.UP;
		var right = controls.RIGHT;
		var down  = controls.DOWN;
		var left  = controls.LEFT;

		var upP    = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP  = controls.DOWN_P;
		var leftP  = controls.LEFT_P;

		var upR    = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR  = controls.DOWN_R;
		var leftR  = controls.LEFT_R;

		#if mobile
		var _l = hitbox.left;
		var _d = hitbox.down;
		var _u = hitbox.up;
		var _r = hitbox.right;

		left  = left  || _l;
		down  = down  || _d;
		up    = up    || _u;
		right = right || _r;

		leftP  = leftP  || (_l && !_prevLeft);
		downP  = downP  || (_d && !_prevDown);
		upP    = upP    || (_u && !_prevUp);
		rightP = rightP || (_r && !_prevRight);

		leftR  = leftR  || (!_l && _prevLeft);
		downR  = downR  || (!_d && _prevDown);
		upR    = upR    || (!_u && _prevUp);
		rightR = rightR || (!_r && _prevRight);

		_prevLeft  = _l;
		_prevDown  = _d;
		_prevUp    = _u;
		_prevRight = _r;
		#end

		if (loadRep)
		{
			up    = false;
			down  = false;
			right = false;
			left  = false;

			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				upP    = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "up";
				rightP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "right";
				downP  = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "down";
				leftP  = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "left";

				upR    = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "up";
				rightR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "right";
				downR  = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "down";
				leftR  = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "left";

				upHold    = upP    ? true : upR    ? false : true;
				rightHold = rightP ? true : rightR ? false : true;
				downHold  = downP  ? true : downR  ? false : true;
				leftHold  = leftP  ? true : leftR  ? false : true;
			}
		}
		else if (!loadRep)
		{
			if (upP)    rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (rightP) rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (downP)  rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (leftP)  rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (upR)    rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (rightR) rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (downR)  rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (leftR)  rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			repPresses++;
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];
			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
				{
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						if (loadRep)
						{
							var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
							daNote.rating = Ratings.CalculateRating(noteDiff);

							if (NearlyEquals(daNote.strumTime, rep.replay.keyPresses[repPresses].time, 30))
								goodNoteHit(daNote);
							else
								noteCheck(controlArray, daNote);
						}
						else
						{
							noteCheck(controlArray, daNote);
						}
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							if (loadRep)
							{
								if (NearlyEquals(coolNote.strumTime, rep.replay.keyPresses[repPresses].time, 30))
								{
									var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);
									if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
										coolNote.rating = "shit";
									else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
										coolNote.rating = "bad";
									else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
										coolNote.rating = "good";
									else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
										coolNote.rating = "sick";
									goodNoteHit(coolNote);
								}
								else
								{
									noteCheck(controlArray, daNote);
								}
							}
							else
							{
								noteCheck(controlArray, coolNote);
							}
						}
					}
				}
				else
				{
					if (loadRep)
					{
						if (NearlyEquals(daNote.strumTime, rep.replay.keyPresses[repPresses].time, 30))
						{
							var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
							daNote.rating = Ratings.CalculateRating(noteDiff);
							goodNoteHit(daNote);
						}
						else
						{
							noteCheck(controlArray, daNote);
						}
					}
					else
					{
						noteCheck(controlArray, daNote);
					}
				}

				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
		}

		if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && loadRep && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						case 2: if (up    || upHold)    goodNoteHit(daNote);
						case 3: if (right || rightHold) goodNoteHit(daNote);
						case 1: if (down  || downHold)  goodNoteHit(daNote);
						case 0: if (left  || leftHold)  goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 2:
					if (!loadRep)
					{
						if (upP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (upR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					}
				case 3:
					if (!loadRep)
					{
						if (rightP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (rightR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					}
				case 1:
					if (!loadRep)
					{
						if (downP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (downR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					}
				case 0:
					if (!loadRep)
					{
						if (leftP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (leftR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					}
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
			{
				spr.centerOffsets();
			}
		});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;

			if (combo > 5 && gf.animOffsets.exists('sad'))
				gf.playAnim('sad');

			combo = 0;
			misses++;

			var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			totalNotesHit += wife;
			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			switch (direction)
			{
				case 0: boyfriend.playAnim('singLEFTmiss', true);
				case 1: boyfriend.playAnim('singDOWNmiss', true);
				case 2: boyfriend.playAnim('singUPmiss', true);
				case 3: boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function updateAccuracy():Void
	{
		totalPlayed += 1;
		accuracy        = Math.max(0, totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = [];

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});

		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}

	var mashing:Int = 0;
	var mashViolations:Int = 0;
	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
			note.rating = "shit";
		else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
			note.rating = "bad";
		else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
			note.rating = "good";
		else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
			note.rating = "sick";

		if (loadRep)
		{
			if (controlArray[note.noteData])
				goodNoteHit(note);
			else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
			{
				if (NearlyEquals(note.strumTime, rep.replay.keyPresses[repPresses].time, 4))
					goodNoteHit(note);
			}
		}
		else if (controlArray[note.noteData])
		{
			for (b in controlArray)
				if (b) mashing++;

			if (mashing <= getKeyPresses(note) && mashViolations < 2)
			{
				mashViolations++;
				goodNoteHit(note, (mashing <= getKeyPresses(note)));
			}
			else
			{
				playerStrums.members[0].animation.play('static');
				playerStrums.members[1].animation.play('static');
				playerStrums.members[2].animation.play('static');
				playerStrums.members[3].animation.play('static');
				health -= 0.2;
			}

			if (mashing != 0)
				mashing = 0;
		}
	}

	var nps:Int = 0;

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);
		note.rating = Ratings.CalculateRating(noteDiff);

		if (!note.isSustainNote)
			notesHitArray.push(Date.now());

		if (resetMashViolation)
			mashViolations--;

		if (!note.wasGoodHit)
		{
			if (note.warning)
			{
				HealthDrain();
			}
			else if (!note.isSustainNote)
			{
				popUpScore(note);
				combo += 1;
			}
			else
			{
				totalNotesHit += 1;
			}

			if (!note.warning)
			{
				switch (note.noteData)
				{
					case 2: boyfriend.playAnim('singUP', true);
					case 3: boyfriend.playAnim('singRIGHT', true);
					case 1: boyfriend.playAnim('singDOWN', true);
					case 0: boyfriend.playAnim('singLEFT', true);
				}
			}

			if (!loadRep)
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(note.noteData) == spr.ID)
						spr.animation.play('confirm', true);
				});
			}

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive():Void
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);
		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer) { resetFastCar(); });
	}

	var isbobmad:Bool = true;
	var appearscreen:Bool = true;

	function shakescreen():Void
	{
		#if desktop
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			Lib.application.window.move(
				Lib.application.window.x + FlxG.random.int(-10, 10),
				Lib.application.window.y + FlxG.random.int(-8, 8)
			);
		}, 50);
		#end
	}

	function HealthDrain():Void
	{
		FlxG.sound.play(Paths.sound("BoomCloud"), 1);
		boyfriend.playAnim("hit", true);
		FlxG.camera.zoom -= 0.02;
		new FlxTimer().start(0.3, function(tmr:FlxTimer) { boyfriend.playAnim("idle", true); });
		new FlxTimer().start(0.01, function(tmr:FlxTimer) { health -= 0.005; }, 300);
	}

	function resetBobismad():Void
	{
		camHUD.visible = true;
		bobsound.pause();
		bobmadshake.visible = false;
		bobsound.volume = 0;
		isbobmad = true;
	}

	function InvisibleNotes():Void
	{
		FlxG.sound.play(Paths.sound('Meow'));
		for (note in playerStrums)
			note.visible = false;
		for (note in strumLineNotes)
			note.visible = false;
	}

	function VisibleNotes():Void
	{
		FlxG.sound.play(Paths.sound('woeM'));
		for (note in playerStrums)
			note.visible = true;
		for (note in strumLineNotes)
			note.visible = true;
	}

	function Bobismad():Void
	{
		camHUD.visible = false;
		bobmadshake.visible = true;
		bobsound.play();
		bobsound.volume = 1;
		isbobmad = false;
		shakescreen();
		new FlxTimer().start(0.5, function(tmr:FlxTimer) { resetBobismad(); });
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;
				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');
		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);
		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		#if windows
		songLength = FlxG.sound.music.length;
		DiscordClient.changePresence(
			detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),
			"Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses,
			iconRPC, true, songLength - Conductor.songPosition
		);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);

			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}

		wiggleShit.update(Conductor.crochet);

		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'onslaught' && curBeat >= 0 && curBeat < 64 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		else if (curSong.toLowerCase() == 'onslaught' && curBeat >= 96 && curBeat < 224 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		else if (curSong.toLowerCase() == 'onslaught' && curBeat >= 240 && curBeat < 352 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat == 2 && curSong == 'Ron')
		{
			var bruh:FlxSprite = new FlxSprite();
			bruh.loadGraphic(Paths.image('bob/longbob'));
			bruh.antialiasing = true;
			bruh.active = false;
			bruh.scrollFactor.set();
			bruh.screenCenter();
			add(bruh);
			FlxTween.tween(bruh, {alpha: 0}, 1, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween) { bruh.destroy(); }
			});
		}

		if (curSong == 'Ron')
		{
			if (curBeat == 7)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut});
				dad.playAnim('cheer', true);
			}
			else if (curBeat == 119)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut});
				dad.playAnim('cheer', true);
			}
			else if (curBeat == 215)
			{
				FlxG.camera.follow(dad, LOCKON, getCamFollowLerp());
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut});
				dad.playAnim('cheer', true);
			}
			else
			{
				FlxG.camera.follow(camFollow, LOCKON, getCamFollowLerp());
			}
		}

		if (curBeat % gfSpeed == 0 && curSong == 'run' && !FlxG.save.data.shakingscreen)
		{
			camHUD.shake(0.02, 0.2);
			FlxG.camera.shake(0.005, 0.2);
		}

		if (curBeat % gfSpeed == 0)
			gf.dance();

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
			boyfriend.playAnim('idle');

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
			boyfriend.playAnim('hey', true);

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		if (curSong.toLowerCase() == 'onslaught' && curBeat >= 128 && curBeat <= 352)
		{
			var amount = curBeat / 20;
			if (FlxG.random.bool(amount) && appearscreen)
			{
				var randomthing:FlxSprite = new FlxSprite(FlxG.random.int(300, 1077), FlxG.random.int(0, 622));
				FlxG.sound.play(Paths.sound("pop_up"), 1);
				randomthing.loadGraphic(Paths.image('bob/PopUps/popup' + FlxG.random.int(1, 11), 'shared'));
				randomthing.updateHitbox();
				randomthing.alpha = 0;
				randomthing.antialiasing = true;
				add(randomthing);
				randomthing.cameras = [camHUD];
				appearscreen = false;

				if (storyDifficulty == 0)
					FlxTween.tween(randomthing, {width: 1, alpha: 0.5}, 0.2, {ease: FlxEase.sineOut});
				else
					FlxTween.tween(randomthing, {width: 1, alpha: 1}, 0.2, {ease: FlxEase.sineOut});

				new FlxTimer().start(1.5, function(tmr:FlxTimer) { appearscreen = true; });
				new FlxTimer().start(2, function(tmr:FlxTimer) { remove(randomthing); });
			}
		}

		if (curSong.toLowerCase() == 'little-man' && curBeat == 1397)
			changeDadCharacter('pizza');

		if (curSong.toLowerCase() == 'little-man' && curBeat == 1497)
			changeDadCharacter('little-man');

		if (curSong.toLowerCase() == 'little-man' && curBeat == 1844)
		{
			changeDadCharacter('tankman');
			dad.x -= 124;
			dad.y -= 644;
			dad.y += 268;
			dad.x -= 27;
		}

		if (curSong.toLowerCase() == 'little-man' && curBeat == 1900)
			spotifyad();

		if (curSong.toLowerCase() == 'trouble' && curBeat == 504)
			BobIngameTransform();

		if (curSong.toLowerCase() == 'onslaught' && curBeat == 96)
			InvisibleNotes();

		if (curSong.toLowerCase() == 'onslaught' && curBeat == 128)
		{
			#if desktop
			windowX = Lib.application.window.x;
			windowY = Lib.application.window.y;
			#end
			IsNoteSpinning = true;
			VisibleNotes();
		}

		if (curSong.toLowerCase() == 'onslaught' && curBeat == 240)
			InvisibleNotes();

		if (curSong.toLowerCase() == 'onslaught' && curBeat == 352)
		{
			IsNoteSpinning = false;
			#if desktop
			if (!FlxG.save.data.shakingscreen)
				WindowGoBack();
			#end
			VisibleNotes();
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();
			case 'hellstage':
				if (FlxG.random.bool(10) && isbobmad && curSong.toLowerCase() == 'run' && !FlxG.save.data.jumpscare)
					Bobismad();
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer) { dancer.dance(); });
				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite) { light.visible = false; });
					curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					phillyCityLights.members[curLight].visible = true;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
			lightningStrikeShit();
	}

	function BobIngameTransform():Void
	{
		dad.playAnim('Transform', true);
		FlxG.sound.play(Paths.sound('bobSpooky'));

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();

		new FlxTimer().start(1.7, function(tmr:FlxTimer)
		{
			add(black);
			FlxG.camera.fade(FlxColor.WHITE, 0.1, true);
		});
	}

	function spotifyad():Void
	{
		var thx:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('littleman/spotifyad'));
		thx.updateHitbox();
		thx.scrollFactor.set(0, 0);
		thx.antialiasing = true;
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
		{
			add(thx);
			FlxG.camera.fade(FlxColor.BLACK, 1, true);
		}, true);
	}

	function WindowGoBack():Void
	{
		#if desktop
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			var xLerp:Float = FlxMath.lerp(windowX, Lib.application.window.x, 0.95);
			var yLerp:Float = FlxMath.lerp(windowY, Lib.application.window.y, 0.95);
			Lib.application.window.move(Std.int(xLerp), Std.int(yLerp));
		}, 20);
		#end
	}

	function changeDadCharacter(id:String):Void
	{
		var olddadx = dad.x;
		var olddady = dad.y;
		remove(dad);
		dad = new Character(olddadx, olddady, id);
		add(dad);
		iconP2.animation.play(id);
	}

	var curLight:Int = 0;
}
