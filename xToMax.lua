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
	local xToMaxXPLevel = {0, 400, 1300, 2700, 4800, 7600, 11400, 16400, 22800, 30900, 40140, 50920, 64150, 80950, 101330,
		125770, 145850, 177350, 212150, 250700, 291960,	336190, 381920, 428720, 478260, 530090, 583570, 638910, 695760,
		755790, 818620, 884790,	953270, 1024330, 1097610, 1173250, 1251370, 1331370, 1413500, 1497520, 1583820, 1672660,
		1764560, 1859670, 1957880, 2059340, 2164080, 2271970, 2383160, 2497680, 2615380, 2736420, 2860820, 2988420, 3119380,
		3253710, 3391250, 3532150, 3676420, 3823890, 3976470, 4133590, 4295480, 4462210, 4633680, 4810130, 4994650, 5187490,
		5388710, 5598740, 5817830, 6046030,	6283800, 6531400, 6788870, 7056710, 7345860, 7646200, 7958010, 8281590, 8612540,
		11999240, 12345730, 12699840, 13061940, 13432120, 13810170, 14196480, 14591130, 14998070, 15413580,	15837740,
		16270330, 16711740, 17162070, 17621400, 18089820, 18567430, 19053980, 19546520,	20043580, 20545160, 21051260,
		21561880, 22077020, 22596680, 23120860, 23649550, 24182760,	24720490, 25551490, 26389420, 27234270, 28086050,
		28944750, 29810380, 30682930, 31562410,	32448810, 32448810};
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