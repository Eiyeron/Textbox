package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;

import textbox.Textbox;
import textbox.Settings;

// Those two demo classes are both an example of how you could make classes to
// modularize plugin features on the textbox and a structure idea to
// eventually make a helper class and/or interface to do so.

class DemoTextCursor extends FlxSprite
{
	public override function new(X:Float, Y:Float)
	{
		super(X, Y);
		makeGraphic(8, 4);

		ownCharacterCallback = function(character:textbox.Text)
		{
			characterCallbackInternal(character);
		};
	}


	public function attachToTextbox(textbox:Textbox)
	{
		textbox.characterDisplayCallbacks.push(ownCharacterCallback);
	}

	public function detachFromTextbox(textbox:Textbox)
	{
		textbox.characterDisplayCallbacks.remove(ownCharacterCallback);
	}

	private function characterCallbackInternal(character:textbox.Text)
	{
		x = character.x + character.width + 2;

		// I noted an issue : the character height is 0 if targetting javascript.
		if (character.text != " ")
		{
			y = character.y + character.height - 4;
		}
		color = character.color;
	}

	private var ownCharacterCallback:textbox.Text->Void = null;
}

class DemoPlaySoundOnCharacter
{
	public function new(soundAsset:flixel.system.FlxAssets.FlxSoundAsset)
	{
		sound = new FlxSound();
		sound.loadEmbedded(soundAsset);

		ownCharacterCallback = function(character:textbox.Text)
		{
			sound.play(true);
		};
	}

	public function attachToTextbox(textbox:Textbox)
	{
		textbox.characterDisplayCallbacks.push(ownCharacterCallback);
	}

	public function detachFromTextbox(textbox:Textbox)
	{
		textbox.characterDisplayCallbacks.remove(ownCharacterCallback);
	}

	private var sound:FlxSound;
	private var ownCharacterCallback:textbox.Text->Void = null;
}

class PlayState extends FlxState
{

	var tbox:Textbox;
	var tbox2:Textbox;
	var cursor:DemoTextCursor;
	var cursorTween:FlxTween;
	var beep1:DemoPlaySoundOnCharacter;
	var beep2:DemoPlaySoundOnCharacter;
	override public function create():Void
	{

		cursor = new DemoTextCursor(0, 0);
		beep1 = new DemoPlaySoundOnCharacter(AssetPaths.beep1__ogg);
		beep2 = new DemoPlaySoundOnCharacter(AssetPaths.beep2__ogg);
		var settingsTbox:Settings =
		{
			font: FlxAssets.FONT_DEFAULT,
			fontSize: 16,
			textFieldWidth: 320,
			color: FlxColor.WHITE
		};
		tbox = new Textbox(200,30, settingsTbox);
		tbox.setText("Hello World!@011001500 How goes? @010@001FF0000Color test!@000 This is a good old textbox test.");
		cursor.attachToTextbox(tbox);
		beep1.attachToTextbox(tbox);
		tbox.bring();

		var settingsTbox2:Settings =
		{
			font: FlxAssets.FONT_DEFAULT,
			fontSize: 12,
			textFieldWidth: 400,
			charactersPerSecond: 30,
			numLines: 4,
			color: FlxColor.YELLOW
		};
		tbox2 = new Textbox(30,150, settingsTbox2);
		tbox2.setText("This is @021014010another@020 textbox, to show how the settings variables can change the result. Speed, size or color and @031023820more with the effects@030! Note that there is a fully working text wrap! :D");
		beep2.attachToTextbox(tbox2);
		tbox2.statusChangeCallbacks.push(function(s:textbox.Status):Void
		{
			if (s == textbox.Status.DONE)
			{
				cursorTween = FlxTween.color(cursor, 0.5, cursor.color, FlxColor.TRANSPARENT,
					{
						type: FlxTween.PINGPONG,
						ease: FlxEase.cubeInOut
					}
				);
			}
		});
		add(cursor);


		tbox.statusChangeCallbacks.push(function (newStatus:textbox.Status):Void
		{
			if (newStatus == textbox.Status.FULL)
			{
				tbox.continueWriting();
			}
			else if(newStatus == textbox.Status.DONE)
			{
				add(tbox2);
				cursor.detachFromTextbox(tbox);
				cursor.attachToTextbox(tbox2);
				tbox2.bring();
			}
		});
		add(tbox);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
