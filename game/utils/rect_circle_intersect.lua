--
-- 怎样判断平面上一个矩形和一个圆形是否有重叠？ - Milo Yip的回答 - 知乎
-- https://www.zhihu.com/question/24251545/answer/27184960
--
local function v2_sub(a, b)
	a.x = a.x - b.x
	a.y = a.y - b.y
	return a
end

local function v2_abs(a)
	a.x = math.abs(a.x)
	a.y = math.abs(a.y)
	return a
end

local function max(v, n)
	if v.x < n then
		v.x = n
	end
	if v.y < n then
		v.y = n
	end
	return v
end

local function dot(a, b)
	return a.x * b.x + a.y * b.y
end


local function get_h(w, h)
	return {
		x = w/2,
		y = h/2
	}
end

local function rotatePoint(p, p0, x)
    local angle = math.rad(x) -- 将角度转换为弧度
    local cosAngle = math.cos(angle)
    local sinAngle = math.sin(angle)

    local newX = (p.x - p0.x) * cosAngle - (p.y - p0.y) * sinAngle + p0.x
    local newY = (p.x - p0.x) * sinAngle + (p.y - p0.y) * cosAngle + p0.y

    p.x = newX
    p.y = newY
    return p
end


-- c V2 矩形中心
-- h V2 矩形半長
-- a float 矩形角度
-- p V2 圆心
-- r 圆心半径
local function rect_circle_intersect(c, h, a, p, r)
	p = rotatePoint(p, c, -a)
	local v = v2_abs(v2_sub(p, c)) 	-- 第1步：转换至第1象限
	local u = max(v2_sub(v, h), 0) 	-- 第2步：求圆心至矩形的最短距离矢量
	return dot(u, u) <= r*r
end


return rect_circle_intersect
