package ripper.macro.utility;

import haxe.macro.Type.ClassType;

class ClassTypeExtension {
	public static function inheritsMetadata(classType: ClassType, metadataName: String): Bool {
		final superClass = classType.superClass;
		if (superClass == null) return false;

		final superClassType = superClass.t.get();
		if (superClassType.meta.has(metadataName)) return true;

		return inheritsMetadata(superClassType, metadataName);
	}
}
