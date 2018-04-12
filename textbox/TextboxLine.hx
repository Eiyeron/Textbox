package textbox;

import flixel.group.FlxGroup;
import flixel.text.FlxText;

class TextBoxLine {
	public var characters:FlxTypedGroup<Text>;
	public var text_width(default, null):Float;
	var inner_text:FlxText;

	public function new()
	{
		characters = new FlxTypedGroup<Text>();
		text_width = 0;
		inner_text = new FlxText();
		inner_text.text = "";
	}

	// Creates a tempoary FlxText to calculate the future length of the current string with a suffix.
	public function projectWidth(string_to_append:String):Float
	{
		var test_string:FlxText = new FlxText();
		test_string.font = inner_text.font;
		test_string.size = inner_text.size;
		test_string.text = inner_text.text + string_to_append;
		return test_string.textField.width;
	}

	// Accepts a new character and updates its logic values like width.
	public function push(character:Text):Void
	{
		// Regerenate the FlxText.
		if(characters.length == 0)
		{
			inner_text.text = "";
			inner_text.font = character.font;
			inner_text.size = character.size;
		}
		characters.add(character);
		inner_text.text += character.text;
		#if js
		// Legnth calculation wouldn't work properly if I haven't done this.
		if(character.text == " ")
			// TODO : pass this magic cookie as a setting
			text_width += character.width+2;
		else
			text_width = inner_text.textField.textWidth;
		#else
		text_width = inner_text.textField.textWidth;
		#end
	}

	// Releases its characters to pass along or put them back into pool.
	public function dispose():FlxTypedGroup<Text>
	{
		text_width = 0;
		var c = characters;
		characters = new FlxTypedGroup<Text>();
		inner_text.text = "";
		return c;
	}

	// Takes ownership of the characters and recalculates its metrics.
	public function take(characters:FlxTypedGroup<Text>):Void
	{
		this.characters = characters;
		inner_text.text = "";
		for(character in characters)
		{
			inner_text.text += character.text;
		}
		text_width = inner_text.width;
	}
}
