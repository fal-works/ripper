package ripper.macro;

#if macro
import sneaker.string_buffer.StringBuffer;
import sneaker.print.Printer;
import sneaker.log.MacroLogger;

using sneaker.log.MacroLogger;

/**
	Logging functions used in macro context of `ripper`.
**/
class Logger {
	#if !ripper_log_disable
	static final debugPrefix = "[DEBUG]";
	static final infoPrefix = "[INFO]";
	static final warnPrefix = "[WARN]";

	static final logSeparator = " | ";
	#end

	public static inline function warn(content: Dynamic) {
		#if !ripper_log_disable
		printLogText(warnPrefix, content);
		#end
		MacroLogger.warn(content);
	}

	public static inline function info(content: Dynamic) {
		#if !ripper_log_disable
		printLogText(infoPrefix, content);
		#end
	}

	public static inline function debug(content: Dynamic) {
		#if (!ripper_log_disable && ripper_log_debug)
		printLogText(debugPrefix, content);
		#end
	}

	#if !ripper_log_disable
	static function printLogText(prefix: String, content: Dynamic) {
		final buffer = new StringBuffer();

		buffer.addPrefixFilePath(prefix);
		buffer.add(logSeparator);
		buffer.add(Context.getLocalClass());
		buffer.add(logSeparator);
		buffer.add(content);

		Printer.println(buffer.toString());
	}
	#end
}
#end
