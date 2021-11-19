/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R008.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Valores Recebidos
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=6, c_s:=18, l_i:=12, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±± Valores Recebidos ±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Data Inicial ÄÄÄÄÄÂ Data Final ÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³                   ³                  ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
datai=CTOD('')                                               // Data Inicial
dataf=CTOD('')                                               // Data Final
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  datai;
                    PICT "@D";
                    VALI CRIT("!EMPT(datai)~Necess rio informar DATA INICIAL")
                    DEFAULT "CtoD('01/01/70')"
                    AJUDA "Informe a data inicial"

   @ l_s+04 ,c_s+24 GET  dataf;
                    PICT "@D";
                    VALI CRIT("!EMPT(dataf)~Necess rio informar DATA FINAL")
                    DEFAULT "DataC"
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

   #ifdef COM_REDE
      IF !USEARQ("RECEBER",.f.,10,1)                         // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("RECEBER")                                      // abre o dbf e seus indices
   #endi

   PTAB(STR(codigo,04,00),"CLIENTES",1,.t.)                  // abre arquivo p/ o relacionamento
   PTAB(STR(custo,04,00),"CUSTO",1,.t.)
   SET RELA TO STR(codigo,04,00) INTO CLIENTES,;             // relacionamento dos arquivos
            TO STR(custo,04,00) INTO CUSTO
   titrel:=criterio := ""                                    // inicializa variaveis
   cpord="DTOS(datapago)"
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,28,11)                   // nao quis configurar...
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
         IF !Empty(datapago).and.(vencimento>=M->datai.and.vencimento<=M->dataf)// se atender a condicao...
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY [Recebimento em : ]+DtoC(datapago)  // titulo da quebra
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            qb05401=datapago                                 // campo para agrupar 1a quebra
            DO WHIL !EOF() .AND. datapago=qb05401
               #ifdef COM_TUTOR
                  IF IN_KEY()=K_ESC                          // se quer cancelar
               #else
                  IF INKEY()=K_ESC                           // se quer cancelar
               #endi
                  IF canc()                                  // pede confirmacao
                     BREAK                                   // confirmou...
                  ENDI
               ENDI
               IF !Empty(datapago).and.(vencimento>=M->datai.and.vencimento<=M->dataf)// se atender a condicao...
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,000 SAY TRAN(documen,"@!")            // Documento
                  @ cl,016 SAY "³"
                  @ cl,018 SAY TRAN(CLIENTES->codigo,"9999") // Cliente
                  @ cl,054 SAY "³"
                  @ cl,056 SAY TRAN(CLIENTES->custo,"999999")// Centro de Custos
                  @ cl,087 SAY "³"
                  @ cl,089 SAY TRAN(valpagar,"@E 999,999,999,999.99")// Vl Pagar
                  @ cl,108 SAY "³"
                  @ cl,110 SAY TRAN(valor,"@E 999,999,999,999.99")// Vl Pago
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,016 SAY "³"
                  @ cl,018 SAY CLIENTES->razao               // Raz„o Social
                  @ cl,054 SAY "³"
                  @ cl,056 SAY CUSTO->departa                // Departamento
                  @ cl,087 SAY "³                    ³"
                  SKIP                                       // pega proximo registro
               ELSE                                          // se nao atende condicao
                  SKIP                                       // pega proximo registro
               ENDI
            ENDD
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(28)                                                    // grava variacao do relatorio
SELE RECEBER                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   @ 0,043 SAY "R E C E B I M E N T O  D E  C L I E N T E                                 Pag :"
   @ 0,123 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 2,045 SAY Par([empresa1])                               // Empresa
   @ 3,000 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 4,001 SAY "Documento      ³ Cliente                             ³ Centro de Custo                ³ Valor Receber      ³ Valor Recebido"
   @ 5,000 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de SFI_R008.PRG
