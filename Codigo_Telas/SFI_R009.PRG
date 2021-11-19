/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R009.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Recibo Cliente
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=19, l_i:=13, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±± Recibo do Cliente ±±±±±±±±±±±±"
@ l_s+02,c_s+1 SAY " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+03,c_s+1 SAY " ³        Sequˆncia:                    ³"
@ l_s+04,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
sequerec=0                                                   // Sequˆncia
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+03 ,c_s+22 GET  sequerec;
                    PICT "9999999999";
                    VALI CRIT("PTAB(STR(sequerec,10,00),'RECEBER',1)~N£mero Interno n„o existe na tabela")
                    AJUDA "Informe o n£mero interno do documento recebido"
                    CMDF8 "VDBF(6,34,20,77,'RECEBER',{'seque','documen','codigo'},1,'seque',[!empty(datapago)])"

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
   SET RELA TO STR(codigo,04,00) INTO CLIENTES               // relacionamento dos arquivos
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,17,11)                   // nao quis configurar...
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
maxli=65                                                     // maximo de linhas no relatorio
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
         IF seque=M->sequerec                                // se atender a condicao...
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,003 SAY Paramet->empresa1                   // Empresa
            @ cl,054 SAY "CGC :"
            @ cl,060 SAY TRAN(Paramet->cgc1,"@R 99.999.999/9999-99")// CGC
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            IMPAC("Endere‡o :",cl,000)
            @ cl,011 SAY Paramet->ender1                     // Endere‡o
            @ cl,046 SAY ","
            @ cl,048 SAY TRAN(Paramet->numero1,"99999")      // N£mero
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,011 SAY TRAN(Paramet->cep1,"@R 99999-999")  // CEP
            @ cl,022 SAY "-"
            @ cl,025 SAY Paramet->cidade1                    // Cidade
            @ cl,046 SAY "/"
            @ cl,048 SAY TRAN(Paramet->uf1,"!!")             // UF
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY "Telefone :"
            @ cl,011 SAY TRAN(Paramet->tele1,"@R (!!!!)!!!!-!!!!")// Telefone
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY REPL("Ä",80)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,035 SAY "Recibo"
            REL_CAB(3)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY "Recebemos do Senhor(a) :"
            @ cl,025 SAY CLIENTES->razao                     // Raz„o Social
            @ cl,066 SAY "em"
            @ cl,069 SAY TRAN(datapago,"@D")                 // Pagamento
            @ cl,079 SAY ","
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            IMPAC("a importƒncia de R$",cl,000)
            @ cl,020 SAY TRAN(valor,"@E 999,999,999,999.99") // Vl Pago
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,020 SAY left(Ext(valor,60),60)              // extenso 1
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,020 SAY substr(ext(valor,60),61,60)         // extenso 2
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY "Referente ao Documento"
            @ cl,023 SAY TRAN(documen,"@!")                  // Documento
            @ cl,045 SAY "de n§ Interno"
            @ cl,059 SAY TRAN(seque,"9999999999")            // Sequˆncia
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY "parcela"
            @ cl,008 SAY TRAN(parcelas,"99")                 // N£mero da Parcela
            @ cl,011 SAY "com vencimento em"
            @ cl,029 SAY TRAN(vencimento,"@D")               // Vencimento
            @ cl,039 SAY "."
            REL_CAB(3)                                       // soma cl/imprime cabecalho
            @ cl,022 SAY "Por ser verdade firmamos o presente"
            REL_CAB(3)                                       // soma cl/imprime cabecalho
            IMPAC("Taubat‚,",cl,020)
            @ cl,030 SAY day(DataC)                          // dia
            @ cl,035 SAY "de"
            @ cl,040 SAY NMes(Month(DataC))                  // mes
            @ cl,053 SAY "de"
            @ cl,057 SAY Year(DataC)                         // ano
            REL_CAB(5)                                       // soma cl/imprime cabecalho
            @ cl,023 SAY REPL("Ä",37)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,024 SAY Paramet->empresa1                   // Empresa1
            SKIP                                             // pega proximo registro
            cl=999                                           // forca salto de pagina
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
   ENDD ccop
END SEQUENCE
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(17)                                                    // grava variacao do relatorio
SELE RECEBER                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   cl=qt-1 ; pg_++
ENDI
RETU

* \\ Final de SFI_R009.PRG
