package textbox;
import textbox.effects.*;

/**
 *  Contains an array of used effects. Their index will be their effect index, so an effect token @00[...]
 *  will interact with the first class in the list.
 *  Feel free to edit this class here and somewhere else too add your own effects.
 */
class TextEffectArray
{
    public static var effectClasses:Array<Class<IEffect>> =
    [
        ColorEffect,        // 00
        RainbowEffect,      // 01
        RotatingEffect,     // 02
        WaveEffect,         // 03
        // ...
    ];
}
