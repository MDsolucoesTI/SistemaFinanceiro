/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: BAIXAPAG.PRG
 \ Data....: 24-04-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Rotina avulsa (Baixa de Contas a Pagar)
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas

Local Op
op_sis=EVAL(qualsis,"PAGAR")
If Select("Bancos")=0
   DbfParam=DrvDbf+"Bancos"
   UseArq(DbfParam)
EndIf
If Select("Contas")=0
   DbfParam=DrvDbf+"Contas"
   UseArq(DbfParam)
EndIf
If Select("Custo")=0
   DbfParam=DrvDbf+"Custo"
   UseArq(DbfParam)
EndIf
If Select("Fornec")=0
   DbfParam=DrvDbf+"Fornec"
   UseArq(DbfParam)
EndIf
If Select("Movim")=0
   DbfParam=DrvDbf+"Movim"
   UseArq(DbfParam)
EndIf
If Select("Receber")=0
   DbfParam=DrvDbf+"Receber"
   UseArq(DbfParam)
EndIf
If Select("Pagar")=0
   DbfParam=DrvDbf+"Pagar"
   UseArq(DbfParam)
EndIf
Sele Pagar
DbGoTop()
Locate for dataprev<=DataC .And. datapago=CtoD("  /  /  ")
If !Found()
   DBox("N„o h  contas … pagar hoje|e nem contas atrasadas … pagar.",,,0,.T.,,)
EndIf
Set Filter to dataprev<=DataC .And. datapago=CtoD("  /  /  ")
DbGoTop()
Do While !Eof()
   tem_borda=.f.
   l_s=1           // coordenadas da tela
   c_s=2
   l_i=22
   c_i=79
   SETCOLOR(drvtittel)
   vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
   CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-4)      // limpa area da tela/sombra
   SETCOLOR(drvcortel)
   @ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±±±±±±±±±±± CONTAS  PAGAR ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
   @ l_s+03,c_s+1 SAY " Ú Sequˆncia ÄÂ Data ÄÄÄÄÂ Data Prevista de Pagamento ¿"
   @ l_s+04,c_s+1 SAY " ³            ³          ³                            ³"
   @ l_s+05,c_s+1 SAY " Ã Fornecedor ÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ l_s+06,c_s+1 SAY " ³      -                                                              ³"
   @ l_s+07,c_s+1 SAY " Ã Plano de Conta ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+08,c_s+1 SAY " ³      -                                                              ³"
   @ l_s+09,c_s+1 SAY " Ã Caixa/Banco ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+10,c_s+1 SAY " ³    -                                                                ³"
   @ l_s+11,c_s+1 SAY " Ã Hist¢rico Padr„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+12,c_s+1 SAY " ³      -                                                              ³"
   @ l_s+13,c_s+1 SAY " Ã Documento ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+14,c_s+1 SAY " ³                                                                     ³"
   @ l_s+15,c_s+1 SAY " Ã Centro de Custo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+16,c_s+1 SAY " ³        -                                                            ³"
   @ l_s+17,c_s+1 SAY " Ã Observa‡„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+18,c_s+1 SAY " ³                                                                     ³"
   @ l_s+19,c_s+1 SAY " Ã Parcelas Â Valor ÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Data Real do Pagamento ÂÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ l_s+20,c_s+1 SAY " ³          ³                    ³                        ³"
   @ l_s+21,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   Infosis()
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   PTAB(STR(CODIGO,04,00),'FORNEC',1)
   PTAB(STR(CONTAS,04,00),'CONTAS',1)
   PTAB(STR(BANCO,02,00),'BANCOS',1)
   PTAB(STR(HISTORICO,04,00),'HISTO',1)
   PTAB(STR(CUSTO,06,00),'CUSTO',1)
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04,c_s+04 Say  seque
   @ l_s+04,c_s+17 Say  data
   @ l_s+04,c_s+28 say  dataprev
   @ l_s+06,c_s+04 say  codigo
   @ l_S+06,c_s+11 Say  Fornec->Razao
   @ l_s+08,c_s+04 say  contas
   @ l_s+08,c_s+11 Say  Contas->descricao
   @ l_s+10,c_s+04 Say  banco
   @ l_s+10,c_s+09 Say  Bancos->descricao
   @ l_s+12,c_s+04 Say  historico
   @ l_s+12,c_s+11 Say  Histo->descri
   @ l_s+14,c_s+04 Say  documento
   @ l_s+16,c_s+04 Say  custo
   @ l_s+16,c_s+13 Say  Custo->departa
   @ l_s+18,c_s+04 Say  obs
   @ l_s+20,c_s+04 Say  parcelas
   @ l_s+20,c_s+15 Say  valor
   @ l_s+20,c_s+36 Say  datapago
   Sele Pagar
   Cursor=SetCursor()
   Cor=SetColor()
   SetColor(DrvCortel)
   Set Cursor Off
   XXX=Space(01)
   @ l_s+18,c_s+48 Get XXX  Pict "@!" When(Balao(1))
   Read
   SetColor(Cor)
   SetCursor(Cursor)
   If XXX=[S]
      Do While .T.
         If Rlock()
            Exit
         EndIf
      EndDo
      Mdatapago=DataC
      @ l_s+08 ,c_s+04 GET  contas;
                       PICT sistema[op_sis,O_CAMPO,05,O_MASC]
      DEFINICAO 5
      MOSTRA sistema[op_sis,O_FORMULA,2]
      @ l_s+10 ,c_s+04 GET  banco;
                       PICT sistema[op_sis,O_CAMPO,06,O_MASC]
      DEFINICAO 6
      MOSTRA sistema[op_sis,O_FORMULA,3]
      @ l_s+12 ,c_s+04 GET  historico;
                       PICT sistema[op_sis,O_CAMPO,07,O_MASC]
      DEFINICAO 7
      MOSTRA sistema[op_sis,O_FORMULA,4]
      @ l_s+14 ,c_s+04 GET  documento
      DEFINICAO 8
      @ l_s+18 ,c_s+04 GET  obs
      DEFINICAO 10
      @ l_s+20 ,c_s+36 GET  Mdatapago PICT "@D" Valid(!Empty(mdatapago))
//      DEFINICAO 13

      READ
      Unlock
      If LastKey()!=27
         Do While .T.
            If Rlock()
               Repl datapago With MDatapago
               Unlock
               Exit
            EndIf
         EndDo
         Sele Movim
         Do While .T.
            Append Blank
            Repl data       With MDataPago
            Repl contas     With Pagar->contas
            Repl banco      With Pagar->banco
            Repl tipo       With [S]
            Repl historico  With Pagar->historico
            Repl documento  With Pagar->documento
            Repl valor      With Pagar->valor
            Repl custo      With Pagar->custo
            Repl Obs        With Pagar->Obs
            Unlock
            Exit
         EndDo
         Sele Bancos
         Do While .T.
            If Rlock()
               Repl saldoatu With saldoatu-Pagar->Valor
               Unlock
               Exit
            EndIf
         EndDo
         Sele Contas
         Do While .T.
            If Rlock()
               Repl saldoatu With saldoatu-Pagar->Valor
               Unlock
               Exit
            EndIf
         EndDo
         If !Empty(Pagar->Custo)
            Sele Custo
            Do While .T.
               If Rlock()
                  Repl despesa With despesa+Pagar->Valor
                  Unlock
                  Exit
               EndIf
            EndDo
         EndIf
      EndIF
   EndIf
   Sele Pagar
   DbSkip()
EndDo
Set Filter to
Return
