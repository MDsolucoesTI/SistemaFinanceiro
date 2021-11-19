/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R020.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Relat¢rio
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
   IF !USEARQ("CUSTO",.f.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("CUSTO")                                           // abre o dbf e seus indices
#endi

titrel:=criterio:=cpord := ""                                // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,38,11)                      // nao quis configurar...
   CLOS ALL                                                  // fecha arquivos e
   RETU                                                      // volta ao menu
ENDI
IF tps=2                                                     // se vai para arquivo/video
   arq_=ARQGER()                                             // entao pega nome do arquivo
   IF EMPTY(arq_)                                            // se cancelou ou nao informou
      RETU                                                   // retorna
   ENDI
ELSE
   arq_=drvporta                                             // porta de saida configurada
ENDI
SET PRINTER TO (arq_)                                        // redireciona saida
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
      tot068004:=tot068005:=tot068006:=tot068007:=tot068008:=tot068009 := 0// inicializa variaves de totais
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
         REL_CAB(1)                                          // soma cl/imprime cabecalho
         @ cl,001 SAY "³"
         @ cl,003 SAY TRAN(codigo,"9999")                    // C¢digo Centro de Custo
         @ cl,039 SAY "³"
         tot068004+=receita
         @ cl,041 SAY TRAN(receita,"@E@X@C 999,999,999,999.99")// Receita
         @ cl,071 SAY "³"
         tot068006+=receber
         @ cl,073 SAY TRAN(receber,"@E@X@C 999,999,999,999.99")// Receber
         @ cl,103 SAY "³"
         tot068008+=pagar
         @ cl,105 SAY TRAN(pagar,"@E@X@C 999,999,999,999.99")// Pagar
         @ cl,131 SAY "³"
         REL_CAB(1)                                          // soma cl/imprime cabecalho
         @ cl,001 SAY "³"
         @ cl,003 SAY departa                                // Departamento
         @ cl,039 SAY "³"
         tot068005+=despesa
         @ cl,049 SAY TRAN(despesa,"@E@X@C 999,999,999,999.99")// Despesa
         @ cl,071 SAY "³"
         tot068007+=recebvenc
         @ cl,081 SAY TRAN(recebvenc,"@E@X@C 999,999,999,999.99")// Rec. Vencido
         @ cl,103 SAY "³"
         tot068009+=pagovenc
         @ cl,112 SAY TRAN(pagovenc,"@E@X@C 999,999,999,999.99")// Pag. Vencido
         @ cl,131 SAY "³"
         SKIP                                                // pega proximo registro
      ENDD
      IF cl+4>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,041 SAY REPL('-',89)
      @ ++cl,041 SAY TRAN(tot068004,"@E@X@C 999,999,999,999.99")// total Receita
      @ cl,073 SAY TRAN(tot068006,"@E@X@C 999,999,999,999.99")// total Receber
      @ cl,105 SAY TRAN(tot068008,"@E@X@C 999,999,999,999.99")// total Pagar
      @ ++cl,049 SAY TRAN(tot068005,"@E@X@C 999,999,999,999.99")// total Despesa
      @ cl,081 SAY TRAN(tot068007,"@E@X@C 999,999,999,999.99")// total Rec. Vencido
      @ cl,112 SAY TRAN(tot068009,"@E@X@C 999,999,999,999.99")// total Pag. Vencido
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(38)                                                    // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   IMPAC("Relat¢rio  de  Posi‡„o  Financeira                                     Pag. :",0,048)
   @ 0,126 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 1,002 SAY NSEM(DATE())                                  // dia da semana
   @ 1,009 SAY ","
   @ 1,011 SAY DTOC(DATE())                                  // data do sistema
   @ 2,048 SAY Par([empresa1])                               // Empresa
   @ 4,001 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 5,001 SAY "³ Centro de Custo                     ³ Receita                       ³ Receber                       ³ Pagar                     ³"
   @ 6,001 SAY "³                                     ³         Despesa               ³         Receber Vencido       ³        Pagar Vencido      ³"
   @ 7,001 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   cl=qt+7 ; pg_++
ENDI
RETU

* \\ Final de SFI_R020.PRG
