package ripper.macro;

#if macro
import haxe.macro.Type.ClassType;

/**
	Global context of the whole process of ripper.
**/
class RipperContext {
	/**
		Is set by `setVerificationState()`.
		DEBUG and INFO logs are suppressed if this is `true`.
	**/
	public static var verified(default, null) = false;

	/**
		The opposite value of `verified`.
	**/
	public static var notVerified(default, null) = true;

	/**
		Sets `verified` and `notVerified` according to the `@:ripper.verified` metadata.
	**/
	public static function setVerificationState(classType: ClassType): Void {
		verified = (classType.meta.has(verifiedMetadataName));
		notVerified = !verified;
	}
}
#end
