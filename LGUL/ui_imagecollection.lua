--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics

-- This undrawable element is a collection for image resource
-- The thing is - it will try not to repeat resource creation if you try to get something from it, instead giving a reference on already created resource

ImageCollection = {}
ImageCollection.__index = ImageCollection
ImageCollection.ident = "ui_imagecollection"
ImageCollection.name = "ImageCollection"
function ImageCollection:new(name)
	local self = {}
	setmetatable(self,ImageCollection)
	self.items = {}
	if name ~= nil then self.name = name end
	return self
end
setmetatable(ImageCollection,{__index = Element})

function ImageCollection:addItem(image,name)
	local c = self:getCount()
	if c>0 then
		
		for i=1,c do
			if self.items[i][2] == name then
				return self.items[i][1]
			end
		end
		local name = name or (#self.items+1)
		local img = l_gfx.newImage(image)
		table.insert(self.items,{img,name})
		return img
	else
		local name = name or (#self.items+1)
		local img = l_gfx.newImage(image)
		table.insert(self.items,{img,name})
		return img
	end
end

function ImageCollection:getItem(item)
	if type(item) == "number" then
		return self.items[item][1],self.items[item][2]
	elseif type(item) == "string" then
		local c = self:getCount()
		if c>0 then
			for i=1,c do
				if self.items[i][2] == item then
					return self.items[i][1],self.items[i][2]
				end
			end
		end
	end
	return nil
end

function ImageCollection:getCount()
	return #self.items
end