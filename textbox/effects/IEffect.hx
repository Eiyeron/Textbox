package textbox.effects;
import textbox.Text;

interface IEffect
{
    public function reset(arg1:Int, arg2:Int, arg3:Int, nthCharacter:Int):Void;
    public function update(elapsed:Float):Void;
    public function apply(text:Text):Void;
    // To be called to offset per character
    public function setActive(active:Bool):Void;
    public function isActive():Bool;
}