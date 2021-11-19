/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R002.PRG
 \ Data....: 23-07-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Movimentos Financeiros
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=5, c_s:=13, l_i:=17, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
Priv mCalsaldo:=0
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±± MOVIMENTOS FINANCEIROS ±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY "          Ú Data Inicial Â Data Final ¿"
@ l_s+04,c_s+1 SAY "          ³              ³            ³"
@ l_s+05,c_s+1 SAY "          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ l_s+06,c_s+1 SAY " Ú Caixa/Banco ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+07,c_s+1 SAY " ³                                             ³"
@ l_s+08,c_s+1 SAY " ³ C¢digo :     C/C :                          ³"
@ l_s+09,c_s+1 SAY " ³                                             ³"
@ l_s+10,c_s+1 SAY " ³ Descri‡„o :                                 ³"
@ l_s+11,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
datai=CTOD('')                                               // Data Incial
dataf=CTOD('')                                               // Data Final
codigo=0                                                     // C¢digo
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+13 GET  datai;
                    PICT "@D";
                    VALI CRIT("!EMPT(datai)~Necess rio informar DATA INCIAL")
                    AJUDA "informe a data Inicial"

   @ l_s+04 ,c_s+28 GET  dataf;
                    PICT "@D";
                    VALI CRIT("!EMPT(dataf)~Necess rio informar DATA FINAL")
                    DEFAULT "DataC"
                    AJUDA "Informe a Data Final"

   @ l_s+08 ,c_s+13 GET  codigo;
                    PICT "99";
                    VALI CRIT("PTAB(STR(codigo,02,00),'BANCOS',1)~C¢DIGO n„o existe na tabela")
                    AJUDA "Informe o c¢digo do Caixa/Banco|que vocˆ deseja o movimento"
                    CMDF8 "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(BANCOS->banco,[@R 999-!!99-!!!!!!!!!-!!]),21)", 8 , 23 }
                    MOSTRA {"LEFT(TRAN(BANCOS->descricao,[]),30)", 10 , 16 }

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
      IF !USEARQ("MOVIM",.f.,10,1)                           // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("MOVIM")                                        // abre o dbf e seus indices
   #endi

   PTAB(STR(contas,04,00),"CONTAS",1,.t.)                    // abre arquivo p/ o relacionamento
   PTAB(STR(banco,02,00),"BANCOS",1,.t.)
   PTAB(STR(historico,03,00),"HISTO",1,.t.)
   PTAB(STR(custo,04,00),"FORNEC",1,.t.)
   SET RELA TO STR(contas,04,00) INTO CONTAS,;               // relacionamento dos arquivos
            TO STR(banco,02,00) INTO BANCOS,;
            TO STR(historico,03,00) INTO HISTO,;
            TO STR(custo,04,00) INTO FORNEC
   titrel:=criterio := ""                                    // inicializa variaveis
   cpord="DTOS(data)+STR(contas,04,00)"
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,36,11)                   // nao quis configurar...
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
      mCalSaldo=0
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
         IF (data>=M->datai.And.data<=M->dataf).And.banco=M->codigo// se atender a condicao...
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY [Movimento em : ]+DtoC(data)        // titulo da quebra
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            qb06401=data                                     // campo para agrupar 1a quebra
            DO WHIL !EOF() .AND. data=qb06401
               #ifdef COM_TUTOR
                  IF IN_KEY()=K_ESC                          // se quer cancelar
               #else
                  IF INKEY()=K_ESC                           // se quer cancelar
               #endi
                  IF canc()                                  // pede confirmacao
                     BREAK                                   // confirmou...
                  ENDI
               ENDI
               IF (data>=M->datai.And.data<=M->dataf).And.banco=M->codigo// se atender a condicao...
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,000 SAY TRAN(documen,"@!")            // Documento
                  @ cl,021 SAY "³"
                  @ cl,023 SAY TRAN(contas,"9999")           // Conta
                  @ cl,054 SAY "³"
                  @ cl,056 SAY HISTO->descri                 // Hist¢rico
                  @ cl,092 SAY "³"
                  @ cl,094 SAY TRAN(IIf(tipo=[E],valor,valor*(-1)),"@(@E 999,999,999,999.99")// Valor
                  @ cl,113 SAY "³"
                  @ cl,115 SAY TRAN(R00201F9(),"@E@X@C 999,999,999,999.99")// saldo
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,021 SAY "³"
                  @ cl,023 SAY CONTAS->descricao             // DescA‡„o
                  @ cl,054 SAY "³"
                  @ cl,056 SAY TRAN(complem,"@!")            // Complemento
                  @ cl,092 SAY "³                    ³"
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
GRELA(36)                                                    // grava variacao do relatorio
SELE MOVIM                                                   // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   @ 0,040 SAY "M O V I M E N T O S  F I N A N C E I R O S                                       Pag :"
   @ 0,127 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 2,044 SAY Par([empresa1])                              // Empresa
   @ 4,018 SAY "Ú Data inicial Â Data Final Â Caixa/Banco ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 5,018 SAY "³"
   @ 5,020 SAY TRAN(M->datai,"@D")                           // Data Incial
   @ 5,033 SAY "³"
   @ 5,035 SAY TRAN(M->dataf,"@D")                           // Data Final
   @ 5,046 SAY "³"
   IF Ptab(Str(m->codigo,02,0),'BANCOS',1)                   // pode imprimir?
      @ 5,048 SAY TRAN(M->codigo,"99")                       // C¢digo
   ENDI
   @ 5,051 SAY "-"
   @ 5,053 SAY TRAN(BANCOS->banco,"@R 999-!!99-!!!!!!!!!-!!")// Banco
   @ 5,075 SAY "-"
   @ 5,077 SAY BANCOS->descricao                             // DescBanco
   @ 5,108 SAY "³"
   @ 6,018 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   IMPAC("Documento              A‡„o Financeira                  Historico - Observa‡„o                 Valor                Saldo",7,000)
   @ 8,000 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   cl=qt+8 ; pg_++
ENDI
RETU

* \\ Final de SFI_R002.PRG
