package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;

class GameOverSubstate extends MusicBeatSubstate
{
	//
	var beep:FlxSound;
	var sasu:Bool;
	var bf:Boyfriend;


	var stageSuffix:String = "";
	var testText:FlxText;
	var testText2:FlxText;
	var testText3:FlxText;
	var testText4:FlxText;
	var testText5:FlxText;
	var testText6:FlxText;
	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}

		
		
		
		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);
		bf.alpha = 0;


		
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('idle');
	}

	override public function create()
	{
		beep = new FlxSound().loadEmbedded(Paths.music('void'));
		FlxG.sound.playMusic(Paths.music('void'), 0);
		
		beep.play();
		testText = new FlxText(860, 500, 0, "Why?", 12);
		testText.setFormat("VCR OSD Mono", 40);	
		testText.alpha = 0;
		testText.screenCenter();
		add(testText);

		testText2 = new FlxText(860, 500, 0, "What have I done?", 12);
		testText2.setFormat("VCR OSD Mono", 40);
		testText2.screenCenter();
		testText2.alpha = 0;	
		add(testText2);

		testText3 = new FlxText(820, 500, 0, "This is not my fault", 12);
		testText3.setFormat("VCR OSD Mono", 40);	
		testText3.alpha = 0;
		testText3.screenCenter();
		add(testText3);

		testText4 = new FlxText(820, 500, 0, "Derp...", 12);
		testText4.setFormat("VCR OSD Mono", 40);
		testText4.alpha = 0;
		testText4.screenCenter();	
		add(testText4);

		testText5 = new FlxText(820, 500, 0, "Forgive me", 12);
		testText5.setFormat("VCR OSD Mono", 40);	
		testText5.alpha = 0;
		testText5.screenCenter();
		add(testText5);

		testText6 = new FlxText(710, 500, 0, "Wake up, you have a troll to do", 12);
		testText6.setFormat("VCR OSD Mono", 40);
		testText6.color = 0xFFE5E1A2;
		testText6.alpha = 0;
		testText6.screenCenter();
		add(testText6);

		new FlxTimer().start(6, function(tmr:FlxTimer)
		{	
			testText.alpha += 0.05;
			FlxG.sound.playMusic(Paths.music('void'));

			if (testText.alpha < 1)
			{
				tmr.reset(0.1);
			}
			if (testText.alpha == 1)
			{
				new FlxTimer().start(3, function(tmr2:FlxTimer)
					{	
							testText.alpha -= 0.05;
						
							if (testText.alpha > 0)
							{
								tmr2.reset(0.1);
							}
							if (testText.alpha == 0)
							{
								new FlxTimer().start(3, function(tmr3:FlxTimer)
								{	
									testText2.alpha += 0.05;
									if (testText2.alpha < 1)
										{
											tmr3.reset(0.1);
										}
										if (testText2.alpha == 1)
										{
											new FlxTimer().start(3, function(tmr4:FlxTimer)
												{	
														testText2.alpha -= 0.05;
													
														if (testText2.alpha > 0)
														{
															tmr4.reset(0.1);
														}
														if (testText2.alpha == 0)
														{
															new FlxTimer().start(3, function(tmr5:FlxTimer)
															{	
																testText3.alpha += 0.05;
																if (testText3.alpha < 1)
																	{
																		tmr5.reset(0.1);
																	}
																	if (testText3.alpha == 1)
																	{
																		new FlxTimer().start(3, function(tmr6:FlxTimer)
																			{	
																					testText3.alpha -= 0.05;
																				
																					if (testText3.alpha > 0)
																					{
																						tmr6.reset(0.1);
																					}
																					if (testText3.alpha == 0)
																					{
																						new FlxTimer().start(3, function(tmr7:FlxTimer)
																						{	
																							testText4.alpha += 0.05;
																							if (testText4.alpha < 1)
																								{
																									tmr7.reset(0.1);
																								}
																								if (testText4.alpha == 1)
																								{
																									new FlxTimer().start(3, function(tmr8:FlxTimer)
																										{	
																												testText4.alpha -= 0.05;
																											
																												if (testText4.alpha > 0)
																												{
																													tmr8.reset(0.1);
																												}
																												if (testText4.alpha == 0)
																												{
																													new FlxTimer().start(3, function(tmr9:FlxTimer)
																													{	
																														testText5.alpha += 0.05;
																														if (testText5.alpha < 1)
																															{
																																tmr9.reset(0.1);
																															}
																															if (testText5.alpha == 1)
																															{
																																new FlxTimer().start(3, function(tmr10:FlxTimer)
																																	{	
																																			testText5.alpha -= 0.05;
																																		
																																			if (testText5.alpha > 0)
																																			{
																																				tmr10.reset(0.1);
																																			}
																																			if (testText5.alpha == 0)
																																			{
																																				new FlxTimer().start(3, function(tmr11:FlxTimer)
																																				{	
																																					testText6.alpha += 0.05;
																																					if (testText6.alpha < 1)
																																						{
																																							tmr11.reset(0.1);
																																						}
																																						
																																				});
																																			}
																																			
																																		});
																															}
																																
																																
																													});
																												}
																												
																											});
																								}
																									
																									
																						});
																					}
																					
																				});
																	}
																		
																		
															});
														}
														
													});
										}
											
											
								});
							}
							
						});
			}
		});
		
		
		
	}
	override function update(elapsed:Float)
	{
		
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			beep.stop();
			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'idle' && bf.animation.curAnim.curFrame == 1 )
		{
		
		}

		if (bf.animation.curAnim.name == 'idle' )
		{
			
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			beep.stop();
			isEnding = true;
			
			
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}

