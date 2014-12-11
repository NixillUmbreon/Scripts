--------------
-- Options! --
--------------
owner = "NixillUmbreon" -- The one the puppy chases
chaseAt = 2 -- Minimum distance between puppy and owner for a chase to ensue
beepOnChase = nil -- Midi code to beep twice on chase starting. Set to nil for no beep.
beepOnCatch = 72 -- Midi code to beep twice on chase ending. Set to nil for no beep.

---------------------------------
-- Classes used in this script --
---------------------------------
function Position(x, y, z)
  values = {
    x=x,
    y=y,
    z=z,
    add = function(pos1, pos2)
      local x = pos1.x + pos2.x
      local y = pos1.y + pos2.y
      local z = pos1.z + pos2.z
      return Position(x, y, z)
    end,
    subtract = function(pos1, pos2)
      local x = pos1.x - pos2.x
      local y = pos1.y - pos2.y
      local z = pos1.z - pos2.z
      return Position(x, y, z)
    end,
    length = function(pos1)
      local x = pos1.x
      local y = pos1.y
      local z = pos1.z
      return (x^2 + y^2 + z^2)^0.5
    end,
    equals = function(pos1, pos2)
      local xeq = (pos1.x == pos2.x)
      local yeq = (pos1.y == pos2.y)
      local zeq = (pos1.z == pos2.z)
      return xeq and yeq and zeq
    end,
    int = function(pos1)
      local x = math.floor(pos1.x)
      local y = math.floor(pos1.y)
      local z = math.floor(pos1.z)
      return Position(x, y, z)
    end,
    toString = function(pos1)
      return ("{%d, %d, %d}"):format(pos1.x, pos1.y, pos1.z)
    end,
    longest = function(pos1)
      --[[ Returns the sides in order of length and direction.
      It returns one of "+x", "0x", "-x"; one of "+y", "0y", "-y";
      and one of "+z", "0z", and "-z"; these will be in order from
      longest (absolute value) side to shortest, in the order shown
      in the event of a tie.]]
      local x = pos1.x
      local xValue = "0x"
      local y = pos1.y
      local yValue = "0y"
      local z = pos1.z
      local zValue = "0z"
      local values = { }
      if x > 0 then xValue = "+x"
        elseif x < 0 then xValue = "-x" x = -x end
      if y > 0 then yValue = "+y"
        elseif y < 0 then yValue = "-y" y = -y end
      if z > 0 then zValue = "+z"
        elseif z < 0 then zValue = "-z" z = -z end
      values = {xValue}
      local h = x
      local l = y
      if y > x then
        table.insert(values, 1, yValue)
        h = y
        l = x
      else table.insert(values, yValue) end
      if z > h then
        table.insert(values, 1, zValue)
      elseif z > l then
        table.insert(values, 2, zValue)
      else table.insert(values, zValue) end
      return values[1], values[2], values[3]
    end
  }
  return values
end

-- Static Position functions!
position = {
  current = function(d)
    return Position(d.getX(), d.getY(), d.getZ())
  end,
  player = function(d, name)
    local p = d.getPlayer(name)
    local x, y, z = p.getPosition()
    if y == "player is offline" then
      return nil, "player is offline"
    else
      return Position(x, y, z)
    end
  end
}

-----------------------------------
-- Functions used in this script --
-----------------------------------

function lineUp(newRot)
  offRot = newRot - cRot
  if offRot == 1 or offRot == -3 then spinRight()
  elseif offRot == 2 or offRot == -2 then spinRight() spinRight()
  elseif offRot == 3 or offRot == -1 then spinLeft() end
end

function spinLeft()
  r.turnLeft()
  cRot = cRot-1
  if cRot == -1 then cRot = 3 end
end

function spinRight()
  r.turnRight()
  cRot = cRot+1
  if cRot == 4 then cRot = 0 end
end

---------------------------
-- Script initialization --
---------------------------

rotations = {"+z", "-x", "-z", "+x", ["+x"]=4, ["-x"]=2, ["+z"]=1, ["-z"]=3}

c = require("component")
d = c.debug
r = require("robot")
n = require("note")

cPos = position.current(d)
r.forward()
dPos = position.current(d)

cRot = rotations[dPos:subtract(cPos):longest()]

chasing = false

while true do
  pPos = position.player(d, owner)
  cPos = position.current(d)
  if pPos ~= nil then
    dist = pPos:subtract(cPos)
    leng = dist:length()
    if leng >= chaseAt then
      if chasing == false and beepOnChase then
        for a = 1, 2 do n.play(beepOnChase, 0.2) end
      end
      chasing = true
      dirs = {dist:longest()}
      for i = 1, 3 do
        dir = dirs[i]
        if dir == "+y" then
          moved = r.up()
        elseif dir == "-y" then
          moved = r.down()
        elseif dir == "0x" or dir == "0y" or dir == "0z" then
          break -- since 0 can only precede other 0s
        else
          lineUp(rotations[dir])
          moved = r.forward()
        end
        if moved then break end
      end
    else
      if chasing and beepOnCatch then
        for a = 1, 2 do n.play(beepOnCatch, 0.2) end
      end
      chasing = false
    end
  end
end
