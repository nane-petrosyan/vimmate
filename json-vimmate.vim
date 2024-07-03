command! VimmatePrettify call s:json_reformat()

function! s:json_reformat()
	let l:json_content = s:fetch_content()
	let l:formatted = s:reformat(l:json_content)

	call setline(1, s:prettify(l:formatted))
endfunction

function! s:fetch_content()
	return join(getline(1, '$'), "\n")
endfunction

function! s:reformat(content)
	let l:parsed = json_decode(a:content)
	let l:formatted = json_encode(l:parsed)
	return l:formatted
endfunction

function! s:prettify(json_string)
    let indent_level = 0
    let pretty_json = []
    let current_line = ''
    let in_quote = 0
    let last_char = ''

    for char in split(a:json_string, '\zs')
        if char == '{' || char == '['
            let current_line = repeat(' ', indent_level * 4) . char
            call add(pretty_json, current_line)
	    let indent_level += 1
	    let current_line = repeat(' ', indent_level * 4)
        elseif char == '}' || char == ']'
            let indent_level -= 1
            call add(pretty_json, current_line)
            let current_line = repeat(' ', indent_level * 4) . char
        elseif char == ','
            let current_line .= char
            call add(pretty_json, current_line)
            let current_line = repeat(' ', indent_level * 4)
        elseif char == '"'
            let current_line .= char
            if last_char != '\\' 
                let in_quote = !in_quote
            endif
        else
            let current_line .= char
        endif
        let last_char = char
    endfor

    let pretty_json += [current_line]
    return pretty_json
endfunction
