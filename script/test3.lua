-- Result = {
--   http_request_number=0,
--   http_fail_response_number=0,
--   http_success_response_number=0,
--   http_average_response_time =0
-- }

-- function Result:new(o)
--   o = o or {}
--   setmetatable(o, self)
--   self.__index = self
--   return o
-- end

-- function Result:print()
-- 	print("http_request_number",http_request_number)
-- 	print("http_fail_response_number", http_fail_response_number)
-- 	print("http_success_response_number", http_success_response_number)
-- 	print("http_average_response_time", http_average_response_time)
-- end

-- function Result:set_http_request_number(value)
-- 	self.http_request_number = value
-- end

-- result = Result:new(nil)
-- result:set_http_request_number(1)
-- result:print()

Shape = {area = 0}

-- Base class method new
function Shape:new (o,side)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  side = side or 0
  self.area = side*side;
  return o
end

-- Base class method printArea
function Shape:printArea ()
  print("The area is ",self.area)
end

-- Creating an object
myshape = Shape:new(nil,10)

myshape:printArea()
