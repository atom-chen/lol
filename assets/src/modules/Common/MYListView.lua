
--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--------------------------------
-- @module MYListView

--[[--

quick 列表控件

]]
local MYScrollView = require("modules.Common.MYScrollView")
local MYListView = class("MYListView", MYScrollView)

local MYListViewItem = import(".MYListViewItem")


MYListView.DELEGATE					= "ListView_delegate"
MYListView.TOUCH_DELEGATE			= "ListView_Touch_delegate"

MYListView.CELL_TAG					= "Cell"
MYListView.CELL_SIZE_TAG			= "CellSize"
MYListView.COUNT_TAG				= "Count"
MYListView.CLICKED_TAG				= "Clicked"
MYListView.UNLOAD_CELL_TAG			= "UnloadCell"

MYListView.BG_ZORDER 				= -1
MYListView.CONTENT_ZORDER			= 10

MYListView.ALIGNMENT_LEFT			= 0
MYListView.ALIGNMENT_RIGHT			= 1
MYListView.ALIGNMENT_VCENTER		= 2
MYListView.ALIGNMENT_TOP			= 3
MYListView.ALIGNMENT_BOTTOM			= 4
MYListView.ALIGNMENT_HCENTER		= 5

-- start --

--------------------------------
-- MYListView构建函数
-- @function [parent=#MYListView] new
-- @param table params 参数表

--[[--

MYListView构建函数

可用参数有：

-   direction 列表控件的滚动方向，默认为垂直方向
-   alignment listViewItem中content的对齐方式，默认为垂直居中
-   viewRect 列表控件的显示区域
-   scrollbarImgH 水平方向的滚动条
-   scrollbarImgV 垂直方向的滚动条
-   bgColor 背景色,nil表示无背景色
-   bgStartColor 渐变背景开始色,nil表示无背景色
-   bgEndColor 渐变背景结束色,nil表示无背景色
-   bg 背景图
-   bgScale9 背景图是否可缩放
-	capInsets 缩放区域

]]
-- end --

function MYListView:ctor(params)
	MYListView.super.ctor(self, params)

	self.items_ = {}
	self.direction = params.direction or MYScrollView.DIRECTION_VERTICAL
	self.alignment = params.alignment or MYListView.ALIGNMENT_VCENTER
	self.bAsyncLoad = params.async or false
	self.container = cc.Node:create()
	-- self.padding_ = params.padding or {left = 0, right = 0, top = 0, bottom = 0}

	-- params.viewRect.x = params.viewRect.x + self.padding_.left
	-- params.viewRect.y = params.viewRect.y + self.padding_.bottom
	-- params.viewRect.width = params.viewRect.width - self.padding_.left - self.padding_.right
	-- params.viewRect.height = params.viewRect.height - self.padding_.bottom - self.padding_.top

	self:setDirection(params.direction)
	self:setViewRect(params.viewRect)
	self:addScrollNode(self.container)
	self:onScroll(handler(self, self.scrollListener))

	self.size = {}
	self.itemsFree_ = {}
	self.delegate_ = {}
	self.redundancyViewVal = 0 --异步的视图两个方向上的冗余大小,横向代表宽,竖向代表高

	self.args_ = {params}
end

function MYListView:onCleanup()
	self:releaseAllFreeItems_()
end

-- start --

--------------------------------
-- 列表控件触摸注册函数
-- @function [parent=#MYListView] onTouch
-- @param function listener 触摸临听函数
-- @return MYListView#MYListView  self 自身

-- end --

function MYListView:onTouch(listener)
	self.touchListener_ = listener

	return self
end

-- start --

--------------------------------
-- 列表控件设置所有listItem中content的对齐方式
-- @function [parent=#MYListView] setAlignment
-- @param number align 对
-- @return MYListView#MYListView  self 自身

-- end --

function MYListView:setAlignment(align)
	self.alignment = align
end

-- start --

--------------------------------
-- 创建一个新的listViewItem项
-- @function [parent=#MYListView] newItem
-- @param node item 要放到listViewItem中的内容content
-- @return MYListViewItem#MYListViewItem 

-- end --

function MYListView:newItem(item)
	item = MYListViewItem.new(item)
	item:setDirction(self.direction)
	item:onSizeChange(handler(self, self.itemSizeChangeListener))

	return item
end

-- start --

--------------------------------
-- 设置显示区域
-- @function [parent=#MYListView] setViewRect
-- @return MYListView#MYListView  self

-- end --

function MYListView:setViewRect(viewRect)
	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		self.redundancyViewVal = viewRect.height
	else
		self.redundancyViewVal = viewRect.width
	end

	MYListView.super.setViewRect(self, viewRect)

	return self
end

function MYListView:itemSizeChangeListener(listItem, newSize, oldSize)
	local pos = self:getItemPos(listItem)
	if not pos then
		return
	end

	local itemW, itemH = newSize.width - oldSize.width, newSize.height - oldSize.height
	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		itemW = 0
	else
		itemH = 0
	end

	local content = listItem:getContent()
	local action = cc.MoveBy:create(0.2,cc.p(itemW/2,itemH/2))
	content:runAction(action)
	self.size.width = self.size.width + itemW
	self.size.height = self.size.height + itemH
	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		local action = cc.MoveBy:create(0.2,cc.p(-itemW,-itemH))
		self.container:runAction(action)
		self:moveItems(1, pos - 1, itemW, itemH, true)
	else
		self:moveItems(pos + 1, table.nums(self.items_), itemW, itemH, true)
	end
end

function MYListView:scrollListener(event)
	if "clicked" == event.name then
		local nodePoint = self.container:convertToNodeSpace(cc.p(event.x, event.y))
		local pos
		local idx

		if self.bAsyncLoad then
			local itemRect
			for i,v in ipairs(self.items_) do
				local posX, posY = v:getPosition()
				local itemW, itemH = v:getItemSize()
				itemRect = cc.rect(posX, posY, itemW, itemH)
				if cc.rectContainsPoint(itemRect, nodePoint) then
					idx = v.idx_
					pos = i
					break
				end
			end
		else
			nodePoint.x = nodePoint.x - self.viewRect_.x
			nodePoint.y = nodePoint.y - self.viewRect_.y

			local width, height = 0, self.size.height
			local itemW, itemH = 0, 0

			if MYScrollView.DIRECTION_VERTICAL == self.direction then
				for i,v in ipairs(self.items_) do
					itemW, itemH = v:getItemSize()

					if nodePoint.y < height and nodePoint.y > height - itemH then
						pos = i
						idx = pos
						nodePoint.y = nodePoint.y - (height - itemH)
						break
					end
					height = height - itemH
				end
			else
				for i,v in ipairs(self.items_) do
					itemW, itemH = v:getItemSize()

					if nodePoint.x > width and nodePoint.x < width + itemW then
						pos = i
						idx = pos
						break
					end
					width = width + itemW
				end
			end
		end

		self:notifyListener_{name = "clicked",
			listView = self, itemPos = idx, item = self.items_[pos],
			point = nodePoint}
	else
		event.scrollView = nil
		event.listView = self
		self:notifyListener_(event)
	end

end

-- start --

--------------------------------
-- 在列表项中添加一项
-- @function [parent=#MYListView] addItem
-- @param node listItem 要添加的项
-- @param integer pos 要添加的位置,默认添加到最后
-- @return MYListView#MYListView 

-- end --

function MYListView:addItem(listItem, pos)
	self:modifyItemSizeIf_(listItem)

	if pos then
		table.insert(self.items_, pos, listItem)
	else
		table.insert(self.items_, listItem)
	end
	self.container:addChild(listItem)

	return self
end

-- start --

--------------------------------
-- 在列表项中移除一项
-- @function [parent=#MYListView] removeItem
-- @param node listItem 要移除的项
-- @param boolean bAni 是否要显示移除动画
-- @return MYListView#MYListView 

-- end --

function MYListView:removeItem(listItem, bAni)
	assert(not self.bAsyncLoad, "MYListView:removeItem() - syncload not support remove")

	local itemW, itemH = listItem:getItemSize()
	self.container:removeChild(listItem)

	local pos = self:getItemPos(listItem)
	if pos then
		table.remove(self.items_, pos)
	end

	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		itemW = 0
	else
		itemH = 0
	end

	self.size.width = self.size.width - itemW
	self.size.height = self.size.height - itemH

	if 0 == table.nums(self.items_) then
		return
	end
	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		self:moveItems(1, pos - 1, -itemW, -itemH, bAni)
	else
		self:moveItems(pos, table.nums(self.items_), -itemW, -itemH, bAni)
	end

	return self
end

-- start --

--------------------------------
-- 移除所有的项
-- @function [parent=#MYListView] removeAllItems
-- @return integer#integer 

-- end --

function MYListView:removeAllItems()
    self.container:removeAllChildren()
    self.items_ = {}

    return self
end

-- start --

--------------------------------
-- 取某项在列表控件中的位置
-- @function [parent=#MYListView] getItemPos
-- @param node listItem 列表项
-- @return integer#integer 

-- end --

function MYListView:getItemPos(listItem)
	for i,v in ipairs(self.items_) do
		if v == listItem then
			return i
		end
	end
end

-- start --

--------------------------------
-- 判断某项是否在列表控件的显示区域中
-- @function [parent=#MYListView] isItemInViewRect
-- @param integer pos 列表项位置
-- @return boolean#boolean 

-- end --

function MYListView:isItemInViewRect(pos)
	local item
	if "number" == type(pos) then
		item = self.items_[pos]
	elseif "userdata" == type(pos) then
		item = pos
	end

	if not item then
		return
	end
	
	local bound = item:getBoundingBox()
	local nodePoint = self.container:convertToWorldSpace(
		cc.p(bound.x, bound.y))
	bound.x = nodePoint.x
	bound.y = nodePoint.y

	return cc.rectIntersectsRect(self.viewRect_, bound)
end

-- start --

--------------------------------
-- 加载列表
-- @function [parent=#MYListView] reload
-- @return MYListView#MYListView 

-- end --

function MYListView:reload()
	if self.bAsyncLoad then
		self:asyncLoad_()
	else
		self:layout_()
	end

	return self
end

-- start --

--------------------------------
-- 取一个空闲项出来,如果没有返回空
-- @function [parent=#MYListView] dequeueItem
-- @return MYListViewItem#MYListViewItem  item
-- @see MYListViewItem

-- end --

function MYListView:dequeueItem()
	if #self.itemsFree_ < 1 then
		return
	end

	local item
	item = table.remove(self.itemsFree_, 1)

	--标识从free中取出,在loadOneItem_中调用release
	--这里直接调用release,item会被释放掉
	item.bFromFreeQueue_ = true

	return item
end

function MYListView:layout_()
	local width, height = 0, 0
	local itemW, itemH = 0, 0
	local margin

	-- calcate whole width height
	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		width = self.viewRect_.width

		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			height = height + itemH
		end
	else
		height = self.viewRect_.height

		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			width = width + itemW
		end
	end
	self:setActualRect({x = self.viewRect_.x,
		y = self.viewRect_.y,
		width = width,
		height = height})
	self.size.width = width
	self.size.height = height

	local tempWidth, tempHeight = width, height
	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		itemW, itemH = 0, 0

		local content
		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			tempHeight = tempHeight - itemH
			content = v:getContent()
			content:setAnchorPoint(0.5, 0.5)
			-- content:setPosition(itemW/2, itemH/2)
			self:setPositionByAlignment_(content, itemW, itemH, v:getMargin())
			v:setPosition(self.viewRect_.x,
				self.viewRect_.y + tempHeight)
		end
	else
		itemW, itemH = 0, 0
		tempWidth = 0

		for i,v in ipairs(self.items_) do
			itemW, itemH = v:getItemSize()
			itemW = itemW or 0
			itemH = itemH or 0

			content = v:getContent()
			content:setAnchorPoint(0.5, 0.5)
			-- content:setPosition(itemW/2, itemH/2)
			self:setPositionByAlignment_(content, itemW, itemH, v:getMargin())
			v:setPosition(self.viewRect_.x + tempWidth, self.viewRect_.y)
			tempWidth = tempWidth + itemW
		end
	end

	self.container:setPosition(0, self.viewRect_.height - self.size.height)
end

function MYListView:notifyItem(point)
	local count = self.listener[MYListView.DELEGATE](self, MYListView.COUNT_TAG)
	local temp = (self.direction == MYListView.DIRECTION_VERTICAL and self.container:getContentSize().height) or 0
	local w,h = 0, 0
	local tag = 0

	for i = 1, count do
		w,h = self.listener[MYListView.DELEGATE](self, MYListView.CELL_SIZE_TAG, i)
		if self.direction == MYListView.DIRECTION_VERTICAL then
			temp = temp - h
			if point.y > temp then
				point.y = point.y - temp
				tag = i
				break
			end
		else
			temp = temp + w
			if point.x < temp then
				point.x = point.x + w - temp
				tag = i
				break
			end
		end
	end

	if 0 == tag then
		printInfo("MYListView - didn't found item")
		return
	end

	local item = self.container:getChildByTag(tag)
	self.listener[MYListView.DELEGATE](self, MYListView.CLICKED_TAG, tag, point)
end

function MYListView:moveItems(beginIdx, endIdx, x, y, bAni)
	if 0 == endIdx then
		self:elasticScroll()
	end

	local posX, posY = 0, 0

	local moveByParams = {x = x, y = y, time = 0.2}
	for i=beginIdx, endIdx do
		if bAni then
			if i == beginIdx then
				moveByParams.onComplete = function()
					self:elasticScroll()
				end
			else
				moveByParams.onComplete = nil
			end
			local action = cc.MoveBy:create(moveByParams.time,cc.p(moveByParams.x,moveByParams.y))
			local sequence = nil
			if moveByParams.onComplete then
				sequence = cc.Sequence:create(action,cc.CallFunc:create(onComplete))
			else
				sequence = action
			end
			self.items_[i]:runAction(sequence)
		else
			posX, posY = self.items_[i]:getPosition()
			self.items_[i]:setPosition(posX + x, posY + y)
			if i == beginIdx then
				self:elasticScroll()
			end
		end
	end
end

function MYListView:notifyListener_(event)
	if not self.touchListener_ then
		return
	end

	self.touchListener_(event)
end

function MYListView:modifyItemSizeIf_(item)
	local w, h = item:getItemSize()

	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		if w ~= self.viewRect_.width then
			item:setItemSize(self.viewRect_.width, h, true)
		end
	else
		if h ~= self.viewRect_.height then
			item:setItemSize(w, self.viewRect_.height, true)
		end
	end
end

function MYListView:update_(dt)
	MYListView.super.update_(self, dt)

	self:checkItemsInStatus_()
	if self.bAsyncLoad then
		self:increaseOrReduceItem_()
	end
end

function MYListView:checkItemsInStatus_()
	if not self.itemInStatus_ then
		self.itemInStatus_ = {}
	end

	local rectIntersectsRect = function(rectParent, rect)
		-- dump(rectParent, "parent:")
		-- dump(rect, "rect:")

		local nIntersects -- 0:no intersects,1:have intersects,2,have intersects and include totally
		local bIn = rectParent.x <= rect.x and
				rectParent.x + rectParent.width >= rect.x + rect.width and
				rectParent.y <= rect.y and
				rectParent.y + rectParent.height >= rect.y + rect.height
		if bIn then
			nIntersects = 2
		else
			local bNotIn = rectParent.x > rect.x + rect.width or
				rectParent.x + rectParent.width < rect.x or
				rectParent.y > rect.y + rect.height or
				rectParent.y + rectParent.height < rect.y
			if bNotIn then
				nIntersects = 0
			else
				nIntersects = 1
			end
		end

		return nIntersects
	end

	local newStatus = {}
	local bound
	local nodePoint
	for i,v in ipairs(self.items_) do
		bound = v:getBoundingBox()
		nodePoint = self.container:convertToWorldSpace(cc.p(bound.x, bound.y))
		bound.x = nodePoint.x
		bound.y = nodePoint.y
		newStatus[i] =
			rectIntersectsRect(self.viewRect_, bound)
	end

	-- dump(self.itemInStatus_, "status:")
	-- dump(newStatus, "newStatus:")
	for i,v in ipairs(newStatus) do
		if self.itemInStatus_[i] and self.itemInStatus_[i] ~= v then
			-- print("statsus:" .. self.itemInStatus_[i] .. " v:" .. v)
			local params = {listView = self,
							itemPos = i,
							item = self.items_[i]}
			if 0 == v then
				params.name = "itemDisappear"
			elseif 1 == v then
				params.name = "itemAppearChange"
			elseif 2 == v then
				params.name = "itemAppear"
			end
			self:notifyListener_(params)
		else
			-- print("status same:" .. self.itemInStatus_[i])
		end
	end
	self.itemInStatus_ = newStatus
	-- dump(self.itemInStatus_, "status:")
	-- print("itemStaus:" .. #self.itemInStatus_)
end

--[[--

动态调整item,是否需要加载新item,移除旧item
私有函数

]]
function MYListView:increaseOrReduceItem_()

	if 0 == #self.items_ then
		print("ERROR items count is 0")
		return
	end

	local getContainerCascadeBoundingBox = function ()
		local boundingBox
		for i, item in ipairs(self.items_) do
			local w,h = item:getItemSize()
			local x,y = item:getPosition()
			local anchor = item:getAnchorPoint()
			x = x - anchor.x * w
			y = y - anchor.y * h

			if boundingBox then
				boundingBox = cc.rectUnion(boundingBox, cc.rect(x, y, w, h))
			else
				boundingBox = cc.rect(x, y, w, h)
			end
		end

		local point = self.container:convertToWorldSpace(cc.p(boundingBox.x, boundingBox.y))
		boundingBox.x = point.x
		boundingBox.y = point.y
		return boundingBox
	end

	local count = self.delegate_[MYListView.DELEGATE](self, MYListView.COUNT_TAG)
	local nNeedAdjust = 2 --作为是否还需要再增加或减少item的标志,2表示上下两个方向或左右都需要调整
	local cascadeBound = getContainerCascadeBoundingBox()
	local localPos = self:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y))
	local item
	local itemW, itemH

	-- print("child count:" .. self.container:getChildrenCount())
	-- dump(cascadeBound, "increaseOrReduceItem_ cascadeBound:")
	-- dump(self.viewRect_, "increaseOrReduceItem_ viewRect:")

	if MYScrollView.DIRECTION_VERTICAL == self.direction then

		--ahead part of view
		local disH = localPos.y + cascadeBound.height - self.viewRect_.y - self.viewRect_.height
		local tempIdx
		item = self.items_[1]
		if not item then
			print("increaseOrReduceItem_ item is nil, all item count:" .. #self.items_)
			return
		end
		tempIdx = item.idx_
		-- print(string.format("befor disH:%d, view val:%d", disH, self.redundancyViewVal))
		if disH > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.height - itemH > self.viewRect_.height
				and disH - itemH > self.redundancyViewVal then
				self:unloadOneItem_(tempIdx)
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx - 1
			if tempIdx > 0 then
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y + cascadeBound.height))
				item = self:loadOneItem_(localPoint, tempIdx, true)
			end
			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end

		--part after view
		disH = self.viewRect_.y - localPos.y
		item = self.items_[#self.items_]
		if not item then
			return
		end
		tempIdx = item.idx_
		-- print(string.format("after disH:%d, view val:%d", disH, self.redundancyViewVal))
		if disH > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.height - itemH > self.viewRect_.height
				and disH - itemH > self.redundancyViewVal then
				self:unloadOneItem_(tempIdx)
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx + 1
			if tempIdx <= count then
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y))
				item = self:loadOneItem_(localPoint, tempIdx)
			end
			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end
	else
		--left part of view
		local disW = self.viewRect_.x - localPos.x
		item = self.items_[1]
		local tempIdx = item.idx_
		if disW > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.width - itemW > self.viewRect_.width
				and disW - itemW > self.redundancyViewVal then
				self:unloadOneItem_(tempIdx)
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx - 1
			if tempIdx > 0 then
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x, cascadeBound.y))
				item = self:loadOneItem_(localPoint, tempIdx, true)
			end
			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end

		--right part of view
		disW = localPos.x + cascadeBound.width - self.viewRect_.x - self.viewRect_.width
		item = self.items_[#self.items_]
		tempIdx = item.idx_
		if disW > self.redundancyViewVal then
			itemW, itemH = item:getItemSize()
			if cascadeBound.width - itemW > self.viewRect_.width
				and disW - itemW > self.redundancyViewVal then
				self:unloadOneItem_(tempIdx)
			else
				nNeedAdjust = nNeedAdjust - 1
			end
		else
			item = nil
			tempIdx = tempIdx + 1
			if tempIdx <= count then
				local localPoint = self.container:convertToNodeSpace(cc.p(cascadeBound.x + cascadeBound.width, cascadeBound.y))
				item = self:loadOneItem_(localPoint, tempIdx)
			end
			if nil == item then
				nNeedAdjust = nNeedAdjust - 1
			end
		end
	end

	-- print("increaseOrReduceItem_() adjust:" .. nNeedAdjust)
	-- print("increaseOrReduceItem_() item count:" .. #self.items_)
	if nNeedAdjust > 0 then
		return self:increaseOrReduceItem_()
	end
end

--[[--

异步加载列表数据

@return MYListView

]]
function MYListView:asyncLoad_()
	self:removeAllItems()
	self.container:setPosition(0, 0)
	self.container:setContentSize(cc.size(0, 0))

	local count = self.delegate_[MYListView.DELEGATE](self, MYListView.COUNT_TAG)

	self.items_ = {}
	local itemW, itemH = 0, 0
	local item
	local containerW, containerH = 0, 0
	local posX, posY = 0, 0
	for i=1,count do
		item, itemW, itemH = self:loadOneItem_(cc.p(posX, posY), i)

		if MYScrollView.DIRECTION_VERTICAL == self.direction then
			posY = posY - itemH

			containerH = containerH + itemH
		else
			posX = posX + itemW

			containerW = containerW + itemW
		end

		-- 初始布局,最多保证可隐藏的区域大于显示区域就可以了
		if containerW > self.viewRect_.width + self.redundancyViewVal
			or containerH > self.viewRect_.height + self.redundancyViewVal then
			break
		end
	end

	-- self.container:setPosition(self.viewRect_.x, self.viewRect_.y)
	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		self.container:setPosition(self.viewRect_.x,
			self.viewRect_.y + self.viewRect_.height)
	else
		self.container:setPosition(self.viewRect_.x, self.viewRect_.y)
	end

	return self
end

-- start --

--------------------------------
-- 设置delegate函数
-- @function [parent=#MYListView] setDelegate
-- @return MYListView#MYListView 

-- end --

function MYListView:setDelegate(delegate)
	self.delegate_[MYListView.DELEGATE] = delegate
end

--[[--

调整item中content的布局,
私有函数

]]
function MYListView:setPositionByAlignment_(content, w, h, margin)
	local size = content:getContentSize()
	if 0 == margin.left and 0 == margin.right and 0 == margin.top and 0 == margin.bottom then
		if MYScrollView.DIRECTION_VERTICAL == self.direction then
			if MYListView.ALIGNMENT_LEFT == self.alignment then
				content:setPosition(size.width/2, h/2)
			elseif MYListView.ALIGNMENT_RIGHT == self.alignment then
				content:setPosition(w - size.width/2, h/2)
			else
				content:setPosition(w/2, h/2)
			end
		else
			if MYListView.ALIGNMENT_TOP == self.alignment then
				content:setPosition(w/2, h - size.height/2)
			elseif MYListView.ALIGNMENT_RIGHT == self.alignment then
				content:setPosition(w/2, size.height/2)
			else
				content:setPosition(w/2, h/2)
			end
		end
	else
		local posX, posY
		if 0 ~= margin.right then
			posX = w - margin.right - size.width/2
		else
			posX = size.width/2 + margin.left
		end
		if 0 ~= margin.top then
			posY = h - margin.top - size.height/2
		else
			posY = size.height/2 + margin.bottom
		end
		content:setPosition(posX, posY)
	end
end

--[[--

加载一个数据项
私有函数

@param table originPoint 数据项要加载的起始位置
@param number idx 要加载数据的序号
@param boolean bBefore 是否加在已有项的前面

@return MYListViewItem item

]]
function MYListView:loadOneItem_(originPoint, idx, bBefore)
	-- print("MYListView loadOneItem idx:" .. idx)
	-- dump(originPoint, "originPoint:")

	local itemW, itemH = 0, 0
	local item
	local containerW, containerH = 0, 0
	local posX, posY = originPoint.x, originPoint.y
	local content

	item = self.delegate_[MYListView.DELEGATE](self, MYListView.CELL_TAG, idx)
	if nil == item then
		print("ERROR! MYListView load nil item")
		return
	end
	item.idx_ = idx
	itemW, itemH = item:getItemSize()

	if MYScrollView.DIRECTION_VERTICAL == self.direction then
		itemW = itemW or 0
		itemH = itemH or 0

		if bBefore then
			posY = posY
		else
			posY = posY - itemH
		end
		content = item:getContent()
		content:setAnchorPoint(0.5, 0.5)
		self:setPositionByAlignment_(content, itemW, itemH, item:getMargin())
		item:setPosition(0, posY)

		containerH = containerH + itemH
	else
		itemW = itemW or 0
		itemH = itemH or 0
		if bBefore then
			posX = posX - itemW
		end

		content = item:getContent()
		content:setAnchorPoint(0.5, 0.5)
		self:setPositionByAlignment_(content, itemW, itemH, item:getMargin())
		item:setPosition(posX, 0)

		containerW = containerW + itemW
	end

	if bBefore then
		table.insert(self.items_, 1, item)
	else
		table.insert(self.items_, item)
	end

	self.container:addChild(item)
	if item.bFromFreeQueue_ then
		item.bFromFreeQueue_ = nil
		item:release()
	end
	-- local cascadeBound = self.container:getCascadeBoundingBox()
	-- dump(cascadeBound, "cascadeBound:")

	return item, itemW, itemH
end

--[[--

移除一个数据项
私有函数


]]
function MYListView:unloadOneItem_(idx)
	-- print("MYListView unloadOneItem idx:" .. idx)

	local item = self.items_[1]

	if nil == item then
		return
	end
	if item.idx_ > idx then
		return
	end
	local unloadIdx = idx - item.idx_ + 1
	item = self.items_[unloadIdx]
	if nil == item then
		return
	end
	table.remove(self.items_, unloadIdx)
	self:addFreeItem_(item)
	-- item:removeFromParentAndCleanup(false)
	self.container:removeChild(item, false)

	self.delegate_[MYListView.DELEGATE](self, MYListView.UNLOAD_CELL_TAG, idx)
end

--[[--

加一个空项到空闲列表中
私有函数

]]
function MYListView:addFreeItem_(item)
	item:retain()
	table.insert(self.itemsFree_, item)
end

--[[--

释放所有的空闲列表项
私有函数

]]
function MYListView:releaseAllFreeItems_()
	for i,v in ipairs(self.itemsFree_) do
		v:release()
	end
	self.itemsFree_ = {}
end

function MYListView:createCloneInstance_()
    return MYListView.new(unpack(self.args_))
end

function MYListView:copyClonedWidgetChildren_(node)
    local children = node.items_
    if not children or 0 == #children then
        return
    end

    for i, child in ipairs(children) do
        local cloneItem = self:newItem()
        local content = child:getContent()
        local cloneContent = content:clone()
        cloneItem:addContent(cloneContent)
        cloneItem:copySpecialProperties_(child)
        self:addItem(cloneItem)
    end
end

return MYListView


