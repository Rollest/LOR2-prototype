extends Resource
class_name UnitConfig

@export var hp:int
@export var maxHP:int
@export var sp:int
@export var maxSP:int
@export var speed:Array[int]
@export var deck:Array[CardConfig]
@export var hand:Array[CardConfig]
@export var mana:int
@export var status:Array[Keyword]
@export var texture: CompressedTexture2D
@export var unit_name: String

func values(base: UnitConfig):
	hp= base.hp
	maxHP=base.maxHP
	sp=base.sp
	maxSP=base.maxSP
	speed=base.speed
	deck=base.deck
	hand=base.hand
	mana=base.mana
	status=base.status
	texture=base.texture
	unit_name=base.unit_name
