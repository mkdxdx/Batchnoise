--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics
local format,min,floor = string.format,math.min,math.floor

-- an updateable element which can show values, or can be updated manually without defining its update behavior

ProgressBar = {}
ProgressBar.__index = ProgressBar
ProgressBar.ident = "ui_progressbar"
ProgressBar.name = "ProgressBar"
ProgressBar.caption = ""
ProgressBar.displayVal = true
ProgressBar.updateable = true
ProgressBar.leftCaption = false
ProgressBar.asPercentage = false
ProgressBar.w = 128
function ProgressBar:new()
	local self = {}
	setmetatable(self,ProgressBar)
	if name ~= nil then self.name = name end
	self.value = 0
	self.max = 100
	self.showCaption = true
	return self
end
setmetatable(ProgressBar,{__index = UIElement})

function ProgressBar:draw() 
	local cr,cg,cb,ca = love.graphics.getColor()
	l_gfx.setColor(self.colorFill)
	l_gfx.rectangle("fill",self.x,self.y,self.w,self.h)
	l_gfx.setColor(self.colorHighlight)
	local factor = min(1,self.value/self.max)
	l_gfx.rectangle("fill",self.x,self.y,self.w*factor,self.h)
	l_gfx.setColor(self.colorFont)
	if self.displayVal == true then
		if self.asPercentage == true then
			l_gfx.printf(floor(self.value/self.max*100).."%",self.x,self.y+(self.h/2-7),self.w,"center")
		else
			l_gfx.printf(self.value.."/"..self.max,self.x,self.y+(self.h/2-7),self.w,"center")
		end
	end
	if self.showCaption == true then
		if self.leftCaption == true then 
			l_gfx.printf(self.caption,self.x-l_gfx:getFont():getWidth(self.caption),self.y+(self.h/2-7),self.w,"left")
		else
			l_gfx.printf(self.caption,self.x,self.y-16,self.w,"center")
		end
	end
	l_gfx.setColor(cr,cg,cb,ca)
end
