extends Resource
class_name ItemData

@export var id: String
@export var name: String
@export var description: String

@export_enum("CONSUMABLE", "WEAPON", "ARMOR", "MATERIAL")
var type: String
