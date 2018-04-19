package wrappers;

import textbox.Textbox.TextboxCharacter;

class Textbox extends textbox.Textbox
{
	public function getCharacters():Array<TextboxCharacter>
	{
		return characters;
	}
}