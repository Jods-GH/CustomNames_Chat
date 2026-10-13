local lib = LibStub("CustomNames")
local AceHook = LibStub("AceHook-3.0")


local function convertName(msg, name)
	local customName = lib.Get(name)
	if customName ~= name then
		local color = msg:match("|c(%x%x%x%x%x%x%x%x)(.-)|r")
		if color then
			local colorCodedName = WrapTextInColorCode(customName, color)
			return "|Hplayer:"..name.."|h["..colorCodedName.."]|h" 
		else
			return "|Hplayer:"..name.."|h["..customName.."]|h" 
		end
	end
end

local function GetBattleTag(bnetIDAccount)
	if not bnetIDAccount then return end
	local info = C_BattleNet.GetAccountInfoByID(bnetIDAccount)
	if not info then return end
	local tag = info.battleTag
	if tag == nil or issecretvalue(tag) then return end
	return tag
end

local function convertBNName(msg, linkData)
	local _, bnetIDAccount = strsplit(":", linkData, 5)
	local btag = GetBattleTag(tonumber(bnetIDAccount))
	if not btag then return end

	local customName = lib.Get(btag)
	if customName and customName ~= btag then
		local color = msg:match("|c(%x%x%x%x%x%x%x%x)(.-)|r")
		if color then
			customName = WrapTextInColorCode(customName, color)
		end
		return "|HBNplayer:"..linkData.."|h["..customName.."]|h"
	end
end

function AceHook:AddMessage(frame, text, ...)
	if issecretvalue(text) then return self.hooks[frame].AddMessage(frame, text, ...) end
	if text and type(text) == "string" then
		text = text:gsub("(|Hplayer:([^:]+).-|h.-|h)", convertName)
		text = text:gsub("(|HBNplayer:(.-)|h.-|h)", convertBNName)
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G["ChatFrame" .. i]
	if cf ~= COMBATLOG then
		AceHook:RawHook(cf, "AddMessage", true)
	end
end
