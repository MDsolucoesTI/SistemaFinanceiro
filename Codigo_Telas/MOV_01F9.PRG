/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: MOV_01F9.PRG
 \ Data....: 24-04-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Pr‚-valida‡„o do campo TIPO, arquivo MOVIM
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
Para XCo
If XCo>=2000
   MOVIM->tipo=[S]
   M->Tipo=[S]
   Tipo=[S]
Else
   MOVIM->tipo=[E]
   M->Tipo=[E]
   Tipo=[E]
EndIf
RETU(.T.)       // <- deve retornar um valor L¢GICO

* \\ Final de MOV_01F9.PRG
