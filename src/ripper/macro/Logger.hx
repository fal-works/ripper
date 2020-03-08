package ripper.macro;

#if macro
import sneaker.string_buffer.StringBuffer;
import sneaker.print.Printer;
import sneaker.log.MacroLogger;

using sneaker.log.MacroLogger;

class Logger {
	static final debugPrefix = "[DEBUG]";
	static final infoPrefix = "[INFO]";
	static final warnPrefix = "[WARN]";

	static final logSeparator = " | ";

	static function printLogText(prefix: String, content: Dynamic) {
		final buffer = new StringBuffer();

		buffer.addPrefixFilePath(prefix);
		buffer.add(logSeparator);
		buffer.add(Context.getLocalClass());
		buffer.add(logSeparator);
		buffer.add(content);

		Printer.println(buffer.toString());
	}

	public static inline function debug(content: Dynamic) {
		#if (!ripper_log_disable && ripper_log_verbose)
		printLogText(debugPrefix, content);
		#end
	}

	public static inline function info(content: Dynamic) {
		#if !ripper_log_disable
		printLogText(infoPrefix, content);
		#end
	}

	public static inline function warn(content: Dynamic) {
		#if !ripper_log_disable
		printLogText(warnPrefix, content);
		#end
		MacroLogger.warn(content);
	}
}
#end
