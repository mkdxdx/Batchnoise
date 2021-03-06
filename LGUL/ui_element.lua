--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

-- root element class
-- defines the element itself, usually invisible and is usefull for elements
-- which are invisible but have their purpose (e.g. Timer element, or Collection element)

Element = {}
Element.__index = Element

Element.active = true -- putting this to true will make UIManager to handle this object, like updating, drawing, etc...
Element.drawable = false -- putting this to true will make UIManager to try to draw this element by calling its draw() method
Element.input = true -- this will make UIManager to send input to this object by firing according methods
Element.updateable = false -- this will make UIManager to try to invoke update(dt) method
Element.name = "Element" -- this identifier should be unique to every element you create, so then you can find it without storing a reference variable
Element.ident = "ui_element" -- this is a type identifier, for, say "make all buttons go invisible" or something
function Element:new(name) -- element instancing
	local self = {}
	setmetatable(self,Element)
	if name ~= nil then self.name = name end -- if name is not specified, it will use its default name
	return self
end


-- all the methods are usually fired by uimanager
function Element:getName() return self.name end
function Element:oncreate() end
function Element:keypressed(key,isrepeat) end
function Element:keyreleased(key) end
function Element:mousepressed(x,y,b) end
function Element:mousereleased(x,y,b) end
function Element:wheelmoved(x,y) end
function Element:mousemoved(x,y,dx,dy) end
function Element:onchangewindow(w,h) end
function Element:textinput(t)	end


Container = {}
Container.__index = Container
Container.name = "Container"
Container.ident = "ui_container"
function Container:new(name)
	local self = setmetatable({},Container)
	self.name = name or self.name
	return self
end
setmetatable(Container,{__index = Element})

function Container:addItem(item)
	table.insert(self.items,item)
end

function Container:getItem(name)
	local c = #self.items
	if c>0 then
		for i=1,c do
			if self.items[i]:getName() == item then return self.items[i] 
			elseif self.items[i].items ~= nil then return self.items[i]:getItem(name) end
		end
	end
	return nil
end

function Container:deleteItem(name)
	local c = #self.items
	if c>0 then
		for k,v in pairs(self.items) do
			self.items[k] = nil
		end
	end
end
