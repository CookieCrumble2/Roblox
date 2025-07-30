--[[
Simple Webhook Dtc
Blocks and optionally deletes Discord webhooks in HttpPost and RequestAsync
]]--

local HttpService = game:GetService("HttpService")
local Req = http_request or request or syn.request

local config = {
    Enabled = true,
    Delete = false -- Those who kow💔😭
}

local function sussy(url)
    return string.find(url, "https://discord%.com/api/webhooks/[%w-_]+/[%w-_]+") or
           string.find(url, "webhook")
end

local function trash(url)
    if config.Delete and Req then
        local success, res = pcall(function()
            return Req({
                Url = url,
                Method = "DELETE"
            })
        end)
        if success and res and res.StatusCode == 204 then
            warn("Webhook successfully deleted:", url)
        else
            warn("Could not delete webhook:", url, res and res.StatusCode)
        end
    end
end

if config.Enabled and hookfunction and typeof(game.HttpPost) == "function" then
    local originalPost = game.HttpPost
    hookfunction(game.HttpPost, function(self, url, ...)
        if sussy(url) then
            warn("Blocked, Discord webhook in HttpPost:", url)
            trash(url)
            return nil
        end
        return originalPost(self, url, ...)
    end)
end

if config.Enabled and hookfunction and typeof(HttpService.RequestAsync) == "function" then
    local originalRequest = HttpService.RequestAsync
    hookfunction(HttpService.RequestAsync, function(self, request)
        if request and request.Url and sussy(request.Url) then
            warn("Blocked, Discord webhook in RequestAsync:", request.Url)
            trash(request.Url)
            return {Success = false, StatusCode = 403, Body = "Blocked webhook"}
        end
        return originalRequest(self, request)
    end)
end

if config.Enabled and Req and typeof(Req) == "function" and hookfunction then
    local originalReq = Req
    hookfunction(Req, function(options)
        if options and options.Url and sussy(options.Url) then
            warn("Blocked Discord webhook request:", options.Url)
            trash(options.Url)
            return {Success = false, StatusCode = 403, Body = "Blocked webhook"}
        end
        return originalReq(options)
    end)
end

print("Dont Skid Just Paste!")
