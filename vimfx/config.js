vimfx.set('hint_chars', 'qwertasdfgzxcvb')

let map = (shortcuts, command, custom=false) => {
  vimfx.set(`${custom ? 'custom.' : ''}mode.normal.${command}`, shortcuts)
}

function disable_cmd ( cmd ) {
    map("", cmd);
}

map('s', 'scroll_down')
map('w', 'scroll_up')
map('d', 'scroll_half_page_down')
map('e', 'scroll_half_page_up')
