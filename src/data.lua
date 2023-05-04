if settings.startup["meaningful-inventory-size-enable"].value then
	data.raw.character.character.inventory_size = settings.startup["meaningful-inventory-size"].value
end

if settings.startup["meaningful-reach-enable"].value then
	data.raw.character.character.build_distance = settings.startup["meaningful-reach"].value
	data.raw.character.character.drop_item_distance = settings.startup["meaningful-reach"].value
	data.raw.character.character.item_pickup_distance = settings.startup["meaningful-reach"].value
	data.raw.character.character.loot_pickup_distance = settings.startup["meaningful-reach"].value
	data.raw.character.character.reach_distance = settings.startup["meaningful-reach"].value
	data.raw.character.character.reach_resource_distance = settings.startup["meaningful-reach"].value
end
