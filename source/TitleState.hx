package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if desktop
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	public static var http:Bool = true;
	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var kadeDev:FlxSprite;

	var loadingImage:FlxSprite;
	var loadingDone:FlxSprite;


	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	public static var loadTxt:FlxText;

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		if (FlxG.save.data.photosensitive == null)
		{
			FlxG.save.data.photosensitive = false;
		}


		// DEBUG BULLSHIT

		super.create();

		loadingImage = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
			-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		loadingDone = new FlxSprite(0, 0).loadGraphic(Paths.image('dark', 'preload'));
		loadingImage.updateHitbox();
		loadingImage.screenCenter();
		loadingDone.updateHitbox();
		loadingDone.screenCenter();
		loadingImage.alpha = 0;
		loadingDone.alpha = 0;
		add(loadingImage);
		add(loadingDone);

		loadTxt = new FlxText(0, 0, 0, "initialized game", 30);
		loadTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		loadTxt.screenCenter(X);
		loadTxt.alignment = RIGHT;
		loadTxt.y = 600;
		loadTxt.x = 0;
		add(loadTxt);

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		CachedFrames.loadEverything();
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var gfDance1:FlxSprite;
	var gfDance2:FlxSprite;
	var gfDance3:FlxSprite;
	var gfDance4:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(-100, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(300, 300);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		

		gfDance2 = new FlxSprite(0, 0);
		gfDance2.loadGraphic(Paths.image('A'));
		gfDance2.alpha = 0;

		gfDance3 = new FlxSprite(0, 0);
		gfDance3.loadGraphic(Paths.image('B'));
		gfDance3.alpha = 0;

		gfDance4 = new FlxSprite(0, 0);
		gfDance4.loadGraphic(Paths.image('C'));
		gfDance4.alpha = 0;

		gfDance1 = new FlxSprite(300, 300);
		gfDance1.frames = Paths.getSparrowAtlas('gfDanceTitle1');
		gfDance1.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance1.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance1.antialiasing = true;
		
		add(logoBl);
		add(gfDance);
		add(gfDance1);
		add(gfDance2);
		add(gfDance3);
		add(gfDance4);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		kadeDev = new FlxSprite(0, FlxG.height * 0.4).loadGraphic(Paths.image('kADE_logo'));
		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		add(kadeDev);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		kadeDev.setGraphicSize(Std.int(kadeDev.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;
		kadeDev.visible = false;
		kadeDev.updateHitbox();
		kadeDev.screenCenter(X);
		kadeDev.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	var once:Bool = false;


	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (!CachedFrames.cachedInstance.loaded)
		{
			loadingImage.alpha = CachedFrames.cachedInstance.progress / 100;
		}
		else if (!once)
		{
			once = true;
			remove(loadTxt);
			FlxG.sound.play(Paths.sound('badnoise1','shared'), 1);
			loadingImage.alpha = 0;
			loadingDone.alpha = 1;
			FlxTween.tween(loadingDone,{alpha: 0}, 1);
			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			});
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;
			

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			
			FlxG.sound.music.stop();
			gfDance.alpha = 0;
			logoBl.alpha = 0;
			blackScreen.alpha = 0;
			titleText.alpha = 0;

			transitioning = true;


			new FlxTimer().start(2, function(tmr:FlxTimer)
			{	gfDance2.alpha = 1;
				FlxG.sound.play(Paths.sound('static'));
				new FlxTimer().start(0.2, function(tma:FlxTimer)
				{	
					gfDance2.alpha = 0;
					gfDance1.scale.set(1.5,1.5);

					new FlxTimer().start(3, function(tm2r:FlxTimer)
						{	FlxG.sound.play(Paths.sound('static'));
							gfDance3.alpha = 1;
							new FlxTimer().start(0.2, function(tmar:FlxTimer)
							{
								
								gfDance3.alpha = 0;
								gfDance1.scale.set(2,2);
								new FlxTimer().start(0.1, function(tm3r:FlxTimer)
								{
									
									gfDance4.alpha = 1;
									new FlxTimer().start(0.1, function(tmawe:FlxTimer)
									{
										gfDance1.alpha = 0;
										gfDance4.alpha = 0;
										new FlxTimer().start(2, function (tweweqaw:FlxTimer)
										{
											FlxG.switchState(new OutdatedSubState());
										});
									});
									
								});
							});
						});
				});

			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 5:
				//TIRA ISSO LOL
				
					createCoolText(['In Partnership', 'with']);
			case 7:
				{
					addMoreText('Newgrounds');
					ngSpr.visible = true;
				}
			// credTextShit.text += '\nNewgrounds';
			case 8:
				ngSpr.visible = false;
				deleteCoolText();
				createCoolText(['Made with']);
				
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				kadeDev.visible = true;
			// credTextShit.visible = true;
			case 11:

			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
				kadeDev.visible = false;
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText('Turn off');
			case 14:
				addMoreText('Photosensitive stuff');
			case 15:
				addMoreText('In settings');

			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(kadeDev);

			
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
