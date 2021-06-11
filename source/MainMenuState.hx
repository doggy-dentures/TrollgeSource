package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.util.FlxTimer;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'options', 'donate'];
	#else
	var optionShit:Array<String> = ['story mode', 'options', 'donate'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;
	var bg0:FlxSprite = new FlxSprite(-80);
	var bg:FlxSprite = new FlxSprite(-80);
	var bg2:FlxSprite = new FlxSprite(-80);
	var bg3:FlxSprite = new FlxSprite(-80);
	var caso:Bool = false;
	

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "   ";

	var magenta:FlxSprite;
	//var camFollow:FlxObject;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

	

		persistentUpdate = persistentDraw = true;


		
		bg.frames = Paths.getSparrowAtlas('frames/sheeto');
		bg.animation.addByPrefix('n', 'n', 24);
		bg.animation.play('n');
		bg.scale.set(4, 4);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		
		bg0.frames = Paths.getSparrowAtlas('frames/sheeto2');
		bg0.animation.addByPrefix('n', 'n', 24);
		bg0.animation.play('n');
		bg0.scale.set(4, 4);
		bg0.alpha = 0;
		bg0.updateHitbox();
		bg0.screenCenter();
		add(bg0);

		bg2.loadGraphic(Paths.image('frames/brah'));
		bg2.alpha = 0.3;
		bg2.scale.set(1.5, 1.5);
		bg2.updateHitbox();
		bg2.screenCenter();
		add(bg2);

		bg3.loadGraphic(Paths.image('frames/brah2'));
		bg3.alpha = 0;
		bg3.scale.set(1.5, 1.5);
		bg3.updateHitbox();
		bg3.screenCenter();
		add(bg3);

		//camFollow = new FlxObject(0, 0, 1, 1);
		//add(camFollow);

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
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 250 + (i * 80)); //i*n = tamanho entre eles
			menuItem.frames = tex;
			menuItem.scale.set(0.75, 0.75);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		//FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	function glitch():Void
	{
		new FlxTimer().start(0.25, function(swagTimer:FlxTimer)
			{
				bg2.alpha -= 0.001; //timer
				if (bg2.alpha > 0)
					swagTimer.reset();
				else
				{
					caso = true;
				}
			});
	}
	function glitch2():Void
		{
			new FlxTimer().start(0.25, function(swagTimer:FlxTimer)
				{
					bg2.alpha += 0.001; //timer
					if (bg2.alpha < 0.3)
						swagTimer.reset();
					else
					{
						caso = false;
					}
				});
		}

	override function update(elapsed:Float)
	{
		

		if(caso == false)
		{	
			glitch();
		}
		if(caso == true)
		{
			glitch2();
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

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

			if (controls.ACCEPT)
			{
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					bg0.alpha = 1;
					bg2.alpha = 0;
					bg3.alpha = 0.2;
					FlxFlicker.flicker(bg0, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
									case 'donate':
										FlxG.switchState(new AboutThisShit());
										
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
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
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
