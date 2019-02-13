package textbox;
import flixel.text.FlxText;
import textbox.effects.IEffect;

class Text extends FlxText {
    public var effects:Array<IEffect>;

    public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?text:String, Size:Int = 8, EmbeddedFont:Bool = true)
    {
        super(X, Y, FieldWidth, text, Size, EmbeddedFont);
        effects = [];
        for (effect in TextEffectArray.effectClasses)
        {
            effects.push(Type.createInstance(effect, []));
        }
    }

    public function clear()
    {
        this.offset.set(0,0);
    }

    override public function update(elapsed:Float)
    {
        for (effect in effects)
        {
            if (effect.isActive())
            {
                effect.update(elapsed);
                effect.apply(this);
            }
        }
    }
}