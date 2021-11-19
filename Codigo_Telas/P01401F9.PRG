/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: P01401F9.PRG
 \ Data....: 09-05-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Condi‡„o para lan‡amento em MOVIM, gerado por SFI_P014
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas

/*
   -------------------------------------------------------------------
   Se abrir outros arquivos salve situacao anterior e restaure ao sair
   como no exemplo abaixo:
     LOCAL reg_dbf:=POINTER_DBF()
     ...        ...        ...        ...
     POINTER_DBF(reg_dbf)
     RETU
   -------------------------------------------------------------------
*/
Para D
LOCAL reg_dbf:=POINTER_DBF(),Ordem:=.F.

Sele Movim
DbGoTop()
Locate for data=D .And. historico=1 .And. contas=1 .And. banco=BANCOS->codigo
If !Found()
   Ordem=.T.
EndIf
POINTER_DBF(reg_dbf)
RETU(Ordem)       // <- deve retornar um valor L¢GICO

* \\ Final de P01401F9.PRG
