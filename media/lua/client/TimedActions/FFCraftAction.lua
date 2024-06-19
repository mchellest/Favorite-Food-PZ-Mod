require "TimedActions/ISBaseTimedAction"

ISCraftAction = ISBaseTimedAction:derive("ISCraftAction");

local PZ_Craft_Perform = ISCraftAction.perform;

function ISCraftAction:perform()
  -- Call original function
  PZ_Craft_Perform(self);
  
	local resultItemCreated = RecipeManager.PerformMakeItem(self.recipe, self.item, self.character, self.containers);
  if resultItemCreated and instanceof(resultItemCreated, "Food") and instanceof(self.item, "Food") then
		-- TODO: this could be improved by checking/averaging all the items involved
		resultItemCreated:setHeat(self.item:getHeat());
		resultItemCreated:setFreezingTime(self.item:getFreezingTime());
		resultItemCreated:setFrozen(self.item:isFrozen());
	end
  if resultItemCreated and self.recipe:getResult():getCount() > 1 then
		-- FIXME: this does not call the recipe's OnCreate lua function
		local itemsAdded = self.container:AddItems(resultItemCreated:getFullType(), self.recipe:getResult():getCount());
		-- now we modify the variables of the item created, for example if you create a nailed baseball bat, it'll have the condition of the used baseball bat
		if itemsAdded and instanceof(resultItemCreated, "Food") then
			for i=0, itemsAdded:size()-1 do
				local newItem = itemsAdded:get(i);
				if resultItemCreated:isCustomName() then
					newItem:setName(resultItemCreated:getDisplayName());
					newItem:setCustomName(true);
				end
				newItem:setCooked(resultItemCreated:isCooked());
				newItem:setRotten(true);
				newItem:setBurnt(resultItemCreated:isBurnt());
				newItem:setAge(resultItemCreated:getAge());
				newItem:setHungChange(resultItemCreated:getHungChange());
				newItem:setBaseHunger(resultItemCreated:getBaseHunger());
				newItem:setThirstChange(resultItemCreated:getThirstChangeUnmodified());
				newItem:setPoisonDetectionLevel(resultItemCreated:getPoisonDetectionLevel());
				newItem:setPoisonPower(resultItemCreated:getPoisonPower());
				newItem:setCarbohydrates(resultItemCreated:getCarbohydrates());
				newItem:setLipids(resultItemCreated:getLipids());
				newItem:setProteins(resultItemCreated:getProteins());
				newItem:setCalories(resultItemCreated:getCalories());
				newItem:setTaintedWater(resultItemCreated:isTaintedWater());
				newItem:setActualWeight(resultItemCreated:getActualWeight());
				newItem:setWeight(resultItemCreated:getWeight());
				newItem:setCustomWeight(resultItemCreated:isCustomWeight());
				--set the new items heat/freezing/frozen
				newItem:setHeat(resultItemCreated:getHeat());
				newItem:setFreezingTime(resultItemCreated:getFreezingTime());
				newItem:setFrozen(resultItemCreated:isFrozen());
				newItem:setBoredomChange(resultItemCreated:getBoredomChangeUnmodified());
				newItem:setUnhappyChange(resultItemCreated:getUnhappyChangeUnmodified());
			end
		end
  end
end
