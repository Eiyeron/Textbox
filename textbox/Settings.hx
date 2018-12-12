package textbox;

import flixel.util.FlxColor;
import flixel.system.FlxAssets;

@:structInit
class Settings
{
    public var font:String;
    public var fontSize:Int;
    public var textFieldWidth:Float;
    public var color: FlxColor;
    public var numLines:Int;
    public var charactersPerSecond:Float;
    /**
     *  This should only be used in html5 target as determining the space character'size
     *   is broken only on this target.
     */
    public var characterSpacingHack:Float;

    public function new(
        font:String = null,
        fontSize:Int = 12,
        textFieldWidth:Float = 240,
        color:FlxColor = FlxColor.WHITE,
        numLines:Int = 3,
        charactersPerSecond:Float = 24,
        // This default value has been empirically chosen to work with only the fonts
        // I used, feel free to use another value to match your font's needs
        characterSpacingHack:Float = 2
    )
    {
        this.font = font == null ? FlxAssets.FONT_DEFAULT : font;
        this.fontSize = fontSize;
        this.textFieldWidth = textFieldWidth;
        this.color = color;
        this.numLines = numLines;
        this.charactersPerSecond = charactersPerSecond;
        this.characterSpacingHack = characterSpacingHack;
    }
}