package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var saba:Int = 50;
	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gfG':
				// GIRLFRIEND CODE
				tex = CachedFrames.cachedInstance.fromSparrow('gfG','characters/new_girlfriendG');
				frames = tex;
				animation.addByPrefix('singUP', 'GF Up Note', 48, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				animation.addByPrefix('scared', 'GF FEAR', 48);
	
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
	
				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gf2':
				// GIRLFRIEND CODE
				tex = CachedFrames.cachedInstance.fromSparrow('gf2','characters/new_girlfriend2');
				frames = tex;
				animation.addByPrefix('singUP', 'GF Up Note', 48, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				
				animation.addByPrefix('scared', 'GF FEAR', 48);

				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/new_girlfriend');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

			
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

			
			

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/new_boyfriend');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				

				playAnim('idle');

				flipX = true;
			case 'bfG':
				var tex = CachedFrames.cachedInstance.fromSparrow('bfG','characters/new_boyfriendG');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
	
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
				animation.addByPrefix('scared', 'BF idle shaking', 24);
	
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);
	
				playAnim('idle');
	
				flipX = true;
			case 'bfblue':
				var tex = CachedFrames.cachedInstance.fromSparrow('bfblue','characters/new_blue_boyfriend');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
	
				addOffset('idle', -5);

				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);

	
				playAnim('idle');

				flipX = true;
		
		//////////////troll

			case 'troll':
			{
				tex = Paths.getSparrowAtlas('characters/SadSheet');
				frames = tex;
				animation.addByPrefix('idle',"TrollfaceIdle", 6, false);
				animation.addByPrefix('singUP',"TrollfaceUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollfaceDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollfaceLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollfaceRight", 24, false);

				addOffset('idle', 30, -130);
				addOffset('singUP', -8, -130); //X +esquerda. -direita ; Y +cima. -Baixo
				addOffset('singRIGHT', 100, -142);
				addOffset('singLEFT', 97, -144);
				addOffset('singDOWN', 18, -171);

				playAnim("idle");
			}
			case 'troll2':
			{
				tex = Paths.getSparrowAtlas('characters/SadSheet2');
				frames = tex;
				animation.addByPrefix('idle',"TrollfaceIdle", 6, false);
				animation.addByPrefix('singUP',"TrollfaceUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollfaceDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollfaceLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollfaceRight", 24, false);

				addOffset('idle', 30, -130);
				addOffset('singUP', -8, -130); //X +esquerda. -direita ; Y +cima. -Baixo
				addOffset('singRIGHT', 100, -142);
				addOffset('singLEFT', 97, -144);
				addOffset('singDOWN', 18, -171);

				playAnim("idle");
			}
			case 'troll3':
			{
				tex = CachedFrames.cachedInstance.fromSparrow('troll3', 'characters/SadSheet3');
				frames = tex;
				animation.addByPrefix('idle',"TrollfaceIdle", 6, false);
				animation.addByPrefix('singUP',"TrollfaceUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollfaceDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollfaceLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollfaceRight", 24, false);

				addOffset('idle', 30, -130);
				addOffset('singUP', -8, -130); //X +esquerda. -direita ; Y +cima. -Baixo
				addOffset('singRIGHT', 100, -142);
				addOffset('singLEFT', 97, -144);
				addOffset('singDOWN', 18, -171);

				playAnim("idle");
			}
			case 'trollrager':
				{
					tex = Paths.getSparrowAtlas('characters/1TrollgeRage');
					frames = tex;
					animation.addByPrefix('idle',"1TrollgeRageIdle", 6, false);
					animation.addByPrefix('singUP',"1TrollgeRageUp", 24, false);
					animation.addByPrefix('singDOWN',"1TrollgeRageDown", 24, false);
					animation.addByPrefix('singLEFT',"1TrollgeRageLeft", 24, false);
					animation.addByPrefix('singRIGHT',"1TrollgeRageRight", 24, false);
	
					addOffset('idle', 30 + saba, -130);
					addOffset('singUP', 201 + saba, -106); //X -esquerda. +direita ; Y +cima. -Baixo
					addOffset('singRIGHT', 47 + saba, -156);
					addOffset('singLEFT', 54+ saba, -127);//exceto aqui :clown
					addOffset('singDOWN', 70+ saba, -152); //42 direita 18 cima
	
					playAnim("idle");
				}
			case 'trollrager2':
			{
				tex = Paths.getSparrowAtlas('characters/2TrollgeRage');
				frames = tex;
				animation.addByPrefix('idle',"1TrollgeRageIdle", 6, false);
				animation.addByPrefix('singUP',"1TrollgeRageUp", 24, false);
				animation.addByPrefix('singDOWN',"1TrollgeRageDown", 24, false);
				animation.addByPrefix('singLEFT',"1TrollgeRageLeft", 24, false);
				animation.addByPrefix('singRIGHT',"1TrollgeRageRight", 24, false);

				addOffset('idle', 30 + saba, -130);
				addOffset('singUP', 201 + saba, -106); //X -esquerda. +direita ; Y +cima. -Baixo
				addOffset('singRIGHT', 47 + saba, -156);
				addOffset('singLEFT', 54+ saba, -127);//exceto aqui :clown
				addOffset('singDOWN', 70+ saba, -152); //42 direita 18 cima

				playAnim("idle");
			}
			case 'trollrager3':
			{
				tex = Paths.getSparrowAtlas('characters/3TrollgeRage');
				frames = tex;
				animation.addByPrefix('idle',"1TrollgeRageIdle", 6, false);
				animation.addByPrefix('singUP',"1TrollgeRageUp", 24, false);
				animation.addByPrefix('singDOWN',"1TrollgeRageDown", 24, false);
				animation.addByPrefix('singLEFT',"1TrollgeRageLeft", 24, false);
				animation.addByPrefix('singRIGHT',"1TrollgeRageRight", 24, false);

				addOffset('idle', 30 + saba, -130);
				addOffset('singUP', 201 + saba, -106); //X -esquerda. +direita ; Y +cima. -Baixo
				addOffset('singRIGHT', 47 + saba, -156);
				addOffset('singLEFT', 54+ saba, -127);//exceto aqui :clown
				addOffset('singDOWN', 70+ saba, -152); //42 direita 18 cima

				playAnim("idle");
			}
			
			case 'trollge_sad':

				tex = Paths.getSparrowAtlas('characters/trollgesad');
				frames = tex;
				animation.addByPrefix('idle',"IncidentSad", 3, false);

				addOffset('idle',0 ,0);

				playAnim("idle");

			case 'trollge_4':

				tex = Paths.getSparrowAtlas('characters/trollgephase4');
				frames = tex;
				animation.addByPrefix('idle',"IncidentSadSIdle", 12, false);
				animation.addByPrefix('singA',"IncidentSadSing", 24, false);
				animation.addByPrefix('speak',"IncidentSadSpeaking", 24, false);
				animation.addByPrefix('smile',"IncidentSadSmile", 24, false);
	
				addOffset('idle',0 ,-300);
				addOffset('singA',0 ,-300);
				addOffset('speak',0 ,-300);
				addOffset('smile',0 ,-300);
	
				

			case 'trollge':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/trollge');
				frames = tex;
				animation.addByPrefix('idle',"TrollgeIdle", 6, false);
				animation.addByPrefix('singUP',"TrollgeUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollgeDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollgeLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollgeRight", 24, false);

				addOffset('idle', saba, 0);
				addOffset('singUP', 119+ saba, 6);
				addOffset('singRIGHT', -20+ saba, -4);
				addOffset('singLEFT', 73+ saba, -2);
				addOffset('singDOWN', 23+ saba, -63);

				playAnim("idle");

				/////////////////////////////////////////////////////
			case 'trollge1':
				// DAD ANIMATION LOADING CODE
				tex = CachedFrames.cachedInstance.fromSparrow('trollge1', 'characters/trollgeStatic1');
				frames = tex;
				animation.addByPrefix('idle',"TrollgeIdle", 12, false);
				animation.addByPrefix('singUP',"TrollgeUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollgeDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollgeLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollgeRight", 24, false);
	
				addOffset('idle');
				addOffset('singUP', 119, 6);
				addOffset('singRIGHT', -20, -4);
				addOffset('singLEFT', 73, -2);
				addOffset('singDOWN', 23, -63);

				playAnim("idle");
				/////////////////////////////////////////////////////
			case 'trollge2':
				// DAD ANIMATION LOADING CODE
				tex = CachedFrames.cachedInstance.fromSparrow('trollge2', 'characters/trollgeStatic2');
				frames = tex;
				animation.addByPrefix('idle',"TrollgeIdle", 12, false);
				animation.addByPrefix('singUP',"TrollgeUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollgeDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollgeLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollgeRight", 24, false);
	
				addOffset('idle');
				addOffset('singUP', 119, 6);
				addOffset('singRIGHT', -20, -4);
				addOffset('singLEFT', 73, -2);
				addOffset('singDOWN', 23, -63);

				playAnim("idle");
				/////////////////////////////////////////////////////
			case 'trollge4':
				// DAD ANIMATION LOADING CODE
				tex = CachedFrames.cachedInstance.fromSparrow('trollge4', 'characters/trollgeStatic4');
				frames = tex;
				animation.addByPrefix('idle',"TrollgeIdle", 12, false);
				animation.addByPrefix('singUP',"TrollgeUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollgeDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollgeLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollgeRight", 24, false);
			
				addOffset('idle');
				addOffset('singUP', 119, 6);
				addOffset('singRIGHT', -20, -4);
				addOffset('singLEFT', 73, -2);
				addOffset('singDOWN', 23, -63);
	
				playAnim("idle");
				/////////////////////////////////////////////////////
			case 'trollgeglitch':
				// DAD ANIMATION LOADING CODE
				tex = CachedFrames.cachedInstance.fromSparrow('trollgeglitch', 'characters/trollgeGlitch');
				frames = tex;
				animation.addByPrefix('idle',"TrollgeIdle", 12, false);
				animation.addByPrefix('singUP',"TrollgeUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollgeDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollgeLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollgeRight", 24, false);
				
				addOffset('idle');
				addOffset('singUP', 119, 6);
				addOffset('singRIGHT', -20, -4);
				addOffset('singLEFT', 73, -2);
				addOffset('singDOWN', 23, -63);
		
				playAnim("idle");
					/////////////////////////////////////////////////////
			case 'trollgeglitch2':
				
				tex = CachedFrames.cachedInstance.fromSparrow('trollgeglitch2', 'characters/TrollgeFinal');
				frames = tex;
				animation.addByPrefix('idle',"TrollgeIdle", 24, false);
				animation.addByPrefix('singUP',"TrollgeUp", 24, false);
				animation.addByPrefix('singDOWN',"TrollgeDown", 24, false);
				animation.addByPrefix('singLEFT',"TrollgeLeft", 24, false);
				animation.addByPrefix('singRIGHT',"TrollgeRight", 24, false);
				
				addOffset('idle');
				addOffset('singUP', 119, 6);
				addOffset('singRIGHT', -20, -4);
				addOffset('singLEFT', 73, -2);
				addOffset('singDOWN', 23, -63);
		
				playAnim("idle");
					/////////////////////////////////////////////////////
					}


		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
					case 'gf2':
					if (!animation.curAnim.name.startsWith('hair'))
					{
		
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
					case 'gfG':
					if (!animation.curAnim.name.startsWith('hair'))
					{
		
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
