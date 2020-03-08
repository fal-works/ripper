package ripper.macro;

#if macro
import haxe.ds.StringMap;
import haxe.macro.Compiler;

class SoulMacro {
	@:persistent public static final fieldsMap = new StringMap<Array<Field>>();

	macro public static function register(): BuildMacroResult {
		log('Start registering Soul fields.');

		final localType = Context.getLocalType();
		if (localType == null) {
			log('Tried to process something that is not a type. Break registration.');
			return null;
		}

		final localTypePath = TypeTools.toString(localType);

		final localFields = Context.getBuildFields();
		fieldsMap.set(localTypePath, localFields);
		log('Registered fields.');

		Compiler.exclude(localTypePath, false);
		log('Excluded this type from compilation.');

		return null;
	}
}
#end
