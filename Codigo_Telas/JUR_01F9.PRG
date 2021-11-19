/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: JUR_01F9.PRG
 \ Data....: 08-09-95
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Valida‡„o do campo CGC, arquivo CLIENTES
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"    // inicializa constantes manifestas
Parameters x
LOCAL reg_dbf:=POINTER_DBF()
Ordem=.F.
Select CLIENTES
Go Top
Locate For cgc = x
If Found()
   Alerta(2)
   Dbox("N£mero do CGC j  Cadastrado|n„o ‚ permitido cadastrar|um Cliente mais de uma vez",,,4)
Else
   Ordem=.T.
EndIf
POINTER_DBF(reg_dbf)
RETURN(Ordem)       // <- deve retornar um valor L¢GICO
* \\ Final de JUR_01F9.PRG
