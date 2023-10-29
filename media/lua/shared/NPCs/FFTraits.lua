FFTraitsDetails = {};
-- addTrait(string: Name, string: Name, int: Cost, string: Tooltip text, boolean: isFree)
-- Traits that have isFree as true will not show the tooltip text on hover
-- Traits that have isFree as false will be sorted into Good/Bad traits and show tooltip on hover
FFTraitsDetails.DoTraits = function ()
    local favFoodChicken = TraitFactory.addTrait("FavFoodChicken", "Chicken", 0, "This increases positive buffs your character gets from eating Chicken", false);
    local favFoodBacon = TraitFactory.addTrait("FavFoodBacon", "Bacon", 0, "This increases positive buffs your character gets from eating Bacon", false);

    -- TraitFactory.sortList();

end

Events.OnGameBoot.Add(FFTraitsDetails.DoTraits);