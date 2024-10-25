-- 添加日志功能
local function log(msg)
    -- 写入到标准错误输出和日志文件
    local function write_log(str)
        io.stderr:write(str .. "\n")
        local f = io.open("pandoc_filter.log", "a")
        if f then
            f:write(str .. "\n")
            f:close()
        end
    end
    
    write_log(os.date("%Y-%m-%d %H:%M:%S") .. " " .. tostring(msg))
end

-- 清空日志文件
io.open("pandoc_filter.log", "w"):close()
log("Filter started")

-- 定义图标映射
local icon_map = {
    ["\\faPhone"] = '<i class="fas fa-phone"></i>',
    ["\\faEnvelope"] = '<i class="fas fa-envelope"></i>',
    ["\\faGithub"] = '<i class="fab fa-github"></i>',
    ["\\faMapMarker"] = '<i class="fas fa-map-marker-alt"></i>',
    ["\\faGlobe"] = '<i class="fas fa-globe"></i>',
    ["\\faBlog"] = '<i class="fas fa-blog"></i>',
    ["\\LaTeX"] = 'LaTeX',
    ["\\XeTeX"] = 'XeTeX',
    ["\\separator"] = '<span class="separator">•</span>',
    ["\\arrowsymbol"] = '<span class="arrow">→</span>'
}

-- 处理联系方式的函数
local function create_contact_grid()
    log("Creating contact grid")
    return pandoc.RawBlock('html', [[
        <div class="contact-grid">
            <div class="contact-item">
                <i class="fas fa-phone"></i>
                <span>1*********</span>
            </div>
            <div class="contact-item">
                <i class="fas fa-envelope"></i>
                <a href="mailto:***@***.com">***@***.com</a>
            </div>
            <div class="contact-item">
                <i class="fab fa-github"></i>
                <a href="https://gitee.com/***">gitee.com/***</a>
            </div>
            <div class="contact-item">
                <i class="fas fa-map-marker-alt"></i>
                <span>武汉市***</span>
            </div>
            <div class="contact-item">
                <i class="fas fa-globe"></i>
                <a href="https://***.pages.dev">***.pages.dev</a>
            </div>
            <div class="contact-item">
                <i class="fas fa-blog"></i>
                <a href="https://www.cnblogs.com/***">cnblogs.com/***</a>
            </div>
        </div>
    ]])
end

-- 处理行内元素
function RawInline(el)
    if el.format == "tex" then
        log("Processing RawInline: " .. el.text)
        -- 处理图标
        if icon_map[el.text] then
            log("Found icon: " .. el.text)
            return pandoc.RawInline('html', icon_map[el.text])
        end
        -- 处理特殊命令
        if el.text:match("\\begin{tabularx}") then
            log("Found begin tabularx")
            return pandoc.RawInline('html', '')
        end
        if el.text:match("\\end{tabularx}") then
            log("Found end tabularx")
            return pandoc.RawInline('html', '')
        end
    end
    return el
end

-- 处理段落
function Para(el)
    local text = pandoc.utils.stringify(el)
    log("Processing Para: " .. text)
    
    -- 检查是否是联系方式表格
    if text:match("@L%s*L%s*L@") or
       text:match("1%%*%*%*%*%*%*%*%*%*") then
        log("Found contact info")
        return create_contact_grid()
    end
    -- 移除特定的无用文本
    if text:match("^%s*height%s*0%.5pt%s*$") or
       text == "" then
        log("Removing height line or empty para")
        return {}
    end
    return el
end

-- 处理原始块
function RawBlock(el)
    if el.format == "tex" then
        log("Processing RawBlock: " .. el.text:sub(1, 100))
        -- 处理 tabularx 环境
        if el.text:match("\\begin{tabularx}") then
            log("Found tabularx environment")
            return create_contact_grid()
        end
        -- 移除其他 LaTeX 命令
        if el.text:match("\\end{tabularx}") or
           el.text:match("\\noindent") then
            log("Removing LaTeX command")
            return {}
        end
    end
    return el
end

-- 处理分隔线
function HorizontalRule(el)
    log("Processing HorizontalRule")
    return pandoc.RawBlock('html', '<hr class="section-divider">')
end

return {
    { RawInline = RawInline },
    { Para = Para },
    { RawBlock = RawBlock },
    { HorizontalRule = HorizontalRule }
}
