/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_P002.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Fechamento Financeiro
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=21, l_i:=15, c_i:=64, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±± FECHAMENTO FINANCEIRO ±±±±±±±±±±"
@ l_s+03,c_s+1 SAY "      Ú Data Inicial Â Data Final ¿"
@ l_s+04,c_s+1 SAY "      ³              ³            ³"
@ l_s+05,c_s+1 SAY "      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ"
datai=CTOD('')                                               // Data inicial
dataf=CTOD('')                                               // Data Final
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+09 GET  datai;
                    PICT "@D";
                    VALI CRIT("!EMPT(datai).And.PTAB(DTOS(datai),'MOVIM',1)~Necess rio informar DATA INICIAL|ou esta DATA n„o foi feito ainda o fechamento")
                    DEFAULT "DataC"
                    AJUDA "Informe a data Inicial"

   @ l_s+04 ,c_s+24 GET  dataf;
                    PICT "@D";
                    VALI CRIT("!EMPT(dataf)~Necess rio informar DATA FINAL")
                    DEFAULT "Datac"
                    AJUDA "Informe a Data Final"

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
msgt="FECHAMENTO FINANCEIRO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            IF !USEARQ("BANCOS",.t.,10,1)                    // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("BANCOS")                                 // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   CLOSE MOVIM
   IF !USEARQ("MOVIM",.t.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("MOVIM")                                           // abre o dbf e seus indices
#endi

   SELE BANCOS                                               // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF P01401F9(m->dataf+1)
         SELE MOVIM                                          // arquivo alvo do lancamento

         #ifdef COM_REDE
            DO WHIL .t.
               APPE BLAN                                     // tenta abri-lo
               IF NETERR()                                   // nao conseguiu
                  DBOX(ms_uso,20)                            // avisa e
                  LOOP                                       // tenta novamente
               ENDI
               EXIT                                          // ok. registro criado
            ENDD
         #else
            APPE BLAN                                        // cria registro em branco
         #endi

         SELE BANCOS                                         // inicializa registro em branco
         REPL MOVIM->data WITH m->dataf+1,;
              MOVIM->documen WITH [SALDO INICIAL  ],;
              MOVIM->contas WITH 1,;
              MOVIM->banco WITH codigo,;
              MOVIM->tipo WITH [E],;
              MOVIM->historico WITH 1

         #ifdef COM_REDE
            MOVIM->(DBUNLOCK())                              // libera o registro
         #endi

      ENDI
      SKIP                                                   // pega proximo registro
   ENDD

         #ifdef COM_REDE
            IF !USEARQ("BANCOS",.t.,10,1)                    // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("BANCOS")                                 // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE BANCOS                                               // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()

      #ifdef COM_REDE
         REPBLO('BANCOS->valorflag',{||0})
      #else
         REPL BANCOS->valorflag WITH 0
      #endi

      SKIP                                                   // pega proximo registro
   ENDD

         #ifdef COM_REDE
            CLOSE MOVIM
            IF !USEARQ("MOVIM",.t.,10,1)                     // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("MOVIM")                                  // abre o dbf e seus indices
         #endi

         PTAB(STR(banco,02,00),"BANCOS",1,.t.)               // abre arquivo p/ o relacionamento
         SET RELA TO STR(banco,02,00) INTO BANCOS            // relacionamento dos arquivos
         criterio := ""                                      // inicializa variaveis
         cpord="DTOS(data)"
         chv_rela:=chv_1:=chv_2 := ""
         INDTMP()
   SELE MOVIM                                                // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF data>=m->datai.And.data<=m->dataf                   // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('BANCOS->valorflag',{||IIf(tipo=[E],BANCOS->valorflag+valor,BANCOS->valorflag-valor)})
         #else
            REPL BANCOS->valorflag WITH IIf(tipo=[E],BANCOS->valorflag+valor,BANCOS->valorflag-valor)
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE MOVIM                                                // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            CLOSE MOVIM
            IF !USEARQ("MOVIM",.t.,10,1)                     // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("MOVIM")                                  // abre o dbf e seus indices
         #endi

         PTAB(STR(banco,02,00),"BANCOS",1,.t.)               // abre arquivo p/ o relacionamento
         SET RELA TO STR(banco,02,00) INTO BANCOS            // relacionamento dos arquivos
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE MOVIM                                                // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF contas=1.And.historico=1.And.data=(m->DataF+1)      // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('MOVIM->valor',{||BANCOS->valorflag})
         #else
            REPL MOVIM->valor WITH BANCOS->valorflag
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE MOVIM                                                // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("BANCOS",.t.,10,1)                    // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("BANCOS")                                 // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE BANCOS                                               // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()

      #ifdef COM_REDE
         REPBLO('BANCOS->datmov',{||DataF+1})
      #else
         REPL BANCOS->datmov WITH DataF+1
      #endi

      SKIP                                                   // pega proximo registro
   ENDD
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de SFI_P002.PRG
