require "ISUI/ISPanelJoypad"
require "ISUI/ISUI3DModel"

require "XpSystem/ISUI/ISCharacterScreen"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

local PZ_CS_Render = ISCharacterScreen.render;

function ISCharacterScreen:render()
    -- Call original function
    PZ_CS_Render(self);

    -- Variables from PZ_CS_Render
    local z = 25; -- z start
	local nameText = self.char:getDescriptor():getForename().." "..self.char:getDescriptor():getSurname()
	local nameX = self.avatarX + self.avatarWidth + 25
	local nameWid = getTextManager():MeasureStringX(UIFont.Medium, nameText)

    local professionWid = self.profImage:getWidth()

    local hairWidth = getTextManager():MeasureStringX(UIFont.Small, self.hairStyle)
	local beardWidth = self.char:isFemale() and 0 or getTextManager():MeasureStringX(UIFont.Small, self.beardStyle)
	local hairBeardButtonX = self.xOffset + 10 + math.max(hairWidth, beardWidth) + 10
	
    local panelWidth = self.avatarX + self.avatarWidth + 25 + nameWid + 20 + professionWid + 20
	panelWidth = math.max(panelWidth, nameX + nameWid + 40 + self.profImage.width + 20)
	panelWidth = math.max(panelWidth, hairBeardButtonX + self.hairButton.width + 20)
	
    -- Keep up with changes to local z when rendering Character Info
    z = z + FONT_HGT_MEDIUM; -- z after showing profession
	z = z + 10; -- z after drawing border
	local smallFontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
    z = z + smallFontHgt; -- z BEFORE drawing weight info
	z = z + smallFontHgt; -- z AFTER drawing weight info

	local traitBottom = z;
	local finalY = z + (math.max(FONT_HGT_SMALL, 18) - 18) / 2 + 2;
    
    local favFoodTraits = {};
    -- Redraw traits to remove the Favorite Food from other traits
    if #self.traits > 0 then
        for i, v in ipairs(self.traits) do
            local textureName = v:getTexture():getName()
            local isFavoriteFood = string.find(textureName, "favFood");
            if isFavoriteFood == nil then
                v:setY(y);
                v:setX(x);
                v:setVisible(true);
                traitBottom = y + v:getTexture():getHeightOrig() + 2
                x = x + v:getTexture():getWidthOrig() + 6;
                if (i < #self.traits) and (x + v:getTexture():getWidthOrig() > self:getWidth() - 20) then
                    x = self.xOffset + 10
                    y = y + v:getTexture():getHeightOrig() + 2
                end
            else
                table.insert(favFoodTraits, v);
            end
        end
        finalY = y + self.traits[1]:getTexture():getHeightOrig();
    end
    finalY = finalY + 20;

    if #favFoodTraits > 0 then
        self:drawTextRight("Fav Food", self.xOffset, (finalY - 20), 1,1,1,1, UIFont.Small);
        local x = self.xOffset + 10;
        local y = z + (math.max(FONT_HGT_SMALL, 18) + 20) / 2 + 2
        for index, val in ipairs(favFoodTraits) do
            val:setY(y);
            val:setX(x);
            val:setVisible(true);
        end
    end

	z = self.literatureButton:getBottom();
	z = math.max(z + 16, traitBottom);
	z = math.max(z, self.avatarY + self.avatarHeight + 25)
	local textWid1 = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_char_Favourite_Weapon"))
	local textWid2 = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_char_Zombies_Killed"))
	local textWid3 = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_char_Survived_For"))
	local x = 20 + math.max(textWid1, math.max(textWid2, textWid3))


end -- Render