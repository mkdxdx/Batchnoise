--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics

-- Your simple label element
-- can wrap words
-- can align words

Label = {}
Label.__index = Label
Label.ident = "ui_label"
Label.caption = "Label"
Label.align = "center"
Label.wrap = true
Label.name = "Label"
function Label:new(name)
	local self = {}
	setmetatable(self,Label)
	if name ~= nil then self.name = name end
	return self
end
setmetatable(Label,{__index = UIElement})

function Label:draw()
	local cr,cg,cb,ca = love.graphics.getColor()
	l_gfx.setColor(self.colorFont)
	if self.wrap == true then
		l_gfx.printf(self.caption,self.x,self.y,self.w,self.align)
	else
		l_gfx.print(self.caption,self.x,self.y)
	end
	l_gfx.setColor(cr,cg,cb,ca)
end

-- This label is updateable
-- useful for displaying varying information, e.g. FPS:
--[[
	local fpslabel = RefreshingLabel:new("L_FPS")
	fpslabel:update(dt)
		fpslabel.caption = "FPS:"..love.timer.getFPS()
	end
]]
RefreshingLabel = {}
RefreshingLabel.__index = RefreshingLabel
RefreshingLabel.ident = "ui_refreshinglabel"
RefreshingLabel.name = "RefreshingLabel"
RefreshingLabel.updateable = true
function RefreshingLabel:new(name)
	local self = {}
	setmetatable(self,RefreshingLabel)
	if name ~= nil then self.name = name end
	return self
end
setmetatable(RefreshingLabel,{__index = Label})

TextBox = {}
TextBox.__index = TextBox
TextBox.name = "TextBox"
TextBox.ident = "ui_textbox"
TextBox.showBorder = true
TextBox.fill = true
function TextBox:new(name)
	local self = setmetatable({},TextBox)
	self.name = name or self.name
	return self
end
setmetatable(TextBox,{__index = Label})

function TextBox:alignBox()
	--local w,l =  l_gfx.getFont():getWrap(self.caption,self.w)
	--self.h = l_gfx.getFont():getHeight()*l
end



function TextBox:draw()
	local cr,cg,cb,ca = love.graphics.getColor()
	if self.showBorder == true then
		l_gfx.setColor(self.colorLine)
		l_gfx.rectangle("line",self.x,self.y,self.w,self.h)
	end
	if self.fill == true then
		l_gfx.setColor(self.colorFill)
		l_gfx.rectangle("fill",self.x,self.y,self.w,self.h)
	end
	l_gfx.setColor(self.colorFont)
	l_gfx.printf(self.caption,self.x,self.y,self.w,self.align)
	l_gfx.setColor(cr,cg,cb,ca)
end