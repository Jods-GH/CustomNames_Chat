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

function AceHook:AddMessage(frame, text, ...)
	if text and type(text) == "string" then 
		text = text:gsub("(|Hplayer:([^:]+).-|h.-|h)", convertName)
	end
	return self.hooks[frame].AddMessage(frame, text, ...)
end

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G["ChatFrame" .. i]
	if cf ~= COMBATLOG then
		AceHook:RawHook(cf, "AddMessage", true)
	end
end
