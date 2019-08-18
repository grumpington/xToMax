--Config Area

local xToMaxHeight = 20
local xToMaxWidth = 500
local xToMaxAnchor = {"CENTER", UIPARENT, "CENTER", 0, -275}
local xToMaxPoint = {"CENTER", "xToMaxBarFrame","CENTER", 0, 0}
local xToMaxTexture = "Interface\\TargetingFrame\\UI-StatusBar"
local xToMaxFont = [[Fonts\FRIZQT__.TTF]]
local xToMaxFontSize = 12
local xToMaxFontFlags = "NONE"
local xToMaxColor = { r = 0, g = 1, b = 0 }



function comma_value(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end

--Creating the Frame
local xToMaxBarFrame = CreateFrame("Frame", "xToMaxBarFrame", UIParent)
xToMaxBarFrame:SetFrameStrata("HIGH")
xToMaxBarFrame:SetHeight(xToMaxHeight)
xToMaxBarFrame:SetWidth(xToMaxWidth)
xToMaxBarFrame:SetPoint(unpack(xToMaxAnchor))
xToMaxBarFrame:EnableMouse(true)
xToMaxBarFrame:SetMovable(true)
xToMaxBarFrame:SetResizable(true)
xToMaxBarFrame:SetClampedToScreen(true)

--Creating background and border
local backdrop = xToMaxBarFrame:CreateTexture(nil, "BACKGROUND")
backdrop:SetHeight(xToMaxHeight)
backdrop:SetWidth(xToMaxWidth)
backdrop:SetPoint(unpack(xToMaxPoint))
backdrop:SetTexture(xToMaxTexture)
backdrop:SetVertexColor(0.1, 0.1, 0.1)
xToMaxBarFrame.backdrop = backdrop

--Creating the XP Bar
local xToMaxBar = CreateFrame("StatusBar", "xToMaxBar", xToMaxBarFrame)
xToMaxBar:SetWidth(xToMaxWidth)
xToMaxBar:SetHeight(xToMaxHeight)
xToMaxBar:SetPoint(unpack(xToMaxPoint))
xToMaxBar:SetStatusBarTexture(xToMaxTexture)
xToMaxBar:GetStatusBarTexture():SetHorizTile(false)
xToMaxBar:SetStatusBarColor(xToMaxColor.r, xToMaxColor.g, xToMaxColor.b, 1)
xToMaxBarFrame.xToMaxBar = xToMaxBar

--Creating the text on the bar
local Text = xToMaxBar:CreateFontString("xToMaxBarText", "OVERLAY")
Text:SetFont(xToMaxFont, xToMaxFontSize, xToMaxFontFlags)
Text:SetPoint("CENTER", xToMaxBar, "CENTER",0,1)
Text:SetAlpha(1)

--Making the bar movable and sizable
xToMaxBarFrame:SetScript("OnMouseDown", function(self, button)
	if not IsShiftKeyDown() then return end
	
	if button == "LeftButton" then
		self:StartMoving()
		self.isMoving = true
	end
end)

xToMaxBarFrame:SetScript("OnMouseUp", function(self, button)
  if not IsShiftKeyDown() then return end
  if button == "LeftButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
   --print("Stopped moving");
  elseif button == "RightButton" and self.isSizing then
	self:StopMovingOrSizing();
	self.isSizing = false
  end
end)

--Making the magic Happen
local function UpdateStatus()
	local xToMaxXPLevel = {0, 400, 1300, 2700, 4800, 7600, 11400, 16400, 22800, 30900, 40140, 50920, 64150, 80950,
		101330, 125770, 153850, 185350, 220150, 258700, 299960, 344190, 389920, 436720, 486260,
		538090, 591570, 646910, 703760, 763790, 826620, 892790, 961270, 1032330, 1105610, 1181250,
		1259370, 1339370, 1421500, 1505520, 1591820, 1680660, 1772560, 1867670, 1965880, 2067340,
		2172080, 2279970, 2391160, 2505680, 2623380, 2744420, 2868820, 2996420, 3127380, 3261710,
		3399250, 3540150, 3684420, 3831890, 3984470, 4141590, 4303480, 4470210, 4641680, 4818130,
		5002650, 5195490, 5396710, 5606740, 5825830, 6054030, 6291800, 6539400, 6796870, 7064710,
		7343190, 7632340, 7932680, 8244490, 8568070, 8899020, 9237690, 9584180, 9938290, 10300390,
		10670570, 11048620, 11434930, 11829580, 12236520, 12652030, 13076190, 13508780, 13950190,
		14400520, 14859850, 15328270, 15805880, 16292430, 16784970, 17282030, 17783610, 18289710,
		18800330, 19315470, 19835130, 20359310, 20888000, 21421210, 21958940, 22789940, 23627870,
		24472720, 25324500, 26183200, 27048830, 27921380, 28800860, 29687260};
	local xToMaxCurrentXP = UnitXP("player") + xToMaxXPLevel[UnitLevel("player")]
	local xToMaxMaxXP = xToMaxXPLevel[MAX_PLAYER_LEVEL]
	local xToMaxPercXP = floor(xToMaxCurrentXP/xToMaxMaxXP*100)
	
	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		backdrop:Hide()
		xToMaxBar:Hide()
		xToMaxBarFrame:Hide()
	else
		xToMaxBar:SetMinMaxValues(min(0, xToMaxCurrentXP), xToMaxMaxXP)
		xToMaxBar:SetValue(xToMaxCurrentXP)
		Text:SetText(format("%s/%s (%s%%|cffb3e1ff|r)", comma_value(xToMaxCurrentXP), comma_value(xToMaxMaxXP), xToMaxPercXP))
	end
end

--Register Events
xToMaxBarFrame:RegisterEvent("PLAYER_LEVEL_UP")
xToMaxBarFrame:RegisterEvent("PLAYER_XP_UPDATE")
xToMaxBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
xToMaxBarFrame:SetScript("OnEvent", UpdateStatus)