package ripper;

/**
	Interface for indicating that it is not fully implemented by itself and
	needs other classes that are marked with `Spirit` interface.

	Set `@:ripper.spirits(...)` metadata for each class that implements `Body`.
	Any `Spirit` class can be specified here so that the implementation will be
	copied from the `Spirit` to the `Body`.
**/
@:autoBuild(ripper.macro.BodyMacro.build())
interface Body {}
