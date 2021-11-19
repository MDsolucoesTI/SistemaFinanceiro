/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: FOR_01F9.PRG
 \ Data....: 08-07-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Valida‡„o do campo RG, arquivo FORNEC
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"    // inicializa constantes manifestas
Parameters x
LOCAL reg_dbf:=POINTER_DBF()
lugar=RecNo()
Ordem=.F.
Select FORNEC
If !BOF()
   Go Top
EndIf
If LastRec()>0
   Locate For rg = x
   If Found()
      If (op_cad=01 .Or. (op_cad=02 .And. RecNo() <> lugar))
         Alerta(2)
         Dbox("N£mero do RG j  Cadastrado|n„o ‚ permitido cadastrar|um Fornecedor mais de uma vez",,,4)
      Else
         Ordem=.T.
      EndIf
   Else
      Ordem=.T.
   EndIf
Else
   Ordem=.T.
EndIf
POINTER_DBF(reg_dbf)

RETURN(Ordem)       // <- deve retornar um valor L¢GICO

* \\ Final de FOR_01F9.PRG
