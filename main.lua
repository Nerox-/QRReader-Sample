-- QR Reader plugin for Corona SDK
-- Plugin developed by Andrew Wahid
local qrreader = require "plugin.qrreader"
local widget = require( "widget" )
--
display.setDefault( "background", 0.46, 0.513, 0.588, 1 )
local layoutTable = {}
local radioGroup = display.newGroup()
--
local currentSelectedScanType = "all"
local scanTypes = {"all", "one-d", "qrcode", "product", "data-matrix"}
function onSelectRadioButton(event)
	currentSelectedScanType = event.target.id
end
--
layoutTable["scanButton"] = display.newRoundedRect(display.contentCenterX, display.contentCenterY+65, 100, 40, 2)
layoutTable["scanButton"].strokeWidth = 1
layoutTable["scanButton"]:setFillColor(1, 1, 1, 1)
layoutTable["scanButton"]:setStrokeColor(0,0,0)
--
layoutTable["scanText"] = display.newText("Start Scan", display.contentCenterX, display.contentCenterY+65)
layoutTable["scanText"]:setFillColor(0, 0, 0)
--
layoutTable["scanTextField"] = native.newTextField(display.contentCenterX, display.contentCenterY-200, 200, 30)
layoutTable["scanTextField"].placeholder = "Scan Title"
--
local currentX = display.contentCenterX-115
for i=1, #scanTypes do
	layoutTable["scanFormat#"..i] = widget.newSwitch(
	{
		x = currentX,
		y = display.contentCenterY-125,
		style = "radio",
		id = scanTypes[i],
		onRelease = onSelectRadioButton,
	})
	layoutTable["scanTypeText#"..i] = display.newText(scanTypes[i], currentX, display.contentCenterY-150, native.systemFont, 11)
	layoutTable["scanTypeText#"..i]:setFillColor(0, 0, 0)
	--
	radioGroup:insert(layoutTable["scanFormat#"..i])
	currentX = currentX + 60
end
--
layoutTable["scanFrontCameraCheck"] = widget.newSwitch(
{
	x = display.contentCenterX,
	y = display.contentCenterY-65,
	style = "checkbox",
	id = "Checkbox",
})
layoutTable["scanCameraText"] = display.newText("Use Front-Camera", display.contentCenterX, display.contentCenterY-90, native.systemFont, 11)
layoutTable["scanCameraText"]:setFillColor(0, 0, 0)
--
layoutTable["scanBeepCheck"] = widget.newSwitch(
{
	x = display.contentCenterX,
	y = display.contentCenterY-5,
	style = "checkbox",
	id = "Checkbox",
})
layoutTable["scanBeepText"] = display.newText("Beep Enabled", display.contentCenterX, display.contentCenterY-30, native.systemFont, 11)
layoutTable["scanBeepText"]:setFillColor(0, 0, 0)
--
layoutTable["scanResultBox"] = native.newTextBox(display.contentCenterX, display.contentCenterY+180, 250, 150)
layoutTable["scanResultBox"].isEditable = false
--
function scanListener( event )
	local eventText = "SCAN RESULT ("..os.date("%c").."):\nEvent error: "..tostring(event.isError).."\nEvent State: "..tostring(event.state).."\nEvent Result: "..tostring(event.result)..""
	layoutTable["scanResultBox"].text = eventText
end
--
layoutTable["scanButton"]:addEventListener("touch", function(event)
	if event.phase ~= "ended" then return false end
	local p_scanTitle = layoutTable["scanTextField"].text
	local p_useFrontCamera = layoutTable["scanFrontCameraCheck"].isOn
	local p_beepEnabled = layoutTable["scanBeepCheck"].isOn
	local p_scanType = currentSelectedScanType
	qrreader.startScan( {
		onScanComplete = scanListener,
		title = p_scanTitle,
		useFrontCamera = p_useFrontCamera,
		barcodeFormat = p_scanType,
		beepEnabled = p_beepEnabled,
	} )
end)
