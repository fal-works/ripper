package roles;

class Attacker extends GameCharacter implements ripper.Spirit {
	public function attack() {
		trace('${this.name} attacked!');
		trace('${this.offence} damage on the opponent!');
	}
}

class HardAttacker extends GameCharacter implements ripper.Spirit {
	public function attackHard() {
		trace('${this.name} attacked hard!!');
		trace('${2 * this.offence} damage on the opponent!');
	}
}
