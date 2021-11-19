/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: FOR_04F9.PRG
 \ Data....: 08-09-95
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Valida‡„o do campo CGC, arquivo FORNEC
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"    // inicializa constantes manifestas
Parameters x
LOCAL reg_dbf:=POINTER_DBF()
Ordem=.F.
Select FORNEC
Go Top
Locate For cgc = x
If Found()
   Alerta(2)
   Dbox("N£mero do CGC j  Cadastrado|n„o ‚ permitido cadastrar|um Fornecedor mais de uma vez",,,4)
Else
   Ordem=.T.
EndIf
POINTER_DBF(reg_dbf)
RETURN(Ordem)       // <- deve retornar um valor L¢GICO
* \\ Final de FOR_04F9.PRG
