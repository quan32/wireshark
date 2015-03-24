#!/usr/local/bin/lua

local i=0
while i <= 10
do
	print("lua",i)
	i=i+1
end

j=2
if j == 2
then
	print("true")
else
	print("false")
end

function max(num1,num2)
	local result=num1
	if(num1 > num2)
	then
		result=num1
	else
		result=num2
	end
	return result
end

print(max(4,2))
hello_world=
function()
	print("Hello world")
end

for i=0, 10, 1
do
	hello_world()
end

function average(...)
	result=0
	local arg={...}
	for i,v in ipairs(arg)
	do
		result=result+v
	end
	return result/#arg
end

print("The average is",average(1,2,3,4,5,6,7))

array={1,2,3,4}
for i=1,#array
do
	print("array[",i,"]=",array[i])
end

