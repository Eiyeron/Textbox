package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import haxe.Utf8;
import textbox.CommandValues;
import textbox.Textbox.TextboxCharacter;
import wrappers.Textbox;

/**
 * Auto generated ExampleTest for MassiveUnit.
 * This is an example test class can be used as a template for writing normal and async tests
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TextboxTest
{
	private var tbox:Textbox;
	public function new()
	{
	}

	@Before
	public function setup()
	{
		tbox = new Textbox(0, 0, {});
	}

	@Test
	public function testSimpleParsing()
	{
		var text = "Hello world";
		tbox.setText(text);
		var characters = tbox.getCharacters();

		Assert.areEqual(Utf8.length(text), characters.length);


		matchTextAgainstCharacters(text, characters);
	}

	@Test
	public function testEnableSequenceParsing()
	{
		var text = "@001123456";
		tbox.setText(text);
		var characters = tbox.getCharacters();

		Assert.areEqual(1, characters.length);
		var sequence:CommandValues = cast characters[0];
		var expectedSequence:CommandValues =
		{
			command: 0,
			activated: true,
			arg1: 0x12,
			arg2: 0x34,
			arg3: 0x56,
		};

		matchSequences(expectedSequence, sequence);


	}

	@Test
	public function testDisableSequenceParsing()
	{
		var text = "@050";
		tbox.setText(text);
		var characters = tbox.getCharacters();

		Assert.areEqual(1, characters.length);
		var sequence:CommandValues = cast characters[0];
		var expectedSequence:CommandValues =
		{
			command: 5,
			activated: false,
			arg1: 0,
			arg2: 0,
			arg3: 0,
		};

		matchSequences(expectedSequence, sequence);
	}

	@Test
	public function testParsingInText()
	{
		var prefix = "Hello ";
		var suffix = "world!";
		var code = "@001123456";

		var prefixLength = Utf8.length(prefix);
		var suffixLength = Utf8.length(suffix);

		var text = prefix + code + suffix;
		tbox.setText(text);
		var characters = tbox.getCharacters();

		Assert.areEqual(prefixLength + suffixLength + 1, characters.length, "Length should match the prefix's plus the suffix's plus the character sequence");

		matchTextAgainstCharacters(prefix, characters.slice(0, prefixLength));

		matchSequences
		(
			{
				command: 0,
				activated: true,
				arg1: 0x12,
				arg2: 0x34,
				arg3: 0x56,
			},
			characters[prefixLength]
		);

		matchTextAgainstCharacters(suffix, characters.slice(prefixLength + 1, characters.length));
	}

	@Test
	public function testInvalidSequenceParsing()
	{
		// As now, the parser only breaks at the end of a sequence part.
		// Here, it stops after collecting the two characters of the command's index
		// Hence the string resulting length is not taking both in count
		// TODO : Fix parsing to add the collected values back into `characters` on failure.
		var text = "Hello@GG0001122";
		var expectedText = "Hello0001122";
		tbox.setText(text);
		var characters = tbox.getCharacters();

		Assert.areEqual(Utf8.length(expectedText), characters.length);

		matchTextAgainstCharacters(expectedText, characters);
	}

	// Small helpers
	function matchSequences(expected:CommandValues, actual:CommandValues)
	{
		Assert.areEqual(expected.command, actual.command);
		Assert.areEqual(expected.activated, actual.activated);
		Assert.areEqual(expected.arg1, actual.arg1);
		Assert.areEqual(expected.arg2, actual.arg2);
		Assert.areEqual(expected.arg3, actual.arg3);
	}

	function matchTextAgainstCharacters(expectedText:String, characters:Array<TextboxCharacter>)
	{
		for (i in 0...Utf8.length(expectedText))
		{
			Assert.areEqual(expectedText.substr(i,1),  characters[i]);
		}
	}
}