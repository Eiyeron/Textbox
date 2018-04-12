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

    public function new(
        font:String = null,
        fontSize:Int = 12,
        textFieldWidth:Float = 240,
        color:FlxColor = null,
        numLines:Int = 3,
        charactersPerSecond:Float = 24
    )
    {
        this.font = font == null ? FlxAssets.FONT_DEFAULT : font;
        this.color = color == null ? FlxColor.WHITE : color;

        this.fontSize = fontSize;
        this.textFieldWidth = textFieldWidth;
        this.numLines = numLines;
        this.charactersPerSecond = charactersPerSecond;
    }
}