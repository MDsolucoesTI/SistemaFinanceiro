/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_P010.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Gera Parcelas a Pagar
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=1, c_s:=11, l_i:=23, c_i:=68, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±±± Gerar Parcelas ±±±±±±±±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Documento ÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³                 ³"
@ l_s+05,c_s+1 SAY " Ã Fornecedor ÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+06,c_s+1 SAY " ³      -                                             ³"
@ l_s+07,c_s+1 SAY " Ã Data Vencimento Â Valor … Pagar ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+08,c_s+1 SAY " ³                 ³                                  ³"
@ l_s+09,c_s+1 SAY " ³ A‡„o Financeira ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+10,c_s+1 SAY " ³      -                                             ³"
@ l_s+11,c_s+1 SAY " Ã Caixa/Banco ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+12,c_s+1 SAY " ³    -                                               ³"
@ l_s+13,c_s+1 SAY " Ã Hist¢rico Padr„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+14,c_s+1 SAY " ³      -                                             ³"
@ l_s+15,c_s+1 SAY " ³ Centro de Custo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+16,c_s+1 SAY " ³      -                                             ³"
@ l_s+17,c_s+1 SAY " Ã Observa‡„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+18,c_s+1 SAY " ³                                                    ³"
@ l_s+19,c_s+1 SAY " Ã Parcelas ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ l_s+20,c_s+1 SAY " ³          ³"
@ l_s+21,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÙ"
documenp=SPAC(15)                                            // Documento
codigop=0                                                    // C¢digo
vencimentp=CTOD('')                                          // Data
valpagarp=0                                                  // Vl Pagar
contasp=0                                                    // C¢digo da A‡„o Financeira
bancop=0                                                     // C¢digo do Banco
historicop=0                                                 // C¢digo do Hist¢rico
custop=0                                                     // Centro de Custos
obsp=SPAC(50)                                                // Observa‡„o
parcelasp=0                                                  // N£mero da Parcela
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  documenp;
                    PICT "@!";
                    VALI CRIT("!EMPT(documenp)~Necess rio informar o n£mero do documento")
                    AJUDA "Informe o n£mero do documento a ser pago|se houver tar‡os ou barras manter na digita‡„o"

   @ l_s+06 ,c_s+04 GET  codigop;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(codigop,04,00),'FORNEC',1)~Necess rio informar o C¢digo do Fornecedor")
                    AJUDA "Informe o c¢digo do Fornecedor|F8 Tabela Pick"
                    CMDF8 "VDBF(6,3,20,77,'FORNEC',{'codigo','razao','cgc','rg'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(FORNEC->razao,[]),35)", 6 , 11 }

   @ l_s+08 ,c_s+04 GET  vencimentp;
                    PICT "@D";
                    VALI CRIT("!EMPT(vencimentp).and.terCont(vencimentp)~Necess rio informar o vencimento")
                    AJUDA "Informe a primeira data do vencimento"

   @ l_s+08 ,c_s+22 GET  valpagarp;
                    PICT "@E 999,999,999,999.99";
                    VALI CRIT("valpagarp>0~Valor n„o aceit vel")
                    AJUDA "Informe o valor a ser pago"

   @ l_s+10 ,c_s+04 GET  contasp;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(contasp,04,00),'CONTAS',1)~Necess rio informar o C¢digo da Conta")
                    AJUDA "Informe o C¢digo da A‡„o Financeira|F8 Tabela Pick"
                    CMDF8 "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[codigo>=2000])"
                    MOSTRA {"LEFT(TRAN(CONTAS->descricao,[]),30)", 10 , 11 }

   @ l_s+12 ,c_s+04 GET  bancop;
                    PICT "99";
                    VALI CRIT("PTAB(STR(bancop,02,00),'BANCOS',1).or.Empty(bancop)~C¢digo do Banco n„o existe na tabela")
                    AJUDA "Informe o C¢digo do Banco|F8 Tabela Pick"
                    CMDF8 "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(BANCOS->descricao,[]),30)", 12 , 9 }

   @ l_s+14 ,c_s+04 GET  historicop;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(historicop,04,00),'HISTO',1).or.Empty(historicop)~C¢digo do Hist¢rico Padr„o n„o existe na tabela")
                    AJUDA "Informe o C¢digo do Hist¢rico Padr„o|F8 Tabela Pick"
                    CMDF8 "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(HISTO->descri,[]),35)", 14 , 11 }

   @ l_s+16 ,c_s+04 GET  custop;
                    PICT "9999";
                    VALI CRIT("Empty(custop).or.PTAB(STR(custop,04,00),'CUSTO',1)~Centro de Custos n„o existe na tabela")
                    AJUDA "Informe o C¢digo do Centro de Custo|F8 Tabela Pick|se houver"
                    CMDF8 "VDBF(6,32,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(CUSTO->departa,[]),35)", 16 , 11 }

   @ l_s+18 ,c_s+04 GET  obsp
                    AJUDA "Informe uma observa‡„o|se houver"

   @ l_s+20 ,c_s+04 GET  parcelasp;
                    PICT "99";
                    VALI CRIT("parcelasp>=0~N£mero da Parcela n„o aceit vel")
                    AJUDA "Se for pagamentos parcelos|informe o n£mero da parcela|caso contr rio digite 0"

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
msgt="GERA PARCELAS A PAGAR"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            CLOSE FORNEC
            IF !USEARQ("FORNEC",.t.,10,1)                    // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("FORNEC")                                 // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   IF !USEARQ("PAGAR",.t.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("PAGAR")                                           // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
   msg=FIEL(i)
   PRIV &msg.
NEXT
   SELE FORNEC                                               // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF codigo=m->codigop                                   // se atender a condicao...
         FOR nparc=1 TO m->parcelasp
            SELE PAGAR                                       // arquivo alvo do lancamento

            #ifdef COM_REDE
               PAG_CRIA_SEQ()
               SELE PAGAR
               PAG_GERA_SEQ()
               DO WHIL .t.
                  APPE BLAN                                  // tenta abri-lo
                  IF NETERR()                                // nao conseguiu
                     DBOX(ms_uso,20)                         // avisa e
                     LOOP                                    // tenta novamente
                  ENDI
                  EXIT                                       // ok. registro criado
               ENDD
            #else
               PAG_GERA_SEQ()
               APPE BLAN                                     // cria registro em branco
            #endi

            PAG_GRAVA_SEQ()
            SELE FORNEC                                      // inicializa registro em branco
            REPL PAGAR->seque WITH PAGAR->seque,;
                 PAGAR->data WITH Datac,;
                 PAGAR->documen WITH m->documenp,;
                 PAGAR->codigo WITH m->codigop,;
                 PAGAR->vencimento WITH CalData(m->vencimentp,30*(nparc-1)),;
                 PAGAR->valpagar WITH m->valpagarp,;
                 PAGAR->contas WITH m->contasp,;
                 PAGAR->banco WITH m->bancop,;
                 PAGAR->historico WITH m->historicop,;
                 PAGAR->custo WITH m->custop,;
                 PAGAR->obs WITH m->obsp,;
                 PAGAR->parcelas WITH nparc

            #ifdef COM_REDE
               PAGAR->(DBUNLOCK())                           // libera o registro
            #endi

         NEXT
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

* \\ Final de SFI_P010.PRG
