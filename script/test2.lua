-- http response code
response_code_list = {"100","101","102","200","201","202","203","204","205","206","207","208","226","300","301","302","303","304","305","306","307","308"}
function in_array(array, element)
  for key,value in pairs(array) do
    if element == value then
      return true
    end
  end
  return false
end


-- result array
result = {
  http_request_number=0,
  http_request_method = "GET",
  http_fail_response_number=0,
  http_success_response_number=0,
  http_total_response_time =0,
  first_request_time = 0,
  last_response_time =0,
  uri = ""
}

-- file open
file = io.open("../result.csv","a")

-- main program
http_request_extractor = Field.new("http.request")
http_uri_extractor = Field.new("http.request.uri")
http_method_extractor = Field.new("http.request.method")
http_code_extractor = Field.new("http.response.code")
http_response_extractor = Field.new("http.response")
http_response_time_extractor = Field.new("http.time")
http_request_in_extractor = Field.new("http.request_in")
frame_time_relative_extractor = Field.new("frame.time_relative")

-- HTTP Processing
filter="http and (ip.src==203.131.197.228 or ip.src==203.131.197.228 or ip.src==203.131.197.229 or ip.dst==203.131.197.228)"
http = Listener.new(nil,filter)

function http.packet(pinfo)
  local packet_number = pinfo.number
  local frame_time_relative = frame_time_relative_extractor()
	local http_request = http_request_extractor()
  local http_uri = http_uri_extractor()
	local http_method = http_method_extractor()
  local http_code = http_code_extractor()
	local http_response = http_response_extractor()
	local http_response_time = http_response_time_extractor()
  http_response_time = tostring(http_response_time)
	local http_request_in = http_request_in_extractor()
  http_request_in = tostring(http_request_in)

	print("number", packet_number)
  print("frame_time_relative",frame_time_relative)
	print("http_request=",http_request)
  print("http_uri=",http_uri)
	print("http_method=",http_method)
  print("http_code",http_code)
	print("http_response",http_response)
	print("http_response_time",http_response_time)
	print("http_request_in", http_request_in)

	if http_request then

      if result.http_request_number == 0 then
        result.http_request_method = tostring(http_method)
        result.first_request_time = tostring(frame_time_relative)
        result.uri = tostring(http_uri)
      end
      result.http_request_number = result.http_request_number +1

  else

  	if in_array(response_code_list, tostring(http_code)) then
      result.last_response_time = tostring(frame_time_relative)
      result.http_success_response_number = result.http_success_response_number + 1
    else
      result.http_fail_response_number = result.http_fail_response_number + 1
  	end

  end
end

function http.draw()
  result.http_total_response_time = result.last_response_time-result.first_request_time
  file:write("home_btn,"..result.http_total_response_time..","..result.http_request_method..","..result.http_request_number..","..(result.http_success_response_number+result.http_fail_response_number)..","..result.http_success_response_number..","..result.http_fail_response_number.."," ..result.uri.."\n")
end

function http.reset()
		file:close()
end

