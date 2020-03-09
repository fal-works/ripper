package sample2.roles;

class Magician extends sample2.GameCharacter implements ripper.Spirit {
	public function magic() {
		trace('${this.name} chanted magic!');
	}
}
