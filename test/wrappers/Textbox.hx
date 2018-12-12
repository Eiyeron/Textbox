package wrappers;

import textbox.Textbox.CharacterType;

class Textbox extends textbox.Textbox
{
	public function getCharacters():Array<CharacterType>
	{
		return characters;
	}
}