/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R011.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Contra Cheques
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=5, c_s:=19, l_i:=11, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±± Impress„o de Contra Cheques ±±±±±±±"
@ l_s+03,c_s+1 SAY "      Ú Seq. Inicial Â Seq. Final Ä¿"
@ l_s+04,c_s+1 SAY "      ³              ³             ³"
@ l_s+05,c_s+1 SAY "      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
sequei=0                                                     // Sequˆncia
sequef=0                                                     // Sequˆncia
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+09 GET  sequei;
                    PICT "9999999999";
                    VALI CRIT("PTAB(STR(sequei,10,00),'CHEQUES',1)~SEQUENCIA n„o aceit vel")
                    AJUDA "Informe o n£mero de Sequˆncia Inicial"
                    CMDF8 "VDBF(6,41,20,77,'CHEQUES',{'seque','documen'},1,'seque',[])"

   @ l_s+04 ,c_s+24 GET  sequef;
                    PICT "9999999999";
                    VALI CRIT("PTAB(STR(sequef,10,00),'CHEQUES',1)~SEQUENCIA n„o aceit vel")
                    AJUDA "Informe o n£mero de sequˆncia Final"
                    CMDF8 "VDBF(6,41,20,77,'CHEQUES',{'seque','documen'},1,'seque',[])"

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
      IF !USEARQ("CHEQUES",.f.,10,1)                         // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("CHEQUES")                                      // abre o dbf e seus indices
   #endi

   PTAB(STR(codigo,04,00)+documen+DTOS(vencimento),"PAGAR",3,.t.)// abre arquivo p/ o relacionamento
   PTAB(STR(codigo,04,00),"FORNEC",1,.t.)
   PTAB(STR(codbanco,02,00),"BANCOS",1,.t.)
   SET RELA TO STR(codigo,04,00)+documen+DTOS(vencimento) INTO PAGAR,;// relacionamento dos arquivos
            TO STR(codigo,04,00) INTO FORNEC,;
            TO STR(codbanco,02,00) INTO BANCOS
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,35,11)                   // nao quis configurar...
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
IF !EMPTY(drvtapg)                                           // existe configuracao de tam pag?
   op_=AT("NNN",drvtapg)                                     // se o codigo que altera
   IF op_=0                                                  // o tamanho da pagina
      msg="Configura‡„o do tamanho da p gina!"               // foi informado errado
      DBOX(msg,,,,,"ERRO!")                                  // avisa
      CLOSE ALL                                              // fecha todos arquivos abertos
      RETU                                                   // e cai fora...
   ENDI                                                      // codigo para setar/resetar tam pag
   lpp_025=LEFT(drvtapg,op_-1)+"025"+SUBS(drvtapg,op_+3)
   lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
   lpp_025:=lpp_066 :=""                                     // nao ira mudara o tamanho da pag
ENDI
op_2=1
DO WHIL op_2=1 .AND. tps=1                                   // teste de posicionamento
   msg="Testar Posicionamento|Emitir o Relat¢rio|"+;
       "Cancelar a Opera‡„o"
   op_2=DBOX(msg,,,E_MENU,,"POSICIONAMENTO DO PAPEL")        // menu de opcoes
   IF op_2=0 .OR. op_2=3                                     // cancelou ou teclou ESC
      CLOSE ALL                                              // fecha todos arquivos abertos
      RETU
   ELSEIF op_2=2                                             // emite conteudos...
      EXIT
   ELSE                                                      // testar posicionamento
      SET DEVI TO PRIN                                       // direciona para impressora
      IMPCTL(lpp_025)                                        // seta pagina com 25 linhas
      IMPCTL(drvpde8)                                        // ativa 8 lpp
      IMPCTL(drvpcom)                                        // comprime os dados
      @ 000,044 SAY REPL("X",35)
      @ 001,056 SAY REPL("X",18)
      @ 005,052 SAY REPL("X",7)
      @ 005,061 SAY REPL("X",10)
      @ 009,009 SAY REPL("X",3)
      @ 009,017 SAY REPL("X",21)
      @ 009,043 SAY REPL("X",30)
      @ 009,109 SAY REPL("X",18)
      @ 011,021 SAY REPL("X",90)
      @ 013,021 SAY REPL("X",90)
      @ 015,021 SAY REPL("X",40)
      @ 018,021 SAY REPL("X",23)
      @ 018,048 SAY REPL("X",9)
      @ 018,061 SAY REPL("X",4)
      @ 028,060 SAY REPL("X",40)
      EJEC                                                   // salta pagina no inicio
      IMPCTL(drvtcom)                                        // retira comprimido
      IMPCTL(drvtde8)                                        // ativa 6 lpp
      IMPCTL(lpp_066)                                        // seta pagina com 66 linhas
      SET DEVI TO SCRE                                       // se parametro maior que 0
   ENDI
ENDD
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SET DEVI TO PRIN                                             // inicia a impressao
maxli=32                                                     // maximo de linhas no relatorio
IMPCTL(lpp_025)                                              // seta pagina com 25 linhas
IMPCTL(drvpde8)                                              // ativa 8 lpp
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
         IF banco=[033].And.seque>=m->sequei.And.seque<=sequef// se atender a condicao...
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,044 SAY Par([empresa1])                     // Empresa
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,050 SAY "CGC :"
            @ cl,056 SAY TRAN(Par([cgc1]),"@R 99.999.999/9999-99")// CGC
            REL_CAB(3)                                       // soma cl/imprime cabecalho
            @ cl,048 SAY "C O N T R A   C H E Q U E S"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,052 SAY NSEM(DATE())                        // dia da semana
            @ cl,059 SAY ","
            @ cl,061 SAY DTOC(DATE())                        // data do sistema
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY REPL("Í",132)
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,001 SAY "Banco :"
            @ cl,009 SAY TRAN(BANCOS->tipoban,"999")         // N£mero Banco
            @ cl,014 SAY "-"
            @ cl,017 SAY TRAN(BANCOS->banco,"@R 999-!!99-!!!!!!!!!-!!")// Banco
            @ cl,040 SAY "-"
            @ cl,043 SAY BANCOS->descricao                   // Descri‡„o
            @ cl,098 SAY "Valor : R$"
            @ cl,109 SAY TRAN(valor,"@E 999,999,999,999.99") // Vl Pagar
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,001 SAY "Valor por Extenso :"
            @ cl,021 SAY TRAN(Left(Ext(valor,90),90),"@!")   // Extenso 1
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,021 SAY TRAN(Substr(Ext(valor,90),91,90),"@!")// Extenso 2
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,001 SAY "Favorecido        :"
            @ cl,021 SAY TRAN(If(inter=[S],FORNEC->razao,favorecido),"@!")// Raz„o Social
            REL_CAB(3)                                       // soma cl/imprime cabecalho
            IMPAC("Data da Emiss„o   :",cl,001)
            @ cl,021 SAY Trim(Par([cidade1]))+[,]+Str(Day(emissao),01,02)// Cidade
            @ cl,045 SAY "de"
            @ cl,048 SAY NMes(Month(emissao))                // Mˆs
            @ cl,058 SAY "de"
            @ cl,061 SAY Year(emissao)                       // Ano
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY REPL("Í",132)
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,055 SAY "Recebi em : ______ de _______________ de ______"
            REL_CAB(5)                                       // soma cl/imprime cabecalho
            @ cl,056 SAY REPL("Ä",46)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,060 SAY If(inter=[S],FORNEC->razao,favorecido)// nome
            SKIP                                             // pega proximo registro
            cl=999                                           // forca salto de pagina
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
IMPCTL(drvtde8)                                              // ativa 6 lpp
IMPCTL(lpp_066)                                              // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(35)                                                    // grava variacao do relatorio
SELE CHEQUES                                                 // salta pagina
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

* \\ Final de SFI_R011.PRG
