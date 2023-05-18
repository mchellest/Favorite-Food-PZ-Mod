FFTraitsDetails = {};
-- addTrait(string: Name, string: Name, int: Cost, string: Tooltip text, boolean: isFree)
-- Traits that have isFree as true will not show the tooltip text on hover
-- Traist that have isFree as false will be sorted into Good/Bad traits and show tooltip on hover

-- TODO: Reference how adding a profession adds the "free" traits from that profession into listboxSelectedTraits 
--          then apply that same code to onDblClickFavFood
--          (currently: add food > (nothing), double click > (errors out))
FFTraitsDetails.DoTraits = function ()
    local favFoodChicken = TraitFactory.addTrait("FavFoodChicken", "Chicken", 0, "This increases positive buffs your character gets from eating Chicken", false);
    local favFoodBacon = TraitFactory.addTrait("FavFoodBacon", "Bacon", 0, "This increases positive buffs your character gets from eating Bacon", false);

end

Events.OnGameBoot.Add(FFTraitsDetails.DoTraits);