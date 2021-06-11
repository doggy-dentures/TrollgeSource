package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;

class TCF extends MusicBeatState
{
	public static var leftState:Bool = false;
	var case1:FlxSprite = new FlxSprite(0, 0);
	var case2:FlxSprite = new FlxSprite(0, 0);
	var case3:FlxSprite = new FlxSprite(0, 0);
	var case4:FlxSprite = new FlxSprite(0, 0);
	var case5:FlxSprite = new FlxSprite(0, 0);
	var thank:FlxSprite = new FlxSprite(0, 0);
	var lol:FlxSprite = new FlxSprite(0, 0);
	

	override function create()
	{
		FlxG.sound.playMusic(Paths.music('menu'));
		super.create();


		lol.frames = Paths.getSparrowAtlas('frames/sheeto3');
		lol.animation.addByPrefix('n', 'n', 24);
		lol.animation.play('n');
		lol.scale.set(4, 4);
		lol.updateHitbox();
		lol.screenCenter();
		add(lol);

		case1.loadGraphic(Paths.image('Cases/Case 0001'));
		case1.antialiasing = true;
		case1.screenCenter();
		add(case1);

		case2.loadGraphic(Paths.image('Cases/Case 0007'));
		case2.antialiasing = true;
		case2.alpha = 0;
		case2.screenCenter();
		add(case2);

		case3.loadGraphic(Paths.image('Cases/Case 0023'));
		case3.antialiasing = true;
		case3.alpha = 0;
		case3.screenCenter();
		add(case3);

		case4.loadGraphic(Paths.image('Cases/Case 0076'));
		case4.antialiasing = true;
		case4.alpha = 0;
		case4.screenCenter();
		add(case4);

		case5.loadGraphic(Paths.image('Cases/Case 0000'));
		case5.antialiasing = true;
		case5.alpha = 0;
		case5.screenCenter();
		add(case5);

		thank.loadGraphic(Paths.image('Cases/thank'));
		thank.antialiasing = true;
		thank.alpha = 0;
		thank.screenCenter();
		add(thank);
		



	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);


		if (controls.ACCEPT)
		{
			if(case1.alpha == 1)
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					case1.alpha -= 0.1;
					if(case1.alpha > 0)
					{
						tmr.reset(0.1);
					}
					if (case1.alpha == 0)
					{
						new FlxTimer().start(0.1, function(tmr2:FlxTimer)
							{
								case2.alpha += 0.1;
								if(case2.alpha < 1)
								{
									tmr2.reset(0.1);
								}
							});
					}
				});
			if(case2.alpha == 1)
			new FlxTimer().start(0.1, function(tm2r:FlxTimer)
				{
					case2.alpha -= 0.1;
					if(case2.alpha > 0)
					{
						tm2r.reset(0.1);
					}
					if (case2.alpha == 0)
					{
						new FlxTimer().start(0.1, function(tm2r2:FlxTimer)
							{
								case3.alpha += 0.1;
								if(case3.alpha < 1)
								{
									tm2r2.reset(0.1);
								}
							});
					}
				});
			if(case3.alpha == 1 )
			new FlxTimer().start(0.1, function(t2m2r:FlxTimer)
				{
					case3.alpha -= 0.1;
					if(case3.alpha > 0)
					{
						t2m2r.reset(0.1);
					}
					if (case3.alpha == 0)
					{
						new FlxTimer().start(0.1, function(t2m2r223:FlxTimer)
							{
								case4.alpha += 0.1;
								if(case4.alpha < 1)
								{
									t2m2r223.reset(0.1);
								}
							});
					}
				});
			if(case4.alpha == 1 )
			new FlxTimer().start(0.1, function(t2m2r2:FlxTimer)
				{
					case4.alpha -= 0.1;
					if(case4.alpha > 0)
					{
						t2m2r2.reset(0.1);
					}
					if (case4.alpha == 0)
					{
						new FlxTimer().start(0.1, function(t2m2r22:FlxTimer)
							{
								case5.alpha += 0.1;
								if(case5.alpha < 1)
								{
									t2m2r22.reset(0.1);
								}
							});
					}
				});
			if(case5.alpha == 1 )
			{
				thank.alpha = 1;
				lol.alpha = 0;
				case5.alpha = 0;
			}
		}

	}
}
