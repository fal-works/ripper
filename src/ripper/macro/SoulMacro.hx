package ripper.macro;

#if macro
import haxe.ds.StringMap;
import haxe.macro.Compiler;

class SoulMacro {
	@:persistent public static final fieldsMap = new StringMap<Array<Field>>();

	macro public static function register(): BuildMacroResult {
		debug('Start registering Soul fields.');

		final localType = Context.getLocalType();
		if (localType == null) {
			warn('Tried to process something that is not a type.');
			debug('Break registration.');
			return null;
		}

		final localTypePath = TypeTools.toString(localType);

		final localFields = Context.getBuildFields();
		fieldsMap.set(localTypePath, localFields);
		info('Registered Soul fields for copying to Body.');

		Compiler.exclude(localTypePath, false);
		debug('Excluded this type from compilation.');

		return null;
	}
}
#end
