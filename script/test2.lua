-- list structure
function is_empty(table)
  if next(table) == nil then
    return true
  end
end

function list_add(table, key, value)
  table[key] = value
end

function list_find(table, keyword)
  if not isEmpty(table) then
    for key,value in pairs(table) do
      if(key == keyword) then
        return keyword
      end
    end
  end

  return nil
end

function list_remove(list, keyword)
  list[keyword] = nil
end

function list_display(table)
  print("----------table dump---------")
  for key,value in pairs(table) do
    print(key, "=> [", value.id, ",", value.value, "]")

  end
  print("----------end---------")
end

function display_element(value)
  print("----------element dump---------")
  print(key, "=> [", value.id, ",", value.value, "]")
  print("----------end---------")
end


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
  http_fail_response_number=0,
  http_success_response_number=0,
  http_total_response_time =0
}



-- main program
http_request_extractor = Field.new("http.request")
http_uri_extractor = Field.new("http.request.uri")
http_method_extractor = Field.new("http.request.method")
http_code_extractor = Field.new("http.response.code")
http_response_extractor = Field.new("http.response")
http_response_time_extractor = Field.new("http.time")
http_request_in_extractor = Field.new("http.request_in")


-- HTTP Processing
filter="http and ((ip.src==100.64.17.124 and ip.dst==203.131.197.229) or (ip.src==203.131.197.229 and ip.dst==100.64.17.124))"
http = Listener.new(nil,filter)
http_request_table = {}

function http.packet(pinfo)
  local packet_number = pinfo.number
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
	print("http_request=",http_request)
  print("http_uri=",http_uri)
	print("http_method=",http_method)
  print("http_code",http_code)
	print("http_response",http_response)
	print("http_response_time",http_response_time)
	print("http_request_in", http_request_in)

	if http_request then
        list_add(http_request_table, packet_number, {number=packet_number, method=http_method, uri=http_uri})
        result.http_request_number = result.http_request_number +1
    else
    	if in_array(response_code_list, tostring(http_code)) then
        result.http_success_response_number = result.http_success_response_number + 1
        result.http_total_response_time = result.http_total_response_time + http_response_time
      else
        result.http_fail_response_number = result.http_fail_response_number + 1
    	end

      -- remove request
      list_remove(http_request_table, http_request_in)

    end
  end

  function http.draw()
  	print("-----Summary----")
  	print("success:", result.http_success_response_number)
    print("fail:", result.http_fail_response_number)
  	print("response number:", result.http_success_response_number+result.http_fail_response_number)
  	print("request number:", result.http_request_number)
  	print("Rate:",100*result.http_success_response_number/(result.http_success_response_number+result.http_fail_response_number), "%")
    print("Avarge time:", result.http_total_response_time/result.http_success_response_number)
  end

  function http.reset()
  		
  end

