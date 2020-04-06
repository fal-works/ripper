package ripper;

/**
	Interface for indicating that it is a data class.

	By implementing this, the constructor of the class is automatically
	completed according to the non-initialized variables.
**/
@:autoBuild(ripper.macro.DataMacro.build())
interface Data {}
