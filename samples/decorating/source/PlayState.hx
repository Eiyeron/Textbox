package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;

import textbox.Textbox;
import textbox.Settings;

class PlayState extends FlxState
{
	var tboxBackground:FlxSprite;
	var tbox:Textbox;
	var waitingForUserInput:Bool = false;
	var textboxIsFinished:Bool = false;
	var waitingToRestart:Bool = false;
	var pressSpaceIndication:FlxText;

	function showIndication(text:String)
	{
		pressSpaceIndication.text = text;
		pressSpaceIndication.visible = true;
	}

	override public function create():Void
	{

		var settingsTbox:Settings = new Settings
		(
			FlxAssets.FONT_DEFAULT,
			16,
			320,
			FlxColor.WHITE
		);
		tbox = new Textbox((FlxG.width - 320)/2,30, settingsTbox);
		tbox.setText("This is a demo showing how to make the textbox wait for user input. Useful when you're having too much text and not a lot of space, right? :D");

		tbox.statusChangeCallbacks.push(function (newStatus:textbox.Status):Void
		{
			if (newStatus == textbox.Status.FULL)
			{
				waitingForUserInput = true;
				showIndication("Press [SPACE] to continue.");
			}
			else if(newStatus == textbox.Status.DONE)
			{
				waitingForUserInput = true;
				showIndication("Press [SPACE] to end.");
				textboxIsFinished = true;
			}
		});

		pressSpaceIndication = new FlxText(tbox.x, 160, 0, "", 14);
		pressSpaceIndication.color = FlxColor.CYAN;
		pressSpaceIndication.visible = false;


		tboxBackground = new FlxSprite(tbox.x - 4, tbox.y - 4);
		tboxBackground.makeGraphic(Std.int(settingsTbox.textFieldWidth + 8), 78, FlxColor.BROWN);
		tboxBackground.alpha = 0;

		FlxTween.tween(tboxBackground, {alpha: 1}, 0.4,
		{
			ease: FlxEase.circOut,
			onComplete: function(_)
			{
				tbox.bring();
			}
		});

		add(tboxBackground);
		add(tbox);
		add(pressSpaceIndication);


		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if(FlxG.keys.justPressed.SPACE)
		{
			if (waitingForUserInput)
			{
				waitingForUserInput = false;
				if(textboxIsFinished)
				{
					tbox.dismiss();
					FlxTween.tween(tboxBackground, {alpha: 0}, 0.4,
					{
						ease: FlxEase.circOut,
						onComplete : function(_)
						{
							showIndication("Press [SPACE] to restart.");
							waitingToRestart = true;
						}
					});
				}
				else
				{
					tbox.continueWriting();
				}
				pressSpaceIndication.visible = false;
			}
			else if (waitingToRestart)
			{
				FlxG.resetState();
			}
		}
	}
}
