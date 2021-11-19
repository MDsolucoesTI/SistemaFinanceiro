/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CONMOVIM.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Movimentos Financeiros
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_, ord_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=7, c_s:=20, l_i:=13, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CON", op_sis:=EVAL(qualsis,"MOVIM")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±± Movimentos Financeiros ±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Data Inicial ÄÄÄÄÄÂ Data final ÄÄÄÄÄÄ¿"
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
                    AJUDA "Informe a Data Inicial"

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
   EXIT
ENDD
op_menu=PROJECOES                                            // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
   IF !USEARQ("MOVIM",.f.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("MOVIM")                                           // abre o dbf e seus indices
#endi

PTAB(STR(contas,04,00),"CONTAS",1,.t.)                       // abre arquivo p/ o relacionamento
PTAB(STR(banco,02,00),"BANCOS",1,.t.)
PTAB(STR(historico,04,00),"HISTO",1,.t.)
PTAB(STR(custo,06,00),"CUSTO",1,.t.)
SET RELA TO STR(contas,04,00) INTO CONTAS,;                  // relacionamento dos arquivos
         TO STR(banco,02,00) INTO BANCOS,;
         TO STR(historico,04,00) INTO HISTO,;
         TO STR(custo,06,00) INTO CUSTO
col_cp={;                                                    // conteudo das colunas
          "data",;
          "contas",;
          "TRAN(CONTAS->descricao,[])",;
          "TRAN(IIf(tipo=[E],valor,valor*(-1)),[@E 999,999,999,999.99])",;
          "tipo",;
          "banco",;
          "TRAN(BANCOS->descricao,[])",;
          "historico",;
          "TRAN(HISTO->descri,[])",;
          "documen",;
          "TRAN(CUSTO->codigo,[9999])",;
          "TRAN(CUSTO->departa,[])",;
          "obs";
       }
col_ti={;                                                    // titulo das colunas
          "Data",;
          "Conta",;
          "Descri‡„o A‡„o Financeira",;
          "Valor",;
          "Tipo",;
          "Banco",;
          "Descri‡„o",;
          "Hist¢rico",;
          "Hist¢rico",;
          "Documento",;
          "C¢digo Centro de Custo",;
          "Departamento",;
          "Observa‡„o";
       }
cr_="data>=M->datai .And.data<=M->dataf"                     // filtro inicial
ord_="DTOS(data)"                                            // ordem inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_,ord_)
SELE MOVIM                                                   // salta pagina
SET RELA TO                                                  // retira os relacionamentos
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de CONMOVIM.PRG
