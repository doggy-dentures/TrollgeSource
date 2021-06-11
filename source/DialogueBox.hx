package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	public static var susa:Int = 0;
	public static var sasa:Int = 0;
	public static var sasa2:Int = 0;
	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;



	public var finishThing:Void->Void;

	var time:Float = 0.08;

	var rage1:FlxSound;
	var rage2:FlxSound;
	var incident1:FlxSound;
	var incident2:FlxSound;
	var incident3:FlxSound;
	var incident4:FlxSound;
	var incident5:FlxSound;
	var incident6:FlxSound;
	var sad1:FlxSound;
	var sad2:FlxSound;
	var sad3:FlxSound;
	var sad4:FlxSound;
	var sad5:FlxSound;
	var sad6:FlxSound;
	var sad7:FlxSound;
	var sad8:FlxSound;
	var sad9:FlxSound;
	var sad10:FlxSound;
	var sad11:FlxSound;
	var sad12:FlxSound;
	var sad13:FlxSound;
	var sad14:FlxSound;
	var sad15:FlxSound;
	var sad16:FlxSound;
	var beep:FlxSound;

	var portraitLeft:FlxSprite;
	var portraitLeft2:FlxSprite;
	var portraitLeft3:FlxSprite;
	var portraitRight:FlxSprite;
	var bs:FlxSprite;
	var bbs:FlxSprite;
	var bs2:FlxSprite;
	var bs3:FlxSprite;
	var bse:FlxSprite;

	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
	
		super();

		var daArray:Array<FlxSound> =
		[
			rage1,
			rage2,
			incident1,
			incident2,
			incident3,
			incident4,
			incident5,
			incident6,
			sad1,
			sad2,
			sad3,
			sad4,
			sad5,
			sad6,
			sad7,
			sad8,
			sad9,
			sad10,
			sad11,
			sad12,
			sad13,
			sad14,
			sad15,
			sad16,
			beep
		];

		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
				bgFade.scrollFactor.set();
				bgFade.alpha = 0;
				add(bgFade);

				new FlxTimer().start(0.83, function(tmr:FlxTimer)
					{
						bgFade.alpha += (1 / 5) * 0.7;
						if (bgFade.alpha > 0.7)
							bgFade.alpha = 0.7;
					}, 5);

			case 'sadness':
				bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFF000000);
				bgFade.scrollFactor.set();
				bgFade.alpha = 1;
				add(bgFade);
			case 'incident':
				bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFF000000);
				bgFade.scrollFactor.set();
				bgFade.alpha = 1;
				add(bgFade);
			case 'rage':
				bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFF000000);
				bgFade.scrollFactor.set();
				bgFade.alpha = 1;
				add(bgFade);
		}
		bs = new FlxSprite(0, 0);
		bbs = new FlxSprite(0, 0);
		bse = new FlxSprite(0,0);
		bs2 = new FlxSprite(0,0);
		bs3 = new FlxSprite(0,0);
		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'sadness':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('cutscenes/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'rage':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('cutscenes/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'incident':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('cutscenes/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
	
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		
		if (PlayState.SONG.song.toLowerCase() == 'sadness')
		{
			portraitLeft = new FlxSprite(156, 168);
			portraitLeft.scale.set(1.5, 1.5);
			portraitLeft.loadGraphic(Paths.image('cutscenes/SadPort'));
			portraitLeft.alpha = 0;
			portraitLeft.antialiasing = true;
			add(portraitLeft);
			portraitLeft.visible = true;
			portraitLeft.alpha = 0;
		}
		if (PlayState.SONG.song.toLowerCase() == 'incident')
		{
			portraitLeft = new FlxSprite(156, 168);
			portraitLeft.scale.set(1.5, 1.5);
			portraitLeft.loadGraphic(Paths.image('cutscenes/SadPort'));
			portraitLeft.alpha = 0;
			portraitLeft.antialiasing = true;
			add(portraitLeft);
			portraitLeft.visible = true;
			portraitLeft.alpha = 0;

			
		}
		if (PlayState.SONG.song.toLowerCase() == 'rage' )
		{
			portraitLeft3 = new FlxSprite(156, 168);
			portraitLeft3.scale.set(1.5, 1.5);
			portraitLeft3.antialiasing = true;
			add(portraitLeft3);
			portraitLeft3.visible = true;
			portraitLeft3.loadGraphic(Paths.image('cutscenes/SadPort0'));

			portraitLeft2 = new FlxSprite(156, 168);
			portraitLeft2.scale.set(1.5, 1.5);
			portraitLeft2.antialiasing = true;
			add(portraitLeft2);
			portraitLeft2.visible = true;
			portraitLeft2.loadGraphic(Paths.image('cutscenes/SadPort3'));
			if(susa == 0 )
				{
					portraitLeft2.alpha = 0;
					portraitLeft3.alpha = 0;
				}

			portraitLeft = new FlxSprite(156, 168);
			portraitLeft.scale.set(1.5, 1.5);
			portraitLeft.antialiasing = true;
			add(portraitLeft);
			portraitLeft.visible = true;
			portraitLeft.loadGraphic(Paths.image('cutscenes/SadPort2'));
			
			



			
		}

		if (PlayState.SONG.song.toLowerCase() == 'sadness')
		{
			portraitRight = new FlxSprite(760, 107);
			portraitRight.loadGraphic(Paths.image('cutscenes/boyfriendPort2'));
			portraitRight.alpha = 0;
			
			portraitRight.antialiasing = true;
			add(portraitRight);
			portraitRight.visible = false;

			bse.frames = Paths.getSparrowAtlas('cutscenes/e');
			bse.animation.addByPrefix('e', 'e', 24);
			bse.animation.play('e');	
			bse.alpha = 0;
			bse.screenCenter(X);
			bse.screenCenter(Y);
			bs.frames = Paths.getSparrowAtlas('cutscenes/cut1');
			bs.animation.addByPrefix('culpado_', 'culpado_', 24);
			bs.animation.play('culpado_');	
			bs.alpha = 0;
			bs.screenCenter(X);
			bs.screenCenter(Y);
			bs2.frames = Paths.getSparrowAtlas('cutscenes/LeBoy1');
			bs2.animation.addByPrefix('o', 'o', 24);
			bs2.animation.play('o');	
			bs2.alpha = 0;
			bs2.screenCenter(X);
			bs2.screenCenter(Y);
			bs3.frames = Paths.getSparrowAtlas('cutscenes/LeBoy2');
			bs3.animation.addByPrefix('a', 'a', 24);
			bs3.animation.play('a');	
			bs3.alpha = 0;
			bs3.screenCenter(X);
			bs3.screenCenter(Y);
			bbs.loadGraphic(Paths.image('cutscenes/eyes'));
			bbs.alpha = 0;
			bbs.screenCenter(X);
			bbs.screenCenter(Y);
			
			
		}
		if (PlayState.SONG.song.toLowerCase() == 'incident')
		{
			portraitRight = new FlxSprite(760, 107);
			portraitRight.loadGraphic(Paths.image('cutscenes/boyfriendPort2'));
			portraitRight.alpha = 0;
			
			portraitRight.antialiasing = true;
			add(portraitRight);
			portraitRight.visible = false;

			bse.frames = Paths.getSparrowAtlas('cutscenes/t');
			bse.animation.addByPrefix('t', 't', 24);
			bse.animation.play('t');	
			bse.alpha = 0;
			bse.screenCenter(X);
			bse.screenCenter(Y);

			bs3.frames = Paths.getSparrowAtlas('cutscenes/b');
			bs3.animation.addByPrefix('b', 'b', 24);
			bs3.animation.play('b');	
			bs3.alpha = 0;
			bs3.screenCenter(X);
			bs3.screenCenter(Y);
			
			
		}
		if (PlayState.SONG.song.toLowerCase() == 'rage')
		{
			
			portraitRight = new FlxSprite(760, 107);
			portraitRight.loadGraphic(Paths.image('cutscenes/boyfriendPort2'));
			
			portraitRight.antialiasing = true;
			add(portraitRight);
			portraitRight.visible = false;
		}
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();

		add(bbs);
		add(bse);
		add(bs);
		add(bs2);
		add(bs3);
		add(box);
		
		box.screenCenter(X);
	
		// :(
		/*for (i in 0...daArray.length)
		{
			trace(daArray[i]);
			daArray[i] = new FlxSound().loadEmbedded(Paths.sound(daArray[i], 'shared'));
		}*/

		trace(sad1);

		rage1 = new FlxSound().loadEmbedded(Paths.sound('rage1'));
		rage2 = new FlxSound().loadEmbedded(Paths.sound('rage2'));
		incident1 = new FlxSound().loadEmbedded(Paths.sound('incident1'));
		incident2 = new FlxSound().loadEmbedded(Paths.sound('incident2'));
		incident3 = new FlxSound().loadEmbedded(Paths.sound('incident3'));
		incident4 = new FlxSound().loadEmbedded(Paths.sound('incident4'));
		incident5 = new FlxSound().loadEmbedded(Paths.sound('incident5'));
		incident6 = new FlxSound().loadEmbedded(Paths.sound('incident6'));
		sad1 = new FlxSound().loadEmbedded(Paths.sound('sad1'));
		sad2 = new FlxSound().loadEmbedded(Paths.sound('sad2'));
		sad3 = new FlxSound().loadEmbedded(Paths.sound('sad3'));
		sad4 = new FlxSound().loadEmbedded(Paths.sound('sad4'));
		sad5 = new FlxSound().loadEmbedded(Paths.sound('sad5'));
		sad6 = new FlxSound().loadEmbedded(Paths.sound('sad6'));
		sad7 = new FlxSound().loadEmbedded(Paths.sound('sad7'));
		sad8 = new FlxSound().loadEmbedded(Paths.sound('sad8'));
		sad9 = new FlxSound().loadEmbedded(Paths.sound('sad9'));
		sad10 = new FlxSound().loadEmbedded(Paths.sound('sad10'));
		sad11 = new FlxSound().loadEmbedded(Paths.sound('sad11'));
		sad12 = new FlxSound().loadEmbedded(Paths.sound('sad12'));
		sad13 = new FlxSound().loadEmbedded(Paths.sound('sad13'));
		sad15 = new FlxSound().loadEmbedded(Paths.sound('sad15'));
		sad16 = new FlxSound().loadEmbedded(Paths.sound('sad16'));
		beep = new FlxSound().loadEmbedded(Paths.sound('beep'));

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'VCR OSD Mono';
		swagDialogue.color = 0xFFFFFFFF;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'incident' || PlayState.SONG.song.toLowerCase() == 'rage'|| PlayState.SONG.song.toLowerCase() == 'sadness')
						

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						FlxG.sound.music.stop();
						sasa2 = 0;
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.alpha -= 1 / 5;
						portraitLeft.visible = false;
						if (PlayState.SONG.song.toLowerCase() == 'rage' )
						{	
						portraitLeft2.visible = false;
						portraitLeft3.visible = false;
						portraitLeft2.alpha -= 1 / 5;
						portraitLeft3.alpha -= 1 / 5;
						}
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
	
					}, 5);
					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
						
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(time, true);

		switch (curCharacter)
		{
			case 'dad':
				if (PlayState.SONG.song.toLowerCase() == 'rage' )
					{

						if(susa == 0)
						{
							rage1.play();
						
						}
						if(susa == 30)
						{
							beep.stop();
							rage2.play();
							portraitLeft2.alpha = 1;
							portraitLeft.alpha = 0;
						}
						if (susa > 30 )
						{
							portraitLeft2.alpha = 0;
							portraitLeft3.alpha = 1;
						}
						portraitRight.visible = false;
						if (!portraitLeft.visible)
						{
							portraitLeft.visible = true;
							portraitLeft2.visible = true;
							portraitLeft3.visible = true;
							portraitLeft.animation.play('enter');
						}
					}
				if (PlayState.SONG.song.toLowerCase() == 'incident' )
				{
					
					if (sasa2 == 0)
					{
						FlxG.sound.playMusic(Paths.music('cutscenes'));
						
						incident1.play();
						
						
						box.y -= 200;
						swagDialogue.y -= 200;
					}
					if (sasa2 == 1)
					{
						incident2.play();
						incident1.pause();
					}
					if (sasa2 == 2)
					{
						incident3.play();
						incident2.pause();
					}
					if (sasa2 == 3)
					{
						incident4.play();
						incident3.pause();
					}
					if (sasa2 == 4)
					{
						incident5.play();
						incident4.pause();
					}
					if (sasa2 == 5)
					{
						incident6.play();
						incident5.pause();
						box.y += 200;
						swagDialogue.y += 200;
						bse.alpha = 1;
					}
					
				}
				if (PlayState.SONG.song.toLowerCase() == 'sadness' )
					{
						

						if(sasa == 0)
						{//+ pra baixo - cima
							FlxG.sound.playMusic(Paths.music('cutscenes'));
							sad1.play();
							portraitLeft.alpha = 0;
							box.y -= 200;
							swagDialogue.y -= 200;
						}
						if(sasa == 1)
						{
							
							sad1.pause();
							sad2.play();
							box.y += 200;
							swagDialogue.y += 200;
							bse.alpha = 1;
						}
						if(sasa == 2)
						{
							
							sad2.destroy();
							sad3.play();
							bse.alpha = 0;
							box.y -= 200;
							swagDialogue.y -= 200;
						}
						if(sasa == 3)
						{
							
							sad3.destroy();
							sad4.play();
							bs.alpha = 1;
							box.y += 200;
							swagDialogue.y += 200;
						}
						if(sasa == 4)
						{
							sad4.destroy();
							sad5.play();
							bs.alpha = 0;
							box.y -= 200;
							swagDialogue.y -=200;
						}
						if(sasa == 5)
						{
							sad5.destroy();
							sad6.play();
						}
						if(sasa == 6)
						{
							sad6.destroy();
							sad7.play();
						}
						if(sasa == 7)
						{
							sad7.destroy();
							sad8.play();
						}
						if(sasa == 8)	
						{
							sad8.destroy();
							sad9.play();
						}
						if(sasa == 9)
						{
							sad9.destroy();
							sad10.play();
						}
						if(sasa == 10)
						{
							sad10.destroy();
							sad11.play();
						}
						if(sasa == 11)
						{
							sad11.destroy();
							sad12.play();
						}
						if(sasa == 12)
						{
							sad12.destroy();
							sad13.play();
						}
						if(sasa == 13)
						{
							
							sad13.destroy();
							sad15.play();
							bbs.alpha = 1;
							box.y += 200;
							swagDialogue.y += 200;
							FlxG.sound.music.stop();
						}
						if(sasa == 14)
						{
							sad15.destroy();
							box.alpha = 0;
							bs2.alpha = 1;
							bbs.alpha = 0;

						}
						if(sasa == 16)
						{
							beep.stop();
						}
						
					}
				portraitRight.visible = false;
				sasa+=1;
				sasa2+=1;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				if (PlayState.SONG.song.toLowerCase() == 'rage' )
				{
					rage2.stop();
					rage1.stop();
					beep.play();
					susa += 30;
					portraitLeft3.visible = false;
					portraitLeft.visible = false;
					portraitLeft2.visible = false;
					if (!portraitRight.visible)
						{
							
							portraitRight.visible = true;
							portraitRight.animation.play('enter');
						}
				}
				if (PlayState.SONG.song.toLowerCase() == 'sadness')
				{
					if(sasa == 15)
					{
						sad16.destroy();
						beep.play();
						bs2.alpha = 0;
						bs3.alpha = 1;
					}
				}
				if (PlayState.SONG.song.toLowerCase() == 'incident')
				{
					if(sasa2 == 6)
					{
						beep.play();
						bse.alpha = 0;
						bs3.alpha = 1;
						incident6.pause();
					}
				}
				
				sasa+=1;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
					{
						portraitRight.visible = true;
						portraitRight.animation.play('enter');
					}
				
		}
	}

	function cleanDialog():Void
	{
		
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
