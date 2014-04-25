"============================================================================
"File:        eslint.vim
"Description: Javascript syntax checker - using eslint
"Maintainer:  Maksim Ryzhikov <rv.maksim at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"============================================================================

if exists('g:loaded_syntastic_javascript_eslint_checker')
    finish
endif
let g:loaded_syntastic_javascript_eslint_checker = 1

if !exists('g:syntastic_javascript_eslint_conf')
    let g:syntastic_javascript_eslint_conf = ''
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_javascript_eslint_IsAvailable() dict
    return
        \ executable('eslint') &&
        \ syntastic#util#versionIsAtLeast(syntastic#util#getVersion('eslint --version'), [0, 1])
endfunction

function! SyntaxCheckers_javascript_eslint_GetLocList() dict
    let makeprg = self.makeprgBuild({
        \ 'args_before': '-f compact',
        \ 'args': (g:syntastic_javascript_eslint_conf != '' ?
        \       '--config ' . syntastic#util#shexpand(g:syntastic_javascript_eslint_conf) : '') })

    let errorformat =
       \ '%E%f: line %l\, col %c\, Error - %m,' .
       \ '%W%f: line %l\, col %c\, Warning - %m'

    let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

    for e in loclist
        let e['col'] += 1
    endfor

    call self.setWantSort(1)

    return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'javascript',
    \ 'name': 'eslint'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sts=4 sw=4:
