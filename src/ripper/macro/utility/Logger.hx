package ripper.macro.utility;

#if macro
import haxe.PosInfos;
import sneaker.string_buffer.StringBuffer;
import sneaker.print.Printer;
import sneaker.macro.CompilerMessage;
import sneaker.log.LogFormats.alignmentPosition;

using sneaker.macro.StringBufferLogExtension;
using sneaker.format.PosInfosExtension;

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

	/**
		Prints warning in a macro context.
		Also displays a compilation warning.
	**/
	public static inline function warn(content: Dynamic) {
		#if !ripper_log_disable
		printLogText(warnPrefix, content);
		#end
		CompilerMessage.warn(content);
	}

	/**
		Prints info in a macro context.
	**/
	public static inline function info(content: Dynamic) {
		#if !ripper_log_disable
		printLogText(infoPrefix, content);
		#end
	}

	/**
		Prints debug log in a macro context.
	**/
	public static inline function debug(content: Dynamic) {
		#if (!ripper_log_disable && ripper_log_debug)
		printLogText(debugPrefix, content);
		#end
	}

	/**
		Prints debug log out of a macro context.
	**/
	public static inline function debugWithoutContext(content: Dynamic, ?pos: PosInfos) {
		#if (!ripper_log_disable && ripper_log_debug)
		final buffer = new StringBuffer();
		buffer.addRightPadded(debugPrefix, " ".code, alignmentPosition);
		buffer.add(content);
		buffer.addChar(" ".code);
		buffer.addChar("(".code);
		buffer.add(pos.formatClassMethod());
		buffer.addChar(")".code);

		Printer.println(buffer.toString());
		#end
	}

	/**
		Prints any log text with `prefix` in a macro context.
	**/
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
