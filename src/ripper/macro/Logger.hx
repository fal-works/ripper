package ripper.macro;

#if macro
import sneaker.string_buffer.StringBuffer;
import sneaker.print.Printer.println;

using sneaker.log.MacroLogger;

class Logger {
	static final logPrefix = "[RIPPER]";
	static final logSeparator = " | ";

	public static function log(content: Dynamic) {
		final buffer = new StringBuffer();

		buffer.addPrefixFilePath(logPrefix);
		buffer.add(logSeparator);
		buffer.add(Context.getLocalClass());
		buffer.add(logSeparator);
		buffer.add(content);

		println(buffer.toString());
	}
}
#end
