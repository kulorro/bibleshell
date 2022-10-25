#!/bin/bash
# repo: https://github.com/ydche3/bibleshell

# Proxy Server
#export http_proxy=http://127.0.0.1:7890
#export https_proxy=$http_proxy

version=cunps
while getopts 'v:' OPTION; do
  case "$OPTION" in
    v)
      version=${OPTARG}
      ;;
  esac
done
shift "$(($OPTIND - 1))"

locate=$( echo $@ | sed -E 's/\s{1,}/\./g' )
ulocate=$( echo ${locate} | tr '[:lower:]' '[:upper:]' )
response=$( curl -X GET https://wd.bible/bible/chapterhtml/${version}/${locate} | sed s/"content"/\\n/g | tail -1 )
echo ${response} | sed -E "s/${locate}|${ulocate}|.${version}//g" | sed -E 's/\\u003c\h[0-9]\\u003e/\n\n\n/g' | sed -E 's/\\u003c\/h[0-9]\\u003e\\n/\n/g' | sed -E 's/\\u003cdiv\s{0,1}class=\\"p\\"\\u003e\\n|\\u003cdiv\s{0,1}class=\\"m\\"\\u003e\\n/\n/g' | sed -E 's/\\u003c\/div\\u003e(\\n)?//g' | sed -E 's/\\u003cdiv\s{0,1}id=\\"\.([0-9]|[1-9][0-9])\\"\s{0,1}class=\\"v\\"\\u003e\\u003ca\s{0,1}href=\\"\/bible\/verse\/\.([0-9]|[1-9][0-9])\\"\s{0,1}class=\\"vn\\"\\u003e|\\u003c\/a\\u003e|\\u003cdiv\\u003e//g' | sed -E 's/\\u003cmark\s{0,1}class=\\"f|\\"\\u003e\\u003cspan\s{0,1}class=\\"note\\"\\u003e\\u003cspan\s{0,1}class=\\"fr\\"\\u003e([0-9]|[1-9][0-9]):([0-9]|[1-9][0-9])\\u003c\/span\\u003e\\u003cspan\s{0,1}class=\\"ft\\"\\u003e.{1,}\\u003c\/span\\u003e\\u003c\/span\\u003e\\u003c\/mark\\u003e//g' | sed -E 's/\\u003cdiv\s{0,1}class=\\"pi(\\"\s{0,1}for=\\"\.)?/\n        /g' | sed -E 's/\\"\\u003e//g' | sed -E 's/\\u003cmark\s{0,1}class=\\"add|\\u003c\/mark\\u003e|\\u003cspan\s{0,1}class=\\"[a-z]{2,}|\\u003c\/span\\u003e//g' | sed -E 's/","pageTitle":"/\n(/g' | sed -E 's/"\},"errno":200,"msg":"success"\}/)\n/g' | sed -E 's/":"//g' | sed -E 's/\\n//g'
