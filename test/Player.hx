@:ripper_spirits(roles.Attacker, roles.Magician)
@:ripper_spirits(roles.Attacker.HardAttacker)
class Player extends GameCharacter implements ripper.Body {}

@:ripper_verified
@:ripper_spirits(roles.Priest)
class ExtendedPlayer extends Player {}
