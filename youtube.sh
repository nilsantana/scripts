#!/usr/bin/env bash

#author: Marcos Oliveira <terminalrooot.com.br>
#describe: Get data youtube video and channel details
#version: 0.1
#license: MIT License
#titulo: grep '<title>' nome.html | sed 's/<[^>]*>//g' | sed 's/ - You.*//g'
#visualizacoes grep 'watch-view-count' nome.html | sed 's/<[^>]*>//g'
#Gostei: grep 'like-button-renderer-like-button'  nome.html |sed -n 1p | sed 's/<[^>]*>//g;s/ //g'
#Desgostei: grep 'like-button-renderer-dislike-button'  nome.html |sed -n 1p | sed 's/<[^>]*>//g;s/ //g'
#id do canal:  sed 's/channel/\n&/g' nome.html | grep '^channel'| sed -n 1p | sed 's/isCrawlable.*//g;s/..,.*//g;s/.*"//g' 
#titulo do canal: sed -n '/title/{p;q;}' nome5.html | sed 's/<title> //g'
#inscritos sed -n '/subscriber-count/{p;q;}' nome5.html | sed 's/.*subscriber-count//g' | sed 's/<[^>]*>//g;s/.*>//g'

function youtube(){
	_gr="\e[36;1m" ; _yl="\e[33;1m";_of="\e[m"
        local _video
         _video=$(mktemp)
        local _channel
        _channel=$(mktemp)
	local _token
	_token=$(mktemp) 
        local _url
        _url="https://youtube.com/channel"
        wget "$1" -O "$_video" 2>/dev/null

        local _title
        _title=$(grep '<title>' "$_video" | sed 's/<[^>]*>//g' | sed 's/ - You.*//g')
        local _views
        _views=$(grep 'watch-view-count' "$_video" | sed 's/<[^>]*>//g')
	local _publi
	_publi=$(egrep '(Publicado|Estreou).*<\/strong>' "$_video" | sed 's/.*\(Publicado\|Estreou\)/Publicado/g; s/<\/strong>.*//g')
        local _likes
        _likes=$(grep 'like-button-renderer-like-button' "$_video"  |sed -n 1p | sed 's/<[^>]*>//g;s/ //g')
        local _dislikes
        _dislikes=$(grep 'like-button-renderer-dislike-button'  "$_video" |sed -n 1p | sed 's/<[^>]*>//g;s/ //g')
        local _id
        _id=$(sed 's/channel/\n&/g' "$_video" | grep '^channel'| sed -n 1p | sed 's/isCrawlable.*//g;s/..,.*//g;s/.*"//g')
        wget "$_url/$_id" -O "$_channel" 2>/dev/null

	# Adicionado COMMENTS em vez de -i coment
	local _data 
	_data=$(grep -i 'COMMENTS' "$_video" | sed 's/.*: \"//g ; s/\".*//g')
	wget "$1&lc=$_data" -o $_token 2>/dev/null

	#filtrado somente os n√meros
	local _comments
	_comments=$(grep -i 'comment' "$_token" | sed -n 1p | sed 's/<[^>]*>//g')
        local _tchannel
        _tchannel=$(sed -n '/title/{p;q;}' "$_channel" | sed 's/<title> //g')
        local _subscribers
        _subscribers=$(sed -n '/subscriber-count/{p;q;}' "$_channel" | sed 's/.*subscriber-count//g' | sed 's/<[^>]*>//g;s/.*>//g')

        echo -e "${_gr}T√≠tulo do cana:${_yl}$_tchannel"
        echo -e "${_gr}Inscritos:${_yl}$_subscribers"
        echo -e "${_gr}Titulo do video:${_yl}$_title"
	echo -e "${_gr}Data:${_yl}$_publi"
        echo -e "${_gr}Visualiza√ß√µe${_yl}$_views"
        echo -e "${_gr}Gostei:${_yl} $_likes"
        echo -e "${_gr}Dislikes:${_yl}$_dislikes"
	echo -e "${_gr}Coment√rios:${_yl}$_comments${_of}"
}


youtube "$1"
