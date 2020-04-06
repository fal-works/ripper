package roles;

@:ripper_preserve
class Priest extends GameCharacter implements ripper.Spirit {
	public function heal() {
		trace('${this.name} healed!');
	}
}
