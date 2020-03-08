package ripper.macro;

#if macro
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.TypeTools;
import sneaker.print.Printer.println;
import sneaker.string_buffer.StringBuffer;

using sneaker.log.MacroLogger;

class SoulMacro {
	static final logPrefix = "[RIPPER]";
	static final logSeparator = " | ";

	static function log(content: Dynamic) {
		final buffer = new StringBuffer();
		buffer.addPrefixFilePath(logPrefix);
		buffer.add(logSeparator);
		buffer.add(Context.getLocalClass());
		buffer.add(logSeparator);
		buffer.add(content);
		println(buffer.toString());
	}

	public static final fieldsMap = new StringMap<Array<Field>>();

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
