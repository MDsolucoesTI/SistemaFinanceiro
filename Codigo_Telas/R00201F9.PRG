/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: R00201F9.PRG
 \ Data....: 21-05-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: saldo do relat¢rio SFI_R002
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas
If Contas<>1 .Or. Empty(mCalSaldo)
   If Tipo=[E]
      mCalSaldo=mCalSaldo+Valor
   Else
      mCalSaldo=mCalSaldo-Valor
   EndIf
EndIf

RETU mCalSaldo      // <- deve retornar um valor qualquer

* \\ Final de R00201F9.PRG
