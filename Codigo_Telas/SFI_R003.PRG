/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R003.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Valores em Aberto
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=10, c_s:=24, l_i:=16, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±± Valores em Aberto ±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Data Inicial ÄÄÄÄÂ Data Final ÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³                  ³                   ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
datai=CTOD('')                                               // Data Inicial
dataf=CTOD('')                                               // Data final
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  datai;
                    PICT "@D";
                    VALI CRIT("!EMPT(datai)~Necess rio informar Data Inicial")
                    DEFAULT "CtoD('01/01/70')"
                    AJUDA "Informe a data inicial dos valores a pagar"

   @ l_s+04 ,c_s+23 GET  dataf;
                    PICT "@D";
                    VALI CRIT("!EMPT(dataf)~Necess rio informar Data Final")
                    DEFAULT "DataC"
                    AJUDA "Informe a data final dos valores a pagar"

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA()
      LOOP
   ENDI
   IF LASTKEY()=K_ESC                                        // se quer cancelar
      RETU                                                   // retorna
   ENDI

   #ifdef COM_REDE
      IF !USEARQ("PAGAR",.f.,10,1)                           // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("PAGAR")                                        // abre o dbf e seus indices
   #endi

   PTAB(STR(codigo,04,00),"FORNEC",1,.t.)                    // abre arquivo p/ o relacionamento
   PTAB(STR(custo,04,00),"CUSTO",1,.t.)
   SET RELA TO STR(codigo,04,00) INTO FORNEC,;               // relacionamento dos arquivos
            TO STR(custo,04,00) INTO CUSTO
   titrel:=criterio := ""                                    // inicializa variaveis
   cpord="DTOS(vencimento)"
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,31,11)                   // nao quis configurar...
      CLOS ALL                                               // fecha arquivos e
      LOOP                                                   // volta ao menu
   ENDI
   IF tps=2                                                  // se vai para arquivo/video
      arq_=ARQGER()                                          // entao pega nome do arquivo
      IF EMPTY(arq_)                                         // se cancelou ou nao informou
         LOOP                                                // retorna
      ENDI
   ELSE
      arq_=drvporta                                          // porta de saida configurada
   ENDI
   SET PRINTER TO (arq_)                                     // redireciona saida
   EXIT
ENDD
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SET DEVI TO PRIN                                             // inicia a impressao
maxli=62                                                     // maximo de linhas no relatorio
IMPCTL(drvpcom)                                              // comprime os dados
IF tps=2
   IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      pg_=1; cl=999
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
      tot058006 := 0                                         // inicializa variaves de totais
      DO WHIL !EOF()
         #ifdef COM_TUTOR
            IF IN_KEY()=K_ESC                                // se quer cancelar
         #else
            IF INKEY()=K_ESC                                 // se quer cancelar
         #endi
            IF canc()                                        // pede confirmacao
               BREAK                                         // confirmou...
            ENDI
         ENDI
         IF Empty(datapago).and.(vencimento>=M->datai.and.vencimento<=M->dataf)// se atender a condicao...
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY [Data do Vencimento : ]+DtoC(vencimento)// titulo da quebra
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            qb05801=vencimento                               // campo para agrupar 1a quebra
            st05801006 := 0                                  // inicializa sub-totais
            DO WHIL !EOF() .AND. vencimento=qb05801
               #ifdef COM_TUTOR
                  IF IN_KEY()=K_ESC                          // se quer cancelar
               #else
                  IF INKEY()=K_ESC                           // se quer cancelar
               #endi
                  IF canc()                                  // pede confirmacao
                     BREAK                                   // confirmou...
                  ENDI
               ENDI
               IF Empty(datapago).and.(vencimento>=M->datai.and.vencimento<=M->dataf)// se atender a condicao...
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,000 SAY TRAN(documen,"@!")            // Documento
                  @ cl,021 SAY "³"
                  @ cl,024 SAY TRAN(FORNEC->codigo,"9999")   // Fornecedor
                  @ cl,065 SAY "³"
                  @ cl,067 SAY TRAN(CUSTO->codigo,"9999")    // C¢digo Centro de Custo
                  @ cl,103 SAY "³"
                  st05801006+=valpagar
                  tot058006+=valpagar
                  @ cl,105 SAY TRAN(valpagar,"@E 999,999,999,999.99")// Vl Pagar
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,021 SAY "³"
                  @ cl,024 SAY FORNEC->razao                 // Raz„o
                  @ cl,065 SAY "³"
                  @ cl,067 SAY CUSTO->departa                // Departamento
                  @ cl,103 SAY "³"
                  SKIP                                       // pega proximo registro
               ELSE                                          // se nao atende condicao
                  SKIP                                       // pega proximo registro
               ENDI
            ENDD
            IF cl+3>maxli                                    // se cabecalho do arq filho
               REL_CAB(0)                                    // nao cabe nesta pagina
            ENDI                                             // salta para a proxima pagina
            @ ++cl,105 SAY REPL('-',18)
            @ ++cl,105 SAY TRAN(st05801006,"@E 999,999,999,999.99")// sub-tot Vl Pagar
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
      IF cl+3>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,105 SAY REPL('-',18)
      @ ++cl,105 SAY TRAN(tot058006,"@E 999,999,999,999.99") // total Vl Pagar
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(31)                                                    // grava variacao do relatorio
SELE PAGAR                                                   // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   IMPAC("C O N T A S    P A G A R                                        Pag :",0,046)
   @ 0,117 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 2,041 SAY Par([empresa1])                               // Empresa
   IMPAC("Data de Emiss„o :",3,000)
   @ 3,018 SAY DTOC(DATE())                                  // data do sistema
   @ 4,000 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 5,001 SAY "Documento           ³  Fornecedor                               ³ Centro de Custo                     ³ Valor"
   @ 6,000 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de SFI_R003.PRG
