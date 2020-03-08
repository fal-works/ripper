package ripper.macro;

#if macro
import haxe.ds.StringMap;
import haxe.macro.Compiler;

class SoulMacro {
	@:persistent public static final fieldsMap = new StringMap<Array<Field>>();

	macro public static function register(): BuildMacroResult {
		debug('Start registration of Soul fields.');

		final localType = Context.getLocalType();
		if (localType == null) {
			warn('Tried to process something that is not a type.');
			debug('Break registration.');
			return null;
		}

		final localTypePath = TypeTools.toString(localType);

		final localFields = Context.getBuildFields();
		fieldsMap.set(localTypePath, localFields);
		if (localFields.length > 0)
			debug('Registered Soul fields for copying to Body.');
		else
			warn('Marked as Soul but no fields for copying to Body.');

		Compiler.exclude(localTypePath, false);
		debug('Exclude this type from compilation. End registration.');

		return null;
	}
}
#end
