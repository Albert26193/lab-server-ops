#/bin/bash
function manv {
    nvim \
        -c ":Man $1 $2" \
        -c ":set foldlevel=1" \
        -c ":set nonumber" \
        -c "setlocal buftype=nofile" \
        -c "setlocal bufhidden=hide" \
        -c ":tabedit % | :only" \
        -c ":tabonly"
}
