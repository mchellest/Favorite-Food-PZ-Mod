-- Future Idea: Include Mod options that include Fruit, Veggies with regular Food for Favorite Foods Options
FFFruit = { "Apple", "Banana", "Berry", "Cherry", "Grapefruit", "Grapes", "Lemon", "Lime", "Mango", "Orange", "Peach", "Pear", "Pineapple", "Strawberries", "Watermelon" };
FFVeggies = { "Avocado", "Bell Pepper", "Black Beans", "Broccoli", "Cabbage", "Carrots", "Corn", "Eggplant", "Leek", "Lettuce", "Mixed Vegetables", "Mushroom", "Onion", "Peas", "Potato", "Radish", "Tomato", "Zucchini" };
FFPerishableFood = { "Bacon", "Bagel", "Baguette", "Baloney", "Bass", "Biscuit", "Black Forrest Cake", "Bread", "Burger", "Burrito", "Carrot Cake", "Catfish", "Cheese", "Cheese Cake Slice", "Chicken", "Chocolate", "Corndog", "Croissant", "Cupcake", "Doughnut", "Egg", "Fries", "Granola Bar", "Ground Beef", "Guacamole", "Ham", "Hot Dog", "Ice Cream", "Jalapeno", "Lobster", "Maki", "Mayonnaise",  "Meat Patty", "Milk", "Mutton Chop", "Noodles", "Onigiri", "Pancakes", "Peanut Butter Sandwich", "Pepperoni", "Pie", "Pizza", "Poached Egg", "Poppy Bagel", "Pork Chop", "Potato Pancakes", "Processed Cheese", "Refied Beans", "Salami", "Salmon", "Sausage", "Scrambled Eggs", "Shrimp", "Spring Roll", "Squid", "Steak", "Sunfish", "Taco", "Toast", "Tortilla", "Waffles", "Yogurt" };

FFTraitsDetails = {};
-- addTrait(string: Name, string: Name, int: Cost, string: Tooltip text, boolean: isFree)
-- Traits that have isFree as true will not show the tooltip text on hover
-- Traits that have isFree as false will be sorted into Good/Bad traits and show tooltip on hover
FFTraitsDetails.DoTraits = function ()

  for i, value in ipairs(FFFruit) do
    TraitFactory.addTrait("FavFood"..value, value, 0, "This increases positive buffs your character gets from eating "..value, false);
  end
  for i, value in ipairs(FFVeggies) do
    TraitFactory.addTrait("FavFood"..value, value, 0, "This increases positive buffs your character gets from eating "..value, false);
  end
  for i, value in ipairs(FFPerishableFood) do
    TraitFactory.addTrait("FavFood"..value, value, 0, "This increases positive buffs your character gets from eating "..value, false);
  end

  TraitFactory.sortList();

end

Events.OnGameBoot.Add(FFTraitsDetails.DoTraits);