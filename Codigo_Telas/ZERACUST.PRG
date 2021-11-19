/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: ZERACUST.PRG
 \ Data....: 24-04-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Rotina avulsa (Zera Centro de Custos)
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas
XXX:=Space(01)
@ 13,35 Get XXX Pict "@!" When(Perg1())
Read
If XXX=[S]
   If Select("Custo")=0
      DbfParam=DrvDbf+"Custo"
      UseArq(DbfParam)
   EndIf
   DBox("AGUARDE !!!|Zerando Centro de Custo",,,0.5,,,,)
   Sele Custo
   DbGoTop()
   Do While !Eof()
      Do While .T.
         If Rlock()
            Repl receita With 0
            Repl despesa With 0
            Unlock
            Exit
         EndIf
      EndDo
      DbSkip()
   EndDo
EndIf
RETU

Function Perg1
xxx=MTab([SIM|NŽO],[Deseja realmente zera o Centro de Custo ?])
KeyBoard Chr(13)
Return(.T.)
* \\ Final de ZERACUST.PRG
