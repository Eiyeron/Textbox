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

class PlayState extends FlxState
{

	var tbox:Textbox;
	var tbox2:Textbox;
	var cursor:FlxSprite;
	var cursorTween:FlxTween;
	var beep1:FlxSound;
	var beep2:FlxSound;
	override public function create():Void
	{

		cursor = new FlxSprite(0, 0);
		cursor.makeGraphic(8, 4);
		beep1 = new FlxSound();
		beep1.loadEmbedded(AssetPaths.beep1__ogg);
		beep2 = new FlxSound();
		beep2.loadEmbedded(AssetPaths.beep2__ogg);
		var settingsTbox:Settings =
		{
			font: FlxAssets.FONT_DEFAULT,
			fontSize: 16,
			textFieldWidth: 320,
			color: FlxColor.WHITE
		};
		tbox = new Textbox(200,30, settingsTbox);
		tbox.setText("Hello World!@011001500 How goes? @010@001FF0000Color test!@000 This is a good old textbox test.");
		tbox.characterDisplayCallback = function(t:textbox.Text):Void
		{
			cursor.x = t.x + t.width + 2;
			cursor.y = t.y + t.height - 4;
			cursor.color = t.color;
			beep1.play(true);
		};
		tbox.bring();

		var settingsTbox2:Settings =
		{
			font: FlxAssets.FONT_DEFAULT,
			fontSize: 12,
			textFieldWidth: 400,
			charactersPerSecond: 30,
			color: FlxColor.YELLOW
		};
		tbox2 = new Textbox(30,150, settingsTbox2);
		tbox2.setText("This is @021014010another@020 textbox, to show how the settings variables can change the result. Speed, size or color and @031023820more with the effects@030! Note that there is a fully working text wrap! :D");
		tbox2.characterDisplayCallback = function(t:textbox.Text):Void
		{
			cursor.x = t.x + t.width + 2;
			cursor.y = t.y + t.height - 4;
			cursor.color = t.color;
			beep2.play(true);
		};
		tbox2.statusChangeCallback = function(s:textbox.Status):Void
		{
			if (s == textbox.Status.DONE)
			{
				cursorTween = FlxTween.color(cursor, 0.5, cursor.color, FlxColor.TRANSPARENT, {
					type: FlxTween.PINGPONG,
					ease: FlxEase.cubeInOut
				});
			}
		};
		add(cursor);


		tbox.statusChangeCallback = function (newStatus:textbox.Status):Void
		{
			if (newStatus == textbox.Status.FULL)
			{
				tbox.continueWriting();
			}
			else if(newStatus == textbox.Status.DONE)
			{
				add(tbox2);
				tbox2.bring();
			}
		};
		add(tbox);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
