@:ripper.spirits(roles.Attacker, roles.Magician)
@:ripper.spirits(roles.Attacker.HardAttacker)
class Player extends GameCharacter implements ripper.Body {}

@:ripper.verified
@:ripper.spirits(roles.Priest)
class ExtendedPlayer extends Player {}
