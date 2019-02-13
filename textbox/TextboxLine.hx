package textbox;

import flixel.text.FlxText;

using StringTools;
class TextBoxLine
{
    public function new()
    {
        characters = new Array<Text>();
        textWidth = 0;
        innerText = new FlxText();
        innerText.text = "";
    }

    // Creates a tempoary FlxText to calculate the future length of the current string with a suffix.
    public function projectWidth(string_to_append:String):Float
    {
        var testString:FlxText = new FlxText();
        testString.font = innerText.font;
        testString.size = innerText.size;
        testString.text = innerText.text + string_to_append;
        return testString.textField.width;
    }

    // Accepts a new character and updates its logic values like width.
    public function push(character:Text, characterSpacingHack:Float):Void
    {
        // Regerenate the FlxText.
        if(characters.length == 0)
        {
            innerText.text = "";
            innerText.font = character.font;
            innerText.size = character.size;
        }
        characters.push(character);
        innerText.text += character.text;
        #if js
        // Legnth calculation wouldn't work properly if I haven't done this.
        if(character.text.isSpace(0))
            textWidth += character.width + characterSpacingHack;
        else
            textWidth = innerText.textField.textWidth;
        #else
        textWidth = innerText.textField.textWidth;
        #end
    }

    // Releases its characters to pass along or put them back into pool.
    public function dispose():Array<Text>
    {
        textWidth = 0;
        var c = characters;
        characters = new Array<Text>();
        innerText.text = "";
        return c;
    }

    // Takes ownership of the characters and recalculates its metrics.
    public function take(characters:Array<Text>):Void
    {
        this.characters = characters;
        innerText.text = "";
        for(character in characters)
        {
            innerText.text += character.text;
        }
        textWidth = innerText.width;
    }

    public var characters:Array<Text>;
    public var textWidth(default, null):Float;
    private var innerText:FlxText;
}
