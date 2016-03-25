--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics

UICanvas = {}
UICanvas.__index = UICanvas
UICanvas.ident = "ui_canvas"
UICanvas.mode = "add"
function UICanvas:new(name)
	local self = setmetatable({},UICanvas)
	self.name = name or self.name
	return self
end
setmetatable(UICanvas,{__index = Image})

function UICanvas:create(x,y)
	self.canvas = l_gfx.newCanvas(x,y)
	self:setSize(x,y)
end

function UICanvas:draw()
	if self.canvas ~= nil then
		--[[
		local c = l_gfx.getCanvas()
		l_gfx.setCanvas(self.canvas)
		l_gfx.clear()
		local bm = l_gfx.getBlendMode()
		local cr,cg,cb,ca = l_gfx.getColor()
		l_gfx.setColor(self.colorTint)
		l_gfx.setBlendMode(self.mode)
		l_gfx.draw(self.canvas,self.x,self.y)
		l_gfx.setBlendMode(bm)
		l_gfx.setColor(cr,cg,cb,ca)
		l_gfx.setCanvas(c)
		]]--
		
		local bm = l_gfx.getBlendMode()
		local cr,cg,cb,ca = l_gfx.getColor()
		local px,py = self:getPosition()
		l_gfx.draw(self.canvas,px,py)
		if self.showBorder == true then
			l_gfx.setColor(self.colorLine)
			local w,h = self.w,self.h
			l_gfx.rectangle("line",self.x-1,self.y-1,w+2,h+2)
		end
		l_gfx.setColor(cr,cg,cb,ca)
		l_gfx.setBlendMode(bm)
	end
end

function UICanvas:get()
	return self.canvas
end