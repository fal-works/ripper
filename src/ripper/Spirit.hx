package ripper;

/**
	Interface for indicating that it is a reusable component for other class
	that are marekd with `Body` interface.
**/
@:autoBuild(ripper.macro.SpiritMacro.register())
interface Spirit {}
