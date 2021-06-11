package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;

class Credits extends MusicBeatState
{
	var testText:FlxText;

	var diffCredits:Array<String> = 
	[
		"Special thanks!",
		"Luigipo (Le black hole)",
		"IdiotWithAGun (Le Bone)",
		"Kyoto (Le Rez guy)",
		"Banbuds (CLOWN KILLS YOU)",
		"Soulegal ( lol )",
		"BrightFyre (Rewrote most of the code :pain:)",
		"And you!",
		"You...",
		"I have something to show you",
		"Press Enter to continue"
	];

	var pressEnter:Bool = false;

	override function create()
	{
		testText = new FlxText(860, 500, 0, diffCredits[0], 12);
		testText.setFormat("VCR OSD Mono", 40);	
		testText.alpha = 1;
		testText.screenCenter();
		add(testText);

		//fuck you malicious i had to rewrite this entire thing >:((((
		//-brightfyre

		new FlxTimer().start(3, function(tmr1:FlxTimer)
		{	
			testText.alpha -= 0.05;
			if (testText.alpha > 0)
			{
				tmr1.reset(0.1);
			}
			else
			{
				diffCredits.remove(diffCredits[0]);
				testText.text = diffCredits[0];
				new FlxTimer().start(2, function(tmr2:FlxTimer)
				{
					testText.x = FlxG.width / 2 - testText.width / 2;
					testText.alpha += 0.05;
					if (testText.alpha < 1)
					{
						tmr2.reset(0.1);
					}
					else
					{
						loopOtherStuff();
					}
				});	
			}
		});
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT && pressEnter)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.switchState(new TCF());
		}
		super.update(elapsed);

	}

	function loopOtherStuff()
	{
		new FlxTimer().start(1, function(tmr3:FlxTimer)
		{	
			testText.alpha -= 0.05;
			if (testText.alpha > 0)
			{
				tmr3.reset(0.1);
			}
			else
			{
				diffCredits.remove(diffCredits[0]);
				testText.text = diffCredits[0];
				new FlxTimer().start(2, function(tmr4:FlxTimer)
				{	
					testText.x = FlxG.width / 2 - testText.width / 2;
					testText.alpha += 0.05;
					if (testText.alpha < 1)
					{
						tmr4.reset(0.1);
					}
					else
					{
						if (testText.text != "Press Enter to continue")
						{
							loopOtherStuff();
						}
						else
						{
							pressEnter = true;
						}
					}
				});
			}
		});
	}
}
