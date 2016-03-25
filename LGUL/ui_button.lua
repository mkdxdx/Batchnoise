--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics


-- The Button class definition
-- highlights when mouse over it
-- does stuff if clicked
-- has caption
-- somewhat cute

Button = {}
Button.__index = Button
Button.ident = "ui_button"
Button.caption = "Button"
Button.name = "Button"
Button.showBorder = false
function Button:new(name)
	local self = {}
	setmetatable(self,Button)
	if name ~= nil then self.name = name end
	return self
end
setmetatable(Button,{__index = UIElement}) -- inherits from UIElement class, inherits its input methods and stuff


function Button:draw()
	local cr,cg,cb,ca = love.graphics.getColor()
	if self:isMouseOver() == true and self.active == true then
		l_gfx.setColor(self.colorHighlight)
	else
		l_gfx.setColor(self.colorFill)
	end
	l_gfx.rectangle("fill",self.x,self.y,self.w,self.h)
	if self.showBorder == true then
		l_gfx.setColor(self.colorLine)
		l_gfx.rectangle("line",self.x,self.y,self.w,self.h)
	end
	if self.active == true then
		l_gfx.setColor(self.colorFont)
	else 
		l_gfx.setColor(self.colorDisabledFill)
	end
	l_gfx.printf(self.caption,self.x,self.y+(self.h/2-7),self.w,"center")
	l_gfx.setColor(cr,cg,cb,ca)
end