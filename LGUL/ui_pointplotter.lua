--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics

PointPlotter = {}
PointPlotter.__index = PointPlotter
PointPlotter.ident = "ui_pointplotter"
PointPlotter.name = "PointPlotter"
PointPlotter.drawable = true
PointPlotter.updateable = false
PointPlotter.input = true
PointPlotter.colorPoint = {0,255,255,255}
PointPlotter.sx = 1
PointPlotter.sy = 1
PointPlotter.showBorder = true
PointPlotter.displayName = true
function PointPlotter:new(name)
	local self = setmetatable({},PointPlotter)
	self.name = name or self.name
	self.points = {}
	self.named = {}
	return self
end

function PointPlotter:addItem(x,y,n)
	local cpt = self.colorPoint
	local pt = {self.x+x*self.sx,self.y+y*self.sy,cpt[1],cpt[2],cpt[3],cpt[4]}
	local nm = {n or tostring(#self.named+1),pt,x,y}
	self.points[#self.points+1] = pt
	self.named[#self.named+1] = nm
	return nm
end

function PointPlotter:setItemValue(index,x,y,n)
	if self.named[index] ~= nil then
		self.named[index][1] = n
		self.named[index][3] = x
		self.named[index][4] = y
		self.points[index][1] = self.x+x*self.sx
		self.points[index][2] = self.y+y*self.sy
	end
end

function PointPlotter:clear()
	local c = #self.named
	if c>0 then
		for i=c,1,-1 do
			self.named[i][4] = nil
			self.named[i][3] = nil
			self.named[i][2] = nil
			self.named[i][1] = nil
			self.points[i][1] = nil
			self.points[i][2] = nil
			self.points[i][3] = nil
			self.points[i][4] = nil
			self.points[i][5] = nil
			self.points[i][6] = nil
			table.remove(self.named,i)
			table.remove(self.points,i)
		end
	end
end

function PointPlotter:delItem(index)
	if self.named[index] ~= nil then
		self.named[index][4] = nil
		self.named[index][3] = nil
		self.named[index][2] = nil
		self.named[index][1] = nil
		self.points[index][1] = nil
		self.points[index][2] = nil
		self.points[index][3] = nil
		self.points[index][4] = nil
		self.points[index][5] = nil
		self.points[index][6] = nil
		table.remove(self.named,index)
		table.remove(self.points,index)
	end
end

function PointPlotter:setScale(sx,sy)
	self.sx = sx or self.sx
	self.sy = sy or self.sy
	local c = #self.named
	if c>0 then
		for i=1,c do
			self.named[2][1] = self.x+self.named[3]*self.sx
			self.named[2][2] = self.y+self.named[4]*self.sy
		end
	end
end

function PointPlotter:draw()
	local cr,cg,cb,ca = l_gfx.getColor()
	local px,py = self:getPosition()
	if self.showBorder == true then
		l_gfx.rectangle("line",px,py,self.w,self.h)
	end
	if #self.points>0 then
		l_gfx.points(self.points)
	end
	if self.displayName == true then
		l_gfx.setColor(self.colorPoint)
		local c = #self.named
		if c>0 then
			for i=1,c do
				local pt = self.named[i]
				local pc = pt[2]
				l_gfx.print(pt[1],pc[1]+4,pc[2]+4)
			end
		end
	end
	l_gfx.setColor(cr,cg,cb,ca)
end

setmetatable(PointPlotter,{__index = UIElement})