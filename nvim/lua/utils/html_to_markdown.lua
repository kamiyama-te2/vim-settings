local M = {}

-- HTML to Markdown converter
function M.convert_html_to_markdown()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local html = table.concat(lines, "\n")
  local markdown = M.parse_html(html)
  local markdown_lines = vim.split(markdown, "\n")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, markdown_lines)
  vim.bo.filetype = "markdown"
  print("HTML converted to Markdown successfully!")
end

function M.parse_html(html)
  local markdown = html

  -- Extract Confluence main content if present
  markdown = M.extract_confluence_content(markdown)

  -- Remove sticky table elements
  markdown = M.remove_sticky_elements(markdown)

  -- Remove script tags
  markdown = markdown:gsub("<script[^>]*>.-</script>", "")

  -- Protect tables
  local table_placeholders = {}
  local table_counter = 0
  markdown = markdown:gsub("(<table[^>]*>.-</table>)", function(table_html)
    table_counter = table_counter + 1
    local placeholder = "___TABLE_PLACEHOLDER_" .. table_counter .. "___"
    table_placeholders[placeholder] = table_html
    return "\n" .. placeholder .. "\n"
  end)

  -- Convert lists FIRST before cleaning anything else
  markdown = M.process_lists(markdown)

  -- Clean divs/spans AFTER processing lists
  markdown = markdown:gsub("</?div[^>]*>", "")
  markdown = markdown:gsub("</?span[^>]*>", "")

  -- Convert headings
  markdown = M.convert_headings(markdown)

  -- Convert formatting
  markdown = markdown:gsub("<strong[^>]*>(.-)</strong>", "**%1**")
  markdown = markdown:gsub("<b>(.-)</b>", "**%1**")
  markdown = markdown:gsub("<em>(.-)</em>", "*%1*")
  markdown = markdown:gsub("<i>(.-)</i>", "*%1*")

  -- Remove paragraphs
  markdown = markdown:gsub("<p[^>]*>(.-)</p>", "%1")

  -- Handle breaks - but keep <br> in table cells, convert others to newlines
  -- First protect table content
  local table_br_protected = markdown:gsub("(___TABLE_PLACEHOLDER_%d+___)", function(placeholder)
    return placeholder -- Keep table placeholders as-is
  end)

  -- Convert remaining breaks to newlines
  markdown = markdown:gsub("<br[^>]*/?>", "<br>")

  -- Restore tables
  for placeholder, table_html in pairs(table_placeholders) do
    local converted_table = M.convert_tables(table_html)
    markdown = markdown:gsub(placeholder, converted_table)
  end

  -- Clean remaining HTML but preserve <br> tags
  markdown = markdown:gsub("<br>", "___BR_PRESERVED___")
  markdown = markdown:gsub("<[^>]+>", "")
  markdown = markdown:gsub("___BR_PRESERVED___", "<br>")

  -- Clean whitespace and stray tags
  markdown = markdown:gsub("^%s+", "")
  markdown = markdown:gsub("%s+$", "")
  markdown = markdown:gsub("\n\n\n+", "\n\n")
  -- Remove trailing <br> tags
  markdown = markdown:gsub("<br>%s*$", "")

  return markdown
end

-- Remove sticky table elements
function M.remove_sticky_elements(html)
  local result = html
  
  -- Remove entire sticky table container structure using proper depth tracking
  local function remove_sticky_container(text)
    local output = text
    while true do
      local start_pos = output:find('<div[^>]*class="cc%-12efcmn"[^>]*>')
      if not start_pos then break end
      
      -- Find the matching closing div
      local depth = 1
      local pos = output:find('>', start_pos) + 1
      local end_pos = nil
      
      while depth > 0 and pos <= #output do
        local next_open = output:find('<div[^>]*>', pos)
        local next_close_start, next_close_end = output:find('</div>', pos)
        
        if not next_close_start then break end
        
        if next_open and next_open < next_close_start then
          depth = depth + 1
          pos = output:find('>', next_open) + 1
        else
          depth = depth - 1
          if depth == 0 then
            end_pos = next_close_end
            break
          end
          pos = next_close_end + 1
        end
      end
      
      if end_pos then
        output = output:sub(1, start_pos - 1) .. output:sub(end_pos + 1)
      else
        break
      end
    end
    return output
  end
  
  -- Remove sticky container
  result = remove_sticky_container(result)
  
  -- Remove remaining sticky elements
  local patterns_to_remove = {
    '<div[^>]*class="[^"]*pm%-table%-sticky%-scrollbar%-sentinel%-top[^"]*"[^>]*>.-</div>',
    '<div[^>]*class="[^"]*pm%-table%-sticky%-scrollbar%-sentinel%-bottom[^"]*"[^>]*>.-</div>',
    '<div[^>]*class="[^"]*pm%-table%-sticky%-scrollbar%-container%-view%-page[^"]*"[^>]*>.-</div>',
    '<div[^>]*data%-vc="table%-sticky%-scrollbar%-container"[^>]*>.-</div>',
    -- Remove colgroup with test-id="num"
    '<colgroup>.-<col[^>]*data%-test%-id="num"[^>]*/>.-</colgroup>',
    -- Remove number column cells
    '<td[^>]*class="[^"]*ak%-renderer%-table%-number%-column[^"]*"[^>]*>.-</td>',
  }
  
  for _, pattern in ipairs(patterns_to_remove) do
    result = result:gsub(pattern, "")
  end
  
  return result
end

-- Extract Confluence main content (equivalent to BeautifulSoup's find)
function M.extract_confluence_content(html)
  -- Look for div with id="main-content"
  local main_content_start, main_content_start_end = html:find('<div[^>]*id="main%-content"[^>]*>')

  if not main_content_start then
    -- Also try id='main-content' (single quotes)
    main_content_start, main_content_start_end = html:find("<div[^>]*id='main%-content'[^>]*>")
  end

  if not main_content_start then
    -- If no main-content div found, return original HTML
    -- This maintains compatibility with non-Confluence pages
    return html
  end

  -- Find the matching closing </div> tag
  local depth = 1
  local pos = main_content_start_end + 1
  local main_content_end = nil

  while depth > 0 and pos <= #html do
    local next_open = html:find("<div[^>]*>", pos)
    local next_close_start, next_close_end = html:find("</div>", pos)

    if not next_close_start then
      -- No closing div found, return original HTML
      return html
    end

    if next_open and next_open < next_close_start then
      depth = depth + 1
      pos = next_open + 1
      -- Skip to end of opening tag
      local tag_end = html:find(">", next_open)
      if tag_end then
        pos = tag_end + 1
      end
    else
      depth = depth - 1
      if depth == 0 then
        main_content_end = next_close_start
        break
      end
      pos = next_close_end + 1
    end
  end

  if main_content_end then
    -- Extract only the content inside main-content div
    local extracted_content = html:sub(main_content_start_end + 1, main_content_end - 1)
    print("Confluence main-content extracted (" .. #extracted_content .. " chars)")
    return extracted_content
  else
    -- If matching closing tag not found, return original HTML
    print("Warning: Could not find matching </div> for main-content")
    return html
  end
end

function M.convert_headings(html)
  local patterns = {
    {"<h1[^>]*>(.-)</h1>", "# %1"},
    {"<h2[^>]*>(.-)</h2>", "## %1"},
    {"<h3[^>]*>(.-)</h3>", "### %1"},
  }
  local result = html
  for _, pattern in ipairs(patterns) do
    result = result:gsub(pattern[1], pattern[2] .. "\n")
  end
  return result
end

-- Working list processor
function M.process_lists(html)
  local result = html

  -- Function to find matching closing tag with proper depth tracking
  local function find_matching_close(text, start_pos, open_pattern, close_pattern)
    local depth = 1
    local pos = start_pos

    while depth > 0 and pos <= #text do
      local next_open_start, next_open_end = text:find(open_pattern, pos)
      local next_close_start, next_close_end = text:find(close_pattern, pos)

      if not next_close_start then
        return nil, nil
      end

      if next_open_start and next_open_start < next_close_start then
        depth = depth + 1
        pos = next_open_end + 1
      else
        depth = depth - 1
        if depth == 0 then
          return next_close_start, next_close_end
        end
        pos = next_close_end + 1
      end
    end
    return nil, nil
  end

  -- Extract lists manually using proper HTML parsing
  local function extract_and_convert_lists(text, list_pattern, list_type)
    local output = text
    local found_any = false

    while true do
      local ul_start, ul_start_end = output:find(list_pattern)
      if not ul_start then break end

      local close_start, close_end = find_matching_close(output, ul_start_end + 1, list_pattern, "</[ou]l>")
      if not close_start then break end

      -- Extract the content between the matching tags
      local list_content = output:sub(ul_start_end + 1, close_start - 1)

      -- Convert this specific list
      local converted = M.convert_single_list(list_content, list_type, 0)

      -- Replace the original list with converted markdown
      output = output:sub(1, ul_start - 1) .. "\n" .. converted .. "\n" .. output:sub(close_end + 1)
      found_any = true
    end

    return output, found_any
  end

  -- Process lists iteratively
  local max_iterations = 5
  for i = 1, max_iterations do
    local changed = false
    local temp_result

    -- Process UL lists
    temp_result, changed = extract_and_convert_lists(result, "<ul[^>]*>", "ul")
    result = temp_result

    -- Process OL lists
    temp_result, changed = extract_and_convert_lists(result, "<ol[^>]*>", "ol")
    result = temp_result or result

    if not changed then break end
  end

  return result
end

-- Convert a single list's content
function M.convert_single_list(content, list_type, level)
  local items = {}
  local pos = 1
  level = level or 0
  local indent = string.rep("    ", level)

  while true do
    -- Find next <li> tag
    local li_start, li_start_end = content:find("<li[^>]*>", pos)
    if not li_start then break end

    -- Find matching </li>
    local li_close_start, li_close_end = find_matching_close(content, li_start_end + 1, "<li[^>]*>", "</li>")
    if not li_close_start then break end

    local item_content = content:sub(li_start_end + 1, li_close_start - 1)

    -- First, extract and store any nested lists
    local nested_lists = {}
    local clean_content = item_content

    -- Replace nested ULs with placeholders
    while true do
      local nested_start, nested_start_end = clean_content:find("<ul[^>]*>")
      if not nested_start then break end

      local nested_close_start, nested_close_end = find_matching_close(clean_content, nested_start_end + 1, "<ul[^>]*>", "</ul>")
      if not nested_close_start then break end

      local nested_content = clean_content:sub(nested_start_end + 1, nested_close_start - 1)
      table.insert(nested_lists, {type="ul", content=nested_content})

      clean_content = clean_content:sub(1, nested_start - 1) .. "___NESTED_" .. #nested_lists .. "___" .. clean_content:sub(nested_close_end + 1)
    end

    -- Replace nested OLs with placeholders
    while true do
      local nested_start, nested_start_end = clean_content:find("<ol[^>]*>")
      if not nested_start then break end

      local nested_close_start, nested_close_end = find_matching_close(clean_content, nested_start_end + 1, "<ol[^>]*>", "</ol>")
      if not nested_close_start then break end

      local nested_content = clean_content:sub(nested_start_end + 1, nested_close_start - 1)
      table.insert(nested_lists, {type="ol", content=nested_content})

      clean_content = clean_content:sub(1, nested_start - 1) .. "___NESTED_" .. #nested_lists .. "___" .. clean_content:sub(nested_close_end + 1)
    end

    -- Extract text from the cleaned content
    local text = clean_content:gsub("<p[^>]*>(.-)</p>", "%1")
    text = text:gsub("<[^>]+>", "")
    text = text:gsub("___NESTED_%d+___", "")
    text = text:gsub("^%s+", ""):gsub("%s+$", "")

    -- Generate marker and add item
    if text ~= "" then
      local marker
      if list_type == "ul" then
        marker = "- "
      else
        -- Count actual items, not including nested ones
        local item_count = 0
        for _, existing_item in ipairs(items) do
          if existing_item:find("^" .. indent .. "%d") or existing_item:find("^" .. indent .. "[a-z]") or existing_item:find("^" .. indent .. "i") then
            item_count = item_count + 1
          end
        end
        item_count = item_count + 1

        if level == 0 then
          marker = item_count .. ". "
        elseif level == 1 then
          marker = string.char(96 + item_count) .. ". "  -- a, b, c
        else
          marker = string.rep("i", item_count) .. ". "
        end
      end
      table.insert(items, indent .. marker .. text)
    end

    -- Process nested lists recursively
    for _, nested in ipairs(nested_lists) do
      local nested_result = M.convert_single_list(nested.content, nested.type, level + 1)
      if nested_result ~= "" then
        for line in nested_result:gmatch("[^\n]+") do
          table.insert(items, line)
        end
      end
    end

    pos = li_close_end + 1
  end

  return table.concat(items, "\n")
end

-- Helper function that was missing
function find_matching_close(text, start_pos, open_pattern, close_pattern)
  local depth = 1
  local pos = start_pos

  while depth > 0 and pos <= #text do
    local next_open_start, next_open_end = text:find(open_pattern, pos)
    local next_close_start, next_close_end = text:find(close_pattern, pos)

    if not next_close_start then
      return nil, nil
    end

    if next_open_start and next_open_start < next_close_start then
      depth = depth + 1
      pos = next_open_end + 1
    else
      depth = depth - 1
      if depth == 0 then
        return next_close_start, next_close_end
      end
      pos = next_close_end + 1
    end
  end
  return nil, nil
end

-- Table converter
function M.convert_tables(html)
  local result = html:gsub("<table[^>]*>(.-)</table>", function(table_content)
    local rows = {}
    local header_row = nil

    table_content:gsub("<tr[^>]*>(.-)</tr>", function(row_content)
      local cells = {}

      -- Headers
      row_content:gsub("<th[^>]*>(.-)</th>", function(cell_content)
        local cleaned = M.clean_table_cell(cell_content)
        table.insert(cells, cleaned)
      end)

      if #cells > 0 then
        header_row = cells
        return
      end

      -- Data cells
      row_content:gsub("<td[^>]*>(.-)</td>", function(cell_content)
        local cleaned = M.clean_table_cell(cell_content)
        table.insert(cells, cleaned)
      end)

      if #cells > 0 then
        table.insert(rows, cells)
      end
    end)

    local md_table = ""
    if header_row then
      md_table = "| " .. table.concat(header_row, " | ") .. " |\n"
      md_table = md_table .. "| " .. table.concat({"---", "---", "---"}, " | ") .. " |\n"
    end

    for _, row in ipairs(rows) do
      md_table = md_table .. "| " .. table.concat(row, " | ") .. " |\n"
    end

    return md_table
  end)
  return result
end

function M.clean_table_cell(content)
  content = content:gsub("<br[^>]*/?>", "__BR__")
  content = content:gsub("<p[^>]*>(.-)</p>", "%1")
  content = content:gsub("<strong[^>]*>(.-)</strong>", "**%1**")

  -- Lists in cells
  content = content:gsub("<ul[^>]*>(.-)</ul>", function(list_content)
    local items = {}
    list_content:gsub("<li[^>]*>(.-)</li>", function(item)
      item = item:gsub("<p[^>]*>(.-)</p>", "%1")
      item = item:gsub("^%s+", ""):gsub("%s+$", "")
      if item ~= "" then
        table.insert(items, "- " .. item)
      end
    end)
    return table.concat(items, "<br>")
  end)

  content = content:gsub("__BR__", "<br>")
  content = content:gsub("^%s+", ""):gsub("%s+$", "")
  return content
end

function M.setup()
  vim.api.nvim_create_user_command('HtmlMd', function()
    M.convert_html_to_markdown()
  end, {})
end

return M