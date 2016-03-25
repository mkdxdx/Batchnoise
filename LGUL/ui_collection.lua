--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

-- undrawable container element
-- you can hold stuff in it, strings, numbers, tables, userdata etc
-- has simple adding, deleting and getting interface
-- UIManager's version of an array

Collection = {}
Collection.__index = Collection
Collection.ident = "ui_collection"
Collection.name = "Collection"
Collection.updateable = false
Collection.input = false
Collection.drawable = false
function Collection:new(name)
	local self = {}
	setmetatable(self,Collection)
	self.items = {}
	if name ~= nil then self.name = name end
	return self
end
setmetatable(Collection,{__index = Element})


-- adds element into collection and fires onadd event
function Collection:addItem(item)
	table.insert(self.items,item)
	self:onadd()
end


-- if element is a table or userdata, you will receive a reference to it, in other cases you will create duplicate of that element in your variable
function Collection:getItem(index)
	return self.items[index]
end

function Collection:deleteItem(index)
	table.remove(self.items,index)
	self:ondelete()
end

-- clears collection of anything
function Collection:purge()
	for k,v in pairs(self.items) do self.items[k] = nil end
end

function Collection:getCount()
	return #self.items
end

function Collection:onadd() end
function Collection:ondelete() end


-- UIManager will try to update this collection, you should declare what should it do on every tick,
--[[
	local collection = Collection:new("UColl")
	function collection:update(dt)
		.. do stuff
	end
]]
-- otherwise it will do nothing

UpdateableCollection = {}
UpdateableCollection.__index = UpdateableCollection
UpdateableCollection.ident = "ui_updateablecollection"
UpdateableCollection.name = "UpdateableCollection"
UpdateableCollection.updateable = true
UpdateableCollection.input = false
UpdateableCollection.drawable = false
function UpdateableCollection:new(name)
	local self = {}
	setmetatable(self,UpdateableCollection)
	self.items = {}
	return self
end
setmetatable(UpdateableCollection,{__index = Collection})


function UpdateableCollection:update(dt)
	local c = self:getCount()
	if c>0 then
		for i=1,c do
			self.items[i]:update(dt)
		end
	end
end