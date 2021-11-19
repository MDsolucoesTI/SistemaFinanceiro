/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R001.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Listagem dos Clientes
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
   IF !USEARQ("CLIENTES",.f.,10,1)                           // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("CLIENTES")                                        // abre o dbf e seus indices
#endi

PTAB(STR(codcre,01,00),"CREDITO",1,.t.)                      // abre arquivo p/ o relacionamento
SET RELA TO STR(codcre,01,00) INTO CREDITO                   // relacionamento dos arquivos
titrel:=criterio := ""                                       // inicializa variaveis
cpord="STR(codigo,04,00)"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,26,11)                      // nao quis configurar...
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
         @ cl,002 SAY TRAN(codigo,"9999")                    // C¢digo
         @ cl,006 SAY "-"
         @ cl,007 SAY razao                                  // Raz„o Social
         @ cl,043 SAY "³"
         @ cl,046 SAY TRAN(tipo,"@!")                        // Tipo1
         @ cl,050 SAY "³"
         @ cl,052 SAY TRAN(If(tipo=[F],rg,cgc),"@!")         // Cgc/Rg
         @ cl,071 SAY "³"
         @ cl,073 SAY TRAN(If(!Empty(tipo),CREDITO->tipo,[]),"@!")// Tipo de Cr‚dito
         @ cl,089 SAY "³"
         @ cl,091 SAY TRAN(tele,"@R (!999)!!99-9999")        // Telefone
         @ cl,107 SAY "³"
         @ cl,109 SAY contato                                // Contato
         @ cl,135 SAY "³"
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
GRELA(26)                                                    // grava variacao do relatorio
SELE CLIENTES                                                // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   @ 0,046 SAY "L I S T A G E M  D O S  C L I E N T E S                                        Pag :"
   @ 0,131 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 1,001 SAY NSEM(DATE())                                  // dia da semana
   @ 1,008 SAY ","
   @ 1,010 SAY DTOC(DATE())                                  // data do sistema
   @ 2,048 SAY Par([empresa1])                               // Empresa
   @ 3,000 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   IMPAC("³ Cliente                                  ³ Tipo ³ C.G.C./R.G.        ³ Cr‚dito         ³ Telefone        ³ Contato                   ³",4,000)
   @ 5,000 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de SFI_R001.PRG
