package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;

class AboutThisShit extends MusicBeatState
{
	public static var leftState:Bool = false;
	var bg:FlxSprite = new FlxSprite(0, -30);
	
	var bg2:FlxSprite = new FlxSprite(0, -30);
	var ce:Bool = false;

	override function create()
	{
		super.create();

		bg.loadGraphic(Paths.image('Credits', 'shared'));
		bg.scale.set(0.65, 0.65);
		bg.antialiasing = true;
		bg.screenCenter();
		add(bg);
	}

	override function update(elapsed:Float)
	{


		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);

	}
}
