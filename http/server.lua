--[[
CaptiveIntraweb HTTP Server
Modified by Andy Reischle
Blog at: www.areresearch.net
Youtube: www.youtube.com/AReResearch

Based on 
XChip's NodeMCU IDE
]]--

srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 

   local Status = 0
   local DataToGet = 0
   local method=""
   local url=""
   local vars=""

  conn:on("receive",function(conn,payload)
  
    if Status==0 then
        _, _, method, url, vars = string.find(payload, "([A-Z]+) /([^?]*)%??(.*) HTTP")
        ---print(method, url, vars)                          
    end

	if url==nil then
		url="index.html"
	end
	
	if url=="" then
		url="index.html"
	end
	
	-- some ugly magic for Apple IOS Devices
	if string.find(url, "/") ~= nil then
	 --print ("Slash found")
	 local invurl=string.reverse(url)
	 local a,b=string.find(invurl, "/", 1)
	 url=string.sub(url, string.len(url)-(a-2))
	 --print ("Neue URL= " .. url)
	end
		
	if string.len(url)>= 25 then
		url = string.sub (url,1,25)
	--	print ("cut down URL")
	end
	
   
    DataToGet = -1

    if url == "favicon.ico" then
        conn:send("HTTP/1.1 404 file not found")
        return
    end    

	
    conn:send("HTTP/1.1 200 OK\r\n\r\n")
	
	local foundmatch = 0
	local a = {'one.min.js'}
	for _,v in pairs(a) do
		if v == url then
			foundmatch=1
			print ("Found " .. v)
			break
		end
	end

    if foundmatch == 0 then
        --- print ("Found no match, setting index")
        url="index.html"
    end

    -- it wants a file in particular
    if url~="" then
        DataToGet = 0
        return
    end    
  
  end)
  
  conn:on("sent",function(conn) 
    if DataToGet>=0 and method=="GET" then
        if file.open(url, "r") then            
            file.seek("set", DataToGet)
            local line=file.read(1024)
            file.close()
            if line then
                conn:send(line)
				--- print ("sending:" .. DataToGet)
                DataToGet = DataToGet + 1024    
                if (string.len(line)==1024) then
                    return
                end
            end
        end        
    end

    conn:close()
    conn = nil
    collectgarbage()
  end)
end)

print("HTTP Server is now listening. Free Heap:", node.heap())
