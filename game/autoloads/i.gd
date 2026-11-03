@tool
extends "res://addons/popochiu/engine/interfaces/i_inventory.gd"

# classes ----
const PIIBasket := preload("res://game/inventory_items/basket/inventory_item_basket.gd")
const PIILantern := preload("res://game/inventory_items/lantern/inventory_item_lantern.gd")
const PIINotebook := preload("res://game/inventory_items/notebook/inventory_item_notebook.gd")
const PIIWateringCan := preload("res://game/inventory_items/watering_can/inventory_item_watering_can.gd")
const PIIHandMirror := preload("res://game/inventory_items/hand_mirror/inventory_item_hand_mirror.gd")
const PIIHoneyJar := preload("res://game/inventory_items/honey_jar/inventory_item_honey_jar.gd")
const PIIStone := preload("res://game/inventory_items/stone/inventory_item_stone.gd")
# ---- classes

# nodes ----
var Basket: PIIBasket : get = get_Basket
var Lantern: PIILantern : get = get_Lantern
var Notebook: PIINotebook : get = get_Notebook
var WateringCan: PIIWateringCan : get = get_WateringCan
var HandMirror: PIIHandMirror : get = get_HandMirror
var HoneyJar: PIIHoneyJar : get = get_HoneyJar
var Stone: PIIStone : get = get_Stone
# ---- nodes

# functions ----
func get_Basket() -> PIIBasket: return get_item_instance("Basket")
func get_Lantern() -> PIILantern: return get_item_instance("Lantern")
func get_Notebook() -> PIINotebook: return get_item_instance("Notebook")
func get_WateringCan() -> PIIWateringCan: return get_item_instance("WateringCan")
func get_HandMirror() -> PIIHandMirror: return get_item_instance("HandMirror")
func get_HoneyJar() -> PIIHoneyJar: return get_item_instance("HoneyJar")
func get_Stone() -> PIIStone: return get_item_instance("Stone")
# ---- functions
