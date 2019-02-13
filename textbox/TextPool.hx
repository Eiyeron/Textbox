package textbox;

import flixel.util.FlxDestroyUtil;

class TextPool implements IFlxPool<Text>
{

    public function new()
    {
    }

    public function get():Text
    {
        if (_count == 0)
        {
            return new Text();
        }
        var c:Text = _pool[--_count];
        c.clear();
        return c;
    }

    public function put(obj:Text):Void
    {
        // we don't want to have the same object in the accessible pool twice (ok to have multiple in the inaccessible zone)
        if (obj != null)
        {
            var i:Int = _pool.indexOf(obj);
            // if the object's spot in the pool was overwritten, or if it's at or past _count (in the inaccessible zone)
            if (i == -1 || i >= _count)
            {
                // Make the character invisible and not updated instead of destroying it.
                obj.kill();
                _pool[_count++] = obj;
            }
        }
    }

    public function putUnsafe(obj:Text):Void
    {
        if (obj != null)
        {
            // Make the character invisible and not updated instead of destroying it.
            obj.kill();
            _pool[_count++] = obj;
        }
    }

    public function preAllocate(numObjects:Int):Void
    {
        while (numObjects-- > 0)
        {
            _pool[_count++] = new Text();
        }
    }

    public function clear():Array<Text>
    {
        _count = 0;
        var oldPool = _pool;
        _pool = [];
        return oldPool;
    }

    private inline function get_length():Int
    {
        return _count;
    }

    public var length(get, never):Int;

    private var _pool:Array<Text> = [];

    /**
     * Objects aren't actually removed from the array in order to improve performance.
     * _count keeps track of the valid, accessible pool objects.
     */
    private var _count:Int = 0;
}

interface IFlxPooled extends IFlxDestroyable
{
    public function put():Void;
    private var _inPool:Bool;
}

interface IFlxPool<T:IFlxDestroyable>
{
    public function preAllocate(numObjects:Int):Void;
    public function clear():Array<Text>;
}
