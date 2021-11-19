/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R006.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Posi‡„o Banc ria
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
   IF !USEARQ("BANCOS",.f.,10,1)                             // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("BANCOS")                                          // abre o dbf e seus indices
#endi

titrel:=criterio := ""                                       // inicializa variaveis
cpord="STR(codigo,02,00)"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,37,11)                      // nao quis configurar...
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
IMPCTL(drvpeli)                                              // comprime os dados
IF tps=2
   IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      pg_=1; cl=999
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
      tot066004 := 0                                         // inicializa variaves de totais
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
         @ cl,002 SAY "³"
         @ cl,004 SAY TRAN(codigo,"99")                      // C¢digo
         @ cl,011 SAY "³"
         @ cl,013 SAY TRAN(banco,"@R 999-!!99-!!!!!!!!!-!!") // Banco
         @ cl,035 SAY "³"
         @ cl,037 SAY descricao                              // Descri‡„o
         @ cl,068 SAY "³"
         tot066004+=saldoatu
         @ cl,070 SAY TRAN(saldoatu,"@E@X@C 999,999,999,999.99")// Saldo Atual
         @ cl,089 SAY "³"
         SKIP                                                // pega proximo registro
      ENDD
      IF cl+3>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,070 SAY REPL('-',18)
      @ ++cl,070 SAY TRAN(tot066004,"@E@X@C 999,999,999,999.99")// total Saldo Atual
   ENDD ccop
END SEQUENCE
IMPCTL(drvteli)                                              // retira comprimido
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(37)                                                    // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   IMPAC("P O S I €  O  B A N C  R I A                Pag :",0,031)
   @ 0,083 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 1,003 SAY NSEM(DATE())                                  // dia da semana
   @ 1,010 SAY ","
   @ 1,012 SAY DTOC(DATE())                                  // data do sistema
   @ 2,029 SAY Par([empresa1])                               // Empresa
   @ 3,002 SAY "ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   IMPAC("³ C¢digo ³ Banco                 ³ Descri‡„o                      ³ Valor              ³",4,002)
   @ 5,002 SAY "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de SFI_R006.PRG
