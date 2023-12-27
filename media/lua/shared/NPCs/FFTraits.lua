require "FFList";

FFTraitsDetails = {};
-- addTrait(string: Name, string: Name, int: Cost, string: Tooltip text, boolean: isFree)
-- Traits that have isFree as true will not show the tooltip text on hover
-- Traits that have isFree as false will be sorted into Good/Bad traits and show tooltip on hover
FFTraitsDetails.DoTraits = function ()
    -- Set up code to dynamically create Favorite Food traits based on lists from FFList in the future
    -- Currently not working
    -- if #FFList > 0 then
    --     TraitFactory.addTrait("FavFoodChicken", "FFListTest", 0, "This increases positive buffs your character gets from eating Chicken", false);

    --     for _, listItem in ipairs(FFList) do
    --         TraitFactory.addTrait("FavFoodChicken", "Test", 0, "This increases positive buffs your character gets from eating Chicken", false);

    --         local traitName = "FavFood"+listItem;
    --         local traitTooltipText = "This increases positive buffs your character gets from eating "+listItem;
    --         TraitFactory.addTrait(traitName, listItem, 0, traitTooltipText, false);
    --     end
    -- end
   
    local favFoodChicken = TraitFactory.addTrait("FavFoodChicken", "Chicken", 0, "This increases positive buffs your character gets from eating Chicken", false);
    local favFoodBacon = TraitFactory.addTrait("FavFoodBacon", "Bacon", 0, "This increases positive buffs your character gets from eating Bacon", false);
    local favFoodApple = TraitFactory.addTrait("FavFoodApple", "Apple", 0, "This increases positive buffs your character gets from eating Apples", false);
    local favFoodBanana = TraitFactory.addTrait("FavFoodBanana", "Banana", 0, "This increases positive buffs your character gets from eating Bananas", false);
    local favFoodAvocado = TraitFactory.addTrait("FavFoodAvocado", "Avocado", 0, "This increases positive buffs your character gets from eating Avocados", false);
    local favFoodCheese = TraitFactory.addTrait("FavFoodCheese", "Cheese", 0, "This increases positive buffs your character gets from eating Cheese", false);

    TraitFactory.sortList();

end

Events.OnGameBoot.Add(FFTraitsDetails.DoTraits);