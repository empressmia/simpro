#!/bin/bash -e

## todo: optimize install script by using variables and so on 

if [ -d $HOME/Templates ]; then
  if [ ! -f $HOME/Templates/prj.tcl ]; then
    cp ./prj.tcl $HOME/Templates/prj.tcl;
  fi
  if [ ! -f $HOME/Templates/vsimCompile.tcl ]; then
    cp ./vsimCompile.tcl $HOME/vsimCompile.tcl;
  fi
else
  echo "$HOME/Templates does not exist, please create it"
fi

if [ -d $HOME/bin ]; then
  if [ ! -f $HOME/bin/prjInit ]; then
    cp prjInit.tcl $HOME/bin/prjInit;
  fi
  if [ ! -f $HOME/bin/prjGenerate ]; then
    cp prjGenerate.tcl $HOME/bin/prjGenerate;
  fi
else
  echo "$HOME/bin does not exists, please create it"
fi

if [ -d $HOME/.config/simpro ]; then
  ## create config folder for simpro
  mkdir -p $HOME/.config/simpro;
fi
