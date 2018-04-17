package textbox;

import textbox.CommandValues;
import textbox.Text;
import textbox.TextboxLine;
import textbox.TextPool;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.typeLimit.OneOfTwo;
import haxe.Utf8;

using StringTools;

enum Status
{
    EMPTY;
    WRITING;
    PAUSED;
    FULL;
    DONE;
}

typedef TextboxCharacter = OneOfTwo<String, CommandValues>;

// Callback typedefs

// To be called when the textbox's status changes
typedef StatusChangeCallback = Status -> Void;
// To be called when a character is shown (for sound callbacks, timing or other).
typedef CharacterDisplayCallback = Text -> Void;

/**
 * 	The holy mother of textboxes.
 *  Accepts text with tokens to enable and disable per-character effects.
 *  Accept a settings structure to customize the basic behavior (such as font options or text speed.)
 * 	The token can take two shapes
 *	- @XX0 => disable effect 0xXX
 *	- @XX1AABBCC => set effect 0xXX with args 0xAA, 0xBB 0xCC
 */
class Textbox extends FlxSpriteGroup {

	public function new(X:Float, Y:Float, settings:Settings)
	{
		super(X, Y);
		this.settings = settings;

		status = DONE;

		currentCharacterIndex = 0;
		currentLineIndex = 0;
		timerBeforeNewCharacter = 0;

		willResume = false;


		// Sub structure allocation.
		characters = [];

		characterPool = new TextPool();
		lines = [for(i in 0...settings.numLines) new TextBoxLine()];

		// Those ones can only be set when the lines are created, else we crash.
		visible = false;
		active = false;

		effects = [];
		for (i in 0 ... TextEffectArray.effectClasses.length)
		{
			effects.push({
				command:i,
                activated:false,
				arg1:0,
				arg2:0,
				arg3:0
			});
		}

	}


	public override function update(elapsed:Float)
	{
		// If asked to continue after getting a full state
		if(willResume)
		{
			if(status == FULL)
			{
				moveTextUp();
			}
			status = WRITING;
			willResume = false;
		}
        else if(status != PAUSED && status != DONE)
        {
            // Nothing to do here
            timerBeforeNewCharacter += elapsed;
            while(timerBeforeNewCharacter > timePerCharacter)
            {
                if(status == WRITING)
                {
                    advanceCharacter();
                }
                timerBeforeNewCharacter -= timePerCharacter;
            }
        }
		super.update(elapsed);
	}

	/**
	 * The textbox will be invisible and disables itselfs from the scene.
	 */
	public function dismiss()
	{
		if(!visible)
		{
			return;
		}
		visible = false;
		active = false;
	}

	/**
	 *  When called, the textbox will come on and activates itself into the scene.
	 *  It also starts writing the parsed text, so it should be called after `setText`.
	 */
	public function bring()
	{
		startWriting();
		visible = true;
		active = true;
	}

	/**
	 *  Clears the current text lines and parsed sequences and parse the given text
	 *  to set it up as the new sequence.
	 *  @param text - New text to set
	 */
	public function setText(text:String)
	{
		for(line in lines)
		{
			// Puts back every used character into the pool.
			for(character in line.dispose())
			{
				remove(character);
				characterPool.put(character);
			}
		}

		prepareString(text);
		// Ready.
		status = EMPTY;

	}

	/**
	 *  This function sets the initial state to start writing.
	 */
	public function startWriting()
	{
		currentCharacterIndex = 0;
		currentLineIndex = 0;
		timerBeforeNewCharacter = 0;
		resetTextEffects();
		status = WRITING;
	}

	/**
	 *  This functions asks the textbox to continue writing if it got full.
	 *  This is manually done to allow multiple behaviors like automatic scrolling
	 *  or waiting for user input.
	 */
	public function continueWriting()
	{
		if(status == PAUSED || status == FULL)
		{
			willResume = true;
		}
	}

	/**
	 *  Resets the available effects' state/parameters.
	 */
	function resetTextEffects()
	{
		for (effect in effects)
		{
			effect =
            {
				command:0,
                activated:false,
				arg1:0,
				arg2:0,
				arg3:0
			};
		}
	}

	//
	/**
	 *  Parses the set string and fill the character array with the possible characters and commands.
	 *  @param text - The text to process.
	 */
	function prepareString(text:String)
	{
		characters = [];
		var isParsingACommand = false;
		var command:CommandValues =
		{
			command: 0,
            activated:false,
			arg1: 0,
			arg2: 0,
			arg3: 0
		};
		var currentHexString:String = "0x";
		var commandParsingStep:Int = 0;

		for(i in 0...Utf8.length(text))
		{
			var char_code = Utf8.charCodeAt(text, i);
			var currentCharacter = Utf8.sub(text, i, 1);
			// If we're still parsing a command code
			if(isParsingACommand)
			{
				// Quick shortcut to check if the code is @@ to put @ in the text, just interrupt the parsing.
				if(currentCharacter == "@" && commandParsingStep == 0)
				{
					isParsingACommand = false;
					characters.push(currentCharacter);
					continue;
				}
                // Spacing
                if (currentCharacter.isSpace(0))
                {
                    continue;
                }
				// Continue parsing the hex code.
				currentHexString += currentCharacter;
				if((commandParsingStep == 2 && currentHexString.length == 3) || currentHexString.length == 4)
				{
					// If we parsed a pair, just put it in the correct variable.
					var value:Null<Int> =  Std.parseInt(currentHexString);
					// Bad parsing
					if(value == null)
					{
						isParsingACommand = false;
						continue;
					}
					switch(commandParsingStep)
					{
						// Code  | @IIvAABBCC
						// Index |   12 4 6 8
						case 1:
						command.command = value;
                        case 2:
                        command.activated = value != 0;
						case 4:
						command.arg1 = value;
						case 6:
						command.arg2 = value;
						case 8:
						command.arg3 = value;
					}
					currentHexString = "0x";
				}
				// And stop it if we had enough characters.
				if(commandParsingStep == 8 || (commandParsingStep == 2 && !command.activated))
				{
					isParsingACommand = false;
					characters.push(command);
					// Use a new command.
                    command =
                    {
                        command: 0,
                        activated:false,
                        arg1: 0,
                        arg2: 0,
                        arg3: 0
                    };
				}
				else
				{
					// Go forward in the process
					commandParsingStep++;
				}
			}
			else
			{
				// Go into the hex code system if requested.
				if(char_code == '@'.charCodeAt(0))
				{
					isParsingACommand = true;
					commandParsingStep = 0;
					currentHexString = "0x";
					command.command = 0;
					command.activated = false;
					command.arg1 = 0;
					command.arg2 = 0;
					command.arg3 = 0;
				}
				else
				{
					characters.push(currentCharacter);
				}
			}
		}
		// Decided that the system wouldn't add a partial command code at the end of a text entry.
	}

	/**
	 *  This function is called when the textbox has to write down a new character.
	 *  Does *a bit* of process (like word wrapping or newline support) but makes
	 *  stuff work.
	 */
	function advanceCharacter()
	{
		// Just avoid an access exception.
		if(currentCharacterIndex >= characters.length)
		{
			status = DONE;
			return;
		}
		var currentCharacter = characters[currentCharacterIndex];

		var isCharacter = Std.is(currentCharacter, String);
		// TODO : this process could eventually be split into functions.
		if (isCharacter)
		{
			var currentCharacterChar = cast(currentCharacter, String);
			// If current character is a space, let's calculate how long the next word will be.
			if (currentCharacterChar.isSpace(0))
			{
				// We have to build a string containing the next characters to calculate the size of the line.
				var word:String = " ";
				var index:Int = currentCharacterIndex+1;
				// So, while we're finding non-invisible characters
				while(index < characters.length)
				{
					var forward_character = characters[index];
					if(!Std.is(forward_character, String))
					{
						index++;
						continue;
					}
					var forward_char:String = cast(characters[index], String);
					if(!forward_char.isSpace(0))
						word += forward_char;
					else
						break;
					index++;
				}
				// TODO : please don't make words too long.
				// SO, if we're going over the limit, just go to the next line.
				if(lines[currentLineIndex].projectWidth(word) > settings.textFieldWidth)
				{
					// As we wrapped the line on this character, let's skip it.
					currentCharacterIndex++;
					if(currentLineIndex < settings.numLines-1)
					{
						currentLineIndex++;
					}
					else
					{
						status = FULL;
					}
					return;
				}
			}
			// inline line returns support
			else if (currentCharacterChar == '\n')
			{
				if(currentLineIndex < settings.numLines-1)
				{
					currentLineIndex++;
				}
				else
				{
					// If we're placing a newline in the last textbox's line,
					// make the textbox advance by one character else it'd
					// be perpetually stuck on the newline.
					currentCharacterIndex++;
					status = FULL;
					return;
				}
			}
			// Character-wrap. Shouldn't be really useful but it's still a guard.
			else if(lines[currentLineIndex].projectWidth(currentCharacter) > settings.textFieldWidth)
			{
				if(currentLineIndex < settings.numLines-1)
				{
					currentLineIndex++;
				}
				else
				{
					status = FULL;
					return;
				}
			}

			// Now that the text flow control is past us, let's add the new character to the textbox.

			// Get a new character from the pool
			var newCharacter:Text = characterPool.get();
			// Preparing it for the default style.
			newCharacter.autoSize = true;
			newCharacter.font = settings.font;
			newCharacter.size = settings.fontSize;
			newCharacter.text = currentCharacterChar;
			newCharacter.color = settings.color;
			newCharacter.y = currentLineIndex * newCharacter.height;
			newCharacter.x = lines[currentLineIndex].text_width;
			for (effect in effects)
			{
				var characterEffect = newCharacter.effects[effect.command];
				characterEffect.reset(effect.arg1,effect.arg2,effect.arg3, 0);
                characterEffect.setActive(effect.activated);
                if (effect.activated)
                {
				    characterEffect.apply(newCharacter);
                }
			}

			// This line is only for the opacity tweens to work.
			newCharacter.alpha = alpha;
			// Raaaaaise from the deeead.
			newCharacter.revive();
			// Put it in the line and go forward
			lines[currentLineIndex].push(newCharacter);
			add(newCharacter);
            for (callback in characterDisplayCallbacks)
            {
                callback(newCharacter);
            }
			currentCharacterIndex++;
		}
		else
		{
			var command:CommandValues = cast currentCharacter;
			effects[command.command] = command;

			currentCharacterIndex++;
			timerBeforeNewCharacter += timePerCharacter;
		}
	}

	// THis function is only called when having to continue spitting out characters after going FULL
	function moveTextUp()
	{
		// Clearing the first line and putting its characters in the pool.
		var charactersToDispose = lines[0].dispose();
		for(character in charactersToDispose)
		{
			remove(character);
			characterPool.put(character);
		}
		// Moving the text one line upwards.
		for(i in 1...settings.numLines)
		{
			var charactersToGive:FlxTypedGroup<Text> = lines[i].dispose();
			for(character in charactersToGive)
            {
				character.y -= character.height;
			}
			lines[i-1].take(charactersToGive);
		}
		currentLineIndex = settings.numLines - 1;
	}

    // callbacks
    public var characterDisplayCallbacks(default, null): Array<CharacterDisplayCallback> = [];
    public var statusChangeCallbacks(default, null): Array<StatusChangeCallback> = [];

	// Variable members
	var status(default, set):Status;

	var settings:Settings;


	// internal
	// The character array. Calculated from a sent string, it contains the list of characters to show or commands to execute.
	var characters:Array<TextboxCharacter>;
	var timePerCharacter(get, never):Float;
	// The position among the whole character array.
	var currentCharacterIndex:Int;
	// The timer before adding a new character
	var timerBeforeNewCharacter:Float;


	// A TextPool to easily manage the ever-changing characters with a minimal amount of allocation.
	var characterPool:TextPool;

	// The line array, contains the data structures to store and manage the characters.
	var lines:Array<TextBoxLine>;
	// The text line's index.
	var currentLineIndex:Int;
	// Just a small internal boolean to notice when a FULL textbox can continue.
	var willResume:Bool;

	// Textbox things. Kinds of act like a pen.
	// Stores the current color of the text.
	var effects:Array<CommandValues>;


    // getter/setters
 	public function get_timePerCharacter():Float
	{
		return 1./settings.charactersPerSecond;
	}

	// Small helper to manage the status_icon.
	function set_status(status:Status)
	{
        var previousStatus = this.status;
		this.status = status;
		if(status != previousStatus)
		{
			for (callback in statusChangeCallbacks)
			{
				callback(status);
			}
		}
		return status;
	}

	public override function set_alpha(Alpha:Float):Float
    {
		for(line in lines)
			line.characters.forEach(function(s){s.set_alpha(Alpha);});
		return super.set_alpha(Alpha);
	}

// Why do I need to do this...
	public override function set_visible(Visible:Bool):Bool
    {
		visible = Visible;
		group.set_visible(true);
		return visible;
	}

	public override function set_active(Active:Bool):Bool
    {
		active = Active;
		group.set_active(true);
		return active;
	}
}