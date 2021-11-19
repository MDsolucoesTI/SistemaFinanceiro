/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_P004.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Baixa Contas a Receber
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=5, c_s:=11, l_i:=20, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±± BAIXA DE CONTAS  RECEBER ±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú N§ Interno ÄÂ Documento ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³             ³                                   ³"
@ l_s+05,c_s+1 SAY " Ã Cliente ÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+06,c_s+1 SAY " ³      -                                          ³"
@ l_s+07,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ l_s+08,c_s+1 SAY "      Ú Caixa/Banco ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+09,c_s+1 SAY "      ³    -                                  ³"
@ l_s+10,c_s+1 SAY "      Ã Hist¢rico Padr„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+11,c_s+1 SAY "      ³      -                                ³"
@ l_s+12,c_s+1 SAY "      Ã Data Recebimento Â Valor Recebido ÄÄÄÄ´"
@ l_s+13,c_s+1 SAY "      ³                  ³                    ³"
@ l_s+14,c_s+1 SAY "      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
numseque=0                                                   // Sequˆncia
bancorec=0                                                   // C¢digo do Banco
historec=0                                                   // C¢digo do Hist¢rico
datarec=CTOD('')                                             // Data do Recebimento
valorrec=0                                                   // Valor Recebido
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)

   @ l_s+04 ,c_s+04 GET  numseque;
                    PICT "9999999999";
                    VALI CRIT("PTAB(STR(numseque,10,00),'RECEBER',1)~Sequˆncia n„o aceit vel")
                    AJUDA "Informe o n£mero do interno|do Documento ou Parcela"
                    CMDF8 "VDBF(6,21,20,77,'RECEBER',{'seque','data','documen','codigo'},1,'seque',[empty(datapago)])"
                    MOSTRA {"LEFT(TRAN(RECEBER->documen,[@!]),20)", 4 , 18 }
                    MOSTRA {"LEFT(TRAN(RECEBER->codigo,[9999]),04)", 6 , 4 }
                    MOSTRA {"LEFT(TRAN(V00401F9(),[]),40)", 6 , 11 }

   @ l_s+09 ,c_s+09 GET  bancorec;
                    PICT "99";
                    VALI CRIT("PTAB(STR(bancorec,02,00),'BANCOS',1)~C¢digo do Banco n„o existe na tabela")
                    AJUDA "Informe o C¢digo do Banco|F8 Tabela Pick"
                    CMDF8 "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(BANCOS->descricao,[]),30)", 9 , 14 }

   @ l_s+11 ,c_s+09 GET  historec;
                    PICT "999";
                    VALI CRIT("PTAB(STR(historec,03,00),'HISTO',1)~C¢digo do Hist¢rico n„o existe na tabela")
                    AJUDA "Informe o C¢digo do Hist¢rico Padr„o|F8 Tabela Pick"
                    CMDF8 "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(HISTO->descri,[]),30)", 11 , 16 }

   @ l_s+13 ,c_s+09 GET  datarec;
                    PICT "@D";
                    VALI CRIT("!EMPT(datarec).and.TerCont(datarec)~Necess rio informar Data do Recebimento")
                    DEFAULT "Datac"
                    AJUDA "Informe a data do Recebimento"

   @ l_s+13 ,c_s+28 GET  valorrec;
                    PICT "@E 999,999,999,999.99";
                    VALI CRIT("valorrec>0~Valor Recebido n„o aceit vel")
                    AJUDA "Informe o Valor Recebido"

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
msgt="BAIXA CONTAS A RECEBER"
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

         PTAB(STR(codigo,04,00),"CLIENTES",1,.t.)            // abre arquivo p/ o relacionamento
         SET RELA TO STR(codigo,04,00) INTO CLIENTES         // relacionamento dos arquivos
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
         IF Empty(datapago)
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
            REPL MOVIM->data WITH m->datarec,;
                 MOVIM->documen WITH documen,;
                 MOVIM->contas WITH contas,;
                 MOVIM->banco WITH m->bancorec,;
                 MOVIM->tipo WITH [E],;
                 MOVIM->historico WITH m->historec,;
                 MOVIM->valor WITH m->valorrec,;
                 MOVIM->custo WITH custo,;
                 MOVIM->obs WITH CLIENTES->razao
            SELE MOVIM                                       // arquivo alvo do lancamento
            MOV_GET1(FORM_DIRETA)                            // faz processo do arq do lancamento

            #ifdef COM_REDE
               UNLOCK                                        // libera o registro
            #endi

            SELE RECEBER                                     // arquivo origem do processamento
         ENDI

         #ifdef COM_REDE
            REPBLO('RECEBER->valor',{||m->valorrec})
            REPBLO('RECEBER->datapago',{||m->datarec})
            REPBLO('RECEBER->banco',{||m->bancorec})
            REPBLO('RECEBER->historico',{||m->historec})
         #else
            REPL RECEBER->valor WITH m->valorrec
            REPL RECEBER->datapago WITH m->datarec
            REPL RECEBER->banco WITH m->bancorec
            REPL RECEBER->historico WITH m->historec
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE RECEBER                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de SFI_P004.PRG
