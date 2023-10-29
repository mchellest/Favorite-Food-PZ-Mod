
require"ISUI/ISPanel"
require"ISUI/ISButton"
require"ISUI/ISInventoryPane"
require"ISUI/ISResizeWidget"
require"ISUI/ISRichTextPanel"
require"ISUI/ISMouseDrag"
require"defines"
require"OptionScreens/CharacterCreationProfession";

local CharacterCreationProfessionListBox = ISScrollingListBox:derive("CharacterCreationProfessionListBox")
local CharacterCreationProfessionPresetPanel = ISPanelJoypad:derive("CharacterCreationProfessionPresetPanel")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_TITLE = getTextManager():getFontHeight(UIFont.Title)

local PZ_CCP_Create = CharacterCreationProfession.create;
local PZ_CCP_Prerender = CharacterCreationProfession.prerender;
local PZ_CCP_Render = CharacterCreationProfession.render;

local PZ_CCP_AddTrait = CharacterCreationProfession.addTrait;
local PZ_CCP_DrawTraitMap = CharacterCreationProfession.drawTraitMap; -- Draw the list of available traits
local PZ_CCP_OnOptionMouseDown = CharacterCreationProfession.onOptionMouseDown;
local PZ_CCP_RemoveTrait = CharacterCreationProfession.removeTrait;

function CharacterCreationProfession:create()
    -- Call original function
    PZ_CCP_Create(self)

    -- Taken from original function,
	local buttonHgt = FONT_HGT_SMALL + 3 * 2

    local w = self.width * 0.75;
	local h = self.height * 0.8;
	if (w < 768) then
		w = 768;
	end
	local screenWid = self.width;
	local screenHgt = self.height;

	self.tablePadX = 20
	self.tableWidth = (self.mainPanel:getWidth() - 16 * 2 - self.tablePadX * 2) / 3
	self.topOfLists = 48
	self.tooltipHgt = FONT_HGT_SMALL
	if self.width <= 1980 then
		self.tooltipHgt = FONT_HGT_SMALL * 2
	end
	self.belowLists = 5 + buttonHgt + 4 + math.max(FONT_HGT_MEDIUM, self.tooltipHgt) + 5
	self.bottomOfLists = self.mainPanel:getHeight() - self.belowLists
	self.smallFontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight() + 1
	self.mediumFontHgt = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight()
	self.traitButtonHgt = buttonHgt
	self.traitButtonPad = 6

    local traitButtonGap = self.traitButtonPad * 2 + self.traitButtonHgt
	local halfListHeight = (self.bottomOfLists - self.topOfLists - self.smallFontHgt - traitButtonGap) / 2
    
    -- Create Listbox for Favorite Foods
    self.listboxFavFood = CharacterCreationProfessionListBox:new((w / 3),  self.topOfLists + self.smallFontHgt, self.tableWidth, halfListHeight);
    self.listboxFavFood:initialise();
    self.listboxFavFood:instantiate();
    self.listboxFavFood:setAnchorLeft(true);
    self.listboxFavFood:setAnchorRight(false);
    self.listboxFavFood:setAnchorTop(false);
    self.listboxFavFood:setAnchorBottom(true);
    self.listboxFavFood.itemheight = 30;
    self.listboxFavFood.selected = -1;
    self:populateFavFoodList(self.listboxFavFood);
    self.listboxFavFood.doDrawItem = PZ_CCP_DrawTraitMap;
    self.listboxFavFood:setOnMouseDownFunction(self, CharacterCreationProfession.onSelectFavFood);
    self.listboxFavFood:setOnMouseDoubleClick(self, CharacterCreationProfession.onDblClickFavFood);
    self.listboxFavFood.resetSelectionOnChangeFocus = true;
    self.listboxFavFood.drawBorder = true
    self.listboxFavFood.fontHgt = self.fontHgt
    self.mainPanel:addChild(self.listboxFavFood);

    -- Create Button to choose Favorite Food
    self.addFavFoodBtn = ISButton:new(self.listboxFavFood:getX() + self.listboxFavFood:getWidth() - 50, (self.listboxFavFood:getY() + self.listboxFavFood:getHeight()) + self.traitButtonPad, 50, self.traitButtonHgt, "Add Fav Food >", self, self.onOptionMouseDown);
    self.addFavFoodBtn.internal = "ADDFAVFOOD";
    self.addFavFoodBtn:initialise();
    self.addFavFoodBtn:instantiate();
    self.addFavFoodBtn:setAnchorLeft(true);
    self.addFavFoodBtn:setAnchorRight(false);
    self.addFavFoodBtn:setAnchorTop(false);
    self.addFavFoodBtn:setAnchorBottom(true);
    self.addFavFoodBtn:setEnable(false);
    self.mainPanel:addChild(self.addFavFoodBtn);
    
end

function CharacterCreationProfession:onSelectFavFood(item)
    self.addFavFoodBtn:setEnable(true);
end

function CharacterCreationProfession:onDblClickFavFood(item)
    self:addTrait("favFood");
end

function CharacterCreationProfession:onOptionMouseDown(button, x, y)
    
    local joypadData = JoypadState.getMainMenuJoypad() or CoopCharacterCreation.getJoypad()
    if button.internal == "INFO" then
        if not self.infoRichText then
            self.infoRichText = ISModalRichText:new(getCore():getScreenWidth()/2-300,getCore():getScreenHeight()/2-300,600,600,getText("UI_CharacterCreation"), false);
            self.infoRichText.destroyOnClick = false;
            self.infoRichText:initialise();
            self.infoRichText:addToUIManager();
            self.infoRichText:setAlwaysOnTop(true);
            self.infoRichText.chatText:paginate();
            self.infoRichText.backgroundColor = {r=0, g=0, b=0, a=1};
            self.infoRichText:setHeight(self.infoRichText.chatText:getHeight() + 40);
            self.infoRichText:setY(getCore():getScreenHeight()/2-(self.infoRichText:getHeight()/2));
            if joypadData then
                self.infoRichText.prevFocus = joypadData.focus
            end
            self.infoRichText:setVisible(true, joypadData);
        else
            if joypadData then
                self.infoRichText.prevFocus = joypadData.focus
            end
            self.infoRichText:setVisible(not self.infoRichText:getIsVisible(), joypadData);
            self.infoRichText:bringToTop();
        end
    end
	if button.internal == "BACK" then
		if self.infoRichText then
			self.infoRichText:removeFromUIManager()
			self.infoRichText = nil
		end
		self:setVisible(false)
		if self.previousScreen == "NewGameScreen" then
			self.previousScreen = nil
			NewGameScreen.instance:setVisible(true, joypadData)
			return
		end
		if self.previousScreen == "LoadGameScreen" then
			self.previousScreen = nil
			LoadGameScreen.instance:setSaveGamesList()
			LoadGameScreen.instance:setVisible(true, joypadData)
			return
		end
		if self.previousScreen == "MapSpawnSelect" then
			self.previousScreen = nil
			MapSpawnSelect.instance:setVisible(true, joypadData)
			return
		end
		if self.previousScreen == "WorldSelect" then
			self.previousScreen = nil
			WorldSelect.instance:setVisible(true, joypadData)
			return
		end
		if self.previousScreen == "LastStandPlayerSelect" then
			self.previousScreen = nil
			LastStandPlayerSelect.instance:setVisible(true, joypadData)
			return
		end
		if self.previousScreen == "SandboxOptionsScreen" then
			self.previousScreen = nil
			SandboxOptionsScreen.instance:setVisible(true, joypadData)
			return
		end
		if getWorld():getGameMode() == "Multiplayer" then
			backToSinglePlayer()
			getCore():ResetLua("default", "exitJoinServer")
			return
		end
	end
	if button.internal == "NEXT" then
		if self.infoRichText then
			self.infoRichText:removeFromUIManager()
			self.infoRichText = nil
		end
		MainScreen.instance.charCreationProfession:setVisible(false);
		MainScreen.instance.charCreationMain:setVisible(true, joypadData);
	end
	if button.internal == "ADDTRAIT" then
		if self.listboxTrait.selected > 0 then
			self:addTrait(false);
            self:checkXPBoost();
		end
    end
    if button.internal == "ADDBADTRAIT" then
        if self.listboxBadTrait.selected > 0 then
            self:addTrait(true);
            self:checkXPBoost();
        end
    end
    if button.internal == "ADDFAVFOOD" then
        if self.listboxFavFood.selected > 0 then
            self:addTrait("favFood");
            self:toggleStateFavFoodBtn(button.enable)
        end
    end
	if button.internal == "REMOVETRAIT" then
		if self.listboxTraitSelected.selected > 0 then
			self:removeTrait();
            self:checkXPBoost();
		end
	end
	if button.internal == "RESETTRAITS" then
		self:resetTraits();
	end
end

function CharacterCreationProfession:addTrait(bad)
    local list = self.listboxTrait;
    local favFoodSelected = false;
    if bad then
        list = self.listboxBadTrait;
    end
    if bad == "favFood" then -- FF Mod
        list = self.listboxFavFood;

        favFoodSelected = self:checkForFavFood(); -- Check to see if Fav Food trait has already been added
    end
	local selectedTrait = list.items[list.selected].text;
	-- points left calcul
	self.pointToSpend = self.pointToSpend - list.items[list.selected].item:getCost();
	-- remove from the available traits
	local newItem = self.listboxTraitSelected:addItem(selectedTrait, list.items[list.selected].item);
	newItem.tooltip = list.items[list.selected].tooltip;
	-- then we remove the mutualy exclusive traits
	self:mutualyExclusive(list.items[list.selected].item, false);
	-- add into our selected traits
    list:removeItem(selectedTrait);
	-- reset cursor
	self.listboxTraitSelected.selected = -1;
    self.listboxBadTrait.selected = -1;
    self.listboxFavFood.selected = -1; -- FF Mod
    self.listboxTrait.selected = -1;
	self.removeTraitBtn:setEnable(false);
	self.addTraitBtn:setEnable(false);
    self.addBadTraitBtn:setEnable(false);
    self.addFavFoodBtn:setEnable(false); -- FF Mod

    if favFoodSelected ~= false then -- If not false, we were returned the existing Fav Food Trait
        self:removeTrait(favFoodSelected); -- Remove; Essentially swap the traits
    end
    CharacterCreationMain.sort(self.listboxTraitSelected.items);
end

-- Remove Trait
function CharacterCreationProfession:removeTrait(favFood)
    local trait = nil;
    if favFood ~= nil then
        trait = favFood;
    else
        trait = self.listboxTraitSelected.items[self.listboxTraitSelected.selected].item;
    end
	if not trait:isFree() then
		-- remove from the selected traits
		self.listboxTraitSelected:removeItem(trait:getLabel());
		-- points left calcul
		self.pointToSpend = self.pointToSpend + trait:getCost();
		-- add to available traits
        local newItem = {};
        if trait:getCost() > 0 then
    		newItem = self.listboxTrait:addItem(trait:getLabel(), trait);
        end
        if trait:getCost() < 0 then -- Modified
            newItem = self.listboxBadTrait:addItem(trait:getLabel(), trait);
        end
        if trait:getCost() == 0 then
            newItem = self.listboxFavFood:addItem(trait:getLabel(), trait); -- FF Mod
        end
        newItem.tooltip = trait:getDescription();
		-- add traits excluded by the removed trait back to the available-traits lists
		self:mutualyExclusive(trait, true);
		-- reset cursor
		self.listboxTraitSelected.selected = -1;
		self.listboxTrait.selected = -1;
        self.listboxBadTrait.selected = -1;
        self.listboxFavFood.selected = -1; -- FF Mod
		self.removeTraitBtn:setEnable(false);
		self.addTraitBtn:setEnable(false);
        self.addBadTraitBtn:setEnable(false);
        self.addFavFoodBtn:setEnable(false); -- FF Mod
        CharacterCreationMain.sort(self.listboxTrait.items);
        CharacterCreationMain.invertSort(self.listboxBadTrait.items);
        CharacterCreationMain:sort(self.listboxFavFood.items); -- FF Mod
	end
end

function CharacterCreationProfession:prerender()
    -- Call original function
    PZ_CCP_Prerender(self);

    local listWidth = (self.mainPanel:getWidth() - 16 * 2 - self.tablePadX * 2) / 3

    local traitButtonGap = self.traitButtonPad * 2 + self.traitButtonHgt
	local heightForHalfLists = self.bottomOfLists - self.topOfLists - self.smallFontHgt - traitButtonGap
	local halfListHeight1 = math.floor(heightForHalfLists / 2)
	local halfListHeight2 = heightForHalfLists - halfListHeight1
    local thirdListHeight = (halfListHeight1 * 2) / 3.5
    -- Adjust existing UI (Trait boxes)

    self.listboxFavFood:setX(self.listboxTrait:getX());
    self.listboxFavFood:setWidth(listWidth);

    self.addFavFoodBtn:setX(self.listboxFavFood:getRight() - self.addFavFoodBtn:getWidth());

    self.listboxTrait:setHeight(thirdListHeight) -- Updated
	self.addTraitBtn:setY(self.listboxTrait:getY() + thirdListHeight + self.traitButtonPad)

	self.listboxTraitSelected:setHeight(halfListHeight1)
	self.removeTraitBtn:setY(self.listboxTraitSelected:getY() + halfListHeight1 + self.traitButtonPad)
	
	self.listboxBadTrait:setY(self.listboxTrait:getY() + thirdListHeight + traitButtonGap)
	self.listboxBadTrait:setHeight(thirdListHeight) -- Updated
	self.addBadTraitBtn:setY(self.listboxBadTrait:getY() + thirdListHeight + self.traitButtonPad)

    self.listboxFavFood:setY(self.listboxTrait:getY() + self.smallFontHgt + (thirdListHeight * 2) + (traitButtonGap * 2))
	self.listboxFavFood:setHeight(thirdListHeight)
	self.addFavFoodBtn:setY(self.listboxFavFood:getY() + thirdListHeight + self.traitButtonPad)

	self.listboxXpBoost:setY(self.listboxTraitSelected:getY() + halfListHeight1 + traitButtonGap)
	self.listboxXpBoost:setHeight(halfListHeight2)

end

function CharacterCreationProfession:render()
    -- Call original function
    PZ_CCP_Render(self)

    -- Render text for Favorite Food list box
    self:drawText("Favorite food", self.mainPanel:getX() + self.listboxFavFood:getX(), self.listboxFavFood:getAbsoluteY() - self.smallFontHgt, 1, 1, 1, 1, UIFont.Small);

end

function CharacterCreationProfession:populateFavFoodList(list)
    local traitList = TraitFactory.getTraits();
    for i = 0, traitList:size() - 1 do
        local trait = traitList:get(i);
        print(trait);
        if not trait:isFree() and trait:getCost() == 0 then
            list:addItem(trait:getLabel(), trait);
        end
    end
end

function CharacterCreationProfession:checkForFavFood()
    local favFoodSelected = false;
    local currentTraits = self.listboxTraitSelected.items;
    if #currentTraits > 0 then
        -- Loop through the current traits to see if any are "FavFood" traits
        for i = 1, #currentTraits do
            local trait = currentTraits[i].item;
            if not trait:isFree() and trait:getCost() == 0 then
                favFoodSelected = trait;
            end
        end
    end

    return favFoodSelected;
end
