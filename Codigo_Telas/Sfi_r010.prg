/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_R010.PRG
 \ Data....: 30-07-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Impress„o de Cheques
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
@ l_s+01,c_s+1 SAY "±±±±±±±±±± Impress„o de Cheques ±±±±±±±±±±"
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
      CLOSE CHEQUES
      IF !USEARQ("CHEQUES",.t.,10,1)                         // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("CHEQUES")                                      // abre o dbf e seus indices
   #endi

   PTAB(STR(codigo,04,00)+documen+DTOS(vencimento),"PAGAR",3,.t.)// abre arquivo p/ o relacionamento
   PTAB(STR(codigo,04,00),"FORNEC",1,.t.)
   PTAB(STR(codbanco,02,00),"BANCOS",1,.t.)
   PTAB(BANCOS->codbanco,"TICHEQUE",1,.t.)
   SET RELA TO STR(codigo,04,00)+documen+DTOS(vencimento) INTO PAGAR,;// relacionamento dos arquivos
            TO STR(codigo,04,00) INTO FORNEC,;
            TO STR(codbanco,02,00) INTO BANCOS,;
            TO BANCOS->codbanco INTO TICHEQUE
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,34,11)                   // nao quis configurar...
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
   lpp_018=LEFT(drvtapg,op_-1)+"024"+SUBS(drvtapg,op_+3)
   lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
   lpp_018:=lpp_066 :=""                                     // nao ira mudara o tamanho da pag
ENDI
op_2=2
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
      IMPCTL(lpp_018)                                        // seta pagina com 18 linhas
      IMPCTL(drvpde8)                                        // ativa 8 lpp
      IMPCTL(drvpcom)                                        // comprime os dados
      @ 001,048 SAY REPL("X",18)
      @ 003,012 SAY REPL("X",90)
      @ 005,002 SAY REPL("X",90)
      @ 007,004 SAY REPL("X",40)
      @ 010,028 SAY REPL("X",23)
      @ 010,055 SAY REPL("X",9)
      @ 010,068 SAY REPL("X",2)
      EJEC                                                   // salta pagina no inicio
      IMPCTL(drvtcom)                                        // retira comprimido
      IMPCTL(drvtde8)                                        // ativa 6 lpp
      IMPCTL(lpp_066)                                        // seta pagina com 66 linhas
      SET DEVI TO SCRE                                       // se parametro maior que 0
   ENDI
ENDD
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
maxli=23                                                     // maximo de linhas no relatorio
SET DEVI TO PRIN                                             // inicia a impressao
SetPrc(0,0)
@ PRow(),1 Say &drvpde8                                              // ativa 8 lpp
@ PRow(),1 Say &lpp_018                                              // seta pagina com 18 linhas
@ PRow(),1 Say &drvpcom                                              // comprime os dados
@ PRow(),1 Say Chr(13)
IF tps=2
   IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
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
         l1=linha(ticheque->linval)
         c1=coluna(ticheque->colval)
         IF seque>=m->sequei.And.seque<=sequef               // se atender a condicao...
            @ l1,c1 SAY TRAN(valor,"@E 999,999,999,999.99") // Vl Pagar
            @ linha(ticheque->linext),coluna(ticheque->colext) SAY TRAN(Left(Ext(valor,90),90),"@!")   // Extenso 1
            @ linha(ticheque->linext)+2,coluna(ticheque->colext) SAY TRAN(Substr(Ext(valor,90),91,90),"@!")// Extenso 2
            @ linha(ticheque->linord),coluna(ticheque->colord) SAY TRAN(If(inter=[S],FORNEC->razao,favorecido),"@!")// Raz„o Social
            @ linha(ticheque->lincid),coluna(ticheque->colcid) SAY Trim(Par([cidade1]))+[,]+Str(Day(emissao),01,02)// Cidade
            @ linha(ticheque->lincid),coluna(ticheque->colmes) SAY NMes(Month(emissao))                // Mˆs
            @ linha(ticheque->lincid),coluna(ticheque->colano) SAY Substr(DtoC(emissao),09,02)         // Ano
            SKIP                                             // pega proximo registro
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
   ENDD ccop
END SEQUENCE
@ Prow(),Pcol() Say &drvtcom                                              // retira comprimido
@ Prow(),Pcol() Say &drvtde8                                              // ativa 6 lpp
@ Prow(),Pcol() Say &lpp_066                                            // seta pagina com 66 linhas
@ Prow(),Pcol() Say Chr(13)
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(34)                                                    // grava variacao do relatorio

#ifdef COM_REDE
   IF !USEARQ("MOVIM",.t.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("MOVIM")                                           // abre o dbf e seus indices
#endi

msgt="PROCESSAMENTOS DO RELAT¢RIO|IMPRESSŽO DE CHEQUES"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...
   SELE CHEQUES                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF seque>=m->sequei.And.seque<=sequef                  // se atender a condicao...
         IF Paramet->lancmov=[S]
            SELE MOVIM                                       // arquivo alvo do lancamento

            #ifdef COM_REDE
               DO WHIL .t.
                  APPE BLAN                                  // tenta abri-lo
                  IF NETERR()                                // nao conseguiu
                     DBOX(ms_uso,20)                         // avisa e
                     LOOP                                    // tenta novamente
                  ENDI
                  EXIT                                       // ok. registro criado
               ENDD
            #else
               APPE BLAN                                     // cria registro em branco
            #endi

            SELE CHEQUES                                     // inicializa registro em branco
            REPL MOVIM->data WITH emissao,;
                 MOVIM->documen WITH documen,;
                 MOVIM->contas WITH acao,;
                 MOVIM->banco WITH codbanco,;
                 MOVIM->tipo WITH [S],;
                 MOVIM->historico WITH histo,;
                 MOVIM->complem WITH complem,;
                 MOVIM->valor WITH valor,;
                 MOVIM->custo WITH PAGAR->custo,;
                 MOVIM->obs WITH favorecido

            #ifdef COM_REDE
               MOVIM->(DBUNLOCK())                           // libera o registro
            #endi

         ENDI

         #ifdef COM_REDE
            IF Paramet->baixpag=[S].and.inter=[S]
               REPBLO('PAGAR->datapago',{||emissao})
            ENDI
            IF Paramet->baixpag=[S].and.inter=[S]
               REPBLO('PAGAR->valor',{||valor})
            ENDI
         #else
            IF Paramet->baixpag=[S].and.inter=[S]
               REPL PAGAR->datapago WITH emissao
            ENDI
            IF Paramet->baixpag=[S].and.inter=[S]
               REPL PAGAR->valor WITH valor
            ENDI
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE CHEQUES                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU


* \\ Final de SFI_R010.PRG
