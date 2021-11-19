/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R005.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Listagem de Fornecedores
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
   IF !USEARQ("FORNEC",.f.,10,1)                             // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("FORNEC")                                          // abre o dbf e seus indices
#endi

titrel:=criterio := ""                                       // inicializa variaveis
cpord="STR(codigo,04,00)"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,30,11)                      // nao quis configurar...
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
         @ cl,000 SAY "³"
         @ cl,001 SAY TRAN(codigo,"9999")                    // C¢digo
         @ cl,005 SAY "-"
         @ cl,006 SAY razao                                  // Raz„o
         @ cl,042 SAY "³"
         @ cl,045 SAY TRAN(tipo,"@!")                        // Tipo da Pessoa
         @ cl,049 SAY "³"
         @ cl,051 SAY if(!Empty(tipo=[F]),rg,cgc)            // cgc/rg
         @ cl,070 SAY "³"
         @ cl,072 SAY TRAN(tele,"@R (!999)!!99-9999")        // Telefone
         @ cl,088 SAY "³"
         @ cl,090 SAY ramal                                  // Ramal
         @ cl,096 SAY "³"
         @ cl,098 SAY contato                                // Contato
         @ cl,124 SAY "³"
         SKIP                                                // pega proximo registro
      ENDD
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(30)                                                    // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   @ 0,034 SAY "L I S T A G E M  D E  F O R N E C E D O R E S                                 Pag :"
   @ 0,118 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 1,000 SAY NSEM(DATE())                                  // dia da semana
   @ 1,007 SAY ","
   @ 1,009 SAY DTOC(DATE())                                  // data do sistema
   @ 2,038 SAY Par([empresa1])                               // Empresa
   @ 3,000 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 4,000 SAY "³ Fornecedor                              ³ Tipo ³ CGC/RG             ³ Telefone        ³ Ramal ³ Contato                   ³"
   @ 5,000 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de SFI_R005.PRG
