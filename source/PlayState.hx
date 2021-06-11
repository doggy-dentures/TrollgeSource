package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

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
	var kadeEngineWatermark:FlxText;
	
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	//Characters

	public static var lasttrollge:Character;
	public static var trollge_sad:Character;
	public static var trollrager:Character;
	public static var trollrager2:Character;
	public static var trollrager3:Character;
	public static var dad:Character;
	public static var gf:Character;
	public static var gf2:Character;
	public static var gfG:Character;
	public static var bundaTrollge:Character;
	public static var bundaTrollge2:Character;
	public static var bundaTrollge3:Character;
	public static var bundaTrollgeFinal:Character;
	public static var bundaTrollge4:Character;
	public static var boyfriend:Boyfriend;
	public static var troll2:Character;
	public static var troll3:Character;
	public static var bluefriend:Boyfriend;
	public static var bfG:Boyfriend;
	public static var thefinalt:Character;

	//Characters

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
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

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	public var thing:Int = 33;
	
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
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	

	//Sprites

	private var shakeHUD:Bool = false;
	private var shakeHUD2:Bool = false;
	private var shakeHUD3:Bool = false;
	private var shakeCam:Bool = false;
	private var shakeCam2:Bool = false;
	private var shakeCam3:Bool = false;
	private var bundaCam:Bool = false;

	//shakecam

	var gfanim:FlxSprite = new FlxSprite(620, 180);
	var bfanim:FlxSprite = new FlxSprite(990, 500);
	
	var noise:FlxSprite = new FlxSprite(-80);
	var glitchs:FlxSprite = new FlxSprite();
	var rageAnim1:FlxSprite = new FlxSprite(25, 239);
	var rageAnim2:FlxSprite = new FlxSprite(25, 239);
	var rageAnim3:FlxSprite = new FlxSprite(200, 350);
	var faces:FlxSprite = new FlxSprite(-220, 100);
	public var sura:FlxSprite = new FlxSprite(-500, -260);
	public var sura2:FlxSprite = new FlxSprite(-500, -260);
	public var sur:FlxSprite = new FlxSprite(-500, -260);
	public static var trollvar:Bool = false;
	public static var finalvar:Bool = false;
	var bunda:FlxTrail;
	var sadnessTrail:FlxTrail;
	var rageTrail:FlxTrail;
	var isTrollge:Bool = false;
	var isTrollge2:Bool = false;
	var su:Float = 0;
	var su2:Int = 0;
	var bt:FlxSprite = new FlxSprite(600, 400);
	var whito:FlxSprite = new FlxSprite(-500, -260);
	var whito2:FlxSprite = new FlxSprite(-500, -260);
	var bbg:FlxSprite = new FlxSprite(-500, -260);
	var bbg2:FlxSprite = new FlxSprite(-500, -260);
	var bgt:FlxSprite = new FlxSprite(-500, -260);
	var back1:FlxSprite = new FlxSprite(-500, -260);
	var sadgli:FlxSprite = new FlxSprite(-500, -260);
	var bgo:FlxSprite = new FlxSprite(-500, -260);
	var soe:FlxSprite = new FlxSprite(-500, -260);
	var bt2:FlxSprite = new FlxSprite(600, 400);
	var bt3:FlxSprite = new FlxSprite(600, 400);
	var bt4:FlxSprite = new FlxSprite(600, 400);
	var bt5:FlxSprite = new FlxSprite(600, 400);
	var not:FlxSprite = new FlxSprite(0, 0);
	var valuer:Int = 200;
	var nummber:Int = 2;
	public static var samanta:Bool = true;
	public static var samanta2:Bool = true;
	public static var samanta3:Bool = true;
	//values
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
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
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
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

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		
		switch (SONG.song.toLowerCase())
		{
			case 'sadness':
				dialogue = CoolUtil.coolTextFile(Paths.txt('sadness/diag'));
			case 'incident':
				dialogue = CoolUtil.coolTextFile(Paths.txt('incident/di'));
			case 'rage':
				dialogue = CoolUtil.coolTextFile(Paths.txt('rage/d'));
		}

		switch(SONG.stage)
		{
			
			case 'ragi':
			{
				defaultCamZoom = 1;
				curStage = 'ragi';

				sadgli.loadGraphic(Paths.image('ragi/B0'));
				sadgli.active = false;
				sadgli.alpha = 0;
				add(sadgli);
					
				soe.loadGraphic(Paths.image('ragi/sad'));
				soe.antialiasing = true;
				soe.scrollFactor.set(0.9, 0.9);
				soe.active = false;
				add(soe);
	
				sur.loadGraphic(Paths.image('ragi/foreground'));
				sur.active = false;
				
				noise.frames = Paths.getSparrowAtlas('ragi/sheeto2');
				noise.animation.addByPrefix('n', 'n', 24);
				noise.animation.play('n');
				noise.scale.set(8, 8);
				noise.alpha = 0;
				noise.updateHitbox();
				noise.screenCenter();
				
				glitchs.frames = Paths.getSparrowAtlas('ragi/glitchAnim');
				glitchs.animation.addByPrefix('g', 'g', 24);
				glitchs.animation.play('g');
				glitchs.scale.set(2,2);
				glitchs.alpha = 0;
				glitchs.updateHitbox();
				glitchs.screenCenter();
				
				rageAnim1.frames = Paths.getSparrowAtlas('ragi/RageAnim');
				rageAnim1.animation.addByPrefix('RageFinal1',"RageFinal1", 24);
				
				rageAnim1.alpha = 0;
				add(rageAnim1);

				rageAnim2.frames = Paths.getSparrowAtlas('ragi/RageAnim');
				rageAnim2.animation.addByPrefix('RageFinal2',"RageFinal2", 24, false);
				rageAnim2.alpha = 0;
				add(rageAnim2);

				rageAnim3.frames = Paths.getSparrowAtlas('ragi/RageAnim');
				rageAnim3.animation.addByPrefix('RageFinal3',"RageFinal3", 24);
				rageAnim3.animation.play('RageFinal3');
				rageAnim3.alpha = 0;
				rageAnim3.scale.set(1.3, 1.3);

				faces.loadGraphic(Paths.image('ragi/theface'));
				faces.alpha = 0;
				faces.scale.set(0.6, 0.6);
				
				trollrager = new Character(100, 100, 'trollrager');
				add(trollrager);
				trollrager.alpha = 0;
				trollrager2 = new Character(100, 100, 'trollrager2');
				add(trollrager2);
				trollrager2.alpha = 0;
				trollrager3 = new Character(100, 100, 'trollrager3');
				add(trollrager3);
				trollrager3.alpha = 0;

				sura2.frames = Paths.getSparrowAtlas('ragi/sheeto3');
				sura2.animation.addByPrefix('n', 'n', 24);
				sura2.animation.play('n');
				sura2.scale.set(4, 4);
				sura2.alpha = 0; 
				sura2.scrollFactor.set();
				sura2.screenCenter();

				gfG = new Character(400, 130,'gfG');
				gfG.alpha = 0;
				add(gfG);
				sura.loadGraphic(Paths.image('sadi/aaa'));
				sura.active = false;
				sura.alpha = 1;
				
			}
			case 'sadi':
			{
				defaultCamZoom = 1;
				curStage = 'sadi';

				sadgli.loadGraphic(Paths.image('sadi/B0'));
				sadgli.active = false;
				sadgli.alpha = 0;
				add(sadgli);
				
				sura.loadGraphic(Paths.image('sadi/aaa'));
				sura.active = false;
				sura.alpha = 1;

				soe.loadGraphic(Paths.image('sadi/sad'));
				soe.antialiasing = true;
				soe.scrollFactor.set(0.9, 0.9);
				soe.active = false;
				add(soe);

				sur.loadGraphic(Paths.image('sadi/foreground'));
				sur.active = false;
				
				troll2 = new Character(100, 100, 'troll2');
				add(troll2);
				troll2.alpha = 0;
				troll3 = new Character(100, 100, 'troll3');
				add(troll3);
				troll3.alpha = 0;
				sadnessTrail = new FlxTrail(troll3, null, nummber, 24, 0.3, 0.069);
			}
			case 'redemp':
			{
				curStage = 'rede';
				defaultCamZoom = 1.5;

				whito.loadGraphic(Paths.image('redemp/white'));
				whito.antialiasing = true;
				add(whito);
				whito2.loadGraphic(Paths.image('redemp/white'));
				whito2.antialiasing = true;
				whito2.alpha = 0;
				
				soe.loadGraphic(Paths.image('redemp/sad'));
				soe.antialiasing = true;
				soe.scrollFactor.set(0.9, 0.9);
				soe.active = false;
				add(soe);
				
				sur.loadGraphic(Paths.image('redemp/foreground'));
				sur.active = false;
				add(sur);

				sura.loadGraphic(Paths.image('redemp/aaa'));
				sura.active = false;
				sura.alpha = 1;
				
				thefinalt = new Character(100, 100, 'trollge_4');
				add(thefinalt);
				
				gfanim.frames = Paths.getSparrowAtlas('redemp/gfanim');
				gfanim.animation.addByPrefix('Symbol 1','Symbol 1',12, false);
				gfanim.antialiasing = true;
				gfanim.alpha = 0;
				add(gfanim);

				bfanim.frames = Paths.getSparrowAtlas('redemp/bfanim');
				bfanim.animation.addByPrefix('BF idle dance','BF idle dance',12, false);
				bfanim.antialiasing = true;
				add(bfanim);
				bfanim.alpha = 0;
			}
			case 'incidenti':
			{
				isTrollge2 = false;
				isTrollge = true;
				curStage = 'bundi';
				defaultCamZoom = 1.4;
				bgt.loadGraphic(Paths.image('incidenti/BB1'));
				bgt.active = false;
				
				add(bgt);

				back1.loadGraphic(Paths.image('incidenti/BB3'));
				back1.active = false;
				back1.alpha = 0;
				add(back1);

				bgo.loadGraphic(Paths.image('incidenti/BB6'));
				bgo.active = false;
				bgo.alpha = 0;
				add(bgo);
				bt2.frames = Paths.getSparrowAtlas('incidenti/bruh');
				bt2.animation.addByPrefix('Idle', 'Idle', 6);
				bt2.animation.play('Idle');
				bt2.scale.set(7, 7);
				bt2.alpha = 0;
				add(bt2);

				bt3.frames = Paths.getSparrowAtlas('incidenti/bruh2');
				bt3.animation.addByPrefix('Idle', 'Idle', 6);
				bt3.animation.play('Idle');
				bt3.scale.set(7, 7);
				bt3.alpha = 0;
				add(bt3);
				bbg2.frames = Paths.getSparrowAtlas('incidenti/sheet2');
				bbg2.animation.addByPrefix('Idle', 'Idle', 24);
				bbg2.animation.play('Idle');	
				bbg2.alpha = 0;
				add(bbg2);

				bt4.frames = Paths.getSparrowAtlas('incidenti/bapi2');
				bt4.animation.addByPrefix('sus', 'sus', 6);
				bt4.animation.play('sus');
				bt4.scale.set(7, 7);
				bt4.alpha = 0;
				add(bt4);
				bt5.frames = Paths.getSparrowAtlas('incidenti/bapi');
				bt5.animation.addByPrefix('sus', 'sus', 6);
				bt5.animation.play('sus');
				bt5.scale.set(7, 7);
				bt5.alpha = 0;
				add(bt5);
				
				bbg.frames = Paths.getSparrowAtlas('incidenti/sheet');
				bbg.animation.addByPrefix('Idle', 'Idle', 24);
				bbg.animation.play('Idle');
				bbg.alpha = 0;
				add(bbg);

				bundaTrollge = new Character(100, 100, 'trollge1');
				add(bundaTrollge);
				bundaTrollge.alpha = 0;

				bundaTrollge2 = new Character(100, 100, 'trollge2');
				add(bundaTrollge2);
				bundaTrollge2.alpha = 0;

				bundaTrollge3 = new Character(100, 100, 'trollgeglitch');
				add(bundaTrollge3);
				bundaTrollge3.alpha = 0;

				bundaTrollgeFinal = new Character(100, 100, 'trollgeglitch2');
				add(bundaTrollgeFinal);
				bundaTrollgeFinal.alpha = 0;

				bundaTrollge4 = new Character(100, 100, 'trollge4');
				add(bundaTrollge4);
				bundaTrollge4.alpha = 0;
				
				lasttrollge = new Character(100, 100, 'trollge_4');
				add(lasttrollge);
				lasttrollge.alpha = 0;
				trollge_sad = new Character(100, 100, 'trollge_sad');
				add(trollge_sad);
				trollge_sad.alpha = 0;

				gf2 = new Character(400, 130,'gf2');
				gf2.alpha = 0;
				add(gf2);

				bt.frames = Paths.getSparrowAtlas('incidenti/GlitchSheet');
				bt.animation.addByPrefix('Idle', 'Idle', 24);
				bt.animation.play('Idle');
				bt.scale.set(10, 10);
				bt.alpha = 0;
				add(bt);

				sur.loadGraphic(Paths.image('incidenti/foreground'));
				sur.active = false;
				
				sur.alpha = 0.4;
				sura.loadGraphic(Paths.image('incidenti/aaa'));
				sura.alpha = 1;

				glitchs.frames = Paths.getSparrowAtlas('incidenti/glitchAnim');
				glitchs.animation.addByPrefix('g', 'g', 24);
				glitchs.animation.play('g');
				glitchs.scale.set(2,2);
				glitchs.alpha = 0;
				glitchs.updateHitbox();
				glitchs.screenCenter();

				sura2.frames = Paths.getSparrowAtlas('incidenti/sheeto3');
				sura2.animation.addByPrefix('n', 'n', 24);
				sura2.animation.play('n');
				sura2.scale.set(4, 4);
				sura2.alpha = 0; 
				sura2.scrollFactor.set();
				sura2.screenCenter();
				gfG = new Character(400, 130,'gfG');
				gfG.alpha = 0;
				add(gfG);
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
			case 'trollge':
			{
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			}
			case 'troll':
			{
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y); //quando spawna
			}
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		if (SONG.song.toLowerCase() == 'incident')
		{ 
			bluefriend = new Boyfriend(770, 450, 'bfblue'); 
			bfG = new Boyfriend(770, 450, 'bfG');
		}
		if (SONG.song.toLowerCase() == 'rage')
		{ 
			bfG = new Boyfriend(770, 450, 'bfG'); 
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'ragi':
			{
				//gf2.y+=50;
				gfG.y+=50;
				gf.y += 50;
				
				//gf2.x+=320;
				gf.x += 320;
				gfG.x += 320;

				boyfriend.y += 20;
				bfG.y += 20;
				
				boyfriend.x += 200;
				bfG.x += 200;
				
			}
			case 'bundi':
			{
				boyfriend.y += 20;
				bfG.y += 20;
				bluefriend.y += 20;
				gf.y += 50;
				gfG.y += 50;
				gf2.y += 50;
				
				gf2.x += 320;
				gf.x += 320;
				gfG.x += 320;
				boyfriend.x += 200;
				bfG.x += 200;
				bluefriend.x += 200;
			}
			case 'rede':
			{
				//dad.y += 300;
				//dad.x -= 200;
				dad.x -= 200;
				dad.y += 325;
				gf.y += 50;
				gf.x += 220;
				boyfriend.x += 100;
				boyfriend.y += 20;
			}
			default:
			{
				gf.y += 50;
				//gf.scale.set(0.9,0.9);
				//gf.antialising = true;
				gf.x += 220;
				boyfriend.x += 100;
				boyfriend.y += 20;
				
				troll3.y += 20;
				troll2.y += 20;
			}
		}

		add(gf);


		add(dad);
		if (SONG.song.toLowerCase() == 'rage' || SONG.song.toLowerCase() == 'incident' )
		{ 
			add(sura2); 
		}
		
		if (SONG.song.toLowerCase() == 'rage' )
		{ 
			add(bfG); 
			add(rageAnim3); 
			add(faces); 
		}

		add(boyfriend);

		if (SONG.song.toLowerCase() == 'sadness' || SONG.song.toLowerCase() == 'rage')
		{
			add(sura);
			add(sur);
			add(bfG); 
		}

		if (SONG.song.toLowerCase() == 'rage') 
		{
			add(noise); 
			add(glitchs);
		}
		if (SONG.song.toLowerCase() == 'incident' )
		{ 
			add(bluefriend);  
			add(sur); 
			add(bfG); 
			add(glitchs); 
			add(sura); 
		}
		if (SONG.song.toLowerCase() == 'redemption' ) 
		{
			add(sura); 
			add(whito2);
		};



		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);
			songName.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.alpha = 0;
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		switch (SONG.song.toLowerCase())
		{
			case 'incident': { healthBar.createFilledBar(0xFF000000, 0xFF2C5979); }
			default: { healthBar.createFilledBar(0xFFB12739, 0xFF2C5979); }
		}
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText("@BunnyMalicious @_ezhaltd");
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);
		

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;
			
		

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		

		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;			
		scoreTxt.alpha = 0;										  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.alpha = 0;
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.alpha = 0;
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

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case 'sadness':
					if(samanta2 == true)
					{
						schoolIntro(doof);
					}
					if(samanta2 == false)
					{
						startCountdown();
					}
				case 'rage':
					if(samanta == true)
					{
						schoolIntro(doof);
					}
					if(samanta == false)
					{
						startCountdown();
					}
				case 'incident':
					if(samanta3 == true)
					{
						schoolIntro(doof);
					}
					if(samanta3 == false)
					{
						startCountdown();
					}
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

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

					add(dialogueBox);
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		switch (SONG.song.toLowerCase())
		{
			case 'rage':
				samanta = false;
			case 'sadness':
				samanta2 = false;
			case 'incident':
				samanta3 = false;
		}
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		if (SONG.song.toLowerCase() == 'redemption')
		{
			sura.alpha = 0;
			dad.alpha = 0;
			healthBar.alpha = 0;
			healthBarBG.alpha = 0;
			iconP1.alpha = 0;
			iconP2.alpha = 0;
			scoreTxt.alpha = 0;
			defaultCamZoom = 2;
			camHUD.alpha = 0;
		}

		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			if (SONG.song.toLowerCase() == 'incident')
			{
				gf2.dance();
				gfG.dance();
				bluefriend.playAnim('idle'); 
				bfG.playAnim('idle');
			}
			boyfriend.playAnim('idle');

			if (SONG.song.toLowerCase() == 'rage')
			{
				gfG.dance();
				bfG.playAnim('idle');
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);

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


					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();


					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();


					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			songPosBG.alpha = 0;
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		allowedToHeadbang = false;
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

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

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

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
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

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
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

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

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	function ttweenCamOut():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 0.8}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}
	function ttweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 2}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}
	function ttweenCamIn2():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.6}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
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
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
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
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
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
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.pressed.CONTROL)
		{
			if (FlxG.keys.pressed.ALT)
			{
				if (FlxG.keys.justPressed.S)
				{
					endSong();
				}
			}
		}
		if (!FlxG.save.data.photosensitive)
		{
			if(shakeHUD)
			{
				camHUD.shake(0.002,1);
				FlxG.camera.shake(0.002,1);
			}
			if(shakeHUD2)
			{
				camHUD.shake(0.003,1);
				FlxG.camera.shake(0.003,1);
			}
			if(shakeHUD3)
			{
				camHUD.shake(0.0075,1);
				FlxG.camera.shake(0.003,1);
			}
			if(shakeCam)
			{
				FlxG.camera.shake(0.01,0.01);
				camHUD.shake(0.01,0.01);
			}
			if(shakeCam3)
			{
				FlxG.camera.shake(0.004,0.01);
				camHUD.shake(0.004,0.01);
			}	
			if(shakeCam2)
			{
				FlxG.camera.shake(0.01,0.1);
				camHUD.shake(0.01,0.01);
			}
		}

		#if !debug
		perfectMode = false;
		#end

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

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

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

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
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'troll':
						camFollow.y = dad.getMidpoint().y + 100; //camera iuhuuu
						//camFollow.x = dad.getMidpoint().x - 50;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

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
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
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

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

						//*crys* why
						//- brightfyre

						var daString:String = '';
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								daString = 'singUP';
							case 3:
								daString = 'singRIGHT';
							case 1:
								daString = 'singDOWN';
							case 0:
								daString = 'singLEFT';
						}

						if (SONG.song.toLowerCase() == 'redemption')
						{
							thefinalt.playAnim('singA');
						}
						if (SONG.song.toLowerCase() == 'sadness')
						{
							troll2.playAnim(daString, true);
							troll3.playAnim(daString, true);
						}
						if (SONG.song.toLowerCase() == 'rage')
						{
							trollrager.playAnim(daString, true);
							trollrager2.playAnim(daString, true);
							trollrager3.playAnim(daString, true);
						}
						if (SONG.song.toLowerCase() == 'incident')
						{
							bundaTrollgeFinal.playAnim(daString, true);
							bundaTrollge4.playAnim(daString, true);
							bundaTrollge3.playAnim(daString, true);
							bundaTrollge2.playAnim(daString, true);
							bundaTrollge.playAnim(daString, true);
						}

						dad.playAnim(daString + altAnim, true);





						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
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
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

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
					FlxG.sound.playMusic(Paths.music('credits'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new Credits());
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	

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
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
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
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			
			
			

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			

			
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			
			if(!FlxG.save.data.botplay) 
				add(rating);
	
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
	
			
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
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
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
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

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
		 
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (directionList.contains(daNote.noteData))
							{
								for (coolNote in possibleNotes)
								{
									if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
									{ // if it's the same note twice at < 10ms distance, just delete it
										// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
										dumbNotes.push(daNote);
										break;
									}
									else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
									{ // if daNote is earlier than existing note (coolNote), replace
										possibleNotes.remove(coolNote);
										possibleNotes.push(daNote);
										break;
									}
								}
							}
							else
							{
								possibleNotes.push(daNote);
								directionList.push(daNote.noteData);
							}
						}
					});
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
					if (SONG.song.toLowerCase() == 'incident')
						{
							bluefriend.playAnim('idle');
							bfG.playAnim('idle');
						}
					if (SONG.song.toLowerCase() == 'rage')
						{
							bfG.playAnim('idle');
						}
					
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;


			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			if (SONG.song.toLowerCase() == 'rage')
			{
				if (combo > 5 && gfG.animOffsets.exists('sad'))
				{
					{
						gfG.playAnim('sad');
					}
				}
			}
			if (SONG.song.toLowerCase() == 'incident')
			{
				if (combo > 5 && gf2.animOffsets.exists('sad'))
				{
					{
						gf2.playAnim('sad');
					}
				}
				if (combo > 5 && gfG.animOffsets.exists('sad'))
				{
		
					{
						gfG.playAnim('sad');
					}
				}
			}


			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			var daFuckIsThisCode:String = '';

			switch (direction)
			{
				case 0:
					daFuckIsThisCode = 'singLEFTmiss';
				case 1:
					daFuckIsThisCode = 'singDOWNmiss';
				case 2:
					daFuckIsThisCode = 'singUPmiss';
				case 3:
					daFuckIsThisCode = 'singRIGHTmiss';
			}

			if (SONG.song.toLowerCase() == 'incident')
			{
				bluefriend.playAnim(daFuckIsThisCode, true);
				bfG.playAnim(daFuckIsThisCode, true);
			}
			if (SONG.song.toLowerCase() == 'rage')
			{
				bfG.playAnim(daFuckIsThisCode, true);
			}
			boyfriend.playAnim(daFuckIsThisCode, true);

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

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

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					var daFuckIsThisCode:String = '';

					switch (note.noteData)
					{
						case 0:
							daFuckIsThisCode = 'singLEFT';
						case 1:
							daFuckIsThisCode = 'singDOWN';
						case 2:
							daFuckIsThisCode = 'singUP';
						case 3:
							daFuckIsThisCode = 'singRIGHT';
					}
		
					if (SONG.song.toLowerCase() == 'incident')
					{
						bluefriend.playAnim(daFuckIsThisCode, true);
						bfG.playAnim(daFuckIsThisCode, true);
					}
					if (SONG.song.toLowerCase() == 'rage')
					{
						bfG.playAnim(daFuckIsThisCode, true);
					}
					boyfriend.playAnim(daFuckIsThisCode, true);
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
	function redchangebg():Void
	{
		bt2.alpha = 0.5;
		bt3.alpha = 0;
	}
	function bluechangebg():Void
	{
		bt2.alpha = 0;
		bt3.alpha = 0.5;
	}
	function redchangebg2():Void
	{
		bt4.alpha = 0.5;
		bt5.alpha = 0;
	}
	function bluechangebg2():Void
	{
		bt4.alpha = 0;
		bt5.alpha = 0.5;
	}
	function tradebg():Void
	{
		bbg.alpha = 0;
		bbg2.alpha = 1;
	}
	function removebg():Void
	{
		bbg.alpha = 1;
		bbg2.alpha = 0;
	}
	function tradi():Void
	{
		if (thing < 77)
		{
			
			trollrager3.alpha = 1;
			trollrager2.alpha = 0;
		}
		gfG.alpha = 1;
		gf.alpha = 0;
		sadgli.alpha = 1;
		soe.alpha = 0;
		bfG.alpha = 1;
		boyfriend.alpha = 0;
	}
	function removetradi():Void
	{
		gfG.alpha = 0;
		gf.alpha = 1;
		sadgli.alpha = 0;
		soe.alpha = 1;
		bfG.alpha = 0;
		boyfriend.alpha = 1;
		if (thing < 77)
		{
			
			trollrager3.alpha = 0;
			trollrager2.alpha = 1;
		}
	}
	function glitch():Void
	{
		if (boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			shakeCam = false;
		}
		else
		{
			shakeCam = true;
		}
		bgo.alpha = 1;
		back1.alpha = 0;
		bundaTrollge2.alpha = 0;
		bundaTrollge4.alpha = 1;
		
		
		gf.alpha = 0;
		gfG.alpha = 1;
		boyfriend.alpha = 0;
		bfG.alpha = 1;
		gfG.playAnim('scared');
		glitchs.alpha = 0.1;
		
	}
	function removeglitch():Void
	{
		glitchs.alpha = 0.02;
		if (su<99)
		{
			shakeCam = false;
			bgo.alpha = 0;
			back1.alpha = 1;
			bundaTrollge2.alpha = 1;
			bundaTrollge4.alpha = 0;
			gfG.alpha = 0;
			gf.alpha = 1;
			bfG.alpha = 0;
			boyfriend.alpha = 1;
		}
	}
	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end


		//uhuhuhuhuhuhuhhuhuhuhuhhuhuhuhuhuhuughhhu
		if (SONG.song == 'Sadness')
		{
			switch (curStep)
			{
				case 0:
					shakeCam3 = false;
					shakeCam = false;
				case 1:
					sura.alpha = 0;
					healthBarBG.alpha = 1;
					healthBar.alpha = 1;
					iconP1.alpha = 1;
					iconP2.alpha = 1;
					scoreTxt.alpha = 0;
				case 560:
					troll2.alpha = 1;
					dad.alpha = 0;
				case 1088:
					shakeCam3 = false;
			}
			if (curStep > 1039 && curStep < 1088 )
			{
				shakeCam3 = true;
			}
			if (curStep > 1119 )
			{
				troll2.alpha = 0;
				troll3.alpha = 1;
				new FlxTimer().start(0.1, function(tmr32:FlxTimer)
				{
					soe.alpha = 0;
					sadgli.alpha = 1;
					if (sadgli.alpha > 0)
					{
						new FlxTimer().start(1, function(tmr33:FlxTimer)
						{
							sadgli.alpha = 0;
							soe.alpha = 1;
							if (soe.alpha > 0)
							{
								tmr32.reset(0.1);
							}
						});
					}
				});
				add(sadnessTrail);
				shakeCam3 = false;
				shakeCam = true;
			}
		}
		if (SONG.song.toLowerCase() == 'rage')
		{
			switch (curStep)
			{
				case 0:
					sur.alpha = 1;
					isTrollge2 = false;
				case 1:
					sura.alpha = 0;
					gfG.alpha = 0;
					bfG.alpha = 0;
					healthBarBG.alpha = 1;
					healthBar.alpha = 1;
					iconP1.alpha = 1;
					iconP2.alpha = 1;
					scoreTxt.alpha = 0;
				case 256:
					shakeHUD = true;
					dad.alpha = 0;
					trollrager.alpha = 1;
				case 512:
					gf.alpha = 0;
					gfG.alpha = 1;
					boyfriend.alpha = 0;
					bfG.alpha = 1;
					
					sura2.alpha = 0.95;
					defaultCamZoom = 1.4;
				case 640:
					gfG.alpha = 0;
					gf.alpha = 1;
					noise.alpha = 0.01;
					
					bfG.alpha = 0;
					boyfriend.alpha = 1;
					shakeHUD = false;
					shakeHUD2 = true;
					sura2.alpha = 0;
					defaultCamZoom = 1;
				case 768:
					shakeHUD2 = false;
					shakeHUD3 = true;
					trollrager.alpha = 0;
					trollrager2.alpha = 1;
				case 864:
					glitchs.alpha = 0.1;
					isTrollge2 = true;
				case 1000:
					gfG.alpha = 1;
					gf.alpha = 0;
					thing = 77;
					boyfriend.alpha = 0;
					bfG.alpha = 1;
					sadgli.alpha = 1;
					soe.alpha = 0;
					isTrollge2 = false;
					trollrager2.alpha = 0;
					trollrager3.alpha = 1;
				case 1056:
					trollrager3.alpha = 0;
					rageAnim1.alpha = 1;
					rageAnim1.animation.play('RageFinal1');
					iconP1.alpha = 0;
					iconP2.alpha = 0;
					camHUD.alpha = 0.5;
				case 1130:
					rageAnim1.alpha = 0;
					rageAnim2.alpha = 1;
					rageAnim2.animation.play('RageFinal2');
				case 1167:
					defaultCamZoom = 2;
				case 1184:
					ttweenCamIn();
					rageAnim3.alpha = 0;
					faces.alpha = 0.3;
				case 1190:
					faces.alpha = 0.75;
				case 1196:
					faces.alpha = 1;
					faces.scale.set(1.5, 1.5);
				case 1200:
					endSong();
			}
			if (curStep == 1168 && curStep < 1184)
			{
				shakeHUD3 = false;
				shakeCam = true;
				
				camFollow.y = 0;
				camFollow.x = 0;
				camHUD.alpha = 0;
				
				rageAnim2.alpha = 0;
				rageAnim3.alpha = 1;
				rageAnim3.alpha = 1;
				rageAnim3.animation.play('RageFinal3');
				rageAnim3.antialiasing = true;
				sur.alpha = 0;
				sura2.alpha = 1;
				ttweenCamIn();
			}
		}
		if (SONG.song == 'Incident')
		{
			switch (curStep)
			{
				case 0:
					sura.alpha = 1;
				case 1:
					bfG.alpha = 0;
					sura2.alpha = 0.95;
					defaultCamZoom = 1.4;
					bluefriend.alpha = 0;
					boyfriend.alpha = 1;
					su = 0;
					bbg.alpha = 0;
					bgo.alpha = 0;
					gf2.alpha = 0;
					healthBarBG.alpha = 1;
					healthBar.alpha = 1;
					iconP1.alpha = 1;
					iconP2.alpha = 1;
					
					bundaTrollge2.alpha = 0;

					scoreTxt.alpha = 0;
					
					new FlxTimer().start(0.3, function(tmr2:FlxTimer)
					{
						sura.alpha -= 0.15;
						if (sura.alpha > 0)
						{
							tmr2.reset(0.1);
						}
					});
				case 128:
					shakeHUD = true;
					sura2.alpha = 0;
					sura.alpha = 0;
					ttweenCamIn();
					defaultCamZoom = 1.6;
				case 144:
					defaultCamZoom = 1;
				case 384:
					bgt.alpha = 0.8;
					defaultCamZoom = 1.2;
				case 512:
					shakeHUD = false;
					shakeHUD2 = true;
					su+=1;
					bundaTrollge2.alpha = 1;
					dad.alpha = 0;
					bgt.alpha = 0;
					back1.alpha = 1;
					ttweenCamIn2();
				case 530:
					su+=15;
				case 550:
					su+=10;
				case 640:
					back1.alpha = 0.8;
					defaultCamZoom = 1.2;
				case 672:
					back1.alpha = 1;
					defaultCamZoom = 1;
					glitchs.alpha = 0.01;
				case 800:
					su+= 15;
					glitchs.alpha = 0.02;
				case 960:
					defaultCamZoom = 1.2;
					glitchs.alpha = 0.02;
				case 1152:
										//lembrar de fazer com que aqui o bagui da barra vá diminuindo aos poucos devido
					//a influencia do trollge, e o boy tem que cantar pra barra voltar a subir
					su = 0.00001;
					defaultCamZoom = 1.4;
					new FlxTimer().start(0.3, function(tmr3:FlxTimer)
					{
						iconP1.alpha -= 0.1;
						iconP2.alpha -= 0.1;
						sura2.alpha += 0.1;
						camHUD.alpha -= 0.05;
						if (sura2.alpha < 0.9)
						{
							tmr3.reset(0.1);
						}
					});
				case 1280:
					iconP1.alpha = 1;
					iconP2.alpha = 1;
					camHUD.alpha = 1;
					ttweenCamIn2();
					defaultCamZoom = 1.5;
					shakeHUD2 = false;
					shakeHUD3 = true;
				case 1408:
					shakeHUD3 = false;
					shakeHUD2 = true;
					back1.alpha = 0.5;
					defaultCamZoom = 1;
					sura2.alpha = 0;
					glitchs.alpha = 0.04;
					bt.alpha = 0.3;
					bundaTrollge2.alpha = 0.9;
					bundaTrollge3.alpha = 0.1;
					su = 0;
					boyfriend.alpha = 0;
					gf.alpha = 0;
					gfG.alpha = 1;
					bfG.alpha = 1;
					bbg.alpha = 0.05;
				case 1664:
					gfG.alpha = 0.5;
					sura2.alpha = 0.3;
					defaultCamZoom = 1.2;
					bfG.alpha = 0.5;
				case 1792:
					bbg.alpha = 0.2;
					ttweenCamIn2();
					sura2.alpha = 0;
					bt.alpha = 1;
					
					glitchs.alpha = 0.08;
					bundaTrollge2.alpha = 0;
					bundaTrollge3.alpha = 0;
					bundaTrollgeFinal.alpha = 1;
					gfG.alpha = 0.6;
					gf2.alpha = 0.4;
					bfG.alpha = 0.6;
					bluefriend.alpha = 0.4;
					back1.alpha = 0.1;
				case 1920:
					bbg.alpha = 0.3;
					gfG.alpha = 0.4;
					gf2.alpha = 0.6;
					bluefriend.alpha = 0.6;
					bfG.alpha = 0.4;
					back1.alpha = 0;
					glitchs.alpha = 0.1;
				case 2176:
					shakeHUD3 = false;
					shakeCam = true;
					//trolge yellow eyes shake 
					glitchs.alpha = 0.2;
					bundaTrollge3.alpha = 0.1;
					bundaTrollge2.alpha = 0.1;
				case 2432:
					boyfriend.alpha = 1;
					bluefriend.alpha = 0;
					new FlxTimer().start(0.3, function(tmr4:FlxTimer)
					{
						gfG.alpha = 0;
						gf2.alpha = 0;
						iconP2.alpha -= 0.1;
						iconP1.alpha -= 0.1;
						
						bt4.alpha = 0;
						bt5.alpha = 0;
						bt.alpha -= 0.1;
						
						gf.alpha += 0.1;
						bbg.alpha -= 0.1;
						
						gf2.alpha -= 0.1;
						bluefriend.alpha -= 0.1;
						
						bbg.alpha -= 0.1;
						glitchs.alpha -= 0.1;
						camHUD.alpha -= 0.05;
						sura2.alpha += 0.1;
						if (sura2.alpha < 1)
						{
							tmr4.reset(0.1);
						}
					});
					shakeCam = false;
					defaultCamZoom = 1.4;
				case 2496:
					new FlxTimer().start(0.3, function(tmr3:FlxTimer)
					{
						bgt.alpha += 0.05;
						sura2.alpha -= 0.1;
						
						if (sura2.alpha > 0)
						{
							tmr3.reset(0.1);
						}
					});
					bfG.alpha = 0;
					sur.alpha = 1;
					bundaTrollgeFinal.alpha = 0;
					bundaTrollge3.alpha = 0;
					bundaTrollge2.alpha = 0;
					trollge_sad.alpha = 1;
				case 2592:
					defaultCamZoom = 1.6;
				case 2624:
					defaultCamZoom = 1.2;
			}
				if (curStep > 1279 && curStep < 1408)
				{
					health -= 0.02;
				}
		}
		if (SONG.song == 'Redemption')
		{
			switch (curStep)
			{
				case 2 | 4 | 6 | 8 | 10 | 12 | 14 | 16 | 20 | 22 | 24 | 26 | 28 | 30 | 32 | 34 | 36 | 44 | 47 | 50 | 53 | 56 | 59 | 62 | 65 | 68 | 73 | 76 | 79 | 82 | 99 | 103 | 106 | 109 | 112 | 115 | 117:
					thefinalt.playAnim("speak", true);
				case 38 | 85 | 120:
					thefinalt.playAnim("idle", false);
				case 92:
					boyfriend.playAnim('singRIGHT');
					dad.x += 900;
					//camHUD.alpha = 1;
					defaultCamZoom = 1;
				case 128:
					camHUD.alpha = 1;
				case 256 | 288 | 320 | 336 | 352:
					soe.alpha -= 0.1;
				case 360 | 368 | 384:
					sur.alpha -= 0.3;
					soe.alpha -= 0.1;
				case 640:
					new FlxTimer().start(0.3, function(tmr3:FlxTimer)
					{
						
						thefinalt.alpha -= 0.05;
						if (thefinalt.alpha > 0)
						{
							tmr3.reset(0.1);
						}
					});
				case 672:
					FlxG.camera.flash(0xFFEBEBEB, 3);
					bfanim.alpha = 1;
					gfanim.alpha = 1;
					boyfriend.alpha = 0;
					gf.alpha = 0;
				case 674:
					soe.alpha = 1;
					defaultCamZoom = 1.2;
					gfanim.animation.play('Symbol 1', false);
					bfanim.animation.play('BF idle dance', false);
				case 700:
					new FlxTimer().start(0.3, function(tmr3:FlxTimer)
					{
						whito2.alpha += 0.1;
						
						if (whito2.alpha < 1)
						{
							tmr3.reset(0.05);
						}
					});
				case 750:
					FlxG.sound.play(Paths.sound('thank'));
					sura.alpha = 1;
				case 790:
					new FlxTimer().start(0.3, function(tmr3:FlxTimer)
					{
						whito2.alpha -= 0.1;
						
						if (whito2.alpha > 0)
						{
							tmr3.reset(0.1);
						}
					});
			}
			if (curStep == 99)
			{
				dad.x -= 900;
				new FlxTimer().start(0.3, function(tmr1:FlxTimer)
				{
					camHUD.alpha += 0.1;
					
					if (camHUD.alpha < 1)
					{
						tmr1.reset(0.1);
					}
				});
			}

			if (!FlxG.save.data.photosensitive)
			{
				switch (curStep)
				{
					case 256 | 288 | 320 | 336 | 352 | 360 | 368 | 384:
						FlxG.camera.flash(0xFFEBEBEB, 1);
				}
			}

			if (curStep > 638)
			{
				camHUD.alpha = 0;
				thefinalt.playAnim("smile", true);
			}	

			if (curStep > 100)
			{
				health += 10;
			}
		}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var isTroge:Int = 0;
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var isTheTroge:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
		}

		if (SONG.song.toLowerCase() == 'sadness')
		{
			if (troll2.animation.curAnim.name.startsWith('sing'))
			{
				if (troll2.animation.finished)
				{
					troll2.dance();
				}

			}
			else	
			{
				troll2.dance();
			}
			if (troll3.animation.curAnim.name.startsWith('sing'))
			{
				if (troll3.animation.finished)
				{
					troll3.dance();
				}

			}
			else	
			{
				troll3.dance();
			}
		}
		if (SONG.song.toLowerCase() == 'rage' )
		{
			if (trollrager.animation.curAnim.name.startsWith('sing'))
			{
				if (trollrager.animation.finished)
				{
					trollrager.dance();
				}
	
			}
			else
			{
				trollrager.dance();
			}

			if (trollrager2.animation.curAnim.name.startsWith('sing'))
			{
				if (trollrager2.animation.finished)
				{
					trollrager2.dance();
				}
		
			}
			else
			{
				trollrager2.dance();
			}
			if (trollrager3.animation.curAnim.name.startsWith('sing'))
			{
				if (trollrager3.animation.finished)
				{
					trollrager3.dance();
				}
		
			}
			else
			{
				trollrager3.dance();
			}
		}
		if (dad.animation.curAnim.name.startsWith('sing'))
		{
			if (dad.animation.finished)
			{
				dad.dance();
			}

		}
		else
		{
			dad.dance();
		}
			//pexe stan
			
		if (SONG.song.toLowerCase() == 'incident')
		{
			//do some stuff with this later for optimization
			if (bundaTrollge.animation.curAnim.name.startsWith('sing'))
			{
				if (bundaTrollge.animation.finished)
				{
					bundaTrollge.dance();
				}

			}
			else
			{
				bundaTrollge.dance();
			}

			if (lasttrollge.animation.curAnim.name.startsWith('idle'))
			{
				if (lasttrollge.animation.finished)
					{
						lasttrollge.dance();
					}
				else
				{
					lasttrollge.dance();
				}
			}

			if (trollge_sad.animation.curAnim.name.startsWith('idle'))
			{
				if (trollge_sad.animation.finished)
					{
						trollge_sad.dance();
					}
				else
				{
					trollge_sad.dance();
				}
			}

			if (bundaTrollge2.animation.curAnim.name.startsWith('sing'))
			{
				if (bundaTrollge2.animation.finished)
				{
						bundaTrollge2.dance();
				}

			}
			else
			{
				bundaTrollge2.dance();
			}

			if (bundaTrollgeFinal.animation.curAnim.name.startsWith('sing'))
			{
				if (bundaTrollgeFinal.alpha == 1)
					{
						shakeCam2 = true;
					}
				if (bundaTrollgeFinal.animation.finished)
				{
					bundaTrollgeFinal.dance();
				}
	
			}
			else
			{
				shakeCam2 = false;
				bundaTrollgeFinal.dance();
			}

			if (bundaTrollge3.animation.curAnim.name.startsWith('sing'))
			{
				if (bundaTrollge3.alpha == 1)
					{
						shakeCam2 = true;
					}
				if (bundaTrollge3.animation.finished)
				{
					bundaTrollge3.dance();
				}
		
			}
			else
			{
				shakeCam2 = false;
				bundaTrollge3.dance();
			}

			if (bundaTrollge4.animation.curAnim.name.startsWith('sing'))
			{
				if (bundaTrollge4.animation.finished)
				{
					bundaTrollge4.dance();
				}
			
			}
			else
			{
				bundaTrollge4.dance();
			}
		}


		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
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

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
			if (SONG.song.toLowerCase() == 'incident') { gf2.dance();  gfG.dance();}
			if (SONG.song.toLowerCase() == 'rage') { gfG.dance(); }
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			
			boyfriend.playAnim('idle');
			
		}
		if (SONG.song.toLowerCase() == 'rage' || SONG.song.toLowerCase() == 'incident' )
		{
			if (!bfG.animation.curAnim.name.startsWith("sing"))
				{
					bfG.playAnim('idle');	
				}
		}
		if (SONG.song.toLowerCase() == 'incident' )
			{
				if (!bluefriend.animation.curAnim.name.startsWith("sing"))
					{
						bluefriend.playAnim('idle');	
					}
			}
		
		if (!dad.animation.curAnim.name.startsWith("sing"))
		{
			dad.dance();
		}
		if (su > 0)
		{
			if (isTrollge && FlxG.random.bool(su) && curBeat > isTroge + isTheTroge )
			{
				if(su < 99)
				glitch();
			}
			else
			{
				removeglitch();
			}
		}
		
		if(isTrollge2 == true)
		{
			if (FlxG.random.bool(thing) == true )
			{
				tradi();
			}
			else
			{
				removetradi();
			}
		}

		if (trollvar == true )
		{
			if (isTrollge && FlxG.random.bool(50) && curBeat > isTroge + isTheTroge)
			{
				
				tradebg();
			}
			else
			{
				
				removebg();
			}
		}

		if (!FlxG.save.data.photosensitive)
		{
			if (curStep > 1919 && curStep < 2050)
			{
				if (isTrollge && FlxG.random.bool(50) && curBeat > isTroge + isTheTroge)
				{
					bluechangebg();
				}
				else
				{
					redchangebg();
				}
			}
	
			if (curStep > 2176 && curStep < 2432 )
			{
				bt2.alpha = 0;
				bt3.alpha = 0;
				if (isTrollge && FlxG.random.bool(50) && curBeat > isTroge + isTheTroge)
				{
					bluechangebg2();
				}
				else
				{
					redchangebg2();
				}
			}
		}

	}
}
