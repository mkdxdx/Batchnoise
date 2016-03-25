--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics
local utf8 = require("utf8")

TextField = {}
TextField.__index = TextField
TextField.name = "TextField"
TextField.ident = "ui_textfield"
TextField.inContext = false
TextField.limit = 26
TextField.align = "left"
function TextField:new(name)
	local self = setmetatable({},TextField)
	self.name = name or self.name
	self.text = ""
	return self
end
setmetatable(TextField,{__index = UIElement})

function TextField:draw()
	local cr,cg,cb,ca = l_gfx.getColor()
	l_gfx.setColor(self.colorFill)
	l_gfx.rectangle("fill",self.x,self.y,self.w,self.h)
	l_gfx.setColor(self.colorFont)
	l_gfx.printf(self.text,self.x,self.y,self.w,self.align)
	if self.inContext == true then
		l_gfx.setColor(self.colorLine)
		l_gfx.rectangle("line",self.x,self.y,self.w,self.h)
	end
	l_gfx.setColor(cr,cg,cb,ca)
end

function TextField:mousepressed(x,y,b)
	if self:isMouseOver(x,y) then
		if b == 1 then
			self.inContext = true
		end
		self:click(b)
	else 
		self.inContext = false
	end
end

function TextField:keypressed(key,isrepeat)
	if self.inContext == true and #self.text>0 and key == "backspace" then
		local l = string.len(self.text)
		if l>0 then
			self.text = string.sub(self.text,1,l-1)
		end
	end
end

function TextField:textinput(t)
	if self.inContext == true and #self.text<=self.limit then
		self.text = self.text .. t
	end
end

function TextField:clear()
	self.text = ""
end