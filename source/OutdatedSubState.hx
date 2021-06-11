package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var bg:FlxSprite = new FlxSprite(0, -30);
	
	var bg2:FlxSprite = new FlxSprite(0, -30);
	var ce:Bool = false;

	override function create()
	{
		FlxG.sound.playMusic(Paths.music('menu'), 0);
		

		FlxG.sound.music.fadeIn(4, 0, 0.7);

		super.create();

		bg.loadGraphic(Paths.image('system_cases', 'shared'));
		bg.alpha = 1;
		add(bg);

		bg2.loadGraphic(Paths.image('system_cases2', 'shared'));
		bg2.alpha = 0;
		add(bg2);
	}

	override function update(elapsed:Float)
	{
		new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				new FlxTimer().start(0.1, function(swagTimer:FlxTimer)
					{
						bg2.alpha += 0.1; //timer
						if (bg2.alpha < 1)
							swagTimer.reset();
					});
			});



		if (controls.ACCEPT)
		{
			bg2.alpha = 1;
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);

	}
}
