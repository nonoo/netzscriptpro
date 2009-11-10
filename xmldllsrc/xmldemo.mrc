; /xmldemo

alias xmldemo {
  ; dll and .xml files
  var %dll = $+(",$scriptdirxml.dll,")
  var %xml = $scriptdirxmldemo.xml


  var %w = @xmldemo
  window -a %w | clear %w

  if (!$isfile(%dll)) { echo %w Error - missing: %dll | return }
  if (!$isfile(%xml)) { echo %w Error - missing: %xml | return }

  ; parser name
  var %n = demo

  echo %w Creating parser %n
  var %a = $dll(%dll,create_parser,%n)
  if (%a != S_OK) { echo %w Error - create_parser: %a | return }

  echo %w Setting handler aliases (commandes)
  dll %dll set_handler_xmldecl %n hxmldecl
  dll %dll set_handler_startelement %n hstartelement
  dll %dll set_handler_endelement %n hendelement
  dll %dll set_handler_attribute %n hattribute
  dll %dll set_handler_chardata %n hchardata
  dll %dll set_handler_cdata %n hcdata

  echo %w Setting XML file : %xml
  dll %dll set_file %n %xml

  ; global var: dll pathname will be use in start and end element  handlers
  %xmldemo.dll = %dll

  echo %w Parsing :
  linesep %w
  var %a = $dll(%dll,parse_file,%n)
  if (%a != S_OK) { echo -a Error - parse_file: %a }

  linesep %w
  echo %w Deleting parser %n
  dll %dll free_parser %n

  ; unsets global var
  unset %xmldemo.*
}

; handler aliases (non local)

alias hxmldecl {
  echo @xmldemo XMLdecl (version, encoding, standalone): $2-
}

alias hstartelement {
  echo $color(notice) @xmldemo Startelement: $2 ( $dll(%xmldemo.dll,get_abspath,$1) )
}

alias hendelement {
  echo $color(notice) @xmldemo Endelement: $2 ( $dll(%xmldemo.dll,get_abspath,$1) )
}

alias hattribute {
  echo $color(join) @xmldemo Attribute: $2-
}

alias hchardata {
  echo @xmldemo Chardata: $2-
}

alias hcdata {
  echo @xmldemo CDATA: $2-
}

; eof
