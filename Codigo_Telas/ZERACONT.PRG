/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: ZERACONT.PRG
 \ Data....: 24-04-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Rotina avulsa (Zera Plano de Contas)
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas

If Select("Contas")=0
   DbfParam=DrvDbf+"Contas"
   UseArq(DbfParam)
EndIf
DBox("AGUARDE !!!|Zerando Plano de Contas",,,1,,,,)
Sele Contas
DbGoTop()
Do While !Eof()
   Do While .T.
      If Rlock()
         Repl saldoatu With 0
         Unlock
         Exit
      EndIf
   EndDo
   DbSkip()
EndDo
RETU

* \\ Final de ZERACONT.PRG
