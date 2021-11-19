/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_P005.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Estorno Contas a Receber
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=22, l_i:=14, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±± Estorno de Contas a Receber ±±±±±±±"
@ l_s+03,c_s+1 SAY " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³ N§ Interno :                         ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
numseque=0                                                   // Sequˆncia
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+17 GET  numseque;
                    PICT "9999999999";
                    VALI CRIT("PTAB(STR(numseque,10,00),'RECEBER',1)~N£mero interno n„o aceit vel")
                    AJUDA "Informe o n£mero do interno|do Documento ou Parcela"
                    CMDF8 "VDBF(6,21,20,77,'RECEBER',{'seque','data','documen','codigo'},1,'seque',[!Empty(datapago)])"

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA()
      LOOP
   ENDI
   IF LASTKEY()=K_ESC                                        // se quer cancelar
      RETU                                                   // retorna
   ENDI
   EXIT
ENDD
cod_sos=1
msgt="ESTORNO CONTAS A RECEBER"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            CLOSE RECEBER
            IF !USEARQ("RECEBER",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("RECEBER")                                // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   IF !USEARQ("MOVIM",.t.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("MOVIM")                                           // abre o dbf e seus indices
#endi

   SELE RECEBER                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF m->numseque=seque                                   // se atender a condicao...
         IF !Empty(datapago)
            SELE MOVIM                                       // arquivo alvo do lancamento

            #ifdef COM_REDE
               DO WHIL .t.
                  APPE BLAN                                  // tenta abri-lo
                  IF NETERR()                                // nao conseguiu
                     DBOX(ms_uso,20)                         // avisa e
                     LOOP                                    // tenta novamente
                  ENDI
                  EXIT                                       // ok. registro criado
               ENDD
            #else
               APPE BLAN                                     // cria registro em branco
            #endi

            SELE RECEBER                                     // inicializa registro em branco
            REPL MOVIM->data WITH datac,;
                 MOVIM->contas WITH contas,;
                 MOVIM->banco WITH banco,;
                 MOVIM->tipo WITH [S],;
                 MOVIM->documen WITH documen,;
                 MOVIM->historico WITH historico,;
                 MOVIM->complem WITH [Extorno],;
                 MOVIM->valor WITH valor,;
                 MOVIM->custo WITH custo,;
                 MOVIM->obs WITH obs
            SELE MOVIM                                       // arquivo alvo do lancamento
            MOV_GET1(FORM_DIRETA)                            // faz processo do arq do lancamento

            #ifdef COM_REDE
               UNLOCK                                        // libera o registro
            #endi

            SELE RECEBER                                     // arquivo origem do processamento
         ENDI

         #ifdef COM_REDE
            REPBLO('RECEBER->valor',{||0})
            REPBLO('RECEBER->datapago',{||CtoD('  /  /  ')})
         #else
            REPL RECEBER->valor WITH 0
            REPL RECEBER->datapago WITH CtoD('  /  /  ')
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de SFI_P005.PRG
