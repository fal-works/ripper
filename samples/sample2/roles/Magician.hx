package roles;

class Magician extends GameCharacter implements ripper.Spirit {
	public function magic() {
		trace('${this.name} chanted magic!');
	}
}
